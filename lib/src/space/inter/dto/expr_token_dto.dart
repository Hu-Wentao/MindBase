import 'dart:convert';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:petitparser/petitparser.dart';

import '../../application/service/expr/expression_parser.dart';
import '../../application/service/expr/expr_dto_to_domain.dart';

/// 标识符 仅用于对用户输入的表达式解析
/// 变量/方法的名称, 与上下文对应
class Identifier {
  final String name;

  Identifier(this.name) {
    assert(name != 'null');
    assert(name != 'false');
    assert(name != 'true');
    assert(name != 'this');
  }

  @override
  String toString() => name;
}

/// Expr v11
/// 解析用户输入的表达式
/// `可读字符串` -> `可执行表达式`
abstract class ExprTokenDto {
  /// 表达式不合法会抛出异常
  static ExprTokenDto of(
    ExpressionParser parser,
    String humanReadableString,
  ) {
    // print("#debug#ExpressionDto.of: $humanReadableString");
    return parser.expression.end().parse(humanReadableString).value;
  }

  String toReadableString(); // 人类可读字符串（代码）

  /// 转换为持久化字段，避免上下文变化导致无法解析的问题
  /// [currentContext] 在用户输入字符串时的上下文，会随时变更，例如 `bob.name`
  /// 转换后将会被替换为持久化上下文，即 `<bob对象对应的Record::id>.<bob对应Meta::propId>`
  ExprTokenDto toPersistence(Map<String, dynamic> currentContext);

  /// Expr(表达式ExpressionDto)->Domain(IExpr)
  /// 允许meta为null, 用于解析没有使用`this`或者其他`全局函数`的表达式
  IExpr toDomain([String? metaId, QueryMetaFn? queryMetaFn]) =>
      exprToDomain.convert(
        this,
        {
          // 由于没有`this`,只有`this`的类型(Meta)所以这里使用[ctxTypeSign]
          AsFuncThis.ctxMetaIdSign: metaId,
          // 注入当前工作空间, 用于通过metaId查询Meta
          SpaceModel.ctxQueryMetaSign: queryMetaFn,
        }..addEntries(IFunc.allFuncMapEntry), // 注意,在Dto->Domain时,似乎仍然需要全局Func
      );
}

abstract class BaseExprTokenDto extends ExprTokenDto with EquatableMixin {
  @override
  String toString() => toReadableString();
}

/// 字面值 例如用户输入的 ”My name is", 或者是 123
class LiteralDto extends BaseExprTokenDto {
  final dynamic value; // json解码后的字面量
  final String raw; // json编码后的字符串

  LiteralDto(this.value, [String? raw]) : raw = raw ?? (json.encode(value));

  @override
  List<Object?> get props => [value, raw];

  @override
  String toReadableString() => raw;

  @override
  ExprTokenDto toPersistence(Map<String, dynamic> currentContext) {
    return this;
  }
}

/// Variable 变量/字段/记录的属性值，例如用户输入的 `this.name`, `bob.name`等， 将会解析出`name`对应当前Meta的name字段值
/// [identifier] 指的是变量、方法的名称
class VariableDto extends BaseExprTokenDto {
  final Identifier identifier;

  VariableDto(this.identifier);

  @override
  List<Object?> get props => [identifier];

  @override
  String toReadableString() => '$identifier';

  @override
  ExprTokenDto toPersistence(Map<String, dynamic> currentContext) {
    return currentContext[identifier.name];
  }
}

/// 即`this`
class ThisExprTokenDto extends BaseExprTokenDto {
  static const sign = 'this';

  @override
  List<Object?> get props => const [];

  @override
  String toReadableString() => sign;

  /// 似乎不需要
  @override
  ExprTokenDto toPersistence(Map<String, dynamic> currentContext) => this;
}

/// 成员变量/方法
class MemberExprTokenDto extends BaseExprTokenDto {
  final ExprTokenDto object;

  final Identifier property;

  MemberExprTokenDto(this.object, this.property);

  @override
  List<Object?> get props => [object, property];

  @override
  String toReadableString() => '${object.toReadableString()}.$property';

  @override
  ExprTokenDto toPersistence(Map<String, dynamic> currentContext) {
    return currentContext[object][property.name];
  }
}

/// 索引表达式 ， 表示某个数组的某个元素 `bag[1]`
class IndexExprTokenDto extends BaseExprTokenDto {
  final ExprTokenDto object;

  final ExprTokenDto index;

  IndexExprTokenDto(this.object, this.index);

  @override
  List<Object?> get props => [object, index];

  @override
  String toReadableString() => '${object.toReadableString()}[$index]';

  @override
  ExprTokenDto toPersistence(Map<String, dynamic> currentContext) {
    return this; // todo
    // return toReadableString();
  }
}

/// 调用表达式，调用某个方法， `read()`
class CallExprTokenDto extends BaseExprTokenDto {
  final ExprTokenDto callee;
  final List<ExprTokenDto> arguments;

  CallExprTokenDto(this.callee, this.arguments);

  @override
  List<Object?> get props => [callee, arguments];

  @override
  String toReadableString() =>
      '${callee.toReadableString()}(${arguments.join(', ')})';

  @override
  ExprTokenDto toPersistence(Map<String, dynamic> currentContext) {
    return this; // todo
    // return toReadableString();
  }
}

/// 复合表达式
abstract class CompoundExprTokenDto extends BaseExprTokenDto {
  @override
  String toReadableString() => '($this)';
}

/// 一元表达式
class UnaryExprTokenDto extends BaseExprTokenDto {
  final String operator;

  final ExprTokenDto argument;

  final bool prefix;

  UnaryExprTokenDto(this.operator, this.argument, {this.prefix = true});

  @override
  List<Object?> get props => [operator, argument, prefix];

  @override
  String toReadableString() => '$operator$argument';

  @override
  ExprTokenDto toPersistence(Map<String, dynamic> currentContext) {
    return this; // todo
    // return toReadableString();
  }
}

/// 二元运算符
class BinaryExprTokenDto extends CompoundExprTokenDto {
  final String operator;
  final ExprTokenDto left;
  final ExprTokenDto right;

  BinaryExprTokenDto(this.operator, this.left, this.right);

  @override
  List<Object?> get props => [operator, left, right];

  static int precedenceForOperator(String operator) =>
      ExpressionParser.binaryOperations[operator]!;

  int get precedence => precedenceForOperator(operator);

  @override
  String toString() {
    var l = (left is BinaryExprTokenDto &&
            (left as BinaryExprTokenDto).precedence < precedence)
        ? '($left)'
        : '$left';
    var r = (right is BinaryExprTokenDto &&
            (right as BinaryExprTokenDto).precedence < precedence)
        ? '($right)'
        : '$right';
    return '$l$operator$r';
  }

  @override
  ExprTokenDto toPersistence(Map<String, dynamic> currentContext) {
    return this; // todo
    // return toReadableString();
  }
}

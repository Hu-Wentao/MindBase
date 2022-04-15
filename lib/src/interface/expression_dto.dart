import 'dart:convert';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:petitparser/petitparser.dart';

import '../application/expression_parser.dart';

//
// /// 后期替换 领域层的 Expression类
// /// 作用： 将用户输入的表达式结合当前的上下文，进行持久化，以解决字段名，方法名变更导致表达式无效的问题
// class Expression2 {
//   // 函数名称名称,如果表达式就是一个值，则函数名称可以是self，这样可以表示一个Value（字面值）
//   final Func func;
//
//   // 参数列表
//   final List<Expression2> args;
//
//   Expression2(this.func, this.args);
//
//   Expression2.value(this.args) : func = FuncManager.selfFunc;
// }

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
abstract class ExpressionDto {
  /// 表达式不合法会抛出异常
  static ExpressionDto of(
    ExpressionParser parser,
    String humanReadableString,
  ) =>
      parser.expression.end().parse(humanReadableString).value;

  String toReadableString(); // 人类可读字符串（代码）

  /// 转换为持久化字段，避免上下文变化导致无法解析的问题
  /// [currentContext] 在用户输入字符串时的上下文，会随时变更，例如 `bob.name`
  /// 转换后将会被替换为持久化上下文，即 `<bob对象对应的Record::id>.<bob对应Meta::propId>`
  ExpressionDto toPersistence(Map<String, dynamic> currentContext);
}

abstract class BaseExpressionDto extends ExpressionDto with EquatableMixin {
  @override
  String toString() => toReadableString();
}

/// 字面值 例如用户输入的 ”My name is", 或者是 123
class ValueDto extends BaseExpressionDto {
  final dynamic value; // json解码后的字面量
  final String raw; // json编码后的字符串

  ValueDto(this.value, [String? raw]) : raw = raw ?? (json.encode(value));

  @override
  List<Object?> get props => [value, raw];

  @override
  String toReadableString() => raw;

  @override
  ExpressionDto toPersistence(Map<String, dynamic> currentContext) {
    return this;
  }
}

/// Variable 变量/字段/记录的属性值，例如用户输入的 `this.name`, `bob.name`等， 将会解析出`name`对应当前Meta的name字段值
/// [identifier] 指的是变量、方法的名称
class VariableDto extends BaseExpressionDto {
  final Identifier identifier;

  VariableDto(this.identifier);

  @override
  List<Object?> get props => [identifier];

  @override
  String toReadableString() => '$identifier';

  @override
  ExpressionDto toPersistence(Map<String, dynamic> currentContext) {
    return currentContext[identifier.name];
  }
}

/// 即`this`
class ThisExpressionDto extends BaseExpressionDto {
  @override
  List<Object?> get props => const [];

  @override
  String toReadableString() => toString();

  /// 似乎不需要
  @override
  ExpressionDto toPersistence(Map<String, dynamic> currentContext) => this;
}
// class ThisExpressionDto extends BaseExpressionDto {
//   final String ref; // 输入上下文中，值为 this，持久化上下文中，为对应
//
//   ThisExpressionDto([this.ref = 'this']);
//
//   @override
//   List<Object?> get props => const [];
//
//   @override
//   String toReadableString() => toString();
//
//   @override
//   ExpressionDto toPersistence(Map<String, dynamic> currentContext) =>
//       ThisExpressionDto(
//           (currentContext['this'] as Record).id.toHexString());
// }

/// 成员变量/方法
class MemberExpressionDto extends BaseExpressionDto {
  final ExpressionDto object;

  final Identifier property;

  MemberExpressionDto(this.object, this.property);

  @override
  List<Object?> get props => [object, property];

  @override
  String toReadableString() => '${object.toReadableString()}.$property';

  @override
  ExpressionDto toPersistence(Map<String, dynamic> currentContext) {
    return currentContext[object][property.name];
  }
}

/// 索引表达式 ， 表示某个数组的某个元素 `bag[1]`
class IndexExpressionDto extends BaseExpressionDto {
  final ExpressionDto object;

  final ExpressionDto index;

  IndexExpressionDto(this.object, this.index);

  @override
  List<Object?> get props => [object, index];

  @override
  String toReadableString() => '${object.toReadableString()}[$index]';

  @override
  ExpressionDto toPersistence(Map<String, dynamic> currentContext) {
    return this; // todo
    // return toReadableString();
  }
}

/// 调用表达式，调用某个方法， `read()`
class CallExpressionDto extends BaseExpressionDto {
  final ExpressionDto callee;
  final List<ExpressionDto> arguments;

  CallExpressionDto(this.callee, this.arguments);

  @override
  List<Object?> get props => [callee, arguments];

  @override
  String toReadableString() =>
      '${callee.toReadableString()}(${arguments.join(', ')})';

  @override
  ExpressionDto toPersistence(Map<String, dynamic> currentContext) {
    return this; // todo
    // return toReadableString();
  }
}

/// 复合表达式
abstract class CompoundExpressionDto extends BaseExpressionDto {
  @override
  String toReadableString() => '($this)';
}

/// 一元表达式
class UnaryExpressionDto extends BaseExpressionDto {
  final String operator;

  final ExpressionDto argument;

  final bool prefix;

  UnaryExpressionDto(this.operator, this.argument, {this.prefix = true});

  @override
  List<Object?> get props => [operator, argument, prefix];

  @override
  String toReadableString() => '$operator$argument';

  @override
  ExpressionDto toPersistence(Map<String, dynamic> currentContext) {
    return this; // todo
    // return toReadableString();
  }
}

/// 二元运算符
class BinaryExpressionDto extends CompoundExpressionDto {
  final String operator;
  final ExpressionDto left;
  final ExpressionDto right;

  BinaryExpressionDto(this.operator, this.left, this.right);

  @override
  List<Object?> get props => [operator, left, right];

  static int precedenceForOperator(String operator) =>
      ExpressionParser.binaryOperations[operator]!;

  int get precedence => precedenceForOperator(operator);

  @override
  String toString() {
    var l = (left is BinaryExpressionDto &&
            (left as BinaryExpressionDto).precedence < precedence)
        ? '($left)'
        : '$left';
    var r = (right is BinaryExpressionDto &&
            (right as BinaryExpressionDto).precedence < precedence)
        ? '($right)'
        : '$right';
    return '$l$operator$r';
  }

  @override
  ExpressionDto toPersistence(Map<String, dynamic> currentContext) {
    return this; // todo
    // return toReadableString();
  }
}

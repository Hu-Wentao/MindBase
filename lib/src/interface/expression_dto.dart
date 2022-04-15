import 'dart:convert';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:petitparser/petitparser.dart';

import '../application/expression_parser.dart';

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
  static ExpressionDto of(ExpressionParser parser, String humanReadableString) =>
      parser.expression.end().parse(humanReadableString).value;

  String toReadableString(); // 人类可读字符串（代码）
}

abstract class BaseExpressionDto extends ExpressionDto with EquatableMixin {
  @override
  String toString() => toReadableString();
}

/// 字面值 例如用户输入的 ”My name is", 或者是 123
class ValueDto extends BaseExpressionDto {
  final dynamic value;
  final String raw;

  ValueDto(this.value, [String? raw]) : raw = raw ?? (json.encode(value));

  @override
  String toReadableString() => raw;

  @override
  List<Object?> get props => [value, raw];
}

/// Variable 变量/字段/记录的属性值，例如用户输入的 `this.name`,将会解析出`name`对应当前Meta的name字段值
class VariableDto extends BaseExpressionDto {
  final Identifier identifier;

  VariableDto(this.identifier);

  @override
  String toReadableString() => '$identifier';

  @override
  List<Object?> get props => [identifier];
}

/// 即`this`
class ThisExpressionDto extends BaseExpressionDto {
  @override
  List<Object?> get props => const [];

  @override
  String toReadableString() => toString();
}

/// 成员变量/方法
class MemberExpressionDto extends BaseExpressionDto {
  final ExpressionDto object;

  final Identifier property;

  MemberExpressionDto(this.object, this.property);

  @override
  String toReadableString() => '${object.toReadableString()}.$property';

  @override
  List<Object?> get props => [object, property];
}

/// 索引表达式 ， 表示某个数组的某个元素 `bag[1]`
class IndexExpressionDto extends BaseExpressionDto {
  final ExpressionDto object;

  final ExpressionDto index;

  IndexExpressionDto(this.object, this.index);

  @override
  String toReadableString() => '${object.toReadableString()}[$index]';

  @override
  List<Object?> get props => [object, index];
}

/// 调用表达式，调用某个方法， `read()`
class CallExpressionDto extends BaseExpressionDto {
  final ExpressionDto callee;
  final List<ExpressionDto> arguments;

  CallExpressionDto(this.callee, this.arguments);

  @override
  String toReadableString() =>
      '${callee.toReadableString()}(${arguments.join(', ')})';

  @override
  List<Object?> get props => [callee, arguments];
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
  String toReadableString() => '$operator$argument';

  @override
  List<Object?> get props => [operator, argument, prefix];
}

/// 二元运算符
class BinaryExpressionDto extends CompoundExpressionDto {
  final String operator;
  final ExpressionDto left;
  final ExpressionDto right;

  BinaryExpressionDto(this.operator, this.left, this.right);

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
  List<Object?> get props => [operator, left, right];
}

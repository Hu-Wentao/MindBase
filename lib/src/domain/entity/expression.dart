import 'package:mind_base/src/domain/value.dart';
import 'dart:math' as math;

/// 表达式
class Expression {
  final String name; // 全局唯一
  final String? alias;
  final List<AttrType> pTypes;
  final AttrType rType;

  // run 只有运算, 在调用之前,需要先检查Attr的类型匹配问题
  final Value Function(List<Value> p) onRun;

  const Expression({
    required this.name,
    this.alias,
    required this.pTypes,
    required this.rType,
    required this.onRun,
  });
}

// todo 添加test, 1.检查name唯一性, 2检查参数转换是否正常
final expressionList = [...baseExpressions, ...convertExpressions];

/// 类型检查与转换表达式, 检查/转换失败则抛出异常
final convertExpressions = [
  Expression(
      name: "ToString",
      pTypes: [AttrType.any],
      rType: AttrType.string,
      onRun: (p) => Value.of(p[0].asString)),
  Expression(
      name: "ToNum",
      pTypes: [AttrType.any],
      rType: AttrType.num,
      onRun: (p) => Value.of(p[0].asNum)),
  Expression(
      name: "ToBool",
      pTypes: [AttrType.any],
      rType: AttrType.bool,
      onRun: (p) => Value.of(p[0].asBool)),
  Expression(
      name: "ToDate",
      pTypes: [AttrType.any],
      rType: AttrType.date,
      onRun: (p) => Value.of(p[0].asDate)),
];

/// 基础表达式
final baseExpressions = [
  Expression(
    name: "ADD",
    alias: "+",
    pTypes: [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(p[0].asNum + p[1].asNum),
  ),
  Expression(
    name: "SUB",
    alias: "-",
    pTypes: [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(p[0].asNum - p[1].asNum),
  ),
  Expression(
    name: "MUL",
    alias: "*",
    pTypes: [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(p[0].asNum * p[1].asNum),
  ),
  Expression(
    name: "DIV",
    alias: "/",
    pTypes: [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(p[0].asNum / p[1].asNum),
  ),
  Expression(
    name: "MOD",
    alias: "%",
    pTypes: [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(p[0].asNum % p[1].asNum),
  ),
  Expression(
    name: "POW",
    alias: "^",
    pTypes: [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(math.pow(p[0].asNum, p[1].asNum)),
  ),
  Expression(
    name: "AND",
    alias: "&&",
    pTypes: [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asBool && p[1].asBool),
  ),
  Expression(
    name: "OR",
    alias: "||",
    pTypes: [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asBool || p[1].asBool),
  ),
  Expression(
    name: "NOT",
    alias: "!",
    pTypes: [AttrType.bool],
    rType: AttrType.bool,
    onRun: (p) => Value.of(!p[0].asBool),
  ),
  Expression(
    name: "EQ",
    alias: "==",
    pTypes: [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asString == p[1].asString),
  ),
  Expression(
    name: "NEQ",
    alias: "!=",
    pTypes: [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asString != p[1].asString),
  ),
  Expression(
    name: "GT",
    alias: ">",
    pTypes: [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asNum > p[1].asNum),
  ),
  Expression(
    name: "GTE",
    alias: ">=",
    pTypes: [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asNum > p[1].asNum),
  ),
  Expression(
    name: "LT",
    alias: "<",
    pTypes: [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asNum < p[1].asNum),
  ),
  Expression(
    name: "LTE",
    alias: "<=",
    pTypes: [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asNum <= p[1].asNum),
  ),
];

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/value.dart';
import 'dart:math' as math;

/// 函数 ========================================================================
// enum FunType {
//   operator, // 操作符
//   shell, // 本地CMD命令
//   http, // http云函数
// }

// abstract class IFunc {
//   String get name;
// }

class Func extends Equatable {
  final String name; // 全局唯一
  final String? alias;
  final List<AttrType> pTypes;
  final AttrType rType;

  // run 只有运算, 在调用之前,需要先检查Attr的类型匹配问题
  final Value Function(List<Value> p) onRun;

  const Func({
    required this.name,
    this.alias,
    required this.pTypes,
    required this.rType,
    required this.onRun,
  });

  @override
  List<Object?> get props => [name, alias, pTypes, rType, onRun];
}

/// todo 添加test, 1.检查name唯一性, 2检查参数转换是否正常
class FuncManager {
  static const String noneFuncName = "none";

  static Iterable<Func> get funcList =>
      methodMap.values.expand((element) => element);

  /// 相关 [AttrType]所有用的方法
  static Map<AttrType, Iterable<Func>> get methodMap => {
        AttrType.any: anyFunList,
        AttrType.bool: boolFunList,
        AttrType.num: numFunList,
        AttrType.string: strFunList,
        // AttrType.date: dateFunList,
      };

  static Func findMethod(
    AttrType type,
    String name, {
    Func Function()? orElse,
  }) =>
      methodMap[type]!
          .firstWhere((element) => element.name == name, orElse: orElse);

  static Func findBy(String funcName, {Func Function()? orElse}) =>
      funcList.firstWhere((f) => f.name == funcName, orElse: orElse);
}

/// 类型检查与转换表达式, 检查/转换失败则抛出异常
final anyFunList = [
  Func(
    name: 'none',
    pTypes: const [AttrType.any],
    rType: AttrType.any,
    onRun: (p) => p[0],
  ),
  Func(
      name: "toStr",
      pTypes: const [AttrType.any],
      rType: AttrType.string,
      onRun: (p) => Value.of(p[0].asString)),
  Func(
      name: "toNum",
      pTypes: const [AttrType.any],
      rType: AttrType.num,
      onRun: (p) => Value.of(p[0].asNum)),
  Func(
      name: "toBool",
      pTypes: const [AttrType.any],
      rType: AttrType.bool,
      onRun: (p) => Value.of(p[0].asBool)),
  Func(
      name: "toDate",
      pTypes: const [AttrType.any],
      rType: AttrType.date,
      onRun: (p) => Value.of(p[0].asDate)),
  Func(
    name: "equal",
    alias: "==",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asString == p[1].asString),
  ),
  Func(
    name: "notEqual",
    alias: "!=",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asString != p[1].asString),
  ),
];

/// 基础表达式
final numFunList = [
  Func(
    name: "add",
    alias: "+",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(p[0].asNum + p[1].asNum),
  ),
  Func(
    name: "sub",
    alias: "-",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(p[0].asNum - p[1].asNum),
  ),
  Func(
    name: "mul",
    alias: "*",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(p[0].asNum * p[1].asNum),
  ),
  Func(
    name: "div",
    alias: "/",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(p[0].asNum / p[1].asNum),
  ),
  Func(
    name: "mod",
    alias: "%",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(p[0].asNum % p[1].asNum),
  ),
  Func(
    name: "pow",
    alias: "^",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of(math.pow(p[0].asNum, p[1].asNum)),
  ),
  Func(
    name: "greater",
    alias: ">",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asNum > p[1].asNum),
  ),
  Func(
    name: "greaterEqual",
    alias: ">=",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asNum > p[1].asNum),
  ),
  Func(
    name: "little",
    alias: "<",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asNum < p[1].asNum),
  ),
  Func(
    name: "littleEqual",
    alias: "<=",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asNum <= p[1].asNum),
  ),
];
final boolFunList = [
  Func(
    name: "and",
    alias: "&&",
    pTypes: const [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asBool && p[1].asBool),
  ),
  Func(
    name: "or",
    alias: "||",
    pTypes: const [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    onRun: (p) => Value.of(p[0].asBool || p[1].asBool),
  ),
  Func(
    name: "not",
    alias: "!",
    pTypes: const [AttrType.bool],
    rType: AttrType.bool,
    onRun: (p) => Value.of(!p[0].asBool),
  ),
];
final strFunList = [
  Func(
    name: "len",
    pTypes: const [AttrType.string],
    rType: AttrType.num,
    onRun: (p) => Value.of(p[0].v.length),
  )
];

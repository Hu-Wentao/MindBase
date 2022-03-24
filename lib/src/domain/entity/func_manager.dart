part of 'func.dart';

/// todo 添加test, 1.检查name唯一性, 2检查参数转换是否正常
/// todo 移除alias属性
class FuncManager {
  static const String noneFuncName = "none";
  static const String selfFuncName = "self";

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

  @Deprecated("弃用")
  static Func findMethod(
    AttrType type,
    String name, {
    Func Function()? orElse,
  }) =>
      methodMap[type]!
          .firstWhere((element) => element.name == name, orElse: orElse);

  // 先查一查别名表,如果没有则再查FuncName
  static Func findBy(String funcName, {Func Function()? orElse}) =>
      _findBy((aliasMap[funcName] ?? funcName), orElse: orElse);

  static Func _findBy(String funcName, {Func Function()? orElse}) =>
      funcList.firstWhere((f) => f.name == funcName, orElse: orElse);
  static Map<String, String> aliasMap = {
    "==": "equal",
    "!=": "notEqual",
    "+": "add",
    "-": "sub",
    "*": "mul",
    "/": "div",
    "%": "mod",
    "^": "pow",
    ">": "greater",
    ">=": "greaterEqual",
    "<": "little",
    "<=": "littleEqual",
    "&&": "and",
    "||": "or",
    "!": "not",
  };
}

final Func noneFunc = Func(
  name: FuncManager.noneFuncName,
  pTypes: const [AttrType.any],
  rType: AttrType.any,
  logic: (p) => p[0],
);
final Func selfFunc = Func(
  name: FuncManager.selfFuncName,
  pTypes: const [AttrType.any],
  rType: AttrType.any,
  logic: (p) => p[0],
);

/// 类型检查与转换表达式, 检查/转换失败则抛出异常
final anyFunList = <Func>[
  Func(
      name: "toStr",
      pTypes: const [AttrType.any],
      rType: AttrType.string,
      logic: (p) => Value.of((p[0] as Value).asString)),
  Func(
      name: "toNum",
      pTypes: const [AttrType.any],
      rType: AttrType.num,
      logic: (p) => Value.of((p[0] as Value).asNum)),
  Func(
      name: "toBool",
      pTypes: const [AttrType.any],
      rType: AttrType.bool,
      logic: (p) => Value.of((p[0] as Value).asBool)),
  Func(
      name: "toDate",
      pTypes: const [AttrType.any],
      rType: AttrType.date,
      logic: (p) => Value.of((p[0] as Value).asDate)),
  Func(
    name: "equal",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    logic: (p) =>
        Value.of((p[0] as Value).asString == (p[1] as Value).asString),
  ),
  Func(
    name: "notEqual",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    logic: (p) =>
        Value.of((p[0] as Value).asString != (p[1] as Value).asString),
  ),
  noneFunc,
  selfFunc,
];

/// 基础表达式
final numFunList = [
  Func(
    name: "add",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: (p) => Value.of((p[0] as Value).asNum + (p[1] as Value).asNum),
  ),
  Func(
    name: "sub",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: (p) => Value.of((p[0] as Value).asNum - (p[1] as Value).asNum),
  ),
  Func(
    name: "mul",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: (p) => Value.of((p[0] as Value).asNum * (p[1] as Value).asNum),
  ),
  Func(
    name: "div",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: (p) => Value.of((p[0] as Value).asNum / (p[1] as Value).asNum),
  ),
  Func(
    name: "mod",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: (p) => Value.of((p[0] as Value).asNum % (p[1] as Value).asNum),
  ),
  Func(
    name: "pow",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: (p) =>
        Value.of(math.pow((p[0] as Value).asNum, (p[1] as Value).asNum)),
  ),
  Func(
    name: "greater",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: (p) => Value.of((p[0] as Value).asNum > (p[1] as Value).asNum),
  ),
  Func(
    name: "greaterEqual",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: (p) => Value.of((p[0] as Value).asNum > (p[1] as Value).asNum),
  ),
  Func(
    name: "little",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: (p) => Value.of((p[0] as Value).asNum < (p[1] as Value).asNum),
  ),
  Func(
    name: "littleEqual",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: (p) => Value.of((p[0] as Value).asNum <= (p[1] as Value).asNum),
  ),
];
final boolFunList = [
  Func(
    name: "and",
    pTypes: const [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    logic: (p) => Value.of((p[0] as Value).asBool && (p[1] as Value).asBool),
  ),
  Func(
    name: "or",
    pTypes: const [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    logic: (p) => Value.of((p[0] as Value).asBool || (p[1] as Value).asBool),
  ),
  Func(
    name: "not",
    pTypes: const [AttrType.bool],
    rType: AttrType.bool,
    logic: (p) => Value.of(!(p[0] as Value).asBool),
  ),
];
final strFunList = [
  Func(
    name: "len",
    pTypes: const [AttrType.string],
    rType: AttrType.num,
    logic: (p) => Value.of((p[0] as Value).v.length),
  )
];

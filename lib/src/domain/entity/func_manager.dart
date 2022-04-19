part of 'func.dart';

/// todo 添加test, 1.检查name唯一性, 2检查参数转换是否正常
/// todo 移除alias属性
class FuncManager {
  // 是否为短路运算符
  static bool isShortCircuit(String name) =>
      const ['&&', '||', "and", "or"].contains(name);
  static const String noneFuncName = "none";
  static const String selfFuncName = "self";

  static Func get selfFunc => selfFunction;

  static Func get noneFunc => noneFunction;

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
      methodMap[type]!.firstWhere(
        (element) => element.name == name,
        orElse: orElse,
      );

  // 先查一查别名表,如果没有则再查FuncName
  static Func findBy(String funcName, {Func Function()? orElse}) => _findBy(
        (al[funcName] ?? funcName),
        orElse: () => findAsFunc(
          funcName,
          orElse: orElse,
        ),
      );

  static Func _findBy(String funcName, {Func Function()? orElse}) =>
      funcList.firstWhere((f) => f.name == funcName, orElse: orElse);
  static Map<String, String> al = {
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

  static AsFunc findAsFunc(String funcName, {Func Function()? orElse}) =>
      asFuncList.firstWhere(
        (f) => f.name == funcName,
        orElse: () => orElse?.call() as AsFunc,
      );
}

final Func noneFunction = Func(
  name: FuncManager.noneFuncName,
  pTypes: const [AttrType.any],
  rType: AttrType.any,
  logic: (p) => p[0],
);
final Func selfFunction = Func(
  name: FuncManager.selfFuncName,
  pTypes: const [AttrType.any],
  rType: AttrType.any,
  logic: (p) => p[0],
);

/// dynamic -> T 转换
const asFuncList = <AsFunc>[
  AsFunc<String>(),
  AsFunc<num>(),
  AsFunc<bool>(),
];

/// 类型检查与转换表达式, 检查/转换失败则抛出异常
final anyFunList = <Func>[
  Func(
      name: "toStr",
      pTypes: const [AttrType.any],
      rType: AttrType.string,
      logic: (p) => "${p[0]}"),
  Func(
      name: "toNum",
      pTypes: const [AttrType.any],
      rType: AttrType.num,
      logic: (p) => num.parse(p[0])),
  Func(
      name: "toBool",
      pTypes: const [AttrType.any],
      rType: AttrType.bool,
      logic: (p) {
        switch (p[0].runtimeType) {
          case bool:
            return p[0];
          case String:
            return p[0] == "true";
          case num:
            return p[0] != 0;
          default:
            return false;
        }
      }),
  Func(
    name: "equal",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    logic: (p) => (p[0]) == (p[1]),
  ),
  Func(
    name: "notEqual",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    logic: ((p) => p[0] != p[1]),
  ),
  noneFunction,
  selfFunction,
];

/// 基础表达式
final numFunList = [
  Func(
    name: "add",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) => (p[0]) + (p[1])),
  ),
  Func(
    name: "sub",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) => (p[0]) - (p[1])),
  ),
  Func(
    name: "mul",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) => (p[0]) * (p[1])),
  ),
  Func(
    name: "div",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) => (p[0]) / (p[1])),
  ),
  Func(
    name: "mod",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) => (p[0]) % (p[1])),
  ),
  Func(
    name: "pow",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) => math.pow((p[0]), (p[1]))),
  ),
  Func(
    name: "greater",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: ((p) => (p[0]) > (p[1])),
  ),
  Func(
    name: "greaterEqual",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: ((p) => (p[0]) > (p[1])),
  ),
  Func(
    name: "little",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: ((p) => (p[0]) < (p[1])),
  ),
  Func(
    name: "littleEqual",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: ((p) => (p[0]) <= (p[1])),
  ),
];

/// `short-circuit` 短路表达式
/// todo 考虑将参数2的类型改为 [AttrType.any] 或者对类型检查进行特殊处理
final boolFunList = [
  Func(
    name: "and",
    pTypes: const [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    logic: ((p) => (p[0]) && (p[1] is Function) ? p[1].call() : p[1]),
  ),
  Func(
    name: "or",
    pTypes: const [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    logic: ((p) => (p[0]) || (p[1] is Function) ? p[1].call() : p[1]),
  ),
  Func(
    name: "not",
    pTypes: const [AttrType.bool],
    rType: AttrType.bool,
    logic: ((p) => !(p[0])),
  ),
];
final strFunList = [
  Func(
    name: "len",
    pTypes: const [AttrType.string],
    rType: AttrType.num,
    logic: ((p) => (p[0]).v.length),
  )
];

part of 'func.dart';

/// todo 添加test, 1.检查name唯一性, 2检查参数转换是否正常
/// todo 移除alias属性
class FuncManager {
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

/// 类型检查与转换表达式, 检查/转换失败则抛出异常
final anyFunList = <Func>[
  Func(
    //  引用字段
    name: "reference",
    //(被引用字段所在RecordId(Value本身持有), 被引用字段所在的MetaId(Expr内嵌), 字段K值(Expr内嵌),)
    pTypes: const [AttrType.objectId, AttrType.num, AttrType.objectId],
    rType: AttrType.any,
    logic: (p) {
      final holder = sl<WorkspaceDataHolder>();
      final recordId = p[0].asObjectId;
      final attrKey = p[1].asNum as int;
      final metaId = p[2].asObjectId;
      return holder
          .getRecords(metaId)
          .firstWhere((element) => element.id == recordId)
          .getFieldBy(attrKey);
    },
  ),
  Func(
      name: "toStr",
      pTypes: const [AttrType.any],
      rType: AttrType.string,
      logic: (p) => Value.of(p[0].asString)),
  Func(
      name: "toNum",
      pTypes: const [AttrType.any],
      rType: AttrType.num,
      logic: (p) => Value.of(p[0].asNum)),
  Func(
      name: "toBool",
      pTypes: const [AttrType.any],
      rType: AttrType.bool,
      logic: (p) => Value.of(p[0].asBool)),
  Func(
      name: "toDate",
      pTypes: const [AttrType.any],
      rType: AttrType.date,
      logic: (p) => Value.of(p[0].asDate)),
  Func(
    name: "equal",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    logic: (p) => Value.of(p[0].asString == p[1].asString),
  ),
  Func(
    name: "notEqual",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    logic: (p) => Value.of(p[0].asString != p[1].asString),
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
    logic: (p) => Value.of(p[0].asNum + p[1].asNum),
  ),
  Func(
    name: "sub",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: (p) => Value.of(p[0].asNum - p[1].asNum),
  ),
  Func(
    name: "mul",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: (p) => Value.of(p[0].asNum * p[1].asNum),
  ),
  Func(
    name: "div",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: (p) => Value.of(p[0].asNum / p[1].asNum),
  ),
  Func(
    name: "mod",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: (p) => Value.of(p[0].asNum % p[1].asNum),
  ),
  Func(
    name: "pow",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: (p) => Value.of(math.pow(p[0].asNum, p[1].asNum)),
  ),
  Func(
    name: "greater",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: (p) => Value.of(p[0].asNum > p[1].asNum),
  ),
  Func(
    name: "greaterEqual",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: (p) => Value.of(p[0].asNum > p[1].asNum),
  ),
  Func(
    name: "little",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: (p) => Value.of(p[0].asNum < p[1].asNum),
  ),
  Func(
    name: "littleEqual",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    logic: (p) => Value.of(p[0].asNum <= p[1].asNum),
  ),
];
final boolFunList = [
  Func(
    name: "and",
    pTypes: const [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    logic: (p) => Value.of(p[0].asBool && p[1].asBool),
  ),
  Func(
    name: "or",
    pTypes: const [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    logic: (p) => Value.of(p[0].asBool || p[1].asBool),
  ),
  Func(
    name: "not",
    pTypes: const [AttrType.bool],
    rType: AttrType.bool,
    logic: (p) => Value.of(!p[0].asBool),
  ),
];
final strFunList = [
  Func(
    name: "len",
    pTypes: const [AttrType.string],
    rType: AttrType.num,
    logic: (p) => Value.of(p[0].v.length),
  )
];

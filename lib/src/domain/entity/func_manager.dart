part of 'func.dart';

/// todo 添加test, 1.检查name唯一性, 2检查参数转换是否正常
/// todo 移除alias属性
class FuncManager {
  static Iterable<MapEntry<String, Func>>? _funcMapCache;

  /// 返回所有的全局函数, 用于表达式解析
  static Iterable<MapEntry<String, Func>> get allFuncMapEntry =>
      _funcMapCache ??= funcList.map((e) => MapEntry(e.name, e)).followedBy(
            al.entries.map((e) => MapEntry(e.key, findBy(e.key))),
          );

  // 是否为短路运算符
  static bool isShortCircuit(String name) =>
      const ['&&', '||', "and", "or"].contains(name);
  static const noneFuncName = "none";
  @Deprecated("使用 thisFunc")
  static const selfFuncName = "self";

  static get memberFuncName => memberFunc.name;

  static get indexFuncName => indexFunc.name;

  static get thisFuncName => asThisFunc.name;
  static get refFuncName => asRefFunc.name;

  @Deprecated("使用 thisFunc")
  static Func get selfFunc => selfFunction;

  static Func get memberFunc => memberFunction;

  static Func get indexFunc => indexFunction;

  static AsFunc get asThisFunc => asFuncThis;
  static AsFunc get asRefFunc => asFuncRef;


  static Iterable<Func> get funcList => [
        ...anyFunList,
        ...boolFunList,
        ...numFunList,
        ...strFunList,
        ...asFuncList,
        memberFunction,
        indexFunction,
      ];

  static bool isAsFunc(String name) =>
      (name.startsWith('as')) &&
      asFuncList.any((element) => element.name == name);

  /// 相关 [AttrType]所有用的方法
  static Map<AttrType, Iterable<Func>> get methodMap => {
        AttrType.any: anyFunList,
        AttrType.boolean: boolFunList,
        AttrType.num: numFunList,
        AttrType.string: strFunList,
        // AttrType.date: dateFunList,
      };

  // 先查一查别名表,如果没有则再查FuncName
  static Func findBy(String funcName, {Func Function()? orElse}) => _findBy(
        (al[funcName] ?? funcName),
        orElse: () => (throw "找不到Func[$funcName]"),
      );

  static Func _findBy(String funcName, {Func Function()? orElse}) =>
      funcList.firstWhere((f) => f.name == funcName, orElse: orElse);
  static Map<String, String> al = {
    "==": "equal",
    "!=": "notEqual",
    "+": "add",
    "-": "sub",
    "*": "mul",
    "/": "div", // 非整除
    "%": "mod",
    "^": "pow",
    ">": "greater",
    ">=": "greaterEqual",
    "<": "little",
    "<=": "littleEqual",
    "&&": "and",
    "||": "or",
    "!": "not",
    // 一元位补码
    "~": "complement",
  };

  static AsFunc findAsFunc(String funcName, {Func Function()? orElse}) =>
      (funcName.startsWith('as'))
          ? asFuncList.firstWhere(
              (f) => f.name == funcName,
              orElse: () => (orElse == null)
                  ? (throw "找不到`AsFunc`[$funcName]")
                  : orElse.call() as AsFunc,
            )
          : throw "findAsFunc 的函数名必须以`as`开头,而不是[$funcName]";
}

// const Func callFunction = CallFunc();

const AsFuncRef asFuncRef = AsFuncRef();
const AsFunc asFuncThis = AsFuncThis();
const Func indexFunction = IndexFunc();

/// 通过RecordId查询当前工作区内的Record,并访问成员对象
/// 类比Java访问内存中的对象
const Func memberFunction = MemberFunc();

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
  AsFuncDynamic(),
  AsFuncRecordMeta(),
  AsFuncRecord(),
  asFuncThis,
  asFuncRef,
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
      rType: AttrType.boolean,
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
    rType: AttrType.boolean,
    logic: (p) => (p[0]) == (p[1]),
  ),
  Func(
    name: "notEqual",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.boolean,
    logic: ((p) => p[0] != p[1]),
  ),
  selfFunction,
  Func(
    name: "complement",
    pTypes: const [AttrType.num],
    rType: AttrType.num,
    logic: (p) => ~(p[0]),
  ),
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
    rType: AttrType.boolean,
    logic: ((p) => (p[0]) > (p[1])),
  ),
  Func(
    name: "greaterEqual",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.boolean,
    logic: ((p) => (p[0]) > (p[1])),
  ),
  Func(
    name: "little",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.boolean,
    logic: ((p) => (p[0]) < (p[1])),
  ),
  Func(
    name: "littleEqual",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.boolean,
    logic: ((p) => (p[0]) <= (p[1])),
  ),
];

/// `short-circuit` 短路表达式
/// todo 考虑将参数2的类型改为 [AttrType.any] 或者对类型检查进行特殊处理
final boolFunList = [
  Func(
    name: "and",
    pTypes: const [AttrType.boolean, AttrType.boolean],
    rType: AttrType.boolean,
    logic: ((p) => (p[0]) && (p[1] is Function) ? p[1].call() : p[1]),
  ),
  Func(
    name: "or",
    pTypes: const [AttrType.boolean, AttrType.boolean],
    rType: AttrType.boolean,
    logic: ((p) => (p[0]) || (p[1] is Function) ? p[1].call() : p[1]),
  ),
  Func(
    name: "not",
    pTypes: const [AttrType.boolean],
    rType: AttrType.boolean,
    logic: ((p) => !(p[0])),
  ),
];
final strFunList = [
  Func(
    name: "len",
    pTypes: const [AttrType.string],
    rType: AttrType.num,
    logic: ((p) => (p[0]).value.length),
  )
];

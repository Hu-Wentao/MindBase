part of 'entity.dart';

class IFunc {
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

  /// 规定 AsFunc (即ag均为dynamic类型)必须以 as开头, 否则会造成Json解析出错;
  static bool isAsFunc(String name) => (name.startsWith('as'));

  // 移除从asFuncList查询的步骤,因为 asFuncRef这样的Func没有固定的name;
  // (name.startsWith('as')) &&
  // asFuncList.any((element) => element.name == name);

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
              orElse: () =>
                  // 如果都没查询到, 则尝试 AsFuncRef.ofName
                  AsFuncRef.ofName(funcName) ??
                  ((orElse == null)
                      ? (throw "找不到`AsFunc`[$funcName]")
                      : orElse.call() as AsFunc),
            )
          : throw "findAsFunc 的函数名必须以`as`开头,而不是[$funcName]";
}

const AsFuncRef asFuncRef = AsFuncRef();
const AsFunc asFuncThis = AsFuncThis();
const Func indexFunction = IndexFunc();

/// 通过RecordId查询当前工作区内的Record,并访问成员对象
/// 类比Java访问内存中的对象
const Func memberFunction = MemberFunc();

/// Func 的实例相当于 Dart的external函数
abstract class Func with EquatableMixin {
  const Func();

  // 全局函数需要确保函数名全局唯一
  String get name;

  List<AttrType> get pTypes;

  /// 用于获取返回值的逻辑, 输入值可以是Type,也可以是参数
  /// 用于`求表达式返回值类型`
  @Deprecated(
      "从expr12.1开始, Func的type获取逻辑,大部分由DTO->Domain托管,如MemberFunc, 少部分如AsFunc,是直接在这里获取")
  AttrType type([List<IExpr>? args]);

  //
  // // 在调用之前,需要先检查Attr的类型匹配问题
  // @protected
  // Function get logic;

  /// [ctx] 仅当函数作为方法体时才会被传入, 内容即对象的成员对象(属性和其他方法)
  invoke([List<dynamic>? ag]);

  // invoke([List<dynamic>? ag]) => logic(ag);

  IFunctor apply(List<IFunctor>? p) {
    throw UnimplementedError();
    // try {
    //   // fixme 未作细节处理，如保留原值等
    //   return Function.apply(logic, p);
    // } catch (e) {
    //   // return Value('', e.toString());
    // }
  }
}

class BaseFunc extends Func {
  @override
  final String name; // 全局唯一
  @override
  final List<AttrType> pTypes;

  // todo 新增一个动态获取 rType的方法，针对Any类型的返回值，可以通过方法得到实际的返回类型，而不是Any
  final AttrType rType;

  // 在调用之前,需要先检查Attr的类型匹配问题
  @protected
  final Function logic;

  /// [ctx] 仅当函数作为方法体时才会被传入, 内容即对象的成员对象(属性和其他方法)
  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  IFunctor apply(List<IFunctor>? p) {
    throw UnimplementedError();
    // try {
    //   // fixme 未作细节处理，如保留原值等
    //   return Function.apply(logic, p);
    // } catch (e) {
    //   // return Value('', e.toString());
    // }
  }

  const BaseFunc({
    required this.name,
    required this.pTypes,
    required this.rType,
    required this.logic,
  });

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  // 固定返回值的Func,一般直接用rType返回即可
  @override
  AttrType type([List<dynamic>? ag]) => rType;
}

class AsFunc<T> implements BaseFunc {
  const AsFunc();

  @override
  String get name => "as$T";

  @override
  List<AttrType> get pTypes => [rType];

  @override
  AttrType get rType {
    switch (T) {
      case String:
        return AttrType.string;
      case int:
      case double:
        return AttrType.num;
      case bool:
        return AttrType.boolean;
      default:
        print("debug# 未知的AsFunc返回值类型:[$T],已转换为 [${AttrType.any}]");
        return AttrType.any;
    }
  }

  @override
  AttrType type([List<dynamic>? ag]) => rType;

  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (args) {
        final v = args[0];
        return v as T;
      };

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  bool get stringify => true;
}

class AsFuncDynamic extends AsFunc {
  const AsFuncDynamic();

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  Function get logic => (_) => _[0];

  @override
  String get name => "asDynamic";

  @override
  AttrType get rType => AttrType.any;
}

class MemberFunc implements Func {
  const MemberFunc();

  @override
  final String name = "member";

  @override
  List<AttrType> get pTypes => [AttrType.any];

  @override
  AttrType type([List<IExpr>? ag]) => ag![1].type;

  /// memberFunc就相当于 `.`, 必须要有两个参数!
  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (p) {
        final record = p[0];
        var propId = p[1];
        print("memberFunction#A# ${record.runtimeType} # $record");
        print("memberFunction#B# ${propId.runtimeType} # $propId");
        if (record is MetaModel) {
          return record.getPropBy(propId).name;
        }
        return record[propId] ?? (throw "找不到 propId [$propId]");
      };

  @override
  List<Object?> get props => [name, pTypes, logic];

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  bool get stringify => true;
}

/// 访问数组对象
class IndexFunc implements BaseFunc {
  const IndexFunc();

  @override
  final String name = "index";

  /// [索引, 对象]
  @override
  List<AttrType> get pTypes => [AttrType.num, rType];

  @override
  AttrType get rType => AttrType.any;

  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (p) {
        final index = p[0];
        final list = p[1];
        return list[index] ?? (throw "list 中找不到索引 [$index]");
      };

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  bool get stringify => true;

  @override
  AttrType type([List<dynamic>? ag]) => rType;
}

/// 可以构造[rType]用于表达式返回值类型推断
/// asRef_xx<某MetaId>xx([<this所属Meta的propId,并且与`某MetaId`不同>])
/// 用于表示变量再ctx中是某个Meta下的实例, 其中,xx就代表该Meta的Id
/// todo asRef描述的是,在表达式中,value的类型,
class AsFuncRef implements AsFunc {
  @override
  final AttrType rType;

  const AsFuncRef([this.rType = AttrType.any]);

  static const funPrefix = "asRef_";

  static AsFuncRef? ofName(String funcName) {
    if (!funcName.startsWith(funPrefix)) return null;
    // return AsFuncRef(AttrType.ref(funcName.substring(funPrefix.length)));
    print(
        "AsFuncRef# 不允许通过 ofName进行构造! 即不允许持久化 AsFuncRef, 应当持久化为AsFuncString, 值为RecordId或MetaId.funcName:[$funcName]");
    return null;
  }

  @override
  // String get name => 'asRef';
  String get name => "$funPrefix${rType.r}";

  @override
  AttrType type([List<dynamic>? ag]) => rType;

  @override
  IFunctor apply(List<IFunctor>? p) {
    throw UnimplementedError();
  }

  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (p) => p[0];

  @override
  List<AttrType> get pTypes => throw UnimplementedError();

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  @override
  bool get stringify => true;
}

///
/// [AsFuncThis] 是一个标记性的函数,没有固定Args,返回值从ctx中获取
/// [AsFuncThis]与[AsFuncRef]
/// asThis,用于表示当前类型的对象, 描述了一种"相对的位置",具体的ref值是从ctx中获取;
/// asRef,是绝对位置,ref指定MetaId将会被持久化到数据库中
class AsFuncThis implements AsFunc {
  /// 指定返回值类型, 可以帮助表达式确认Meta, 用于多层MemberFunc的转换
  /// 因此,[AsFuncThis]应当在convert或eval时,
  /// 从ctx中取[ctxTypeSign]作为[rType](是Meta的Id, 因为AttrType只能存储MetaId,暂时不能存储Meta)
  /// 从ctx中取[ctxSign]作为ag:[0]的值(是Record)
  @override
  final AttrType rType;

  const AsFuncThis([this.rType = AttrType.any]);

  @override
  AttrType type([List<dynamic>? ag]) => rType;

  // 如果上下文中存在`this`,则为其key值
  static const ctxSign = 'this';

  /// 如果上下文没有`this`,但是有`this`的类型(Meta),(如表达式convert场景)则为其key值
  /// 对应的value,应该是[MetaModel]类型
  @Deprecated("使用ctxMetaIdSign")
  static const ctxTypeSign = 'thisType';

  /// 作用与[ctxTypeSign] 相同
  /// 如果上下文没有`this`,但是有`this`的类型Id(MetaId),(如表达式convert场景)则为其key值
  /// value是 metaId: String;
  /// (`>>`用于防止用户输入同名变量)
  static const ctxMetaIdSign = '>>thisMetaId';
  @override
  final String name = 'asThis';

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (p) => p[0];

  @override
  List<AttrType> get pTypes => throw UnimplementedError();

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  @override
  bool get stringify => true;
}

@Deprecated("使用asThis")
final Func selfFunction = BaseFunc(
  name: IFunc.selfFuncName,
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
  asFuncThis,
  asFuncRef,
];

/// 类型检查与转换表达式, 检查/转换失败则抛出异常
final anyFunList = <Func>[
  BaseFunc(
      name: "toStr",
      pTypes: const [AttrType.any],
      rType: AttrType.string,
      logic: (p) => "${p[0]}"),
  BaseFunc(
      name: "toNum",
      pTypes: const [AttrType.any],
      rType: AttrType.num,
      logic: (p) => num.parse(p[0])),
  BaseFunc(
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
  BaseFunc(
    name: "equal",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.boolean,
    logic: (p) => (p[0]) == (p[1]),
  ),
  BaseFunc(
    name: "notEqual",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.boolean,
    logic: ((p) => p[0] != p[1]),
  ),
  selfFunction,
  BaseFunc(
    name: "complement",
    pTypes: const [AttrType.num],
    rType: AttrType.num,
    logic: (p) => ~(p[0]),
  ),
];

/// 基础表达式
/// todo 尚未修改返回值类型为[ExprValue]
final numFunList = [
  BaseFunc(
    name: "add",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) => (p[0] as ExprValue).value + (p[1] as ExprValue).value),
  ),
  BaseFunc(
    name: "sub",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) => (p[0] as ExprValue).value - (p[1] as ExprValue).value),
  ),
  BaseFunc(
    name: "mul",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) => (p[0] as ExprValue).value * (p[1] as ExprValue).value),
  ),
  BaseFunc(
    name: "div",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) => (p[0] as ExprValue).value / (p[1] as ExprValue).value),
  ),
  BaseFunc(
    name: "mod",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) => (p[0] as ExprValue).value % (p[1] as ExprValue).value),
  ),
  BaseFunc(
    name: "pow",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    logic: ((p) =>
        math.pow((p[0] as ExprValue).value, (p[1] as ExprValue).value)),
  ),
  BaseFunc(
    name: "greater",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.boolean,
    logic: ((p) => (p[0] as ExprValue).value > (p[1] as ExprValue).value),
  ),
  BaseFunc(
    name: "greaterEqual",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.boolean,
    logic: ((p) => (p[0] as ExprValue).value > (p[1] as ExprValue).value),
  ),
  BaseFunc(
    name: "little",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.boolean,
    logic: ((p) => (p[0] as ExprValue).value < (p[1] as ExprValue).value),
  ),
  BaseFunc(
    name: "littleEqual",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.boolean,
    logic: ((p) => (p[0] as ExprValue).value <= (p[1] as ExprValue).value),
  ),
];

/// `short-circuit` 短路表达式
/// todo 考虑将参数2的类型改为 [AttrType.any] 或者对类型检查进行特殊处理
final boolFunList = [
  BaseFunc(
    name: "and",
    pTypes: const [AttrType.boolean, AttrType.boolean],
    rType: AttrType.boolean,
    logic: ((p) => (p[0] as ExprValue).value && (p[1] is Function)
        ? p[1].call()
        : (p[1] as ExprValue).value),
  ),
  BaseFunc(
    name: "or",
    pTypes: const [AttrType.boolean, AttrType.boolean],
    rType: AttrType.boolean,
    logic: ((p) => (p[0] as ExprValue).value || (p[1] is Function)
        ? p[1].call()
        : (p[1] as ExprValue).value),
  ),
  BaseFunc(
    name: "not",
    pTypes: const [AttrType.boolean],
    rType: AttrType.boolean,
    logic: ((p) => !(p[0] as ExprValue).value),
  ),
];
final strFunList = [
  BaseFunc(
    name: "len",
    pTypes: const [AttrType.string],
    rType: AttrType.num,
    logic: ((p) => (p[0] as ExprValue).value.value.length),
  )
];

import 'package:mind_base/src/domain/value.dart';
import 'dart:math' as math;

import 'package:mind_base/src/interface/dto.dart';

/// 函数 ========================================================================
abstract class ICallable extends IMongoDto {
  ICallable call(List<ICallable> p);
}

abstract class BaseCallable extends IMongoDto implements ICallable {
  const BaseCallable();

  factory BaseCallable.fromTypedJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final real = json['real'] as Map<String, dynamic>;
    switch (type) {
      case "Value":
        return Value.fromJson(real);
      case 'Func':
        return Func.fromJson(real);
      case 'Expression':
        return Expression.fromJson(real);
      default:
        throw Exception('BaseCallable::fromTypedJson# Unknown type: $type');
    }
  }

  Map<String, dynamic> toJsonWithType() => {
        'type': "$runtimeType",
        'real': toJson(),
      };

  @override
  toMongoJson({AttrType type = AttrType.string}) => toJsonWithType();
}

/// 表达式由多个[Func]构成
/// 如果是Value，则pTypes为空， expr为表达式的内容， rType为返回值类型
class Expression extends BaseCallable {
  static Expression field(AttrType rType, {List<BaseCallable>? calls}) =>
      Expression(
        pTypes: const [AttrType.any], // 单个入参
        calls: calls ?? [FuncManager.selfFunc], // 不做处理返回自身
        rType: rType,
      );

  /// [pThisType] 表示改列对应的Value的类型
  static Expression method(
    AttrType pThisType, {
    required AttrType rType,
    required List<AttrType> pTypes,
    required List<BaseCallable> calls,
  }) =>
      Expression(
        pTypes: [pThisType, ...pTypes],
        calls: calls,
        rType: rType,
      );

  final List<AttrType> pTypes;
  final List<BaseCallable> calls;
  final AttrType rType;

  @override
  ICallable call(List<ICallable> p) {
    // fixme 未检查类型正确性
    late ICallable r;
    for (var callable in calls) {
      r = callable.call(p);
    }
    return r;
  }

  const Expression({
    required this.pTypes,
    required this.calls,
    required this.rType,
  });

  @override
  List<Object?> get props => [pTypes, calls, rType];

  static Expression fromJson(Map<String, dynamic> attrMap) => Expression(
        pTypes: (attrMap['pTypes'] as List<dynamic>)
            .map((e) => e as String)
            .map((AttrType.values.byName))
            .toList(),
        calls: (attrMap['calls'] as List<dynamic>)
            .map((e) => BaseCallable.fromTypedJson(e as Map<String, dynamic>))
            .toList(),
        rType: AttrType.values.byName(attrMap['rType'] as String),
      );

  @override
  Map<String, dynamic> toJson() => {
        'pTypes': pTypes.map((e) => e.name).toList(growable: false),
        'calls': calls.map((e) => e.toJsonWithType()).toList(growable: false),
        'rType': rType.name,
      };

  @override
  toMongoJson({AttrType type = AttrType.string}) => toJson();
}

class Func extends BaseCallable {
  final String name; // 全局唯一
  final String? alias;
  final List<AttrType> pTypes;
  final AttrType rType;

  // run 只有运算, 在调用之前,需要先检查Attr的类型匹配问题
  final ICallable Function(List<ICallable> p) onRun;

  @override
  ICallable call(List<ICallable> p) {
    try {
      // fixme 未作细节处理，如保留原值等
      return onRun(p);
    } catch (e) {
      return Value('', e.toString());
    }
  }

  const Func({
    required this.name,
    this.alias,
    required this.pTypes,
    required this.rType,
    required this.onRun,
  });

  @override
  List<Object?> get props => [name, alias, pTypes, rType, onRun];

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
      };

  @override
  toMongoJson({AttrType type = AttrType.string}) => toJson();

  static Func fromJson(Map<String, dynamic> json) =>
      FuncManager.findBy(json['name'] as String);
}

/// todo 添加test, 1.检查name唯一性, 2检查参数转换是否正常
class FuncManager {
  static const String noneFuncName = "none";
  static const String selfFuncName = "self";
  static final Func noneFunc = selfFunc;
  static final Func selfFunc = Func(
    name: selfFuncName,
    pTypes: const [AttrType.any],
    rType: AttrType.any,
    onRun: (p) => p[0],
  );

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

  static Func findBy(String funcName, {Func Function()? orElse}) =>
      funcList.firstWhere((f) => f.name == funcName, orElse: orElse);
}

/// 类型检查与转换表达式, 检查/转换失败则抛出异常
final anyFunList = <Func>[
  FuncManager.noneFunc,
  FuncManager.selfFunc,
  Func(
      name: "toStr",
      pTypes: const [AttrType.any],
      rType: AttrType.string,
      onRun: (p) => Value.of((p[0] as Value).asString)),
  Func(
      name: "toNum",
      pTypes: const [AttrType.any],
      rType: AttrType.num,
      onRun: (p) => Value.of((p[0] as Value).asNum)),
  Func(
      name: "toBool",
      pTypes: const [AttrType.any],
      rType: AttrType.bool,
      onRun: (p) => Value.of((p[0] as Value).asBool)),
  Func(
      name: "toDate",
      pTypes: const [AttrType.any],
      rType: AttrType.date,
      onRun: (p) => Value.of((p[0] as Value).asDate)),
  Func(
    name: "equal",
    alias: "==",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    onRun: (p) =>
        Value.of((p[0] as Value).asString == (p[1] as Value).asString),
  ),
  Func(
    name: "notEqual",
    alias: "!=",
    pTypes: const [AttrType.any, AttrType.any],
    rType: AttrType.bool,
    onRun: (p) =>
        Value.of((p[0] as Value).asString != (p[1] as Value).asString),
  ),
];

/// 基础表达式
final numFunList = [
  Func(
    name: "add",
    alias: "+",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of((p[0] as Value).asNum + (p[1] as Value).asNum),
  ),
  Func(
    name: "sub",
    alias: "-",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of((p[0] as Value).asNum - (p[1] as Value).asNum),
  ),
  Func(
    name: "mul",
    alias: "*",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of((p[0] as Value).asNum * (p[1] as Value).asNum),
  ),
  Func(
    name: "div",
    alias: "/",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of((p[0] as Value).asNum / (p[1] as Value).asNum),
  ),
  Func(
    name: "mod",
    alias: "%",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) => Value.of((p[0] as Value).asNum % (p[1] as Value).asNum),
  ),
  Func(
    name: "pow",
    alias: "^",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.num,
    onRun: (p) =>
        Value.of(math.pow((p[0] as Value).asNum, (p[1] as Value).asNum)),
  ),
  Func(
    name: "greater",
    alias: ">",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of((p[0] as Value).asNum > (p[1] as Value).asNum),
  ),
  Func(
    name: "greaterEqual",
    alias: ">=",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of((p[0] as Value).asNum > (p[1] as Value).asNum),
  ),
  Func(
    name: "little",
    alias: "<",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of((p[0] as Value).asNum < (p[1] as Value).asNum),
  ),
  Func(
    name: "littleEqual",
    alias: "<=",
    pTypes: const [AttrType.num, AttrType.num],
    rType: AttrType.bool,
    onRun: (p) => Value.of((p[0] as Value).asNum <= (p[1] as Value).asNum),
  ),
];
final boolFunList = [
  Func(
    name: "and",
    alias: "&&",
    pTypes: const [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    onRun: (p) => Value.of((p[0] as Value).asBool && (p[1] as Value).asBool),
  ),
  Func(
    name: "or",
    alias: "||",
    pTypes: const [AttrType.bool, AttrType.bool],
    rType: AttrType.bool,
    onRun: (p) => Value.of((p[0] as Value).asBool || (p[1] as Value).asBool),
  ),
  Func(
    name: "not",
    alias: "!",
    pTypes: const [AttrType.bool],
    rType: AttrType.bool,
    onRun: (p) => Value.of(!(p[0] as Value).asBool),
  ),
];
final strFunList = [
  Func(
    name: "len",
    pTypes: const [AttrType.string],
    rType: AttrType.num,
    onRun: (p) => Value.of((p[0] as Value).v.length),
  )
];

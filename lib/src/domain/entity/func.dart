import 'dart:convert';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/value.dart';
import 'dart:math' as math;

import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

part 'func_manager.dart';

mixin IExpr on IFunctor {
  Func get fn;

  /// [ctx] 上下文, 仅在IExpr为Expression,并且作为`方法`时,才会传入
  callee([Map<String, dynamic>? ctx]);

  AttrType get type => fn.rType;

  List<dynamic> get ag;
}

/// 表达式[Expression]由多个[Func]构成
/// 表达式是有状态的,存储了参数的来源,返回值类型等等; 而Func是无状态,只有name
/// 如果是Value，则pTypes为空， expr为表达式的内容， rType为返回值类型
/// 如果Expression作为方法体, 则 ag[0]应当为`this`
class Expression with IFunctor, IExpr, EquatableMixin {
  @override
  final Func fn;
  @override
  final List<IExpr> ag;

  const Expression(this.fn, [this.ag = const []]);

  /// self 参数 当且仅当 表达式是`方法体`时才会传入, 值应当为Record的prop集合
  @override
  callee([Map<String, dynamic>? ctx]) => fn.invoke(
        ctx, // 相当于this
        ag.map((a) => a.callee(ctx)).toList(),
      );

// todo 出入参数量,类型检查 等等
  @override
  get value => callee();

  @override
  List<Object?> get props => [fn, ag];

// @override
// IFunctor fMap(Func fn) {
//   // TODO: implement fMap
//   throw UnimplementedError();
// }

}

mixin IFunctor {
  dynamic get value;

// IFunctor fMap(Func fn);
}

// /// Expr-v11.2 方案,允许Value指定类型
// class Value2<T> extends IExpr with IFunctor, EquatableMixin,ITypeMx{
//   @override
//   final AsFunc<T> fn ;
//
//   @override
//   final  List<IExpr> ag ;
//
//   @override
//   List<Object?> get props =>[fn,ag];
//
//   @override
//  T get value => throw UnimplementedError();
// }

/// Expr-v11.2 方案 直接存储dynamic类型,通过 fn映射为具体的类型
/// 一般来说 List [ag], ag[0]用于存储 v, 表示当前的值;考虑用ag[1]存储 e
/// 需要注意的是, ag[0]可以是dynamic类型,在计算时,会自动as为String类型
class Value with IFunctor, IExpr, EquatableMixin {
  @override
  final AsFunc fn; // 对于Value, fn对象始终是 [AsFunc]类及其子类
  // 对于Value, ag对象始终是 [List<String>]类
  @override
  final List<dynamic> ag; // ag[0]为实际值, ag[1]为错误值
  @override
  callee([Map<String, dynamic>? ctx]) => fn.logic.call(ag);

  @override
  dynamic get value => callee();

  dynamic get v => value;

  String get e => ag[1];

  @override
  List<Object?> get props => [fn, ...ag];

  @protected
  const Value({
    required this.fn,
    required this.ag,
  });

  factory Value.of(dynamic v, [dynamic e]) {
    AsFunc fn;
    switch (v.runtimeType) {
      case double:
        fn = const AsFunc<double>();
        break;
      case int:
        fn = const AsFunc<int>();
        break;
      case num:
        fn = const AsFunc<num>();
        break;
      case String:
        fn = const AsFunc<String>();
        break;
      case bool:
        fn = const AsFunc<bool>();
        break;
      default:
        fn = const AsFuncDynamic();
      // throw "暂不支持的包装类型[${v.runtimeType}]";
    }

    return Value(
      fn: fn,
      ag: [v ?? "", if (e != null) e],
    );
  }

  factory Value.err(String? e) => Value.of("", e);

  Value.fromJson(Map<String, dynamic> json)
      : this(
          fn: FuncManager.findAsFunc(json['fn'] as String),
          ag: (json['ag'] as List<dynamic>),
        );

  toJson() => {
        "fn": fn.name,
        "ag": jsonEncode(ag),
      };

  // 返回值可以是 json， 也可以是[ObjectId]
  dynamic toMongoJson({AttrType type = AttrType.string}) {
    switch (type) {
      // case AttrType.objectId: // todo 暂无实现
      //   return value;
      default:
        return toJson();
    }
  }
}

/// Func 的实例相当于 Dart的external函数
class Func with EquatableMixin {
  final String name; // 全局唯一
  final List<AttrType> pTypes;

  // todo 新增一个动态获取 rType的方法，针对Any类型的返回值，可以通过方法得到实际的返回类型，而不是Any
  final AttrType rType;

  // 在调用之前,需要先检查Attr的类型匹配问题
  @protected
  final Function logic;

  /// [ctx] 仅当函数作为方法体时才会被传入, 内容即对象的成员对象(属性和其他方法)
  invoke([Map<String, dynamic>? ctx, List<dynamic>? ag]) => logic(ag);

  IFunctor apply(List<IFunctor>? p) {
    throw UnimplementedError();
    try {
      // fixme 未作细节处理，如保留原值等
      return Function.apply(logic, p);
    } catch (e) {
      // return Value('', e.toString());
    }
  }

  const Func({
    required this.name,
    required this.pTypes,
    required this.rType,
    required this.logic,
  });

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

// Map<String, dynamic> toJson() => {
//       "name": name,
//     };
//
// toMongoJson({AttrType type = AttrType.string}) => toJson();
//
// static Func fromJson(Map<String, dynamic> json) =>
//     FuncManager.findBy(json['name'] as String);
}

class AsFunc<T> implements Func {
  const AsFunc();

  @override
  String get name => "as$T";

  @override
  List<AttrType> get pTypes => [rType];

  @override
  AttrType get rType => AttrType.values.byName("$T");

  @override
  invoke([Map<String, dynamic>? ctx, List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (args) {
        final v = args[0];
        // if (v is String && T is ObjectId) {
        //   return ObjectId.fromHexString(v);
        // }
        return v as T;
      };

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  // @override
  // Map<String, dynamic> toJson() => {
  //       "name": name,
  //     };
  //
  // @override
  // toMongoJson({AttrType type = AttrType.string}) => toJson();

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

  /// [ctx]是隐式传递
  @override
  List<AttrType> get pTypes => [rType];

  @override
  AttrType get rType => AttrType.any;

  @override
  invoke([Map<String, dynamic>? ctx, List<dynamic>? ag]) {
    if (ctx == null) throw "MemberFunc 必须传入 ctx";
    return logic([ctx, if (ag != null) ...ag]);
  }

  @override
  Function get logic => (p) {
        print("memberFunction# param # $p");
        final record = p[0];
        final propId = p[1];
        return record[propId] ?? (throw "找不到 propId [$propId]");
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

/// 访问数组对象
class IndexFunc implements Func {
  const IndexFunc();

  @override
  final String name = "index";

  /// [索引, 对象]
  @override
  List<AttrType> get pTypes => [AttrType.num, rType];

  @override
  AttrType get rType => AttrType.any;

  @override
  invoke([Map<String, dynamic>? ctx, List<dynamic>? ag]) => logic(ag);

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
}

import 'dart:convert';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/value.dart';
import 'dart:math' as math;

import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

part 'func_manager.dart';

mixin IExpr on IFunctor {
  Func get fn;

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

  const Expression(this.fn, this.ag);

  AttrType get type => fn.rType;

// todo 出入参数量,类型检查 等等
  @override
  Value get value => Value.of(fn.logic.call(ag));

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

/// Expr-v11.1 方案 所有Value都是对String类型的包装,无其他类型
/// 一般来说 List [ag], ag[0]用于存储 v, 表示当前的值;考虑用ag[1]存储 e
/// 需要注意的是, ag[0]可以是dynamic类型,在计算时,会自动as为String类型
class Value with IFunctor, IExpr, EquatableMixin {
  @override
  final AsFunc<String> fn; // 对于Value, fn对象始终是 [AsFunc]类及其子类
  // 对于Value, ag对象始终是 [List<String>]类
  @override
  final List<dynamic> ag; // ag[0]为实际值, ag[1]为错误值

  @override
  String get value => fn.logic.call(ag);

  String get v => value;

  @override
  List<Object?> get props => [fn, ...ag];

  @protected
  const Value({
    this.fn = const AsFunc<String>(),
    required this.ag,
  });

  Value.of(dynamic v, [dynamic e]) : this(ag: [v ?? "", if (e != null) e]);

  Value.err(String? e) : this.of("", e);

  Value.fromJson(Map<String, dynamic> json)
      : this(
          fn: FuncManager.findAsFunc(json['fn'] as String) as AsFunc<String>,
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
  final Function logic;

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
  Function get logic => (v) {
        if (v is String && T is ObjectId) {
          return ObjectId.fromHexString(v);
        }
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

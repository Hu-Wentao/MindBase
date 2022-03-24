import 'package:mind_base/src/domain/value.dart';
import 'dart:math' as math;

import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

part 'func_manager.dart';

/// 函数 ========================================================================
mixin Invokable on EquatableMixin {
  Invokable invoke();
}

/// 表达式[Expression]由多个[Func]构成
/// 表达式是有状态的,存储了参数的来源,返回值类型等等; 而Func是无状态,只有name
/// 如果是Value，则pTypes为空， expr为表达式的内容， rType为返回值类型
class Expression extends BaseCallable {
  static Expression field(
    ObjectId? selfMetaId,
    int selfKey,
    AttrType rType,
  ) =>
      Expression(
        metaId: selfMetaId, // 字段 所存在的Meta,
        pKeys: [selfKey], // 字段的Attr::k
        calls: [FuncManager.selfFunc], // 返回字段本身
        rType: rType,
      );

  /// [pThisType] 表示改列对应的Value的类型
  static Expression method(
    AttrType pThisType, {
    required ObjectId metaId,
    required AttrType rType,
    required List<int> pAttrKeys,
    required List<BaseCallable> calls,
  }) =>
      Expression(
        metaId: metaId,
        pKeys: pAttrKeys,
        calls: calls,
        rType: rType,
      );

  /// Expression 所在列的Value必须是[AttrType.objectId]类型
  /// Expression 所在
  /// Value持有的ObjectId对应的
  final ObjectId? metaId; // null表示引用当前类的meta
  final List<int> pKeys;
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
    required this.metaId,
    required this.pKeys,
    required this.calls,
    required this.rType,
  });

  @override
  List<Object?> get props => [metaId, pKeys, calls, rType];

  static Expression fromJson(Map<String, dynamic> attrMap) {
    final mtId = attrMap['metaId'] as String?;
    return Expression(
      metaId: mtId == null ? null : ObjectId.fromHexString(mtId),
      pKeys: (attrMap['pKeys'] as List<dynamic>).map((e) => e as int).toList(),
      calls: (attrMap['calls'] as List<dynamic>)
          .map((e) => BaseCallable.fromTypedJson(e as Map<String, dynamic>))
          .toList(),
      rType: AttrType.values.byName(attrMap['rType'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'metaId': metaId?.toHexString(), // 空表示当前所在的Meta类
        'pKeys': pKeys.map((e) => e).toList(growable: false),
        'calls': calls.map((e) => e.toJsonWithType()).toList(growable: false),
        'rType': rType.name,
      };

  @override
  toMongoJson({AttrType type = AttrType.string}) => toJson();
}

// class Expression  {
//   static Expression field(
//     ObjectId? selfMetaId,
//     int selfKey,
//     AttrType rType,
//   ) =>
//       Expression(
//         metaId: selfMetaId, // 字段 所存在的Meta,
//         pKeys: [selfKey], // 字段的Attr::k
//         calls: [], // 返回字段本身
//         rType: rType,
//       );
//
//   /// [pThisType] 表示改列对应的Value的类型
//   static Expression method(
//     AttrType pThisType, {
//     required ObjectId metaId,
//     required AttrType rType,
//     required List<int> pAttrKeys,
//     required List<Invokable> calls,
//   }) =>
//       Expression(
//         metaId: metaId,
//         pKeys: pAttrKeys,
//         calls: calls,
//         rType: rType,
//       );
//
//   /// Expression 所在列的Value必须是[AttrType.objectId]类型
//   /// Expression 所在
//   /// Value持有的ObjectId对应的
//   final ObjectId? metaId; // null表示引用当前类的meta
//   final List<int> pKeys;
//   final List<Invokable> calls;
//   final AttrType rType;
//
//   @override
//   Invokable invoke([List<Invokable> p = const []]) {
//     // fixme 未检查类型正确性
//     late Invokable r;
//     for (var callable in calls) {
//       r = callable.invoke();
//     }
//     return r;
//   }
//
//   const Expression({
//     required this.metaId,
//     required this.pKeys,
//     required this.calls,
//     required this.rType,
//   });
//
//   @override
//   List<Object?> get props => [metaId, pKeys, calls, rType];
//
//   static Expression fromJson(Map<String, dynamic> attrMap) {
//     final mtId = attrMap['metaId'] as String?;
//     return Expression(
//       metaId: mtId == null ? null : ObjectId.fromHexString(mtId),
//       pKeys: (attrMap['pKeys'] as List<dynamic>).map((e) => e as int).toList(),
//       calls: [],
//       // calls: (attrMap['calls'] as List<dynamic>)
//       //     .map((e) => BaseCallableDto.fromTypedJson(e as Map<String, dynamic>))
//       //     .toList(),
//       rType: AttrType.values.byName(attrMap['rType'] as String),
//     );
//   }
//
//   @override
//   Map<String, dynamic> toJson() => {
//         'metaId': metaId?.toHexString(), // 空表示当前所在的Meta类
//         'pKeys': pKeys.map((e) => e).toList(growable: false),
//         // 'calls': calls.map((e) => e.toJsonWithType()).toList(growable: false),
//         'rType': rType.name,
//       };
//
//   @override
//   toMongoJson({AttrType type = AttrType.string}) => toJson();
// }

class Func with EquatableMixin {
  final String name; // 全局唯一
  final List<AttrType> pTypes;

  // todo 新增一个动态获取 rType的方法，针对Any类型的返回值，可以通过方法得到实际的返回类型，而不是Any
  final AttrType rType;

  // run 只有运算, 在调用之前,需要先检查Attr的类型匹配问题
  final Invokable Function(List<Invokable> p) logic;

  Invokable onInvoke(List<Value> p) {
    try {
      // fixme 未作细节处理，如保留原值等
      return logic(p);
    } catch (e) {
      return Value('', e.toString());
    }
  }

  const Func({
    required this.name,
    required this.pTypes,
    required this.rType,
    required this.logic,
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

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/value.dart';
import 'dart:math' as math;

import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

part 'func_manager.dart';

abstract class IExpr with IFunctor {
  const IExpr();

  factory IExpr.of(Func fn, List<dynamic> ag) {
    if (ag is List<IExpr>) {
      print(
          "IExpr.of: ag is List<IExpr>#[${fn.runtimeType}], ag: ${ag.join(", ")}");
      return Expression(fn, ag);
    } else if (fn is AsFunc) {
      print("IExpr.of: fn is AsFunc#[${fn.runtimeType}], ag: ${ag.join(", ")}");
      return Value(fn: fn, ag: ag);
    } else if (fn is MemberFunc) {
      // fixme 这里由于MemberFunc 的参数额外添加了一个 RecordMeta的kvMap, 导致这里需要特殊处理
      print("debug### ag[0]: ${ag[0].runtimeType}");
      return Expression(fn, [Value.of((ag[0] as RecordMeta)), Value.of(ag[1])]);
    } else {
      throw "IExpr.of# [${fn.runtimeType}] # ${ag.join(", ")}";
    }
  }

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
class Expression extends IExpr with IFunctor, EquatableMixin {
  // todo 如果短时间内无法解决, 则使用本方案
  // String? raw; // 存储原始可读串, 用于解决表达式无法被还原的问题

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
class Value extends IExpr with IFunctor, EquatableMixin {
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
    dynamic value = v ?? "";
    switch (v.runtimeType) {
      case String:
        fn = const AsFunc<String>();
        break;
      case double:
        fn = const AsFunc<double>();
        break;
      case int:
        fn = const AsFunc<int>();
        break;
      case num:
        fn = const AsFunc<num>();
        break;
      case bool:
        fn = const AsFunc<bool>();
        break;
      case RecordMeta:
        return Value.ofMetaId(v.id);
      case Record:
        fn = const AsFuncRecord();
        value = v.id;
        break;
      case IExpr:
        return v;
      case Value: // 无法被IExpr取代, 原因未知
        return v;
      case Expression: // 无法被IExpr取代, 原因未知
        return v;
      default:
        fn = const AsFuncDynamic();
      // throw "暂不支持的包装类型[${v.runtimeType}]";
    }
    return Value(
      fn: fn,
      ag: [value, if (e != null) e],
    );
  }

  Value.ofMetaId(ObjectId metaId)
      : this(
          fn: const AsFuncRecordMeta(),
          ag: [metaId],
        );

  factory Value.err(String? e) => Value.of("", e);

  @override
  String toString() => '${fn.name}($ag)';
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
    // try {
    //   // fixme 未作细节处理，如保留原值等
    //   return Function.apply(logic, p);
    // } catch (e) {
    //   // return Value('', e.toString());
    // }
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

class AsFuncRecord extends AsFunc<Record> {
  const AsFuncRecord();

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  /// 存储的是RecordId
  @override
  Function get logic => (_) {
        final recordId = _[0];
        final record = sl<WorkspaceDataHolder>().queryRecordBy(recordId);
        return record;
      };

  @override
  String get name => "asFuncRecord";

  @override
  AttrType get rType => AttrType.any;
}

class AsFuncRecordMeta extends AsFunc<RecordMeta> {
  const AsFuncRecordMeta();

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  /// 存储的是MetaId
  @override
  Function get logic => (_) {
        // fixme 这里做特殊处理,
        final metaId = (_[0] is ObjectId)
            ? _[0]
            : ObjectId.fromHexString(_[0]); // ObjectId (MetaId), 注册在Workspace中
        final meta = sl<WorkspaceDataHolder>().getMetaBy(metaId);
        return meta;
      };

  @override
  String get name => "asFuncRecordMeta";

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

  /// fixme 隐式传递 本身就是个错误的设计! 应当恢复成原有的样式, memberFunc就相当于 `.`, 必须要有两个参数!
  @override
  invoke([Map<String, dynamic>? ctx, List<dynamic>? ag]) {
    if (ctx == null) throw "MemberFunc 必须传入 ctx";
    return logic([ctx, if (ag != null) ...ag]);
  }

  @override
  Function get logic => (p) {
        print("memberFunction# param # $p");
        final record = p[0];
        var propId = p[1];
        // fixme 通过UI创建的方法Expr, 传入的ctx正常, 但参数 p[1]是 RecordMeta, p[2]是 propId, 与预期的 仅p[1] propId不符, 这里进行特殊处理
        if (p[1] is RecordMeta) {
          propId = p[2];
        }
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

/// 执行函数
class CallFunc implements Func {
  const CallFunc();

  @override
  final String name = "call";

  /// [callee, List参数列表]
  /// todo 考虑新增 函数类型, List类型
  @override
  List<AttrType> get pTypes => [AttrType.any, AttrType.any];

  @override
  AttrType get rType => AttrType.any;

  @override
  invoke([Map<String, dynamic>? ctx, List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (p) {
        print("callFunc#$p");
        final callee = p[0];
        final args = p[1];
        return Function.apply(callee, args) ??
            (throw "无法执行函数[$callee], 参数[$args]");
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

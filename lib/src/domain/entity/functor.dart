import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/value.dart';
import 'dart:math' as math;

import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

part 'func.dart';

abstract class IExpr with IFunctor {
  const IExpr();

  /// 不常用, 如果是 [ExpressionDto]转换成 [IExpr], 则需要使用 [ExprDtoToDomain],结合ctx上下文做转换
  factory IExpr.of(Func fn, List<dynamic> ag, AttrType type) {
    if (fn is AsFunc) {
      return Value(fn: fn, ag: ag);
    } else if (ag is List<IExpr>) {
      return Expression(fn: fn, ag: ag, type: type);
    } else {
      throw "IExpr.of构造失败#fn名称与类型: [${fn.name}][${fn.runtimeType}] #ag参数# ${ag
          .join(", ")}";
    }
  }

  Func get fn;

  /// 调用后即为 [value]
  callee();

  // 返回值类型
  AttrType get type;

  List<dynamic> get ag;
}

/// 表达式[Expression]由多个[Func]构成
/// 表达式是有状态的,存储了参数的来源,返回值类型等等; 而Func是无状态,只有name
/// 如果是Value，则pTypes为空， expr为表达式的内容， rType为返回值类型
/// 如果Expression作为方法体, 则 ag[0]应当为`this`
class Expression extends IExpr with IFunctor, EquatableMixin {
  @override
  final Func fn;
  @override
  final List<IExpr> ag;

  // expr-v12.1 表达式需要显式确定返回值类型
  @override
  final AttrType type;

  // const Expression(this.fn, this.type, [this.ag = const []]);
  const Expression({required this.fn, this.ag = const [], required this.type});

  // const Expression(this.fn, [this.ag = const [], this.type = AttrType.any]);

  @override
  callee() => fn.invoke(ag.map((a) => a.callee()).toList());

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

/// Expr-v11.2 方案 直接存储dynamic类型,通过 fn映射为具体的类型
/// 一般来说 List [ag], ag[0]用于存储 v, 表示当前的值;考虑用ag[1]存储 e
/// 需要注意的是, ag[0]可以是dynamic类型,在计算时,会自动as为String类型
class Value extends IExpr with IFunctor, EquatableMixin {
  @override
  final AsFunc fn; // 对于Value, fn对象始终是 [AsFunc]类及其子类
  @override
  final List<dynamic> ag; // ag[0]为实际值, ag[1]为错误值
  @override
  callee() => fn.logic.call(ag);

  // expr-v12.1
  @override
  AttrType get type => fn.rType;

  @override
  dynamic get value => callee();

  dynamic get v => ag[0];

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

  /// 特殊处理 对于[RecordMeta], 直接存储 metaId:[ObjectId]
  Value.ofMetaId(ObjectId metaId)
      : this(fn: const AsFuncRecordMeta(), ag: [metaId]);

  factory Value.err(String? e) => Value.of("", e);

  @override
  String toString() => '${fn.name}($ag)';
}

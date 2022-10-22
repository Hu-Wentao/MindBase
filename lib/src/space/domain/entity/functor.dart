part of 'entity.dart';

typedef FindRecordFn = RecordModel Function(ExprValue value);

abstract class IExpr with IFunctor {
  const IExpr();

  /// 不常用, 如果是 [ExpressionDto]转换成 [IExpr], 则需要使用 [ExprDtoToDomain],结合ctx上下文做转换
  factory IExpr.of(Func fn, List<dynamic> ag, AttrType type) {
    if (fn is AsFunc) {
      return ExprValue.build(type: fn.rType, ag: ag);
    } else if (ag is List<IExpr>) {
      return Expression(fn: fn, ag: ag, type: type);
    } else {
      throw "IExpr.of构造失败#fn名称与类型: [${fn.name}][${fn.runtimeType}] #ag参数# ${ag.join(", ")}";
    }
  }

  @Deprecated("IExpr_v20B fn只作为Expression独有属性")
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
  // todo 表达式的返回值类型应该是可以推算出来的, 因此不应该需要指定, 而应该是一个get方法
  @override
  final AttrType type;

  const Expression({required this.fn, this.ag = const [], required this.type});

  @override
  callee() => fn.invoke(ag.map((a) => a.callee()).toList());

// todo 出入参数量,类型检查 等等
  @override
  get value => callee();

  @override
  List<Object?> get props => [fn, ag, type];

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

/// 用于返回某个Meta的Prop时的包装
/// type: 字段的类型,
/// value: 字段的名称(而不是字段的值,如果时值,则应当时访问Record的结果)
extension PropExprValueX on ExprValue {
  static of(Property prop) {
    return ExprValue.build(type: prop.type, ag: [prop.propId]);
  }

  bool get isRefValue => type.isRef;
}

/// 对于RefValue, 表示一个对象的引用,类型为[type],对象Id(RecordId)为
extension RefExprValueX on ExprValue {
  static of(AttrType type, String recordId) {
    assert(type.isRef, "RefExprValueX::of#type[${type.name}]不是Ref类型");
    return ExprValue.build(type: type, ag: [recordId]);
  }

  bool get isRefValue => type.isRef;
}

/// IExpr_v20B
/// 取代原有的Value类
/// 仅用于表达式中的Value, 对于Record中的Value,其类型已经再Meta中指定了, 只需要[ag]即可
class ExprValue extends IExpr with IFunctor, EquatableMixin {
  @override
  final AttrType type;
  @override
  final List ag;

  const ExprValue.build({
    required this.type,
    required this.ag,
  });

  @override
  callee() => v;

  @override
  dynamic get value => callee();

  // 避免没有valued导致抛出RangeError
  dynamic get v => ag.isEmpty ? null : ag[0];

  String get e => ag[1];

  @override
  List<Object?> get props => ag;

  factory ExprValue.of(dynamic v, [dynamic e]) {
    dynamic value = v ?? "";
    switch (v.runtimeType) {
      case String:
        return ExprValue.build(type: AttrType.string, ag: [value, e]);
      case int:
      case double:
      case num:
        return ExprValue.build(type: AttrType.num, ag: [value, e]);
      case bool:
        return ExprValue.build(type: AttrType.boolean, ag: [value, e]);
      case IExpr:
      case ExprValue: // 无法被IExpr取代, dart限制
      case Expression: // 无法被IExpr取代, dart限制
        return v;
      default:
        print("debug #warn#ExprValue.of 尚未配置的类型: ${v.runtimeType}");
        return ExprValue.build(type: AttrType.any, ag: [value, e]);
      // fn = const AsFuncDynamic();
      // throw "暂不支持的包装类型[${v.runtimeType}]";
    }
  }

  factory ExprValue.err(String? e) => ExprValue.of(null, e);

  @override
  String toString() => '($ag:${type.name})';

  @override
  Func get fn => throw UnimplementedError("ExprValue不需要fn属性");
}

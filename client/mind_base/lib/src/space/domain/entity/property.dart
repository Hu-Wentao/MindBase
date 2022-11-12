part of 'entity.dart';

/// 是 [Attribute]和[Method]的父类
abstract class Property extends Equatable {
  final int k; // 表头key,对应Field:k,需要从所在的TableMeta中获取
  final String name; // 表头名称
  final String memo; // 表头备注
  AttrType get type; // 最终返回值类型

  /// 字段或属性在一个Meta中的唯一标识
  String get propId => PropertyX.getPropId(this is Attribute, k);

  static Tuple2<String, int> parsePropId(String propId) => propId.parsePropId();

  const Property(this.k, this.name, this.memo);

  static const subTypeMap = {
    Method: 'm',
    Attribute: 'a',
  };

  String get toSubTypeSign => subTypeMap[runtimeType]!;

  Type getSubTypeBySign(String sign) {
    final subType = subTypeMap.entries
        .firstWhere((e) => e.value == sign,
            orElse: () => throw "找不到类型标识: [$sign]")
        .key;
    return subType;
  }

  @override
  List<Object> get props => [k, name, memo, type];
}

class Method extends Property {
  // 方法体
  final IExpr expr;

  @override
  AttrType get type => expr.type;

  const Method({
    required int k,
    required String name,
    required String memo,
    required this.expr,
  }) : super(k, name, memo);

  @override
  List<Object> get props => super.props..addAll([expr]);

  /// 表达式求值
  /// [record] 对象实例, 必填
  /// [find] record所在的SpaceModel中调用, 可空(如果Record内的方法没有引用其他类型(Meta)的话)
  ///
  /// 上下文 [AsFuncThis.ctxSign]  : 当前record(`this`)
  /// 上下文 [SpaceModel.ctxFindRecordFnSign] :用于查询 [AttrType.ref] 所对应的记录值
  dynamic eval(RecordModel record, FindRecordFn? find) {
    final r = exprEvaluator.eval(expr, {
      AsFuncThis.ctxSign: record,
      SpaceModel.ctxFindRecordFnSign: find,
    });
    return r.value;
  }
}

class Attribute extends Property {
  @override
  final AttrType type; // 类型
  // @Deprecated("已将Meta集成到type中,使用 type.ref 访问MetaIdStr")
  // final MetaModel? meta; //如果type是"ref", 该值不为空,存储被引用的MetaId

  const Attribute({
    required int k,
    required String name,
    required String memo,
    required this.type,
    // this.meta,
  }) : super(k, name, memo);
}

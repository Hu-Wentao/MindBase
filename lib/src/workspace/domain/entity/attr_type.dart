part of 'entity.dart';

typedef QueryMetaFn = MetaModel Function(String metaId);

class AttrType {
  final AttrTp tp;
  final String? r;
  // 从所在SpaceModel中获取Meta的函数
  final QueryMetaFn? _getMeta;

  @Deprecated("考虑移除any类型, 默认用string")
  static const AttrType any = AttrType(AttrTp.any, null, null);
  static const AttrType num = AttrType(AttrTp.num, null, null);
  static const AttrType string = AttrType(AttrTp.string, null, null);
  static const AttrType boolean = AttrType(AttrTp.bool, null, null);

  const AttrType(this.tp, this.r, this._getMeta);

  const AttrType.ref(String metaId, QueryMetaFn getMeta)
      : this(AttrTp.ref, metaId, getMeta);

  /// [name]可以仅为 AttrTp.name, 也可以是 `ref_$metaId`
  /// 这里 [get]设为"非空",是因为传入的[name]可能是 ref的类型
  factory AttrType.by(
    String name,
    QueryMetaFn get, [
    String? ref,
  ]) =>
      (name.startsWith(refPrefix))
          ? AttrType.ref(name.substring(refPrefix.length), get)
          : AttrType(AttrTp.values.byName(name), ref, get);

  /// [AttrTp.ref]类型的[r]前缀
  static final refPrefix = "${AttrTp.ref.name}_";

  String get tpName => tp.name;

  String get name => tp == AttrTp.ref ? "$refPrefix$r" : tpName;

  bool get isRef => tp == AttrTp.ref;

  MetaModel? get meta => r == null ? null : _getMeta?.call(r!);

  @override
  String toString() => name;
}

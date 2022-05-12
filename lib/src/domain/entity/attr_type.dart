part of 'entity.dart';

class AttrType {
  final AttrTp tp;
  final RecordMeta? meta;
  static const AttrType any = AttrType(AttrTp.any, null);
  static const AttrType num = AttrType(AttrTp.num, null);
  static const AttrType string = AttrType(AttrTp.string, null);
  static const AttrType boolean = AttrType(AttrTp.bool, null);

  const AttrType(this.tp, this.meta);

  const AttrType.ref(RecordMeta meta) : this(AttrTp.ref, meta);

  /// [AttrTp.ref]类型的[r]前缀
  static final refPrefix = "${AttrTp.ref.name}_";

  String get tpName => tp.name;

  String? get r => meta?.id.$oid;

  String get name => tp == AttrTp.ref ? "$refPrefix$r" : tpName;

  bool get isRef => tp == AttrTp.ref;
}

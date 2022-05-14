part of 'aggregate.dart';

class Workspace implements IEtt<ObjectId> {
  /// 开头`>>`用于防止用户自己设置同名变量
  /// 对应Value类型为 [QueryMetaFn] 将`MetaId->Meta查询`注入到ctx中, 以便读取meta,同时解决循环依赖问题
  static const ctxQueryMetaSign = ">>_workspace_ctx_query_meta_sign";

  @override
  final ObjectId id;

  // Map<String, User> users; // <身份,用户>; 如管理员,编辑人员,查看人员,或者是用户自定义的
  String name;

  // 空间内的表
  final List<RecordMeta> metas;

  // 空间内的记录
  final Map<ObjectId, List<Record>> records;

  Workspace({
    required this.id,
    required this.name,
    required this.metas,
    this.records = const {},
  });

  // QueryMetaFn 的包装
  RecordMeta queryMeta(String metaId) =>
      getMetaBy(ObjectId.fromHexString(metaId))!;

  /// 只能查询已存在与workspace
  RecordMeta? getMetaBy(ObjectId metaId) {
    for (final m in metas) {
      if (m.id == metaId) return m;
    }
    return null;
  }
}

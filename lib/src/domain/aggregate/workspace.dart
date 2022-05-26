part of 'aggregate.dart';

class Workspace implements IAgg<String> {
  /// 开头`>>`用于防止用户自己设置同名变量
  /// 用于DTO->Domain转换: 对应Value类型为 [QueryMetaFn] 将`MetaId->Meta查询`注入到ctx中, 以便读取meta,同时解决循环依赖问题
  static const ctxQueryMetaSign = ">>_ctxQueryMetaSign";

  /// 用于表达式求值: 在工作空间内查询Record的实例(参见[AttrType.ref], [AsFuncThis])
  static const ctxFindRecordFnSign = ">>_ctxFindRecordFnSign";

  @override
  final String id;

  // Map<String, User> users; // <身份,用户>; 如管理员,编辑人员,查看人员,或者是用户自定义的

  String name;

  // 空间内的表
  final List<RecordMeta> metas;

  Workspace({
    required this.id,
    required this.name,
    required this.metas,
  });

  // QueryMetaFn 的包装
  RecordMeta queryMeta(String metaId) => getMetaBy((metaId))!;

  /// 只能查询已存在与workspace
  RecordMeta? getMetaBy(String metaId) {
    for (final m in metas) {
      if (m.id == metaId) return m;
    }
    return null;
  }
}

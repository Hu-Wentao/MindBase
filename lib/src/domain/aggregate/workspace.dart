part of 'aggregate.dart';



class Workspace implements IEtt<ObjectId> {
  @override
  final ObjectId id;
  // Map<String, User> users; // <身份,用户>; 如管理员,编辑人员,查看人员,或者是用户自定义的
  String name;
  final List<RecordMeta> metas; // 空间内的表
  final Map<ObjectId, Record> records; // 空间内的记录

  Workspace({
    required this.id,
    required this.name,
    required this.metas,
    required this.records,
  });
}



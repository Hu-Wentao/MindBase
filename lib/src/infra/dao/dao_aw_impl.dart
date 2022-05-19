import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:mind_base/src/domain/entity/entity.dart';
import 'package:mind_base/src/infra/dto/dto_aw_impl.dart';
import 'package:mind_base/src/interface/i_dao.dart';
import 'package:mind_base/src/interface/i_dto.dart';

/// 适配Appwrite

abstract class IAppwriteAccessor<T extends IEntityDto> extends IAccessor<T> {
  String get collectionId;

  @override
  T jsonToDto(Map<String, dynamic> mgJson);

  @override
  T? jsonToDtoOr(Map<String, Object?>? mgJson);

  @override
  Map<String, dynamic> dtoToJson(T dto);

  @override
  Future<T?> findById(String id);

  @override
  Stream<T> findAll();

  // Stream<WatchEvent<T>> watchById(String id);

  @override
  Future<Document> insert(T dto);

  @override
  Future<Document> update(T dto);

  @override
  Future<Document> replace(T dto);

  /// 删除记录
  @override
  Future deleteBy(String id);

  /// 删除表
  @override
  Future<bool> drop();
}

extension DocumentX on Document {
  toFullJson() => data..['id'] = $id;
}

abstract class BaseAppwriteAccessor<T extends IEntityDto>
    implements IAppwriteAccessor<T> {
  final Database db;
  @override
  final String collectionId;

  const BaseAppwriteAccessor(this.db, this.collectionId);

  @override
  T? jsonToDtoOr(Map<String, dynamic>? mgJson) =>
      (mgJson == null) ? null : jsonToDto(mgJson);

  @override
  Future<T?> findById(String id) => db
      .getDocument(collectionId: collectionId, documentId: id)
      .then((e) => jsonToDtoOr(e.toFullJson()));

  @override
  Stream<T> findAll([List<String>? queries]) async* {
    final r =
        await db.listDocuments(collectionId: collectionId, queries: queries);
    for (final e in r.documents) {
      yield jsonToDto(e.toFullJson());
    }
  }

  // @override
  // Stream<WatchEvent<T>> watchAll() => db
  //         .collection(collectionId)
  //         .watch(
  //           builder?.build() ??
  //               AggregationPipelineBuilder().addStage(
  //                 Match(where.exists('_id').toQuery()),
  //               ),
  //         )
  //         .map((e) => WatchEvent.of<T>(e, jsonToDtoOr))
  //         .map((e) {
  //       slLogger.info("[$runtimeType::watchAll] $e");
  //       return e;
  //     });

  // @override
  // Stream<WatchEvent<T>> watchById(String id) => db
  //     .collection(collectionId)
  //     .watch(
  //       AggregationPipelineBuilder()
  //           .addStage(Match(where.id(id).toQuery()))
  //           .build(),
  //     )
  //     .map<mg.ChangeEvent>((e) => e as mg.ChangeEvent)
  //     .map((v) => WatchEvent.of<T>(v, jsonToDtoOr));

  /// 当ObjectId已存在时,更新无效
  @override
  Future<Document> insert(
    T dto, {
    // 记录级别的读写权限控制
    List<String>? read,
    List<String>? write,
  }) async =>
      await db.createDocument(
        collectionId: collectionId,
        documentId: dto.id,
        data: dtoToJson(dto),
        read: read,
        write: write,
      );

  @override
  Future<Document> update(T dto) => replace(dto);

  // /// 如果已存在,
  // Future<Document> save(String id, T dto) async {
  //   final exist = await findById(id);
  //   if (exist == null) {
  //     return insert(dto);
  //   } else {
  //     //  目前只能实现替换,更新需要指定字段
  //     return await replace(dto);
  //     // return await updateBy(id, dto);
  //   }
  // }

  // @Deprecated("实现错误! 更新方法需要指定更新的属性, 使用 ModifierBuilder")
  // Future<Document> updateBy(String id, T dto) async => await db
  //     .collection(collectionId)
  //     .updateOne(where.id(id), dto.toMongoJson());

  // Future<WriteResult> replace(T dto);
  @override
  Future<Document> replace(T dto) async => await db.updateDocument(
        collectionId: collectionId,
        documentId: dto.id,
        data: dtoToJson(dto),
      );

  @override
  Future deleteBy(String id) =>
      db.deleteDocument(collectionId: collectionId, documentId: id);

  // todo
  @override
  Future<bool> drop() => throw "需要Server Client";
}

/// 根据 Meta-v3.1C 实现
class WorkspaceEttAccessor extends BaseAppwriteAccessor<WorkspaceDto> {
  const WorkspaceEttAccessor(Database db, String collectionId)
      : super(db, collectionId);

  @override
  WorkspaceDto jsonToDto(Map<String, Object?> js) =>
      WorkspaceDtoAppwriteX.fromJson(js);

  @override
  Map<String, dynamic> dtoToJson(WorkspaceDto dto) =>
      WorkspaceDtoAppwriteX(dto).toJson();
}

/// 即Meta
class RecordMetaEttAccessor extends BaseAppwriteAccessor<RecordMetaDto> {
  const RecordMetaEttAccessor(Database db, String workspaceId)
      : super(db, workspaceId);

  @override
  RecordMetaDto jsonToDto(Map<String, Object?> mgJson) =>
      RecordMetaDtoAppwriteX.fromJson(mgJson);

  Stream<RecordMetaDto> findAllBy(String metaName) => findAll([
        "name.equal('$metaName')",
      ]);

  @override
  Map<String, dynamic> dtoToJson(RecordMetaDto dto) =>
      RecordMetaDtoAppwriteX(dto).toJson();
}

class RecordEttAccessor extends BaseAppwriteAccessor<RecordDto> {
  // Record所在Workspace的Meta查询方法.
  // 显然,在查询Record之前,应当先保存Workspace内所有的Meta,以供查询
  const RecordEttAccessor(Database db, String metaId) : super(db, metaId);

  @override
  RecordDto jsonToDto(Map<String, dynamic> json) =>
      RecordDtoAppwriteX.fromJson(json);

  @override
  Map<String, dynamic> dtoToJson(RecordDto dto) =>
      RecordDtoAppwriteX(dto).toJson();
}

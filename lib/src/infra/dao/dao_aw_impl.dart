import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:mind_base/src/domain/entity/entity.dart';
import 'package:mind_base/src/infra/dto/dto_aw_impl.dart';
import 'package:mind_base/src/interface/i_dao.dart';
import 'package:mind_base/src/interface/i_dto.dart';

/// 适配Appwrite读写

abstract class BaseEttAccessor<T extends IEntityDto> implements IAccessor<T> {
  final Database db;

  const BaseEttAccessor(this.db);

  @override
  T? jsonToDtoOr(Map<String, dynamic>? mgJson) =>
      (mgJson == null) ? null : jsonToDto(mgJson);

  @override
  Future<T?> findById(String id) => db
      .getDocument(collectionId: collectionId, documentId: id)
      .then((e) => jsonToDtoOr(e.data));

  @override
  Stream<T> findAll([List<String>? queries]) async* {
    final r =
        await db.listDocuments(collectionId: collectionId, queries: queries);
    for (final e in r.documents) {
      yield jsonToDto(e.data);
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
  Future<Document> insert(T dto) async => await db.createDocument(
        collectionId: collectionId,
        documentId: dto.id,
        data: dto.toJson(),
      );

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
        data: dto.toJson(),
      );

  @override
  Future deleteBy(String id) =>
      db.deleteDocument(collectionId: collectionId, documentId: id);

  // todo
  @override
  Future<bool> drop() => throw "需要Server Client";
}

/// 根据 Meta-v3.1C 实现
class WorkspaceEttAccessor extends BaseEttAccessor<WorkspaceDto> {
  @override
  final String collectionId;

  const WorkspaceEttAccessor(Database db, this.collectionId) : super(db);

  @override
  WorkspaceDto jsonToDto(Map<String, Object?> js) =>
      WorkspaceDtoAppwriteX.fromJson(js);
}

/// 即Meta
class RecordMetaEttAccessor extends BaseEttAccessor<RecordMetaDto> {
  @override
  final String collectionId;

  const RecordMetaEttAccessor(Database db, String workspaceId)
      : collectionId = workspaceId,
        super(db);

  @override
  RecordMetaDto jsonToDto(Map<String, Object?> mgJson) =>
      RecordMetaDtoAppwriteX.fromJson(mgJson);

  Stream<RecordMetaDto> findAllBy(String metaName) => findAll([
        "name.equal('$metaName')",
      ]);
}

class RecordEttAccessor extends BaseEttAccessor<RecordDto> {
  @override
  final String collectionId;

  // Record所在Workspace的Meta查询方法.
  // 显然,在查询Record之前,应当先保存Workspace内所有的Meta,以供查询
  final QueryMetaFn toMeta;

  const RecordEttAccessor(Database db, String metaId, this.toMeta)
      : collectionId = metaId,
        super(db);

  @override
  RecordDto jsonToDto(Map<String, dynamic> json) =>
      RecordDtoAppwriteX.fromJson(json, toMeta);
}

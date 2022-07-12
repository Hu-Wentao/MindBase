import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/workspace/infra/dao/realtime_hub.dart';
import 'package:mind_base/src/workspace/infra/dto/dto_aw_impl.dart';
import 'package:mind_base/src/core/inter/i_dao.dart';
import 'package:mind_base/src/core/inter/i_dto.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';

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

  @override
  Future<Document> update(T dto) async => await db.updateDocument(
        collectionId: collectionId,
        documentId: dto.id,
        data: dtoToJson(dto),
      );

  @override
  Future<Document> replace(T dto) => update(dto);

  @override
  Future deleteBy(String id) =>
      db.deleteDocument(collectionId: collectionId, documentId: id);

  // todo
  @override
  Future<bool> drop() => throw "需要Server Client";
}

mixin AppwriteAccessorWatchableMx<T extends IEntityDto>
    on BaseAppwriteAccessor<T> {
  static const collectionEvtTag = "database.documents.";

  RealtimeChannelHub get hub;

  Stream<AccessorEvt<T>> watchById(String id) {
    final channel = SubChannel.document(collectionId, id);
    hub.actAddChannel(channel);
    return hub.stream
        .where(
          (event) =>
              // todo 转换操作需要转移到其他类中, 例如[RealTimeEvtFactory]
              event.event.startsWith(collectionEvtTag) &&
              event.payload['\$collection'] == collectionId &&
              event.payload['\$id'] == id,
        )
        .map((event) => AccessorEvt<T>(
              _collectionEvt2AccessorEvtTp(event.event),
              id,
              collectionId,
              jsonToDtoOr(event.payload..['id'] = id),
            ))
        .doOnCancel(() {
      print(
          "debug #AppwriteAccessorWatchableMx::watchById cancel! 添加移除channel任务 ${DateTime.now()}");
      hub.actRemoveChannel(channel);
    });
  }

  /// 监听整个集合内的记录变更事件
  Stream<AccessorEvt<T>> watchAll() {
    final channel = SubChannel.collection(collectionId);
    hub.actAddChannel(channel);
    return hub.stream
        .where(
      (event) =>
          // todo 转换操作需要转移到其他类中, 例如[RealTimeEvtFactory]
          event.event.startsWith(collectionEvtTag) &&
          event.payload['\$collection'] == collectionId,
    )
        .map((event) {
      final id = event.payload['\$id'];
      return AccessorEvt<T>(
        _collectionEvt2AccessorEvtTp(event.event),
        id, collectionId,
        // fixme 需要类似 toFullJson方法
        jsonToDtoOr(event.payload..['id'] = id),
      );
    }).doOnCancel(() {
      print(
          "debug #AppwriteAccessorWatchableMx::watchAll cancel! 添加移除channel任务 ${DateTime.now()}");
      hub.actRemoveChannel(channel);
    });
  }

  // todo 转换操作需要转移到其他类中, 例如[RealTimeEvtFactory]
  AccessorEvtTp _collectionEvt2AccessorEvtTp(String event) {
    switch (event) {
      case "${collectionEvtTag}create":
        return AccessorEvtTp.insert;
      case "${collectionEvtTag}update":
        return AccessorEvtTp.update;
      case "${collectionEvtTag}delete":
        return AccessorEvtTp.delete;
      default:
        throw ("debug #_collectionEvt2AccessorEvtTp#Error! 未处理的event类型: $event");
    }
  }
}

/// 根据 Meta-v3.1C 实现
class WorkspaceEttAccessor extends BaseAppwriteAccessor<WorkspaceDto>
    with AppwriteAccessorWatchableMx<WorkspaceDto> {
  @override
  final RealtimeChannelHub hub;

  const WorkspaceEttAccessor(Database db, String collectionId, this.hub)
      : super(db, collectionId);

  @override
  WorkspaceDto jsonToDto(Map<String, Object?> js) =>
      WorkspaceDtoAppwriteX.fromJson(js);

  @override
  Map<String, dynamic> dtoToJson(WorkspaceDto dto) =>
      WorkspaceDtoAppwriteX(dto).toJson();

  Stream<WorkspaceDto> findAllByTeam(String teamId) => findAll([
        "teamId.equal('$teamId')",
      ]);
}

/// 即Meta
class RecordMetaEttAccessor extends BaseAppwriteAccessor<RecordMetaDto>
    with AppwriteAccessorWatchableMx<RecordMetaDto> {
  const RecordMetaEttAccessor(Database db, String workspaceId)
      : super(db, workspaceId);

  @override
  RealtimeChannelHub get hub => sl<RealtimeChannelHub>();

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

class RecordEttAccessor extends BaseAppwriteAccessor<RecordDto>
    with AppwriteAccessorWatchableMx<RecordDto> {
  const RecordEttAccessor(Database db, String metaId) : super(db, metaId);

  @override
  RealtimeChannelHub get hub => sl<RealtimeChannelHub>();

  @override
  RecordDto jsonToDto(Map<String, dynamic> json) =>
      RecordDtoAppwriteX.fromJson(json);

  @override
  Map<String, dynamic> dtoToJson(RecordDto dto) =>
      RecordDtoAppwriteX(dto).toJson();
}

class MetaViewEttAccessor extends BaseAppwriteAccessor<MetaViewDto>
    with AppwriteAccessorWatchableMx<MetaViewDto> {
  const MetaViewEttAccessor(Database db, String metaId) : super(db, metaId);

  @override
  RealtimeChannelHub get hub => sl<RealtimeChannelHub>();

  @override
  MetaViewDto jsonToDto(Map<String, dynamic> json) =>
      MetaViewDtoAppwriteX.fromJson(json);

  @override
  Map<String, dynamic> dtoToJson(MetaViewDto dto) =>
      MetaViewDtoAppwriteX(dto).toJson();
}

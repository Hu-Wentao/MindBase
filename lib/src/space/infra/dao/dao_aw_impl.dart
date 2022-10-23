import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/config/appwrite_config.dart';
import 'package:mind_base/src/core/config/common_config.dart';
import 'package:mind_base/src/space/infra/ap_adapter.dart';
import 'package:mind_base/src/space/infra/dao/realtime_hub.dart';
import 'package:mind_base/src/space/infra/dto/dto_aw_impl.dart';
import 'package:mind_base/src/core/inter/i_dao.dart';
import 'package:mind_base/src/core/inter/i_dto.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';

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
  final Databases db;
  @override
  final String collectionId;

  const BaseAppwriteAccessor(this.db, this.collectionId);

  @override
  T? jsonToDtoOr(Map<String, dynamic>? mgJson) =>
      (mgJson == null) ? null : jsonToDto(mgJson);

  @override
  Future<T?> findById(String id) => db
      .getDocument(
        databaseId: mainDataBaseId,
        collectionId: collectionId,
        documentId: id,
      )
      .then((e) => jsonToDtoOr(e.toFullJson()));

  @override
  Stream<T> findAll([List<String>? queries]) async* {
    final r = await db.listDocuments(
      databaseId: mainDataBaseId,
      collectionId: collectionId,
      queries: queries,
    );
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
          databaseId: mainDataBaseId,
          collectionId: collectionId,
          documentId: dto.id,
          data: dtoToJson(dto),
          permissions: [
            ...ApAdapter.toPermitBy(reads: read),
            ...ApAdapter.toPermitBy(writes: write)
          ]);

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
        databaseId: mainDataBaseId,
        collectionId: collectionId,
        documentId: dto.id,
        data: dtoToJson(dto),
      );

  @override
  Future<Document> replace(T dto) => update(dto);

  @override
  Future deleteBy(String id) => db.deleteDocument(
        databaseId: mainDataBaseId,
        collectionId: collectionId,
        documentId: id,
      );

  // todo
  @override
  Future<bool> drop() => throw "需要Server Client";
}

mixin AppwriteAccessorWatchableMx<T extends IEntityDto>
    on BaseAppwriteAccessor<T> {
  static const collectionEvtTag = "database.documents.";

  static const documentsEvtTag = "documents";
  static const evtCreate = 'create';
  static const evtUpdate = 'update';
  static const evtDelete = 'delete';

  RealtimeChannelHub get hub;

  ///
  /// [documentId] 表示监听单个文档的变更; 为null表示监听整个集合变更
  Stream<AccessorEvt<T>> watch({String? documentId}) {
    final SubChannel channel;
    channel = documentId != null
        ? SubChannel.document(collectionId, documentId)
        : SubChannel.collection(collectionId);
    hub.actAddChannel(channel);
    return hub.stream
    // v1.0.3
    // databases.default.collections.6354d209b832016b29204b2c.documents
        .where((event) => event.channels.contains(channel.channel))
    // .where(
        //   // todo 转换操作需要转移到其他类中, 例如[RealTimeEvtFactory]
        //   //这里的events是各种可能性的排列组合, 这里假定[0]是最完整的事件, 仅限 appwrite 0.15.3
        //   (event) => event.events[0].split('.').contains(documentsEvtTag) &&
        //           event.payload['\$collection'] == collectionId &&
        //           (documentId == null)
        //       ? true
        //       : event.payload['\$id'] == documentId,
        // )
        .map((event) => AccessorEvt<T>(
              //这里的events是各种可能性的排列组合, 这里假定[0]是最完整的事件, 仅限 appwrite 0.15.3
              _collectionEvt2AccessorEvtTp(event.events[0].split('.')),
              // 不能给documentId赋值,否则监听集合变更将出错.
              documentId ?? event.payload['\$id'] as String,
              // 如果是监听整个集合,则这里需要从payload中获取
              collectionId,
              jsonToDtoOr(
                  event.payload..['id'] = event.payload['\$id'] as String),
            ))
        .doOnCancel(() {
      slLogger.info(
          "debug #AppwriteAccessorWatchableMx::watchById cancel! 添加移除channel任务 ${DateTime.now()}");
      hub.actRemoveChannel(channel);
    });
  }

  // todo 转换操作需要转移到其他类中, 例如[RealTimeEvtFactory]
  AccessorEvtTp _collectionEvt2AccessorEvtTp(List<String> events) {
    if (events.contains(evtCreate)) {
      return AccessorEvtTp.insert;
    } else if (events.contains(evtUpdate)) {
      return AccessorEvtTp.update;
    } else if (events.contains(evtDelete)) {
      return AccessorEvtTp.delete;
    } else {
      throw ("debug #_collectionEvt2AccessorEvtTp#Error! 未处理的event类型: $events");
    }
  }
}

/// 根据 Meta-v3.1C 实现
class SpaceModelEttAccessor extends BaseAppwriteAccessor<SpaceDto>
    with AppwriteAccessorWatchableMx<SpaceDto> {
  @override
  final RealtimeChannelHub hub;

  const SpaceModelEttAccessor(Databases db, String collectionId, this.hub)
      : super(db, collectionId);

  @override
  SpaceDto jsonToDto(Map<String, Object?> js) =>
      SpaceModelDtoAppwriteX.fromJson(js);

  @override
  Map<String, dynamic> dtoToJson(SpaceDto dto) =>
      SpaceModelDtoAppwriteX(dto).toJson();

  Stream<SpaceDto> findAllByTeam(String teamId) => findAll([
        Query.equal('teamId', teamId),
      ]);
}

/// 即Meta
class MetaModelEttAccessor extends BaseAppwriteAccessor<MetaDto>
    with AppwriteAccessorWatchableMx<MetaDto> {
  const MetaModelEttAccessor(Databases db, String workspaceId)
      : super(db, workspaceId);

  @override
  RealtimeChannelHub get hub => sl<RealtimeChannelHub>();

  @override
  MetaDto jsonToDto(Map<String, Object?> mgJson) =>
      MetaDtoAppwriteX.fromJson(mgJson);

  Stream<MetaDto> findAllBy(String metaName) => findAll([
        Query.equal('name', metaName),
        // "name.equal('$metaName')",
      ]);

  @override
  Map<String, dynamic> dtoToJson(MetaDto dto) => MetaDtoAppwriteX(dto).toJson();
}

class RecordEttAccessor extends BaseAppwriteAccessor<RecordDto>
    with AppwriteAccessorWatchableMx<RecordDto> {
  const RecordEttAccessor(Databases db, String metaId) : super(db, metaId);

  @override
  RealtimeChannelHub get hub => sl<RealtimeChannelHub>();

  @override
  RecordDto jsonToDto(Map<String, dynamic> json) =>
      RecordDtoAppwriteX.fromJson(json);

  @override
  Map<String, dynamic> dtoToJson(RecordDto dto) =>
      RecordDtoAppwriteX(dto).toJson();
}

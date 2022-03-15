// repo 是对与聚合根而言的

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'aggregate.dart';

/// 当前是照抄mongoDB的event [MongoEventType]
enum RepoEventType {
  insert, // 元素插入
  delete, // 某个元素被移除 - 只返回id
  replace, // 某个元素被替换 - 返回新的完整对象
  update, // 某个元素被更新
  drop,
  rename,
  dropDatabase,
  invalidate,
}

/// 某个 MongoEntityDto对应的collection的 watch事件
class RepoEvent<Ett extends IEtt<ObjectId>> {
  final RepoEventType type;
  final ObjectId ettId;
  final Ett? entity;

  RepoEvent(this.type, this.ettId, this.entity);

  static RepoEvent<Ett>
      of<Ett extends IEtt<ObjectId>, Dto extends IMongoEntityDto>(
    WatchEvent<Dto> event,
    Ett? Function(Dto? dto) mapper,
  ) =>
          RepoEvent(
            RepoEventType.values.asNameMap()[event.type.name]!,
            event.documentId,
            mapper(event.document),
          );
// final WatchEvent<Dto> event;
// final Ett Function(Dto dto) mapper;
// RepoEvent(this.event, this.mapper);
}

///
/// 简单的Repo实现, 只能读取, 无法save聚合根
@lazySingleton
class RecordRepo {
  final IMongoStorage mongoStorage;
  final SchemaRepo schemaRepo;

  RecordRepo(this.mongoStorage, this.schemaRepo);

  /// 通过记录Id查询一条记录对应的实例
  Future<Record> findBy(ObjectId id) async =>
      await mongoStorage.withSyncAsync((sync) async {
        RecordDto rcdDto = (await RecordAccessor(sync).findById(id))!;
        return rcdDto.toDomain(await schemaRepo.findBy(rcdDto.metaId));
      });

  Future<Record?> findByOr(ObjectId id) async =>
      await mongoStorage.withSyncAsync(
        (sync) async {
          RecordDto? rcdDto = (await RecordAccessor(sync).findById(id));
          return rcdDto?.toDomain(await schemaRepo.findBy(rcdDto.metaId));
        },
      );

  /// 通过MetaId查找聚合根的所有记录对应的实例
  /// todo 添加limit,限制查询数量
  Stream<Record> findAllByMeta(ObjectId metaId) async* {
    final sync = await mongoStorage.asyncDb;
    RecordMeta meta = await schemaRepo.findBy(metaId);
    yield* (RecordAccessor(sync).findAllByMetaId(metaId))
        .map((rcd) => rcd.toDomain(meta));
  }

  /// 通过MetaId监视聚合根的所有记录对应的实例的变更
  /// 重点测试
  /// watch Schema对应的Record 集合.
  Stream<RepoEvent<Record>> watchAllByMeta(ObjectId metaId) async* {
    final sync = await mongoStorage.asyncDb;
    yield* schemaRepo
        .watchBy(metaId) // 返回Schema事件流
        .asyncExpand((meta) => RecordAccessor(sync)
            .watchAllByMetaId(metaId)
            .map((rcd) => RepoEvent.of<Record, RecordDto>(
                rcd, (dto) => dto?.toDomainOr(meta.entity))));
  }

  Future<WriteResult> insert(Record entity) async =>
      await mongoStorage.withSyncAsync((sync) async {
        RecordMetaDto metaDto = entity.meta.toDto();
        RecordDto rcdDto = entity.toDto();
        final rMeta = await RecordMetaAccessor(sync).insert(metaDto);
        if (rMeta.writeError != null) return rMeta;
        final rRecord = await RecordAccessor(sync).insert(rcdDto);
        return rRecord;
      });

  Future<WriteResult> update(Record entity) async =>
      await mongoStorage.withSyncAsync((sync) async =>
          await RecordAccessor(sync).updateBy(entity.id, entity.toDto()));

  Future<WriteResult> save(Record record) async {
    final exist = await findByOr(record.id);
    if (exist == null) {
      return insert(record);
    } else {
      return update(record);
    }
  }
}

@lazySingleton
class SchemaRepo {
  final IMongoStorage mongoStorage;

  SchemaRepo(this.mongoStorage);

  Attribute _attrDtoToAttr(AttributeDto dto) =>
      dto.toDomain(FuncManager.findBy(dto.checkFuncName));

  /// 通过记录Id查询一条记录对应的实例
  Future<RecordMeta> findBy(ObjectId id,
          {RecordMeta Function()? onNull}) async =>
      await mongoStorage.withSyncAsync(
        (sync) async =>
            (await RecordMetaAccessor(sync).findById(id))
                ?.toDm(_attrDtoToAttr) ??
            onNull?.call() ??
            (throw BaseException('Not found by id[$id]')),
      );

  Future<RecordMeta?> findByOr(ObjectId id) async =>
      await mongoStorage.withSyncAsync(
        (sync) async =>
            (await RecordMetaAccessor(sync).findById(id))?.toDm(_attrDtoToAttr),
      );

  /// 通过MetaId查找聚合根的所有记录对应的实例
  /// todo 添加limit,限制查询数量
  Stream<RecordMeta> findAll() async* {
    final db = await mongoStorage.asyncDb;
    yield* RecordMetaAccessor(db)
        .findAll()
        .map((event) => event.toDm(_attrDtoToAttr));
  }

  /// 通过MetaId监视聚合根的所有记录对应的实例的变更
  /// 重点测试
  Stream<RepoEvent<RecordMeta>> watchBy(ObjectId metaId) async* {
    final sync = await mongoStorage.asyncDb;
    yield* RecordMetaAccessor(sync).watchById(metaId).map((event) =>
        RepoEvent.of<RecordMeta, RecordMetaDto>(
            event, (dto) => dto?.toDm(_attrDtoToAttr)));
  }

  Future<WriteResult> insert(RecordMeta entity) async =>
      await mongoStorage.withSyncAsync((sync) async =>
          await RecordMetaAccessor(sync).insert(entity.toDto()));

  Future<WriteResult> update(RecordMeta entity) async =>
      await mongoStorage.withSyncAsync((sync) async =>
          await RecordMetaAccessor(sync).updateBy(entity.id, entity.toDto()));

  Stream<RepoEvent<RecordMeta>> watchAll() async* {
    final sync = await mongoStorage.asyncDb;
    yield* RecordMetaAccessor(sync).watchAll().map(
          (event) => RepoEvent.of<RecordMeta, RecordMetaDto>(
              event, (dto) => dto?.toDm(_attrDtoToAttr)),
        );
  }

  Future<WriteResult> save(RecordMeta schema) async {
    final exist = await findByOr(schema.id);
    if (exist == null) {
      return insert(schema);
    } else {
      return update(schema);
    }
  }
}

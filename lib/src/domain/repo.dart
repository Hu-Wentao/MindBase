// repo 是对与聚合根而言的

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'aggregate.dart';

/// 当前是照抄mongoDB的event [WatchEventType]
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
            event.ettId,
            mapper(event.entity),
          );
}

abstract class IMongoRepo<Ett extends IEtt<ObjectId>,
    Dto extends IMongoEntityDto> {
  Future<IMongoAccessor<Dto>> get asyncAccessor;
}

/// 如果某个聚合根可以直接实现[dtoToEtt], 则其Repo可以混入本Mixin
mixin QueryMx<Ett extends IEtt<ObjectId>, Dto extends IMongoEntityDto>
    on IMongoRepo<Ett, Dto> {
  Ett dtoToEtt(Dto dto);

  Ett? dtoToEttOr(Dto? dto) => dto == null ? null : dtoToEtt(dto);

  Future<Ett?> findByOr(ObjectId id) async {
    final dto = (await (await asyncAccessor).findById(id));
    return dtoToEttOr(dto);
  }

  /// 通过记录Id查询一条记录对应的实例
  Future<Ett> findBy(
    ObjectId id, {
    Ett Function()? onNull,
  }) async =>
      await findByOr(id) ??
      onNull?.call() ??
      (throw BaseException('Not found by id[$id]'));

  /// 通过MetaId查找聚合根的所有记录对应的实例
  /// todo 添加limit,限制查询数量
  Stream<Ett> findAll() async* {
    yield* (await asyncAccessor).findAll().map(dtoToEtt);
  }

  /// 通过MetaId监视聚合根的所有记录对应的实例的变更
  /// 重点测试
  Stream<RepoEvent<Ett>> watchBy(ObjectId metaId) async* {
    yield* (await asyncAccessor)
        .watchById(metaId)
        .map((event) => RepoEvent.of<Ett, Dto>(event, dtoToEttOr));
  }

  Stream<RepoEvent<Ett>> watchAll() async* {
    yield* (await asyncAccessor)
        .watchAll()
        .map((event) => RepoEvent.of<Ett, Dto>(event, dtoToEttOr));
  }
}

abstract class BaseMongoRepo<Ett extends IEtt<ObjectId>,
        Dto extends IMongoEntityDto> extends IMongoRepo<Ett, Dto>
    with QueryMx<Ett, Dto> {
  Dto ettToDto(Ett ett);

  Future<WriteResult> insert(Ett entity) async =>
      await (await asyncAccessor).insert(ettToDto(entity));

// fixme update需要逐个更新字段
// Future<WriteResult> update(RecordMeta entity) async =>
//     await mongoStorage.withSyncAsync((sync) async =>
//         await (await accessor).updateBy(entity.id, ettToDto(entity)));
  Future<WriteResult> replace(Ett entity) async =>
      await (await asyncAccessor).replace(ettToDto(entity));

  Future<WriteResult> save(Ett entity) async {
    final exist = await findByOr(entity.id);
    if (exist == null) {
      return insert(entity);
    } else {
      return replace(entity);
// return update(schema);
    }
  }
}

///
/// 简单的Repo实现, 只能读取, 无法save聚合根
@lazySingleton
class RecordRepo {
  final IMongoStorage mongoStorage;
  final MetaRepo schemaRepo;

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
  /// watch Meta对应的Record 集合.
  Stream<RepoEvent<Record>> watchAllByMeta(ObjectId metaId) async* {
    final sync = await mongoStorage.asyncDb;
    yield* schemaRepo
        .watchBy(metaId) // 返回Meta事件流
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
class MetaRepo extends BaseMongoRepo<RecordMeta, RecordMetaDto> {
  final IMongoStorage mongoStorage;

  MetaRepo(this.mongoStorage);

  @override
  RecordMeta dtoToEtt(RecordMetaDto dto) =>
      dto.toDm((attr) => attr.toDomain(FuncManager.findBy(attr.checkFuncName)));

  @override
  RecordMetaDto ettToDto(RecordMeta ett) => ett.toDto();

  @override
  Future<BaseMongoAccessor<RecordMetaDto>> get asyncAccessor async {
    final sync = await mongoStorage.asyncDb;
    return RecordMetaAccessor(sync);
  }
}

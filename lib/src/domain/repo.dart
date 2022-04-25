// repo 是对与聚合根而言的

import 'package:get_arch_core/get_arch_core.dart';
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
class RepoEvent<Ett extends IEtt<ObjectId>> extends Equatable {
  final RepoEventType type;
  final ObjectId ettId;
  final Ett? entity;

  const RepoEvent(this.type, this.ettId, this.entity);

  @override
  List<Object?> get props => [type, ettId, entity];

  static RepoEvent<Ett>
      of<Ett extends IEtt<ObjectId>, Dto extends IMongoEntityDto>(
    WatchEvent<Dto> event,
    Ett? Function(Dto? dto) mapper,
  ) =>
          RepoEvent.ofEtt(
            event,
            mapper(event.entity),
          );

  static RepoEvent<Ett>
      ofEtt<Ett extends IEtt<ObjectId>, Dto extends IMongoEntityDto>(
    WatchEvent<Dto> event,
    Ett? ett,
  ) =>
          RepoEvent(RepoEventType.values.asNameMap()[event.type.name]!,
              event.ettId, ett);
}

abstract class IMongoRepo<Ett extends IEtt<ObjectId>,
    Dto extends IMongoEntityDto> {
  Future<IMongoAccessor<Dto>> get asyncAccessor;
}

/// 如果某个聚合根可以直接实现[futureDtoToEtt], 则其Repo可以混入本Mixin
mixin QueryMx<Ett extends IEtt<ObjectId>, Dto extends IMongoEntityDto>
    on IMongoRepo<Ett, Dto> {
  Future<Ett> futureDtoToEtt(Dto dto);

  Future<Ett?> futureDtoToEttOr(Dto? dto) async =>
      dto == null ? null : await futureDtoToEtt(dto);

  Future<Ett?> findByOr(ObjectId id) async {
    final dto = (await (await asyncAccessor).findById(id));
    return futureDtoToEttOr(dto);
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
    yield* (await asyncAccessor).findAll().asyncMap(futureDtoToEtt);
  }

  /// 通过MetaId监视聚合根的所有记录对应的实例的变更
  /// 重点测试
  Stream<RepoEvent<Ett>> watchBy(ObjectId metaId) async* {
    yield* (await asyncAccessor).watchById(metaId).asyncMap((event) async {
      final ett = await futureDtoToEttOr(event.entity);
      return RepoEvent.ofEtt<Ett, Dto>(event, ett);
    });
  }

  Stream<RepoEvent<Ett>> watchAll() async* {
    yield* (await asyncAccessor).watchAll().asyncMap((event) async {
      final ett = await futureDtoToEttOr(event.entity);
      return RepoEvent.ofEtt<Ett, Dto>(event, ett);
    });
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
    }
  }

  /// 仅删除主记录, 未对关联记录进行处理
  Future<WriteResult> deleteBy(ObjectId entityId) async =>
      await (await asyncAccessor).deleteBy(entityId);
}

///
/// 简单的Repo实现, 只能读取, 无法save聚合根
class RecordRepo extends IMongoRepo<Record, RecordDto>
    with QueryMx<Record, RecordDto> {
  @Deprecated("请使用 ::asyncAccessorWith")
  @override
  Future<IMongoAccessor<RecordDto>> get asyncAccessor async =>
      asyncAccessorWith(metaId!);

  Future<IMongoAccessor<RecordDto>> asyncAccessorWith(String metaId) async {
    final sync = await mongoStorage.asyncDb;
    return RecordAccessor(sync, metaId);
  }

  @override
  Future<Record> futureDtoToEtt(RecordDto dto) async =>
      dto.toDomain(await metaRepo.findBy(dto.metaId));

  final IMongoStorage mongoStorage;
  final MetaRepo metaRepo;
  String? metaId; // 默认的metaId,可以为空

  RecordRepo(this.mongoStorage, this.metaRepo, this.metaId);

  /// 通过MetaId查找聚合根的所有记录对应的实例
  /// todo 添加limit,限制查询数量
  Stream<Record> findAllByMeta(ObjectId metaId) async* {
    final sync = await asyncAccessorWith(metaId.toHexString());
    RecordMeta meta = await metaRepo.findBy(metaId);
    yield* (sync.findAll()).map((rcd) => rcd.toDomain(meta));
  }

  /// 通过MetaId监视聚合根的所有记录对应的实例的变更
  /// 重点测试
  /// watch Meta对应的Record 集合.
  Stream<RepoEvent<Record>> watchAllByMeta(RecordMeta meta) async* {
    final sync = await asyncAccessorWith(meta.id.toHexString());
    // fixme 收不到更新消息
    yield* sync.watchAll().map(
          (rcd) => RepoEvent.of<Record, RecordDto>(
              rcd, (dto) => dto?.toDomainOr(meta)),
        );
    // yield* metaRepo
    //     .watchBy(metaId) // 返回Meta事件流
    //     .asyncExpand((meta) => sync.watchAll().map((rcd) =>
    //         RepoEvent.of<Record, RecordDto>(
    //             rcd, (dto) => dto?.toDomainOr(meta.entity))));
  }

  Future<WriteResult> insert(Record entity) async {
    final sync = await asyncAccessorWith(entity.meta.id.toHexString());
    final rMeta = await metaRepo.insert(entity.meta);
    if (rMeta.writeError != null) return rMeta;
    return await sync.insert(entity.toDto());
  }

  // fixme 尚未实现更新, 只有replace
  @Deprecated("fixme 尚未实现更新, 只有replace")
  Future<WriteResult> update(Record entity) async {
    return replace(entity);
  }

  Future<WriteResult> replace(Record entity) async {
    final sync = await asyncAccessorWith(entity.meta.id.toHexString());
    final rMeta = await metaRepo.save(entity.meta);
    if (rMeta.writeError != null) return rMeta;
    return sync.replace(entity.toDto());
  }

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
  Future<RecordMeta> futureDtoToEtt(RecordMetaDto dto) async =>
      dto.toDm((attr) => attr.toDomain());

  @override
  RecordMetaDto ettToDto(RecordMeta ett) => ett.toDto();

  @override
  Future<BaseMongoAccessor<RecordMetaDto>> get asyncAccessor async {
    final sync = await mongoStorage.asyncDb;
    return RecordMetaAccessor(sync);
  }
}

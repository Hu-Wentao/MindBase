// repo 是对与聚合根而言的

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'aggregate.dart';

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
        RecordMeta meta = await schemaRepo.findBy(rcdDto.metaId);
        return rcdDto.toDomain(meta);
      });

  /// 通过MetaId查找聚合根的所有记录对应的实例
  /// todo 添加limit,限制查询数量
  Future<List<Record>> findAllByMeta(ObjectId metaId) async =>
      await mongoStorage.withSyncAsync((sync) async {
        RecordMeta meta = await schemaRepo.findBy(metaId);
        return (await RecordAccessor(sync).findAllByMetaId(metaId))
            .map((rcd) => rcd.toDomain(meta))
            .toList();
      });

  /// 通过MetaId监视聚合根的所有记录对应的实例的变更
  /// 重点测试
  Stream<Record> watchAllByMeta(ObjectId metaId) async* {
    final sync = await mongoStorage.asyncDb;
    yield* schemaRepo.watchBy(metaId).asyncExpand((meta) => RecordAccessor(sync)
        .watchAllByMetaId(metaId)
        .map((rcd) => rcd.toDomain(meta)));
  }

  void insert(Record record) async {
    await mongoStorage.withSyncAsync((sync) async {
      RecordMetaDto metaDto = record.meta.toDto();
      RecordDto rcdDto = record.toDto();
      await RecordMetaAccessor(sync).insert(metaDto);
      await RecordAccessor(sync).insert(rcdDto);
    });
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
  Stream<RecordMeta> watchBy(ObjectId metaId) async* {
    final sync = await mongoStorage.asyncDb;
    yield* RecordMetaAccessor(sync)
        .watchById(metaId)
        .map((event) => event.toDm(_attrDtoToAttr));
  }

  Future<WriteResult> insert(RecordMeta entity) async =>
      await mongoStorage.withSyncAsync((sync) async =>
          await RecordMetaAccessor(sync).insert(entity.toDto()));

  Future<WriteResult> update(RecordMeta entity) async =>
      await mongoStorage.withSyncAsync((sync) async =>
          await RecordMetaAccessor(sync).updateBy(entity.id, entity.toDto()));

  Stream<RecordMeta> watchAll() async* {
    final sync = await mongoStorage.asyncDb;
    yield* RecordMetaAccessor(sync)
        .watchAll()
        .map((event) => event.toDm(_attrDtoToAttr));
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

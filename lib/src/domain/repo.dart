// repo 是对与聚合根而言的

import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'aggregate.dart';

///
/// 简单的Repo实现, 只能读取, 无法save聚合根
class RecordRepo {
  final IMongoStorage mongoStorage;

  RecordRepo(this.mongoStorage);

  /// 通过记录Id查询一条记录对应的实例
  Future<Record> find(ObjectId id) async =>
      await mongoStorage.withSyncAsync((sync) async {
        RecordDto rcdDto = (await RecordAccessor(sync).findById(id))!;
        RecordMetaDto metaDto =
            (await RecordMetaAccessor(sync).findById(rcdDto.metaId))!;
        return rcdDto.toDomain(metaDto.toDomain(
          metaDto.attributes
              .map((e) => e.toDomain(FuncManager.findBy(e.checkFuncName)))
              .toList(),
        ));
      });

  /// 通过MetaId查找聚合根的所有记录对应的实例
  /// todo 添加limit,限制查询数量
  Future<List<Record>> findAllByMeta(ObjectId metaId) async =>
      await mongoStorage.withSyncAsync((sync) async {
        RecordMetaDto metaDto =
            (await RecordMetaAccessor(sync).findById(metaId))!;
        List<RecordDto> rcdDtoList =
            (await RecordAccessor(sync).findAllByMetaId(metaId));
        return rcdDtoList
            .map((rcd) => rcd.toDomain(metaDto.toDomain(
                  metaDto.attributes
                      .map((e) =>
                          e.toDomain(FuncManager.findBy(e.checkFuncName)))
                      .toList(),
                )))
            .toList();
      });

  /// 通过MetaId监视聚合根的所有记录对应的实例的变更
  /// 重点测试
  Stream<Record> watchAllByMeta(ObjectId metaId) async* {
    final sync = await mongoStorage.asyncDb;
    // RecordMetaDto metaDto = (await RecordMetaAccessor(sync).findById(metaId))!;
    RecordMetaAccessor(sync).watchById(metaId).map((metaDto) => RecordAccessor(
            sync)
        .watchAllByMetaId(metaId)
        .map((rcd) => rcd.toDomain(metaDto.toDomain(
              metaDto.attributes
                  .map((e) => e.toDomain(FuncManager.findBy(e.checkFuncName)))
                  .toList(),
            ))));
  }
}

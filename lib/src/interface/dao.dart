import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart/src/database/commands/aggreagation_commands/aggregate/return_classes/change_event.dart'
    as mg;

extension SelectorBuilderX on SelectorBuilder {
  // fixed Not implemented for SelectorBuilder({$query: {_id: ObjectId("622ea6754aafc13ddd3d5cab")}})
  // 从Selector中提取`$query` 对应的value, 即 `{_id: ObjectId("622ea6754aafc13ddd3d5cab")}`
  toQuery() => map['\$query'];
}

abstract class IMongoAccessor<T extends IMongoEntityDto> {
  Db get db;

  String get collectionName;

  T mongoJsonToDto(Map<String, dynamic> mgJson);

  T? mongoJsonToDtoOr(Map<String, Object?>? mgJson);

  Future<T?> findById(ObjectId id);

  Stream<T> findAll();

  Stream<T> watchById(ObjectId id);

  // todo 性能优化： 监视所有的更新，会导致性能问题；后期考虑引入工作区的概念,即使改为 `watchBy`
  Stream<T> watchAll();
}

abstract class BaseMongoAccessor<T extends IMongoEntityDto>
    implements IMongoAccessor<T> {
  @override
  T? mongoJsonToDtoOr(Map<String, dynamic>? mgJson) =>
      (mgJson == null) ? null : mongoJsonToDto(mgJson);

  @override
  Future<T?> findById(ObjectId id) => db
      .collection(collectionName)
      .findOne(where.id(id))
      .then(mongoJsonToDtoOr);

  @override
  Stream<T> findAll() =>
      db.collection(collectionName).find().map(mongoJsonToDto);

  @override
  Stream<T> watchAll() => db
      .collection(collectionName)
      .watch(
        AggregationPipelineBuilder()
            .addStage(Match(where.exists('_id').toQuery()))
            .build(),
      )
      .map<mg.ChangeEvent>((e) => e as mg.ChangeEvent)
      // todo 这里默认所有的事件都是正确的, 所以添加了`!`
      .map((v) => mongoJsonToDtoOr((v.fullDocument))!);

  @override
  Stream<T> watchById(ObjectId id) => db
      .collection(collectionName)
      .watch(
        AggregationPipelineBuilder()
            .addStage(Match(where.id(id).toQuery()))
            .build(),
      )
      .map<mg.ChangeEvent>((e) => e as mg.ChangeEvent)
      // todo 这里默认所有的事件都是正确的, 所以添加了`!`
      .map((v) => mongoJsonToDtoOr((v.fullDocument))!);

  /// 当ObjectId已存在时,更新无效
  Future<WriteResult> insert(T dto) async =>
      await db.collection(collectionName).insertOne(dto.toMongoDto());

  Future<WriteResult> updateBy(ObjectId id, T dto) async => await db
      .collection(collectionName)
      .updateOne(where.id(id), dto.toMongoDto());

  // Future<WriteResult> replace(T dto);
  Future<WriteResult> replace(T dto) async => await db
      .collection(collectionName)
      .replaceOne(where.id(dto.id), dto.toMongoDto());
}

class RecordAccessor extends BaseMongoAccessor<RecordDto> {
  RecordAccessor(this.db);

  @override
  String get collectionName => 'record';
  @override
  final Db db;

  @override
  RecordDto mongoJsonToDto(Map<String, dynamic> mgJson) =>
      RecordDto.fromMongoJson(mgJson);

  Stream<RecordDto> findAllByMetaId(ObjectId metaId) => db
      .collection(collectionName)
      .find(where.eq('metaId', metaId))
      .map((event) => RecordDto.fromMongoJson(event));

  Stream<RecordDto> watchAllByMetaId(ObjectId metaId) => db
      .collection(collectionName)
      .watch(
        AggregationPipelineBuilder()
            .addStage(Match(where.eq('metaId', metaId)))
            .build(),
      )
      .map((event) => RecordDto.fromMongoJson(event));
}

/// 即Schema
class RecordMetaAccessor extends BaseMongoAccessor<RecordMetaDto> {
  RecordMetaAccessor(this.db);

  @override
  String get collectionName => 'record_meta';
  @override
  final Db db;

  @override
  RecordMetaDto mongoJsonToDto(Map<String, Object?> mgJson) =>
      RecordMetaDto.fromMongoJson(mgJson);
}

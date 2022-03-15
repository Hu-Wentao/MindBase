import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart/src/database/commands/aggreagation_commands/aggregate/return_classes/change_event.dart'
    as mg;

extension SelectorBuilderX on SelectorBuilder {
  // fixed Not implemented for SelectorBuilder({$query: {_id: ObjectId("622ea6754aafc13ddd3d5cab")}})
  // 从Selector中提取`$query` 对应的value, 即 `{_id: ObjectId("622ea6754aafc13ddd3d5cab")}`
  toQuery() => map['\$query'];
}

enum WatchEventType {
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
class WatchEvent<T extends IMongoEntityDto> {
  final mg.ChangeEvent _changeEvent;
  final T? Function(Map<String, Object?>? mgJson) mongoJsonToDtoOr;

  WatchEvent(this._changeEvent, this.mongoJsonToDtoOr);

  WatchEventType get type =>
      WatchEventType.values.asNameMap()[_changeEvent.operationType]!;

  ObjectId get ettId => (_changeEvent.serverResponse['documentKey']
      as Map<String, dynamic>)['_id'] as ObjectId;

  T? get document => mongoJsonToDtoOr(_changeEvent.fullDocument);
}

abstract class IMongoAccessor<T extends IMongoEntityDto> {
  Db get db;

  String get collectionName;

  T mongoJsonToDto(Map<String, dynamic> mgJson);

  T? mongoJsonToDtoOr(Map<String, Object?>? mgJson);

  Future<T?> findById(ObjectId id);

  Stream<T> findAll();

  Stream<WatchEvent<T>> watchById(ObjectId id);

  // todo 性能优化： 监视所有的更新，会导致性能问题；后期考虑引入工作区的概念,即使改为 `watchBy`
  // builder==null表示监听集合内所有更新
  Stream<WatchEvent<T>> watchAll({AggregationPipelineBuilder? builder});

  Future<WriteResult> insert(T dto);

  Future<WriteResult> replace(T dto);
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
  Stream<T> findAll({SelectorBuilder? selector}) =>
      db.collection(collectionName).find(selector).map(mongoJsonToDto);

  @override
  Stream<WatchEvent<T>> watchAll({AggregationPipelineBuilder? builder}) => db
      .collection(collectionName)
      .watch(
        builder?.build() ??
            AggregationPipelineBuilder().addStage(
              Match(where.exists('_id').toQuery()),
            ),
      )
      .map((e) => WatchEvent<T>(e, mongoJsonToDtoOr));

  @override
  Stream<WatchEvent<T>> watchById(ObjectId id) => db
      .collection(collectionName)
      .watch(
        AggregationPipelineBuilder()
            .addStage(Match(where.id(id).toQuery()))
            .build(),
      )
      .map<mg.ChangeEvent>((e) => e as mg.ChangeEvent)
      .map((v) => WatchEvent<T>(v, mongoJsonToDtoOr));

  /// 当ObjectId已存在时,更新无效
  @override
  Future<WriteResult> insert(T dto) async =>
      await db.collection(collectionName).insertOne(dto.toMongoDto());

  /// 如果已存在,
  Future<WriteResult> save(ObjectId id, T dto) async {
    final exist = await findById(id);
    if (exist == null) {
      return await db.collection(collectionName).insertOne(dto.toMongoDto());
    } else {
      // fixme ... 目前只能实现替换,更新需要指定字段
      return await replace(dto);
      // return await updateBy(id, dto);
    }
  }

  @Deprecated("实现错误! 更新方法需要指定更新的属性, 使用 ModifierBuilder")
  Future<WriteResult> updateBy(ObjectId id, T dto) async => await db
      .collection(collectionName)
      .updateOne(where.id(id), dto.toMongoDto());

  // Future<WriteResult> replace(T dto);
  @override
  Future<WriteResult> replace(T dto) async => await db
      .collection(collectionName)
      .replaceOne(where.id(dto.id), dto.toMongoDto());
}
@lazySingleton
class RecordAccessor extends BaseMongoAccessor<RecordDto> {
  RecordAccessor(this.db);

  // todo 当前是将不同schema对应的record集合都存放在同一个集合(record)中
  // todo 后期考虑将不同schema对应的record存放在各自的${record_xxx}集合中
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

  Stream<WatchEvent<RecordDto>> watchAllByMetaId(ObjectId metaId) => db
      .collection(collectionName)
      .watch(
        AggregationPipelineBuilder()
            .addStage(Match(where.eq('metaId', metaId)))
            .build(),
      )
      .map((e) => WatchEvent<RecordDto>(e, mongoJsonToDtoOr));
}

/// 即Schema
@lazySingleton
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

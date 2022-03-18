import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/config/common_config.dart';
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
  final ObjectId ettId;
  final WatchEventType type;
  final T? entity;

  WatchEvent(this.type, this.ettId, this.entity);

  static of<T extends IMongoEntityDto>(mg.ChangeEvent _changeEvent,
          T? Function(Map<String, Object?>? mgJson) mongoJsonToDtoOr) =>
      WatchEvent<T>(
        WatchEventType.values.asNameMap()[_changeEvent.operationType]!,
        (_changeEvent.serverResponse['documentKey']
            as Map<String, dynamic>)['_id'] as ObjectId,
        mongoJsonToDtoOr(_changeEvent.fullDocument),
      );

  @override
  String toString() =>
      'WatchEvent{ettId: $ettId, type: $type, entity: $entity, }';
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
          .map((e) => WatchEvent.of<T>(e, mongoJsonToDtoOr))
          .map((e) {
        slLogger.info("[$runtimeType::watchAll] $e");
        return e;
      });

  @override
  Stream<WatchEvent<T>> watchById(ObjectId id) => db
      .collection(collectionName)
      .watch(
        AggregationPipelineBuilder()
            .addStage(Match(where.id(id).toQuery()))
            .build(),
      )
      .map<mg.ChangeEvent>((e) => e as mg.ChangeEvent)
      .map((v) => WatchEvent.of<T>(v, mongoJsonToDtoOr));

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

  Stream<RecordDto> findAllByMetaId(ObjectId metaId) =>
      findAll(selector: where.eq('metaId', metaId));

  // fixme [性能] 无法按照条件监听指定record,只能watchAll然后过滤
  // fixme [功能] 由于删除事件没有entity,无法检查metaId,导致无法监听
  Stream<WatchEvent<RecordDto>> watchAllByMetaId(ObjectId metaId) =>
      watchAll().where((event) => event.entity?.metaId == metaId);
// Stream<WatchEvent<RecordDto>> watchAllByMetaId(ObjectId metaId) => watchAll(
//     builder: AggregationPipelineBuilder()
//         .addStage(Match(where.eq('metaId', metaId).toQuery())));
}

/// 即Meta
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

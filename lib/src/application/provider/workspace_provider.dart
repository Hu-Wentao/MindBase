import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/repo.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_frame.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, ObjectId, where;
import 'package:provider_sidecar/provider_sidecar.dart';

/// 统一监听与处理工作空间内的所有数据
/// todo 当前假定本数据库为一个工作空间
class WorkspaceProvider extends ProviderSidecar {
  late final MetaRepo _metaRepo;
  late final RecordRepo _recordRepo;

  // 防止同一个对象状态更新后被重复缓存 <MetaId, Meta>
  final Map<ObjectId, RecordMeta> _cacheMeta = {};

  // 工作空间内所有record
  // #  注意,删除事件只有RecordId, 可能需要在监听时带上MetaId, 否则需要遍历所有Record
  // <MetaId, List<Record>> , 方案2A .. 省一点空间.. 插入/更新较慢 ## 当前方案!
  // <Meta,List<Record>>, 便于查询,但插入时需要根据Record->MetaId->Meta
  // <RecordId, Record> , 便于刷新数据,但如果要恢复某个Meta状态,则需要遍历where
  // final Map<ObjectId, List<Record>> _cacheRecord = {};
  // <MetaId, Map<RecordId,Record>> , 方案2B 考虑.. 插入/更新数据更快
  final Map<ObjectId, Map<ObjectId, Record>> _cacheRecord = {};

  // <MetaId, StreamController<..>>
  final Map<ObjectId, StreamController<RepoEvent<Record>>> _cacheSubject = {};

  @override
  onInitializing() {
    _metaRepo = sl<MetaRepo>();
    _recordRepo = RecordRepo(sl<IMongoStorage>(), _metaRepo, null);
    _cacheAllMetaByWorkspace();
  }

  _cacheAllMetaByWorkspace() {
    // 先查询有所元素 // 然后开始监听变更
    _metaRepo.findAll().listen(_actInsertMeta);
    _metaRepo.watchAll().listen(_onWatchMeta);
  }

  void _actInsertMeta(RecordMeta meta) => setInitialized("插入Meta", () {
        _cacheMeta[meta.id] = meta;
        // 缓存并监听Meta下Record
        _cacheRecordByMeta(meta);
      });

  void _actUpdateMeta(RecordMeta meta) => setInitialized("更新/替换Meta", () {
        _cacheMeta[meta.id] = meta;
        if (watchedMeta?.id == meta.id) {
          watchedMeta = meta; // 提示UI可以刷新
        }
      });

  void _actRemoveMeta(ObjectId ettId) => setInitialized("移除Meta", () {
        _cacheMeta.remove(ettId);
        // 取消缓存和监听Meta下Record
        _disposeSubject(ettId);
      });

  void _onWatchMeta(RepoEvent<RecordMeta> event) {
    switch (event.type) {
      case RepoEventType.insert:
        _actInsertMeta(event.entity!);
        break;
      case RepoEventType.replace:
      case RepoEventType.update:
        _actUpdateMeta(event.entity!);
        break;
      case RepoEventType.delete:
        _actRemoveMeta(event.ettId);
        break;
      case RepoEventType.drop:
        print("###debug drop 尚未确认 '${event.type}'事件的机制, 按照delete处理");
        _actRemoveMeta(event.ettId);
        break;
      case RepoEventType.rename:
      case RepoEventType.dropDatabase:
      case RepoEventType.invalidate:
        print("###debug drop 尚未确认 '${event.type}'事件的机制,事件内容 $event");
        break;
    }
  }

  _cacheRecordByMeta(RecordMeta meta) {
    _recordRepo.findAllByMeta(meta.id).listen(_actInsertRecord);
    // 异步广播流,暂停的监听器将在内部缓存事件,直到监听器取消暂停/被Cancel (需要UI及时dispose子流)
    // 同步广播流,Provider中始终有一个监听器用于刷新数据；其他监听器只用于刷新UI(可能会有丢失UI数据..)
    _cacheSubject[meta.id]?.close();
    _cacheSubject[meta.id] =
        StreamController<RepoEvent<Record>>.broadcast(sync: false)
          ..addStream(_recordRepo.watchAllByMeta(meta.id))
          ..stream.listen(_onWatchRecord);
  }

  // 不指定则移除所有的监听
  _disposeSubject([ObjectId? metaId]) {
    if (metaId != null) {
      _cacheMeta.remove(metaId);
      _cacheRecord.remove(metaId);
      _cacheSubject.remove(metaId)?.close();
    } else {
      _cacheMeta.clear();
      _cacheRecord.clear();
      for (var element in _cacheSubject.values) {
        element.close();
      }
      _cacheSubject.clear();
    }
  }

  void _actInsertRecord(Record record) => setInitialized("插入Record", () {
        (_cacheRecord[record.meta.id] ??= {})[record.id] = record;
      });

  void _actUpdateRecord(Record record) => setInitialized("更新/替换Meta", () {
        (_cacheRecord[record.meta.id] ??= {})[record.id] = record;
      });

  void _actRemoveRecord(ObjectId ettId) => setInitialized("移除Meta", () {
        // _cacheRecord.remove(ettId);
        // 遍历所有的 <RecordId,Record>
        _cacheRecord.values
            .firstWhere((recordMap) => recordMap.remove(ettId) != null);
      });

  void _onWatchRecord(RepoEvent<Record> event) {
    switch (event.type) {
      case RepoEventType.insert:
        _actInsertRecord(event.entity!);
        break;
      case RepoEventType.replace:
      case RepoEventType.update:
        _actUpdateRecord(event.entity!);
        break;
      case RepoEventType.delete:
        _actRemoveRecord(event.ettId);
        break;
      case RepoEventType.drop:
        print("###debug drop 尚未确认 '${event.type}'事件的机制, 按照delete处理");
        _actRemoveRecord(event.ettId);
        break;
      case RepoEventType.rename:
      case RepoEventType.dropDatabase:
      case RepoEventType.invalidate:
        print("###debug drop 尚未确认 '${event.type}'事件的机制,事件内容 $event");
        break;
    }
  }

  @override
  void dispose() {
    _disposeSubject();
    super.dispose();
  }

  /// 适配与业务逻辑部分
  /// MetaProvider
  Map<ObjectId, RecordMeta> get metaMap => _cacheMeta;

  List<RecordMeta> get metaList => _cacheMeta.values.toList();

  RecordMeta? getMeta(ObjectId? id) => id == null ? null : _cacheMeta[id];

  Future<void> actInsertMeta(RecordMeta meta) =>
      actWrapper(() => setInitialized("新增Meta [$meta]", () async {
            await _metaRepo.insert(meta);
          }));

  Future<void> actSaveMeta(RecordMetaDto? dto) =>
      actWrapper(() => setInitialized("保存元素 [$dto]", () async {
            if (dto == null) {
              return null;
            }
            final schema = dto.toDm((dto) => dto.toDm(FuncManager.findBy));
            await _metaRepo.save(schema);
          }));

  Future<RecordMetaDto?> actQueryMeta(ObjectId metaId) =>
      sl<RecordMetaAccessor>().findById(metaId);

  // 更新meta的指定Attr
  Future<void> actEditAttribute(
    RecordMetaDto metaDto,
    AttributeDto? attr,
  ) async {
    if (attr == null) {
      return;
    }
    // final metaDto = meta.toDto();
    print("debug 更新meta的指定Attr [$metaDto] [$attr]");
    // todo 后期改为update
    final index =
        metaDto.attributes.indexWhere((element) => element.k == attr.k);
    if (index != -1) {
      metaDto.attributes[index] = (attr);
    } else {
      metaDto.attributes.add(attr);
    }
    // 持久化
    return actSaveMeta(metaDto);
  }

  Future<List<RecordMetaDto>> actQueryMetaByName(String metaName) async =>
      sl<RecordMetaAccessor>()
          .findAll(selector: where.eq("name", metaName))
          .drain();

  /// RecordProvider

  RecordMeta? watchedMeta;

  // 切换监听的Meta
  Future<void> actWatchMeta(RecordMeta meta) => actWrapper(
        () => setInitialized(
          "开始/切换监听Meta[${meta.name}]",
          () => watchedMeta = meta,
        ),
      );

  Future<void> actSaveRecord(RecordDto? dto) => actWrapper(() async {
        log("actSaveRecord ${dto?.toJson()}");
        // 无需set,因为插入成功后, watch会监听到新的变更
        if (dto == null) return;
        await RecordAccessor(sl<Db>(), dto.metaId.toHexString())
            .save(dto.id, dto)
            .then((value) {
          log("actSaveRecord 插入成功");
        });
      });

  // Future<void> actSaveMeta(RecordMetaDto? dto) => actWrapper(() async {
  //       if (dto == null) return;
  //       await sl<RecordMetaAccessor>().save(dto.id, dto).then((value) {
  //         log("actSaveMeta 成功");
  //       });
  //     });

  RecordDataGridSource2 actGetDataSource() => _watchMeta(watchedMeta!);

  RecordDataGridSource2 _watchMeta(RecordMeta meta) {
    watchedMeta = meta;
    return _newDataSource(meta);
  }

  RecordDataGridSource2 _newDataSource(RecordMeta meta) =>
      RecordDataGridSource2(
        meta,
        actQueryRecord(meta.id),
        _cacheSubject[meta.id]!.stream.listen(null),
        actSaveRecord,
        (_) async => actQueryRecord(_),
      );

  List<Record> actQueryRecord(ObjectId metaId) =>
      _cacheRecord[metaId]?.values.toList() ?? <Record>[];
}

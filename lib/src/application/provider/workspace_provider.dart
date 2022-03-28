import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/repo.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_frame.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, ObjectId, where;
import 'package:provider_sidecar/provider_sidecar.dart';

/// 本类缓存一个工作空间内的所有数据,
/// 以便 "reference"等Func进行计算处理
@singleton
class WorkspaceDataHolder {
  final String name; // 目前全局只有一个workspace

  // 防止同一个对象状态更新后被重复缓存 <MetaId, Meta>
  final Map<ObjectId, RecordMeta> _cacheMeta = {};

  // 工作空间内所有record
  // #  注意,删除事件只有RecordId, 可能需要在监听时带上MetaId, 否则需要遍历所有Record
  // <MetaId, List<Record>> , 方案2A .. 省一点空间.. 插入/更新较慢 ## 当前方案!
  // <Meta,List<Record>>, 便于查询,但插入时需要根据Record->MetaId->Meta
  // <RecordId, Record> , 便于刷新数据,但如果要恢复某个Meta状态,则需要遍历where
  final Map<ObjectId, List<Record>> _cacheRecord = {};

  WorkspaceDataHolder({this.name = 'default'});

  // <MetaId, Map<RecordId,Record>> , 方案2B 考虑.. 插入/更新数据更快
  // final Map<ObjectId, Map<ObjectId, Record>> _cacheRecord = {};

  RecordMeta setMeta(RecordMeta meta) => _cacheMeta[meta.id] = meta;

  void removeMeta(ObjectId metaId) => _cacheMeta.remove(metaId);

  List<Record>? removeRecords(ObjectId metaId) => _cacheRecord.remove(metaId);

  void clearMeta() => _cacheMeta.clear();

  void clearRecord() => _cacheRecord.clear();

  List<Record> getRecords(ObjectId metaId) => _cacheRecord[metaId] ??= [];

  Iterable<List<Record>> allRecords() => _cacheRecord.values;

  Map<ObjectId, RecordMeta> getMeta() => _cacheMeta;

  Iterable<RecordMeta> allMetas() => _cacheMeta.values;

  RecordMeta? getMetaBy(ObjectId? id) => id == null ? null : _cacheMeta[id];
}

/// 统一监听与处理工作空间内的所有数据
/// todo 当前假定本数据库为一个工作空间
class WorkspaceProvider extends ProviderSidecar {
  late final MetaRepo _metaRepo;
  late final WorkspaceDataHolder _dataHolder;

  // RecordRepo 无法监听数据
  // late final RecordRepo _recordRepo;
  RecordAccessor _recordAccessor(String metaId) =>
      RecordAccessor(sl<Db>(), metaId);

  // 监听更新事件
  // <MetaId, StreamController<..>>
  final Map<ObjectId, StreamController<RepoEvent<Record>>> _cacheSubject = {};

  @override
  onInitializing() {
    _metaRepo = sl<MetaRepo>();
    // _recordRepo = RecordRepo(sl<IMongoStorage>(), _metaRepo, null);
    _cacheAllMetaByWorkspace();
  }

  _cacheAllMetaByWorkspace() {
    // 先查询有所元素 // 然后开始监听变更
    _metaRepo.findAll().listen(_onEvtInsertMeta);
    _metaRepo.watchAll().listen(_onWatchMetaEvt);
  }

  void _onEvtInsertMeta(RecordMeta meta) => setInitialized("插入Meta", () {
        _dataHolder.setMeta(meta);
        // 缓存并监听Meta下Record
        _cacheRecordByMeta(meta);
        // fixme 如果meta更新， 那么缓存的Record也需要更新才对，否则映射会出问题
        // fixme
        // fixme
        // fixme
        // fixme
        // fixme
      });

  void _onEvtUpdateMeta(RecordMeta meta) => setInitialized("更新/替换Meta", () {
        _dataHolder.setMeta(meta);
        if (watchedMeta?.id == meta.id) {
          watchedMeta = meta; // 提示UI可以刷新
        }
      });

  void _onEvtRemoveMeta(ObjectId ettId) => setInitialized("移除Meta", () {
        _dataHolder.removeMeta(ettId);
        // 取消缓存和监听Meta下Record
        _disposeSubject(ettId);
      });

  void _onWatchMetaEvt(RepoEvent<RecordMeta> event) {
    switch (event.type) {
      case RepoEventType.insert:
        _onEvtInsertMeta(event.entity!);
        break;
      case RepoEventType.replace:
      case RepoEventType.update:
        _onEvtUpdateMeta(event.entity!);
        break;
      case RepoEventType.delete:
        _onEvtRemoveMeta(event.ettId);
        break;
      case RepoEventType.drop:
        print("###debug drop 尚未确认 '${event.type}'事件的机制, 按照delete处理");
        _onEvtRemoveMeta(event.ettId);
        break;
      case RepoEventType.rename:
      case RepoEventType.dropDatabase:
      case RepoEventType.invalidate:
        print("###debug drop 尚未确认 '${event.type}'事件的机制,事件内容 $event");
        break;
    }
  }

  _cacheRecordByMeta(RecordMeta meta) {
    // _recordRepo.findAllByMeta(meta.id).listen(_onEvtInsertRecord);
    final acc = _recordAccessor(meta.id.$oid)
      ..findAll()
          .map((event) => event.toDomain(meta))
          .listen(_onEvtInsertRecord);
    // 异步广播流,暂停的监听器将在内部缓存事件,直到监听器取消暂停/被Cancel (需要UI及时dispose子流)
    // 同步广播流,Provider中始终有一个监听器用于刷新数据；其他监听器只用于刷新UI(可能会有丢失UI数据..)
    _cacheSubject[meta.id]?.close();
    _cacheSubject[meta.id] =
        StreamController<RepoEvent<Record>>.broadcast(sync: false)
          ..addStream(
            acc.watchAll().map((dtoEvt) => RepoEvent.of<Record, RecordDto>(
                  dtoEvt,
                  (dto) => dto?.toDomainOr(meta),
                )),
          )
          // ..addStream(_recordRepo.watchAllByMeta(meta))
          ..stream.listen((evt) => _onWatchRecord(evt, meta.id));
  }

  // 不指定则移除所有的监听
  _disposeSubject([ObjectId? metaId]) {
    if (metaId != null) {
      _dataHolder.removeMeta(metaId);
      _dataHolder.removeRecords(metaId);
      _cacheSubject.remove(metaId)?.close();
    } else {
      _dataHolder.clearMeta();
      _dataHolder.clearRecord();
      for (var element in _cacheSubject.values) {
        element.close();
      }
      _cacheSubject.clear();
    }
  }

  void _onEvtInsertRecord(Record record) => setInitialized(
      "插入Record", () => _dataHolder.getRecords(record.meta.id).add(record));

  // 返回被更新的元素index
  int _onEvtUpdateRecord(Record record) =>
      setInitialized<int>("更新/替换Record", () {
        final index = (_dataHolder.getRecords(record.meta.id))
            .indexWhere((element) => element.id == record.id);
        if (index == -1) {
          _onEvtInsertRecord(record);
        } else {
          _dataHolder.getRecords(record.meta.id)[index] = record;
        }
        return index;
      })!;

  // 返回被更新的元素index
  int _onEvtRemoveRecord(ObjectId ettId) => setInitialized<int>("移除Record", () {
        // 遍历所有的 <RecordId,Record>
        var index = -1;
        for (var recordList in _dataHolder.allRecords()) {
          index = recordList.indexWhere((element) => element.id == ettId);
          if (index != -1) {
            recordList.removeAt(index);
            break;
          }
        }
        return index;
      })!;

  void _onWatchRecord(RepoEvent<Record> event, ObjectId metaId) {
    print("debug #监听WatchRecord meta# $metaId # $event");
    switch (event.type) {
      case RepoEventType.insert:
        _onEvtInsertRecord(event.entity!);
        _onEvtInsertRecordSource(event.entity!);
        break;
      case RepoEventType.replace:
      case RepoEventType.update:
        final index = _onEvtUpdateRecord(event.entity!);
        _onEvtUpdateRecordSource(event.entity!, index);
        break;
      case RepoEventType.delete:
        final index = _onEvtRemoveRecord(event.ettId);
        _onEvtRemoveRecordSource(event.ettId, metaId, index);
        break;
      case RepoEventType.drop:
        print("###debug drop 尚未确认 '${event.type}'事件的机制, 按照delete处理");
        final index = _onEvtRemoveRecord(event.ettId);
        _onEvtRemoveRecordSource(event.ettId, metaId, index);
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
  Map<ObjectId, RecordMeta> get metaMap => _dataHolder.getMeta();

  List<RecordMeta> get metaList => _dataHolder.allMetas().toList();

  RecordMeta? getMeta(ObjectId? id) => _dataHolder.getMetaBy(id);

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

  Future<void> actRemoveRecord(ObjectId ettId) => actWrapper(() async {
        log("actRemoveRecord $ettId");
        // todo
        throw UnimplementedError("尚未实现删除记录");
        // // 无需set,因为插入成功后, watch会监听到新的变更
        // await RecordAccessor(sl<Db>(), dto.metaId.toHexString())
        //     .save(dto.id, dto)
        //     .then((value) {
        //   log("actSaveRecord 插入成功");
        // });
      });

  // Future<void> actSaveMeta(RecordMetaDto? dto) => actWrapper(() async {
  //       if (dto == null) return;
  //       await sl<RecordMetaAccessor>().save(dto.id, dto).then((value) {
  //         log("actSaveMeta 成功");
  //       });
  //     });

  // <MetaId, 数据源>
  final Map<ObjectId, RecordDataGridSource2> _cacheSource = {};

  void _findCachedSource(
    ObjectId metaId,
    Function(RecordDataGridSource2 source) onFind,
  ) {
    final source = _cacheSource[metaId];
    if (source != null) {
      onFind(source);
    }
  }

  void _onEvtInsertRecordSource(Record record) => _findCachedSource(
        record.meta.id,
        (source) => source.onInsertEvt(record),
      );

  // index: 更新的Record在cache中的索引
  void _onEvtUpdateRecordSource(Record record, int index) => _findCachedSource(
        record.meta.id,
        (source) => source.onUpdateEvt(record, index),
      );

  void _onEvtRemoveRecordSource(ObjectId ettId, ObjectId metaId, int index) =>
      _findCachedSource(metaId, (source) => source.onRemoveEvt(index));

  RecordDataGridSource2 actGetDataSource() => _getByMeta(watchedMeta!);

  RecordDataGridSource2 _getByMeta(RecordMeta meta) {
    watchedMeta = meta;
    var cached = _cacheSource[meta.id];
    if (cached == null || cached.meta != meta) {
      cached = _newDataSource(meta);
      _cacheSource[meta.id] = cached;
    }
    return cached;
  }

  RecordDataGridSource2 _newDataSource(RecordMeta meta) =>
      RecordDataGridSource2(
        meta,
        actSaveRecord,
        // actRemoveRecord,
        getCachedRecordsByMeta,
        getCachedRecordByIndex,
      );

  List<Record> getCachedRecordsByMeta(ObjectId metaId) =>
      _dataHolder.getRecords(metaId);

  Record getCachedRecordByIndex(ObjectId metaId, int index) =>
      getCachedRecordsByMeta(metaId)[index];
}

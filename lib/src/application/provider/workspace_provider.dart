import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/repo.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_frame.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, ObjectId, where;
import 'package:provider_sidecar/provider_sidecar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// 本类缓存一个工作空间内的所有数据, 类比Jvm中存在的对象
@singleton
class WorkspaceDataHolder {
  final String name = 'default'; // 目前全局只有一个workspace
  // WorkspaceDataHolder({this.name = 'default'}); // 有参数,导致依赖注入失败
  ///
  final List<RecordMeta> _cacheMeta = [];

  @protected
  RecordMeta insertMeta(RecordMeta meta) {
    _cacheMeta.add(meta);
    return meta;
  }

  RecordMeta updateMeta(RecordMeta meta) {
    final i = _cacheMeta.indexWhere((element) => element.id == meta.id);
    if (i != -1) {
      _cacheMeta[i].update(meta);
    } else {
      _cacheMeta.add(meta);
    }
    return meta;
  }

  void removeMeta(ObjectId metaId) =>
      _cacheMeta.removeWhere((meta) => meta.id == metaId);

  void clearMeta() => _cacheMeta.clear();

  RecordMeta? getMetaBy(ObjectId? id) =>
      id == null ? null : _cacheMeta.firstWhere((element) => element.id == id);

  Iterable<RecordMeta> allMetas() => _cacheMeta;

  ///
  final Map<ObjectId, List<Record>> _cacheRecord = {};

  @protected
  Record insertRecord(Record record) {
    _cacheRecord.putIfAbsent(record.meta.id, () => []);
    _cacheRecord[record.meta.id]!.add(record);
    return record;
  }

  int updateRecord(Record record) {
    final index = (getRecords(record.meta.id))
        .indexWhere((element) => element.id == record.id);
    if (index == -1) {
      insertRecord(record);
    } else {
      getRecords(record.meta.id)[index].update(record);
    }
    return index;
  }

  List<Record>? removeRecords(ObjectId metaId) => _cacheRecord.remove(metaId);

  void clearRecord() => _cacheRecord.clear();

  List<Record> getRecords(ObjectId metaId) => _cacheRecord[metaId] ??= [];

  Iterable<List<Record>> allRecords() => _cacheRecord.values;

  Record queryRecordBy(ObjectId recordId) {
    Record? r;
    for (var recordList in allRecords()) {
      final i = recordList.indexWhere((element) => element.id == recordId);
      if (i != -1) {
        r = recordList[i];
        break;
      }
    }
    return r ?? (throw "Workspace中找不到ID为[$recordId]的Record");
  }
}

/// 统一监听与处理工作空间内的所有数据
/// todo 当前假定本数据库为一个工作空间
class WorkspaceProvider extends ProviderSidecar {
  late final MetaRepo _metaRepo;

  // 在此处直接赋值,避免出现 _dataHolder未初始化的问题;
  final WorkspaceDataHolder _dataHolder = sl<WorkspaceDataHolder>();

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

  /// 数据同步 ===================================================================
  _cacheAllMetaByWorkspace() {
    // 先查询有所元素 // 然后开始监听变更
    _metaRepo.findAll().listen(_onEvtInsertMeta);
    _metaRepo.watchAll().listen(_onWatchMetaEvt);
  }

  void _onEvtInsertMeta(RecordMeta meta) => setInitialized("插入Meta", () {
        _dataHolder.insertMeta(meta);
        // 缓存并监听Meta下Record
        _cacheRecordByMeta(meta);
      });

  void _onEvtUpdateMeta(RecordMeta meta) => setInitialized("更新/替换Meta", () {
        _dataHolder.updateMeta(meta);
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
        return _dataHolder.updateRecord(record);
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

  /// 业务逻辑-Meta ==============================================================
  /// MetaProvider

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
            final meta = dto.toDm((dto) => dto.toDm());
            await _metaRepo.save(meta);
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
    print("debug 更新meta的指定Attr [$metaDto] [$attr]");
    // todo 后期改为update
    final index = metaDto.attrs.indexWhere((element) => element.k == attr.k);
    if (index != -1) {
      metaDto.attrs[index] = (attr);
    } else {
      metaDto.attrs.add(attr);
    }
    // 持久化
    return actSaveMeta(metaDto);
  }

  Future<List<RecordMetaDto>> actQueryMetaByName(String metaName) async =>
      sl<RecordMetaAccessor>()
          .findAll(selector: where.eq("name", metaName))
          .drain();

  void actRemoveMeta(ObjectId metaId) =>
      actWrapper(() => setInitialized("删除Meta [$metaId]", () async {
            // 取消meta的监听
            actWatchMeta(null);
            // 从数据库中删除 Meta记录
            await _metaRepo.deleteBy(metaId);
            // 从数据库中删除 Meta对应的Record集合
            _recordAccessor(metaId.toHexString()).drop();
          }));

  /// 业务逻辑-Record ============================================================
  /// RecordProvider

  RecordMeta? watchedMeta;

  // 切换监听的Meta
  Future<void> actWatchMeta(RecordMeta? meta) => actWrapper(
        () => setInitialized(
          meta == null ? "取消监听Meta" : "开始/切换监听Meta[${meta.name}]",
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

  // <MetaId, 数据源>
  final Map<ObjectId, Tuple2<RecordDataGridSource2, DataGridController>>
      _cacheSourceWithCtrl = {};

  void _findCachedSource(
    ObjectId metaId,
    Function(RecordDataGridSource2 source) onFind,
  ) {
    final source = _cacheSourceWithCtrl[metaId]?.head;
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

  /// 返回当前meta对应的[IRecordDataGridSource]
  Tuple2<RecordDataGridSource2, DataGridController>
      actGetDataSourceWithCtrl() => _getByMeta(watchedMeta!);

  Tuple2<RecordDataGridSource2, DataGridController> _getByMeta(
      RecordMeta meta) {
    watchedMeta = meta;
    var cached = _cacheSourceWithCtrl[meta.id];
    return cached ?? _newDataSourceWithCtrl(meta);
  }

  /// 创建数据源, 以及数据源对应的[DataGridController]
  Tuple2<RecordDataGridSource2, DataGridController> _newDataSourceWithCtrl(
          RecordMeta meta) =>
      _cacheSourceWithCtrl[meta.id] = Tuple2(
          RecordDataGridSource2(
            meta,
            actSaveRecord,
            getCachedRecordsByMeta,
            getCachedRecordByIndex,
          ),
          DataGridController());

  List<Record> getCachedRecordsByMeta(ObjectId metaId) =>
      _dataHolder.getRecords(metaId);

  Record getCachedRecordByIndex(ObjectId metaId, int index) =>
      getCachedRecordsByMeta(metaId)[index];
}

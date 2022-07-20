part of 'model.dart';

class OpenedMeta extends ProviderSidecar {
  late final StreamSubscription<AccessorEvt<RecordDto>> _cachedRecordSubs;

  // 附加状态
  final OpenedWorkspace at;
  final List<Record> records = [];
  final RecordMeta meta;

  String get id => meta.id;

  String get name => meta.name;

  OpenedMeta(this.meta, this.at);

  _safeFetchAllRecord(
    Stream<RecordDto> Function() fetchAllRecordsFn, {
    required Function(RecordDto dto) onDto,
    int reRryCount = 0,
  }) async {
    try {
      // 出现异常,steam会自动关闭
      await for (final dto in fetchAllRecordsFn()) {
        _onEvtInsertRecord(dto.toDomain(meta));
      }
    } catch (e, s) {
      if (e is AppwriteException) {
        if (e.code == 404 && e.type == "collection_not_found") {
          // 不存在则无需抛出异常
          print("debug OpenedMeta.openBy: [$e], 由推测的`Record集合`尚未创建导致的,无需抛出异常");
          return;
          // 在新建表的时候,首次执行findAll被抛出, 可能是操作太频繁导致, 可以wait一会再重试
          // AppwriteException: null, {"message":"Error: Server Error","code":500,"version":"0.13.4"} (0)
        } else if ((e.type == null &&
                e.code == null &&
                e.message != null &&
                e.message!.startsWith(
                    '{"message":"Error: Server Error","code":500,')) &&
            // 重试次数<5 则继续重试
            (reRryCount < 5)) {
          print("debug 500异常, 重试#[$reRryCount]");
          return _safeFetchAllRecord(
            fetchAllRecordsFn,
            onDto: onDto,
            reRryCount: reRryCount + 1,
          );
        } else {
          print(
              "未处理的Appwrite异常 type# ${e.type}, code# ${e.code}, message# ${e.message}, rsp# ${e.response}");
        }
      }
      print("debug OpenedMeta.open: retry#[$reRryCount] 抛出未知异常 [$e], ");
      throw ExceptionAdapter.of(e, s);
    }
  }

  OpenedMeta.open({
    required this.at,
    required this.meta,
    required Stream<RecordDto> Function() fetchAllRecordsFn,
    required Stream<AccessorEvt<RecordDto>> watchAllRecords,
  }) : super(onCatch: ExceptionAdapter.of) {
    _safeFetchAllRecord(
      fetchAllRecordsFn,
      onDto: (dto) => _onEvtInsertRecord(dto.toDomain(meta)),
    );

    _cachedRecordSubs = watchAllRecords.listen((event) {
      _onWatchRecord(event);
    }, onError: (e, s) {
      if (e is AppwriteException &&
          e.code == 404 &&
          e.type == "collection_not_found") {
        // 不存在则无需抛出异常
        print("debug OpenedMeta.openBy: [$e], 由推测的`Record集合`尚未创建导致的,无需抛出异常");
      } else {
        // print("debug OpenedMeta.openBy: 抛出未知异常 [$e]");
        throw ExceptionAdapter.of(e, s);
      }
    });
  }

  /// 内部缓存表格数据
  RecordDataGridSourcePluto? _cachedDataSource;

  RecordDataGridSourcePluto get dataSource {
    // print("当前是否为缓存DataSource# ${_cachedDataSource == null}");
    return _cachedDataSource ??= RecordDataGridSourcePluto(
      meta: meta,
      findRecord: at.findRecord,
      cachedColumns: meta.toPlutoCols(this),
      cachedRows: records.map((e) => e.toPlutoRow(at.findRecord)).toList(),
    );
  }

  // 变更workspace的版本号，以实现“在不修改实例地址的情况下，让ValueKey能够刷新UI”
  _refreshDataVer() {
    _ver++;
    _ver %= 3;
    notifyListeners();
  }

  int _ver = 0;

  get ver => _ver + hashCode;

  void _onWatchRecord(AccessorEvt<RecordDto> event) {
    print("debug #监听WatchRecord # $event");
    switch (event.type) {
      case AccessorEvtTp.insert:
        _onEvtInsertRecord(event.dto!.toDomain(meta));
        break;
      case AccessorEvtTp.replace:
      case AccessorEvtTp.update:
        _onEvtUpdateRecord(event.dto!.toDomain(meta));
        break;
      case AccessorEvtTp.delete:
        _onEvtRemoveRecord(event.ettId);
        break;
    }
    notifyListeners();
  }

  Record _onEvtInsertRecord(Record record) {
    records.add(record);
    _cachedDataSource?.onInsertEvt(record);
    return record;
  }

  // 返回被更新的元素index
  int _onEvtUpdateRecord(Record record) {
    final index = records.indexWhere((element) => element.id == record.id);
    if (index == -1) {
      _onEvtInsertRecord(record);
    } else {
      records[index].update(record);
      _cachedDataSource?.onUpdateEvt(record, index);
    }
    return index;
  }

  // 返回被更新的元素index
  void _onEvtRemoveRecord(String ettId) {
    records.removeWhere((element) => element.id == ettId);
    // RecordDataGridSourcePluto.onRemoveEvt 不需要传入index,这里使用0
    _cachedDataSource?.onRemoveEvt(ettId, 0);
  }

  close() {
    _cachedRecordSubs.cancel();
    records.clear();
  }

  /// 用于Meta属性被更新时
  /// 删除缓存后会自动根据最新的Meta重建UI
  void cleanDataSourceCache() {
    _cachedDataSource = null;
    _refreshDataVer();
    print("debug 已清除DataSource缓存");
  }

  @override
  onInitializing() {}
}

extension OpenedMetaX on OpenedMeta {
  MetaService get _metaService => MetaService.withDI(sl, at.id)!;

  RecordDtoRepo get _recordDtoRepo => RecordDtoRepo.withDI(sl, meta);

  /// Meta
  Future<BaseException?> actUpdateMeta(
    RecordMetaDto? dto,
  ) async =>
      await actWrapper(() => setInitialized("保存元素 [$dto]", () async {
            if (dto == null) return null;
            await _metaService.updateWithRecordCollection(meta.toDto(), dto);
          }));

  Future<BaseException?> actUpdateMetaName(String? nName) async {
    if (nName == null) return null;
    final nDto = meta.toDto()..name = nName;
    return await actUpdateMeta(nDto);
  }

  /// Attr

  Future<BaseException?> actMetaUpdateAttr(
    AttributeDto? dto,
  ) async =>
      await actWrapper(() => setInitialized("更新属性 [$dto]", () async {
            if (dto == null) return null;
            await _metaService.updateAttribute(meta.toDto(), dto);
          }));

  /// View
  Future<BaseException?> actNewTableView(ViewType type) async =>
      await actWrapper(() async => await _metaService.updateTableView(
            meta.toDto(),
            TableView.builder(
                name: "未命名[${type.name}]视图",
                type: type,
                cols: meta.properties
                    .map((e) => ColViewInfo.build(propId: e.propId))
                    .toList()),
          ));

  Future<BaseException?> actUpdateView(TableView v) async =>
      await actWrapper(() async {
        await _metaService.updateTableView(meta.toDto(), v);
      });

  Future<BaseException?> actUpdateViewName(
      TableView view, String? nName) async {
    if (nName == null) return null;
    final nView = view.copyWith(name: nName);
    return await actUpdateView(nView);
  }

  Future<BaseException?> actDeleteView(int vId) async =>
      await actWrapper(() async {
        await _metaService.deleteTableView(meta.toDto(), vId);
      });

  /// Record

  Future<BaseException?> actSaveRecord(RecordDto? dto) async =>
      await actWrapper(() async {
        log("actSaveRecord ID[${dto?.id}]字段[${dto?.fields}]");
        // 无需set,因为插入成功后, watch会监听到新的变更
        if (dto == null) return;
        await _recordDtoRepo.update(dto);
      });

  Future<void> actRemoveRecord(String ettId) => actWrapper(() async {
        log("actRemoveRecord $ettId");
        await _recordDtoRepo.deleteBy(ettId);
      });
}

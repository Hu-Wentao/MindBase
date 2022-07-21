part of 'model.dart';

/// 管理已打开的工作空间
/// 在这里, 将DTO组装为 Domain对象, 也是业务逻辑的一部分
///
class OpenedWorkspace extends ProviderSidecar {
  late final StreamSubscription<AccessorEvt<RecordMetaDto>> _metasSub;

//  不能使用WorkspaceDto,必须持有RecordMeta,用于处理ref关系
  final Workspace _workspace;

  final List<OpenedMeta> openedMetas = [];

  String get id => _workspace.id;

  String get name => _workspace.name;

  List<RecordMeta> get metas => _workspace.metas;

  QueryMetaFn get queryMeta => _workspace.queryMeta;

  RecordMeta? Function(String metaId) get getMetaBy => _workspace.getMetaBy;

  Record findRecord(ExprValue value) {
    assert(value.type.isRef, "findRecord: value.type.isRef 必须是Ref类型才能作为查询参数");
    // value.type.meta
    return getRecords(value.type.meta!.id)
        .firstWhere((record) => record.id == value.value);
  }

  Iterable<RecordMeta> allMetas() => metas;

  final Stream<RecordDto> Function(String metaId) getFetchAllRecords;
  final Stream<AccessorEvt<RecordDto>> Function(String metaId)
      getWatchAllRecords;

  OpenedWorkspace.openBy({
    required Workspace workspace,
    required Stream<RecordMetaDto> Function() fetchAllMeta,
    required Stream<AccessorEvt<RecordMetaDto>> watchAllMeta,
    required this.getFetchAllRecords,
    required this.getWatchAllRecords,
  })  : _workspace = workspace,
        super(onCatch: ExceptionAdapter.of) {
    // 获取全部
    fetchAllMeta().listen((e) {
      onMetaAdd(e.toDm(queryMeta));
      notifyListeners();
    }, onError: (e, s) {
      if (e is AppwriteException &&
          e.code == 404 &&
          e.type == "collection_not_found") {
        // 不存在则无需抛出异常
        print("debug OpenedMeta.openBy: [$e], 由推测的`Meta集合`尚未创建导致的,无需抛出异常");
      } else {
        // print("debug OpenedMeta.openBy: 抛出未知异常 [$e]");
        throw ExceptionAdapter.of(e, s);
      }
    });
    // 开始监听
    _metasSub = watchAllMeta.listen((event) {
      print("#OpenedWorkspace[$id]#开始监听Meta变更: $event");
      onWatchMetaEvt(event);
    });
  }

  StreamSubscription<AccessorEvt<RecordMetaDto>> get subs => _metasSub;

  @protected
  RecordMeta onMetaAdd(RecordMeta meta) {
    //todo 可能要考虑meta/record在watchAll时,先收到create事件,然后又在getAll中被二次查询到的情况,这会导出出现两个相同Id的Meta/Record
    metas.add(meta);
    final openedMeta = OpenedMeta.open(
      at: this,
      meta: meta,
      fetchAllRecordsFn: () => getFetchAllRecords(meta.id),
      watchAllRecords: getWatchAllRecords(meta.id),
    );
    openedMetas.add(openedMeta);
    // print("debug _openCacheMeta: ${meta.id}");
    return meta;
  }

  RecordMeta onMetaUpdate(RecordMeta meta) {
    __indexByMetas(
      meta.id,
      onFind: (i, m) => m.update(meta),
      onNotFind: () => onMetaAdd(meta),
    );
    __indexByOpenedMetas(
      meta.id,
      onFind: (i, om) => om.cleanDataSourceCache(),
    );
    return meta;
  }

  void onMetaDelete(String metaId) {
    // 先关闭,后移除,否则会找不到Meta
    final i = __indexByOpenedMetas(metaId, onFind: (i, m) {
      m.close();
    });
    if (i != -1) openedMetas.removeAt(i);
    __indexByMetas(metaId, onFind: (i, m) => metas.remove(m));
    // 通知UI刷新
    notifyListeners();
  }

  List<Record> getRecords(String metaId) =>
      openedMetas[__indexByOpenedMetas(metaId)].records;

  Iterable<List<Record>> allRecords() =>
      openedMetas.map((element) => element.records);

  @Deprecated("改用 findRecord")
  Record queryRecordBy(String recordId, {String? metaId}) {
    if (metaId != null) {
      return getRecords(metaId).firstWhere((record) => record.id == recordId);
    }
    for (var recordList in allRecords()) {
      final i = recordList.indexWhere((element) => element.id == recordId);
      if (i != -1) {
        return recordList[i];
      }
    }
    throw "Workspace中找不到ID为[$recordId]的Record";
  }

  int __indexByOpenedMetas(
    String metaId, {
    Function(int index, OpenedMeta meta)? onFind,
  }) {
    final i = openedMetas.indexWhere((element) => element.id == metaId);
    if (i != -1) {
      onFind?.call(i, openedMetas[i]);
    }
    return i;
  }

  int __indexByMetas(
    String metaId, {
    Function(int index, RecordMeta meta)? onFind,
    Function()? onNotFind,
  }) {
    final i = metas.indexWhere((element) => element.id == metaId);
    if (i != -1) {
      onFind?.call(i, metas[i]);
    } else {
      onNotFind?.call();
    }
    return i;
  }

  /// 数据同步 ===================================================================
  Future<void> onWatchMetaEvt(AccessorEvt<RecordMetaDto> event) async {
    print("debug 工作空间#onWatchMetaEvt: $event");
    switch (event.type) {
      case AccessorEvtTp.insert:
        onMetaAdd(event.dto!.toDm(queryMeta));
        break;
      case AccessorEvtTp.replace:
      case AccessorEvtTp.update:
        onMetaUpdate(event.dto!.toDm(queryMeta));
        break;
      case AccessorEvtTp.delete:
        onMetaDelete(event.ettId);
        break;
    }
    notifyListeners();
  }

  Workspace close() {
    openedMetas.map((openedMeta) => openedMeta.close());
    _metasSub.cancel();
    return _workspace;
  }

  @override
  onInitializing() {}
}

extension OpenedSpaceX on OpenedWorkspace {
  MetaService get _metaService => MetaService.withDI(sl, id)!;

  WorkspaceService get _workspaceSrv => sl<WorkspaceService>();

  /// 注意,[actInsertMetaDto]与[actUpdateMeta]不能混用, Insert必须使用Meta,而不是Dto
  Future<BaseException?> actInsertMetaDto(RecordMetaDto meta) async =>
      await actWrapper(() => setInitialized("新增Meta [$meta]", () async {
            await _metaService.insertMetaDto(meta);
          }));

  /// 同时更新Meta与数据
  Future<BaseException?> actUpdateByTable(TableDto dto) async =>
      await actWrapper(
          () => setInitialized("通过Table更新Meta/record [$dto]", () async {
                await _workspaceSrv.insertTable(_metaService, dto);
              }));

  /// 移除Meta
  Future<BaseException?> actRemoveOpenedMeta(OpenedMeta meta) async =>
      await actWrapper(() => setInitialized("删除Meta [${meta.id}]", () async {
            meta.close();
            // 从数据库中删除 Meta记录和Record集合
            await _metaService.deleteBy(meta.id);
          }));
}

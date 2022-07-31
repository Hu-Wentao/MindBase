part of 'model.dart';

@Deprecated('use WorkspaceModel')
typedef OpenedWorkspace = WorkspaceModel;
@Deprecated('use WorkspaceModel')
typedef Workspace = WorkspaceModel;

mixin SpaceStateChangeMx on IWorkspaceModel {
  RecordMetaEttAccessor? __metaAcc;

  RecordMetaEttAccessor get _metaAcc =>
      __metaAcc ??= RecordMetaEttAccessor(sl<Databases>(), data.id);
  StreamSubscription<AccessorEvt<RecordMetaDto>>? _metasSub;

  @override
  FutureOr<void> onCloseSubs() {
    metas.map((openedMeta) => openedMeta.actCloseSubs());
    _metasSub?.cancel();
  }

  @override
  FutureOr<void> onFetch({bool isActive = false}) {
    _fetchMetaCollectionModel();
    _fetchAllMetas();
  }

  @override
  FutureOr<void> onReset() {
    metaCollection = null;
    metas.clear();
  }

  @override
  FutureOr<void> onSubscription() {
    /// meta部分 ----------------
    _metasSub = _metaAcc.watch().listen((event) {
      log("#WorkspaceModel[$id]#监听到Meta变更: $event");
      onWatchMetaEvt(event);
    });
  }

  int __indexByOpenedMetas(
    String metaId, {
    Function(int index, MetaModel meta)? onFind,
  }) {
    final i = metas.indexWhere((element) => element.id == metaId);
    if (i != -1) {
      onFind?.call(i, metas[i]);
    }
    return i;
  }

  int __indexByMetas(
    String metaId, {
    Function(int index, MetaModel meta)? onFind,
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

  MetaModel onMetaAdd(RecordMetaDto meta) => _addNewMetaModel(meta);

  RecordMetaDto onMetaUpdate(RecordMetaDto meta) {
    __indexByMetas(
      meta.id,
      onFind: (i, m) => m.updateData(meta),
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
      m.actReset();
    });
    if (i != -1) metas.removeAt(i);
    __indexByMetas(metaId, onFind: (i, m) => metas.remove(m));
    // 通知UI刷新
    notifyListeners();
  }

  /// 数据同步 ===================================================================
  Future<void> onWatchMetaEvt(AccessorEvt<RecordMetaDto> event) async {
    log("debug 工作空间#onWatchMetaEvt: $event");
    switch (event.type) {
      case AccessorEvtTp.insert:
        onMetaAdd(event.dto!);
        break;
      case AccessorEvtTp.replace:
      case AccessorEvtTp.update:
        onMetaUpdate(event.dto!);
        break;
      case AccessorEvtTp.delete:
        onMetaDelete(event.ettId);
        break;
    }
    notifyListeners();
  }

  _fetchAllMetas() => _metaAcc.findAll().listen((e) {
        onMetaAdd(e);
        notifyListeners();
      }, onError: (e, s) {
        if (e is AppwriteException &&
            e.code == 404 &&
            e.type == "collection_not_found") {
          // 不存在则无需抛出异常
          log("debug MetaModel.openBy: [$e], 由推测的`Meta集合`尚未创建导致的,无需抛出异常");
        }
        throw ExceptionAdapter.of(e, s);
      });
}

abstract class IWorkspaceModel
    extends ModelSidecar<WorkspaceDto, BaseException?>
    with ModelStateChangeMx<WorkspaceDto, BaseException?> {
  IWorkspaceModel(WorkspaceDto data) : super(data, ExceptionAdapter.of);

  String get id;

  List<MetaModel> get metas;

  CollectionInfoModel? get metaCollection;

  set metaCollection(CollectionInfoModel? value);

  MetaModel _addNewMetaModel(RecordMetaDto data);

  _fetchMetaCollectionModel();
}

class WorkspaceModel extends IWorkspaceModel with SpaceStateChangeMx {
  //   /// 开头`>>`用于防止用户自己设置同名变量
//   /// 用于DTO->Domain转换: 对应Value类型为 [QueryMetaFn] 将`MetaId->Meta查询`注入到ctx中, 以便读取meta,同时解决循环依赖问题
  @Deprecated("转移位置..")
  static const ctxQueryMetaSign = ">>_ctxQueryMetaSign";

  /// 用于表达式求值: 在工作空间内查询Record的实例(参见[AttrType.ref], [AsFuncThis])
  @Deprecated("转移位置..")
  static const ctxFindRecordFnSign = ">>_ctxFindRecordFnSign";

  WorkspaceModel(super.data, this.at);

  // 父状态
  final TeamModel at;

  // 子状态
  @override
  List<MetaModel> metas = [];

  // 工作空间下的所有表
  @override
  CollectionInfoModel? metaCollection;

  @Deprecated('使用openedMetas代替')
  List<MetaModel> get openedMetas => metas;

  @override
  String get id => data.id;

  String get name => data.name;

  QueryMetaFn get queryMeta =>
      (metaId) => metas.firstWhereOrNull((element) => element.id == metaId)!;

  @override
  MetaModel _addNewMetaModel(RecordMetaDto data) {
    final m = MetaModel(data, this);
    metas.add(m
      // 添加的同时初始化
      ..actInitSubscription());
    return m;
  }

  @override
  _fetchMetaCollectionModel() {
    final model = CollectionInfoModel(metaCollectionId);
    // 立即初始化
    metaCollection = model..actInitSubscription();
    setDoneKeepState();
  }

  get metaCollectionId => data.id; // 工作空间Id即为Meta集合Id

  @Deprecated('metas')
  Iterable<MetaModel> allMetas() => metas;

  RecordModel findRecord(ExprValue value) {
    assert(value.type.isRef, "findRecord: value.type.isRef 必须是Ref类型才能作为查询参数");
    // value.type.meta
    return getRecords(value.type.meta!.id)
        .firstWhere((record) => record.id == value.value);
  }

  // StreamSubscription<AccessorEvt<RecordMetaDto>> get subs => _metasSub;

  List<RecordModel> getRecords(String metaId) =>
      metas[__indexByOpenedMetas(metaId)].records;

  Iterable<List<RecordModel>> allRecords() =>
      metas.map((element) => element.records);
}

extension WorkspaceModelX on WorkspaceModel {
  MetaService get _metaService => MetaService.withDI(sl, id)!;

  WorkspaceService get _workspaceSrv => sl<WorkspaceService>();

  /// 注意,[actInsertMetaDto]与[actUpdateMeta]不能混用, Insert必须使用Meta,而不是Dto
  /// 本地数据由stream事件触发更新
  Future<BaseException?> actInsertMetaDto(RecordMetaDto meta) async =>
      await actWrapper(() => setDone("新增Meta [$meta]", () async {
            await _metaService.insertMetaDto(meta);
          }, false));

  /// 同时更新Meta与数据
  /// 本地数据由stream事件触发更新
  Future<BaseException?> actUpdateByTable(TableDto dto) async =>
      await actWrapper(() => setDone("通过Table更新Meta/record [$dto]", () async {
            await _workspaceSrv.insertTable(_metaService, dto);
          }, false));

  /// 移除Meta
  /// 本地数据由stream事件触发更新
  Future<BaseException?> actRemoveOpenedMeta(MetaModel meta) async =>
      await actWrapper(() => setDone("删除Meta [${meta.id}]", () async {
            meta.actReset();
            // 从数据库中删除 Meta记录和Record集合
            await _metaService.deleteBy(meta.id);
          }, false));
}

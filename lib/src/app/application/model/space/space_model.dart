part of '../../model.dart';

@freezed
class SpaceAct with _$SpaceAct {
  /// 初始化：更新collection/metas,并watch metas变更
  const factory SpaceAct.initModel() = SpaceActInitModel;

  const factory SpaceAct.updateModel(SpaceDto data) = SpaceActUpdateModel;

  ///
  const factory SpaceAct.updateTableDetail(CollectionDto data) =
      SpaceActUpdateTableDetail;

  ///
  const factory SpaceAct.insertMeta(MetaDto data) = SpaceActInsertMeta;

  const factory SpaceAct.deleteMeta(String metaId) = SpaceActDeleteMeta;

  const factory SpaceAct.updateByTable(TableDto dto) = SpaceActUpdateByTable;
}

@Freezed(makeCollectionsUnmodifiable: false)
class SpaceState with _$SpaceState {
  const factory SpaceState.init() = SpaceStateInit;

  const factory SpaceState.done(
    Collection metaTableDetail,
    List<MetaModel> metas,
  ) = SpaceStateDone;
}

class SpaceModel extends BaseActEntranceModel<SpaceAct, SpaceState> {
  SpaceDto data;

  SpaceModel(this.data, {super.state = const SpaceState.init()});

  @override
  String get id => data.id;

  String get name => data.name;

  @protected
  Collection? get metaTableDetail =>
      state.isOrNull<SpaceStateDone>()?.metaTableDetail;

  CollectionDto? get metaTableDetailDto => CollectionDto.from(metaTableDetail);

  @protected
  List<MetaModel> get metas => state.isOrNull<SpaceStateDone>()?.metas ?? [];

  QueryMetaFn get queryMeta => (metaId) => findMeta(metaId)!;

  MetaModel? findMeta(String? metaId) =>
      metas.firstWhereOrNull((element) => element.id == metaId);

  String get metaCollectionId => data.id; // 工作空间Id即为Meta集合Id

  RecordModel findRecord(ExprValue value) {
    assert(value.type.isRef, "findRecord: value.type.isRef 必须是Ref类型才能作为查询参数");
    // value.type.meta
    return getRecords(value.type.meta!.id)
        .firstWhere((record) => record.id == value.value);
  }

  List<RecordModel> getRecords(String metaId) =>
      metas[__indexByMetaModels(metaId)].records;

  Iterable<List<RecordModel>> allRecords() =>
      metas.map((element) => element.records);

  /// 节流flag改用 [act] 实例
  @override
  BaseException? onBeforeActEntrance(SpaceAct act) =>
      sl<Slowly>().seconds('${id}_${act.runtimeType}', sec: 1)
          ? null
          : const BaseException('msg');

  @override
  onActEntrance(SpaceAct act) async => await act.when(
        initModel: initModel,
        updateModel: updateModel,
        updateTableDetail: updateTableDetail,
        insertMeta: insertMeta,
        deleteMeta: deleteMeta,
        updateByTable: updateByTable,
      );

  MetaModel _addNewMetaModel(MetaDto data) {
    final m = MetaModel(data, this)
      // 添加的同时初始化
      ..actInitSubscription();
    state.isOrNull<SpaceStateDone>((s) => s.metas.add(m));
    // setState(
    //     state.map(
    //       init: (_) => _,
    //       done: (s) => s.copyWith(metas: [...s.metas, m]),
    //     ),
    //     '插入MetaModel[${m.id}]');
    return m;
  }

  /// ==== deprecated

  @Deprecated('metaTableInfo')
  Collection? get metaCollection => metaTableDetail;

  @Deprecated('metas')
  Iterable<MetaModel> allMetas() => metas;

  @Deprecated('使用openedMetas代替')
  List<MetaModel> get openedMetas => metas;

  //   /// 开头`>>`用于防止用户自己设置同名变量
  //   /// 用于DTO->Domain转换: 对应Value类型为 [QueryMetaFn] 将`MetaId->Meta查询`注入到ctx中, 以便读取meta,同时解决循环依赖问题
  @Deprecated("转移位置..")
  static const ctxQueryMetaSign = ">>_ctxQueryMetaSign";

  /// 用于表达式求值: 在工作空间内查询Record的实例(参见[AttrType.ref], [AsFuncThis])
  @Deprecated("转移位置..")
  static const ctxFindRecordFnSign = ">>_ctxFindRecordFnSign";
}

extension SpaceModelX on SpaceModel {
  updateTableDetail(CollectionDto dto) async {
    // 判断是否有权限更新
    final tableDetail =
        await _collectionSrv.updateCollectionNoCheck(metaTableDetail!, dto);
    // 非响应式, 必须手动更新状态
    setState(SpaceStateDone(tableDetail, metas), '更新TableDetail');
  }

  @protected
  initModel() async {
    // 暂不允许重复初始化
    if (state is SpaceStateDone) return;

    // 先watch fixme 没有close
    _metaAcc.watch().listen(onWatchMetaEvt);

    // 后fetch
    final metaTableInfo = await _collectionSrv.findCollection(metaCollectionId);
    final metaDtoLs = await _fetchAllMetas().toList();
    final metas = metaDtoLs.map((e) => MetaModel(e, this)).toList();
    setState(
      SpaceStateDone(metaTableInfo, metas),
      '初始化Space[$id],metas[${metas.length}]',
    );
  }

  updateModel(SpaceDto data) async {
    this.data = data;
    setState(state, '更新data');
  }

  @protected
  insertMeta(MetaDto meta) async {
    await _metaService.insertMetaDto(meta);
    // 通过listen监听刷新
  }

  @protected
  deleteMeta(String metaId) async {
    // 从数据库中删除 Meta记录和Record集合
    await _metaService.deleteBy(metaId);
    // 通过listen监听刷新
  }

  @protected
  updateByTable(TableDto dto) async {
    await _workspaceSrv.insertTable(_metaService, dto);
    // 通过listen监听刷新
  }

  CollectionService get _collectionSrv => sl<CollectionService>();

  MetaService get _metaService => MetaService.withDI(sl, id)!;

  SpaceService get _workspaceSrv => sl<SpaceService>();

  @Deprecated('updateModel')
  Future<BaseException?> updateData(SpaceDto data) async =>
      actEntrance(SpaceAct.updateModel(data));

  @Deprecated('initModel')
  Future<BaseException?> actRefresh() =>
      actEntrance(const SpaceAct.initModel());

  /// 注意,[actInsertMetaDto]与[actUpdateMeta]不能混用, Insert必须使用Meta,而不是Dto
  /// 本地数据由stream事件触发更新
  @Deprecated('insertMeta')
  Future<BaseException?> actInsertMetaDto(MetaDto meta) async =>
      actEntrance(SpaceAct.insertMeta(meta));

  /// 同时更新Meta与数据
  /// 本地数据由stream事件触发更新
  @Deprecated('actEntrance')
  Future<BaseException?> actUpdateByTable(TableDto dto) async =>
      actEntrance(SpaceAct.updateByTable(dto));

  /// 移除Meta
  /// 本地数据由stream事件触发更新
  @Deprecated('actEntrance deleteMeta')
  Future<BaseException?> actRemoveMetaModel(MetaModel meta) async =>
      actEntrance(SpaceAct.deleteMeta(meta.id));
}

@Deprecated('SpaceModelX')
extension SpaceStateChangeX on SpaceModel {
  MetaModelEttAccessor get _metaAcc =>
      MetaModelEttAccessor(sl<cli.Databases>(), data.id);

  int __indexByMetaModels(
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

  MetaModel onMetaAdd(MetaDto meta) => _addNewMetaModel(meta);

  MetaDto onMetaUpdate(MetaDto meta) {
    __indexByMetas(
      meta.id,
      onFind: (i, m) => m.updateData(meta),
      onNotFind: () => onMetaAdd(meta),
    );
    __indexByMetaModels(
      meta.id,
      onFind: (i, om) => om.cleanDataSourceCache(),
    );
    return meta;
  }

  void onMetaDelete(String metaId) {
    // 先关闭,后移除,否则会找不到Meta
    final i = __indexByMetaModels(metaId, onFind: (i, m) {
      m.actReset();
    });
    if (i != -1) metas.removeAt(i);
    __indexByMetas(metaId, onFind: (i, m) => metas.remove(m));
    // 通知UI刷新
    notifyListeners();
  }

  /// 数据同步 ===================================================================
  Future<void> onWatchMetaEvt(AccessorEvt<MetaDto> event) async {
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

  Stream<MetaDto> _fetchAllMetas() => _metaAcc.findAll();
// .listen((e) {
//   onMetaAdd(e);
//   notifyListeners();
// }, onError: (e, s) {
//   if (e is AppwriteException &&
//       e.code == 404 &&
//       e.type == "collection_not_found") {
//     // 不存在则无需抛出异常
//     log("debug MetaModel.openBy: [$e], 由推测的`Meta集合`尚未创建导致的,无需抛出异常");
//   }
//   throw ExceptionAdapter.of(e, s);
// });
}

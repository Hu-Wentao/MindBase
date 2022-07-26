part of 'model.dart';

@Deprecated('use WorkspaceModel')
typedef OpenedWorkspace = WorkspaceModel;
@Deprecated('use WorkspaceModel')
typedef Workspace = WorkspaceModel;

abstract class IWorkspaceModel
    extends ModelSidecar<WorkspaceDto, BaseException?> {
  IWorkspaceModel(WorkspaceDto data) : super(data, ExceptionAdapter.of);

  String get id;

  RecordMeta onMetaAdd(RecordMetaDto meta);

  Future<void> onWatchMetaEvt(AccessorEvt<RecordMetaDto> event);
}

/// Appwrite
mixin MetaAppAccessorMx on IWorkspaceModel {
  RecordMetaEttAccessor? __metaAcc;

  RecordMetaEttAccessor get _metaAcc =>
      __metaAcc ??= RecordMetaEttAccessor(sl<Database>(), data.id);

  var _metasSub;

  actCongested() => actWrapper(() {
        /// meta部分 ----------------
        // 先监听
        _metasSub = _metaAcc.watchAll().listen((event) {
          log("#WorkspaceModel[$id]#监听到Meta变更: $event");
          onWatchMetaEvt(event);
        });
        // 后查询
        _metaAcc.findAll().listen((e) {
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
      });
}

class WorkspaceModel extends IWorkspaceModel with MetaAppAccessorMx {
  //   /// 开头`>>`用于防止用户自己设置同名变量
//   /// 用于DTO->Domain转换: 对应Value类型为 [QueryMetaFn] 将`MetaId->Meta查询`注入到ctx中, 以便读取meta,同时解决循环依赖问题
  @Deprecated("转移位置..")
  static const ctxQueryMetaSign = ">>_ctxQueryMetaSign";

  /// 用于表达式求值: 在工作空间内查询Record的实例(参见[AttrType.ref], [AsFuncThis])
  @Deprecated("转移位置..")
  static const ctxFindRecordFnSign = ">>_ctxFindRecordFnSign";

  WorkspaceModel(super.data);

  // late StreamSubscription<AccessorEvt<RecordMetaDto>> _metasSub;

  @Deprecated('改用dto, 在model中处理ref')
  //  不能使用WorkspaceDto,必须持有RecordMeta,用于处理ref关系
  Workspace? _workspace;

  List<MetaModel> metaModels = [];

  @Deprecated('使用openedMetas代替')
  List<MetaModel> get openedMetas => metaModels;

  @override
  String get id => data.id;

  String get name => data.name;

  // 子状态
  List<MetaModel> metas = [];

  QueryMetaFn get queryMeta => (metaId) =>
      metaModels.firstWhereOrNull((element) => element.id == metaId)!;

  // MetaModel? Function(String metaId) get getMetaBy => _workspace.getMetaBy;

  Iterable<MetaModel> allMetas() => metas;

  late Stream<RecordDto> Function(String metaId) getFetchAllRecords;
  late Stream<AccessorEvt<RecordDto>> Function(String metaId)
      getWatchAllRecords;

  // WorkspaceModel.openBy({
  //   required Workspace workspace,
  //   required Stream<RecordMetaDto> Function() fetchAllMeta,
  //   required Stream<AccessorEvt<RecordMetaDto>> watchAllMeta,
  //   required this.getFetchAllRecords,
  //   required this.getWatchAllRecords,
  // })  : _workspace = workspace,
  //       super(ExceptionAdapter.of) {
  //   // 获取全部
  //   fetchAllMeta().listen((e) {
  //     onMetaAdd(e.toDm(queryMeta));
  //     notifyListeners();
  //   }, onError: (e, s) {
  //     if (e is AppwriteException &&
  //         e.code == 404 &&
  //         e.type == "collection_not_found") {
  //       // 不存在则无需抛出异常
  //       log("debug MetaModel.openBy: [$e], 由推测的`Meta集合`尚未创建导致的,无需抛出异常");
  //     }
  //     throw ExceptionAdapter.of(e, s);
  //   });
  //   // 开始监听
  //   _metasSub = watchAllMeta.listen((event) {
  //     log("#WorkspaceModel[$id]#监听到Meta变更: $event");
  //     onWatchMetaEvt(event);
  //   });
  // }

  Record findRecord(ExprValue value) {
    assert(value.type.isRef, "findRecord: value.type.isRef 必须是Ref类型才能作为查询参数");
    // value.type.meta
    return getRecords(value.type.meta!.id)
        .firstWhere((record) => record.id == value.value);
  }

  StreamSubscription<AccessorEvt<RecordMetaDto>> get subs => _metasSub;

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

  int __indexByOpenedMetas(
    String metaId, {
    Function(int index, MetaModel meta)? onFind,
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

  @override
  RecordMeta onMetaAdd(RecordMetaDto meta) {
    //todo 可能要考虑meta/record在watchAll时,先收到create事件,然后又在getAll中被二次查询到的情况,这会导出出现两个相同Id的Meta/Record
    return MetaModel(
      meta,
      this,
    );
  }

  /// 数据同步 ===================================================================
  Future<void> onWatchMetaEvt(AccessorEvt<RecordMetaDto> event) async {
    print("debug 工作空间#onWatchMetaEvt: $event");
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

  close() {
    openedMetas.map((openedMeta) => openedMeta.close());
    _metasSub.cancel();
  }
}

extension OpenedSpaceX on WorkspaceModel {
  MetaService get _metaService => MetaService.withDI(sl, id)!;

  WorkspaceService get _workspaceSrv => sl<WorkspaceService>();

  /// 注意,[actInsertMetaDto]与[actUpdateMeta]不能混用, Insert必须使用Meta,而不是Dto
  /// 本地数据由stream事件触发更新
  Future<BaseException?> actInsertMetaDto(RecordMetaDto meta) async =>
      await actWrapper(() => setInitialized("新增Meta [$meta]", () async {
            await _metaService.insertMetaDto(meta);
          }));

  /// 同时更新Meta与数据
  /// 本地数据由stream事件触发更新
  Future<BaseException?> actUpdateByTable(TableDto dto) async =>
      await actWrapper(
          () => setInitialized("通过Table更新Meta/record [$dto]", () async {
                await _workspaceSrv.insertTable(_metaService, dto);
              }));

  /// 移除Meta
  /// 本地数据由stream事件触发更新
  Future<BaseException?> actRemoveOpenedMeta(MetaModel meta) async =>
      await actWrapper(() => setInitialized("删除Meta [${meta.id}]", () async {
            meta.close();
            // 从数据库中删除 Meta记录和Record集合
            await _metaService.deleteBy(meta.id);
          }));
}

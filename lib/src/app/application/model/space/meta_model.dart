part of '../../model.dart';

extension MetaModelBizX on MetaModel {
  MethodDto? tryGetMethodBy(
    int methodKey, {
    MethodDto Function(int k)? orElse,
  }) =>
      methods.firstWhereOrNull(
        (mth) => mth.k == methodKey,
      ) ??
      orElse?.call(methodKey);

  PropertyDto getPropBy(String propId) =>
      properties.firstWhere((prop) => prop.propId == propId);
}

mixin MetaStateChangeMx on IMetaModel {
  RecordDtoRepo? __recordDtoRepo;

  RecordDtoRepo get _recordDtoRepo =>
      __recordDtoRepo ??= RecordDtoRepo.withDtoDI(sl, data);
  StreamSubscription<AccessorEvt<RecordDto>>? _cachedRecordSubs;

  int _ver = 0;

  get ver => _ver + hashCode;

  // 变更workspace的版本号，以实现“在不修改实例地址的情况下，让ValueKey能够刷新UI”
  _refreshDataVer() {
    _ver++;
    _ver %= 3;
    notifyListeners();
  }

  /// 开始监听状态
  @override
  Future<bool> onSubscription() async {
    _cachedRecordSubs =
        _recordDtoRepo.acc.watch().listen(_onWatchRecord, onError: (e, s) {
      if (e is cli.AppwriteException &&
          e.code == 404 &&
          e.type == "collection_not_found") {
        // 不存在则无需抛出异常
        log("debug MetaModel.openBy: [$e], 由推测的`Record集合`尚未创建导致的,无需抛出异常");
      } else {
        // print("debug MetaModel.openBy: 抛出未知异常 [$e]");
        throw ExceptionAdapter.of(e, s);
      }
    });
    return true;
  }

  /// 停止订阅流
  @override
  Future<bool> onCloseSubs() async {
    _cachedRecordSubs?.cancel();
    return true;
  }

  /// 单次刷新数据
  @override
  Future<bool> onFetch({bool isActive = false}) async {
    _fetchMetaDocumentModel();
    _fetchRecordCollectionModel();
    _fetchAllRecord();
    return true;
  }

  /// 重置充血数据
  @override
  Future<bool> onReset() async {
    metaDocument = null;
    recordCollection = null;
    records.clear();
    cleanDataSourceCache();
    return true;
  }

  /// 用于Meta属性被更新时
  /// 删除缓存后会自动根据最新的Meta重建UI
  @override
  void cleanDataSourceCache() {
    _cachedDataSource = null;
    _refreshDataVer();
    log("debug cleanDataSourceCache# 已清除DataSource缓存");
  }

  _fetchAllRecord({
    int reRryCount = 0,
  }) async {
    try {
      // 出现异常,steam会自动关闭
      await for (final dto in _recordDtoRepo.findAll()) {
        _onEvtInsertRecord(dto);
      }
    } catch (e, s) {
      if (e is cli.AppwriteException) {
        if (e.code == 404 && e.type == "collection_not_found") {
          // 不存在则无需抛出异常
          log("debug MetaModel.openBy: [$e], 由推测的`Record集合`尚未创建导致的,无需抛出异常");
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
          log("debug 500异常, 重试#[$reRryCount]");
          return _fetchAllRecord(reRryCount: reRryCount + 1);
        } else {
          log("未处理的Appwrite异常 type# ${e.type}, code# ${e.code}, message# ${e.message}, rsp# ${e.response}");
        }
      }
      log("debug MetaModel.open: retry#[$reRryCount] 抛出未知异常 [$e], ");
      throw ExceptionAdapter.of(e, s);
    }
  }

  void _onWatchRecord(AccessorEvt<RecordDto> event) {
    log("debug #监听WatchRecord # $event");
    switch (event.type) {
      case AccessorEvtTp.insert:
        _onEvtInsertRecord(event.dto!);
        break;
      case AccessorEvtTp.replace:
      case AccessorEvtTp.update:
        _onEvtUpdateRecord(event.dto!);
        break;
      case AccessorEvtTp.delete:
        _onEvtRemoveRecord(event.ettId);
        break;
    }
    notifyListeners();
  }

  void _onEvtInsertRecord(RecordDto record) => _addNewRecordModel(record);

  // 返回被更新的元素index
  int _onEvtUpdateRecord(RecordDto record) {
    final index = records.indexWhere((element) => element.id == record.id);
    if (index == -1) {
      _onEvtInsertRecord(record);
    } else {
      final m = records[index]..updateData(record);
      _cachedDataSource?.onUpdateEvt(m, index);
    }
    return index;
  }

  // 返回被更新的元素index
  void _onEvtRemoveRecord(String ettId) {
    records.removeWhere((element) => element.id == ettId);
    // RecordDataGridSourcePluto.onRemoveEvt 不需要传入index,这里使用0
    _cachedDataSource?.onRemoveEvt(ettId, 0);
  }
}

abstract class IMetaModel extends ModelSidecar<MetaDto, BaseException?>
    with StateChangeMx<MetaDto, BaseException?> {
  IMetaModel(MetaDto data) : super(data, ExceptionAdapter.of);

  String get id;

  DocumentInfoModel? get metaDocument;

  set metaDocument(DocumentInfoModel? value);

  CollectionInfoModel? get recordCollection;

  set recordCollection(CollectionInfoModel? value);

  List<RecordModel> get records;

  // 内部缓存表格数据
  RecordDataGridSourcePluto? get _cachedDataSource;

  set _cachedDataSource(RecordDataGridSourcePluto? value);

  cleanDataSourceCache();

  RecordModel _addNewRecordModel(RecordDto data);

  CollectionInfoModel _fetchRecordCollectionModel();

  DocumentInfoModel _fetchMetaDocumentModel();
}

class MetaModel extends IMetaModel with MetaStateChangeMx {
  MetaModel(super.data, this.at);

  final SpaceModel at;

  /// 子状态

  // 当前Meta记录的权限
  @override
  DocumentInfoModel? metaDocument;

  // 下属record集合的权限
  @override
  CollectionInfoModel? recordCollection;
  @override
  List<RecordModel> records = [];
  @override
  RecordDataGridSourcePluto? _cachedDataSource;

  @override
  String get id => data.id;

  String get name => data.name;

  String get recordCollectionId => data.id;

  String get metaDocumentId => data.id;

  String get metaCollectionId => at.id;

  List<AttributeDto> get attrs => data.attrs;

  List<MethodDto> get methods => data.methods;

  List<PropertyDto> get properties => [...attrs, ...methods];

  RecordDataGridSourcePluto get dataSource =>
      _cachedDataSource ??= RecordDataGridSourcePluto(
        meta: this,
        findRecord: at.findRecord,
        cachedColumns: PlutoMetaModelX(this).toPlutoCols(),
        cachedRows: records.map((e) => toPlutoRow(e)).toList(),
      );

  @override
  RecordModel _addNewRecordModel(RecordDto data) {
    final model = RecordModel(this, data);
    records.add(model);
    _cachedDataSource?.onInsertEvt(model);
    setDoneKeepState();
    return model;
  }

  // 由于 [RecordCollectionModel]没有请求dto代码,所以没有入参
  // 只需要在加入到缓存中时立即初始化即可
  @override
  DocumentInfoModel _fetchMetaDocumentModel() {
    final model = DocumentInfoModel(metaDocumentId, metaCollectionId);
    // 添加到缓存的同时, 立即请求刷新
    metaDocument = model..actInitSubscription();
    setDoneKeepState();
    return model;
  }

  // 由于 [RecordCollectionModel]没有请求dto代码,所以没有入参
  // 只需要在加入到缓存中时立即初始化即可
  @override
  CollectionInfoModel _fetchRecordCollectionModel() {
    final model = CollectionInfoModel(recordCollectionId);
    // 添加到缓存的同时, 立即请求刷新
    recordCollection = model..actInitSubscription();
    setDoneKeepState();
    return model;
  }
}

extension MetaModelX on MetaModel {
  MetaDtoRepo get _metaDtoRepo => MetaDtoRepo.withDI(sl, at.id);

  RecordDtoRepo get _recordDtoRepo => RecordDtoRepo.withDI(sl, this);

  /// Meta
  Future<BaseException?> actUpdateMeta(
    MetaDto? dto,
  ) async =>
      await actWrapper(() => setState(null, "保存元素 [$dto]", before: () async {
            if (dto == null) return null;
            await _metaDtoRepo.updateWithRecordCollection(data, dto);
          }));

  Future<BaseException?> actUpdateMetaName(String? nName) async {
    if (nName == null) return null;
    final nDto = data..name = nName;
    return await actUpdateMeta(nDto);
  }

  /// Attr

  Future<BaseException?> actMetaUpdateAttr(
    AttributeDto? dto,
  ) async =>
      await actWrapper(() => setState(null, "更新属性 [$dto]", before: () async {
            if (dto == null) return null;
            await _metaDtoRepo.updateAttribute(data, dto);
          }));

  /// View
  Future<BaseException?> actNewTableView(ViewType type) async =>
      await actWrapper(() async => await _metaDtoRepo.updateTableView(
            data,
            TableView.builder(
                name: "未命名[${type.name}]视图",
                type: type,
                cols: properties
                    .map((e) => ColViewInfo.build(propId: e.propId))
                    .toList()),
          ));

  Future<BaseException?> actUpdateView(TableView v) async =>
      await actWrapper(() async {
        await _metaDtoRepo.updateTableView(data, v);
      });

  Future<BaseException?> actUpdateViewName(
      TableView view, String? nName) async {
    if (nName == null) return null;
    final nView = view.copyWith(name: nName);
    return await actUpdateView(nView);
  }

  Future<BaseException?> actDeleteView(int vId) async =>
      await actWrapper(() async {
        await _metaDtoRepo.deleteTableView(data, vId);
      });

  /// Record

  Future<BaseException?> actSaveRecord(RecordDto? dto) async =>
      await actWrapper(() async {
        log("actSaveRecord ID[${dto?.id}]字段[${dto?.fields}]");
        // 无需set,因为插入成功后, watch会监听到新的变更
        if (dto == null) return;
        await _recordDtoRepo.update(dto);
      });

  Future<BaseException?> actRemoveRecord(String ettId) async =>
      await actWrapper(() async {
        log("actRemoveRecord $ettId");
        await _recordDtoRepo.deleteBy(ettId);
      });
}

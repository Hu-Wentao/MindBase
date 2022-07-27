part of 'model.dart';

@Deprecated("MetaModel")
typedef OpenedMeta = MetaModel;
@Deprecated("MetaModel")
typedef RecordMeta = MetaModel;

extension MetaModelBizX on MetaModel {
  ExprValue getFieldByAttrName(RecordModel record, String name) =>
      getField(record, name.parsePropK);

  ExprValue getField(RecordModel record, int attrKey) {
    final pIndex = data.attrs.indexWhere((attr) => attr.k == attrKey);
    if (pIndex == -1) {
      // 找不到属性，通常是因为新增列，但没有填充值导致的
      return ExprValue.build(
          type: AttrType.string, ag: [null, "Error#找不到Prop[$attrKey]"]);
    }
    final prop = data.attrs[pIndex];
    final value = record.data.fields[attrKey];
    return ExprValue.build(
        type: prop.type.toDomain(at.queryMeta),
        ag: [value?.value, value == null ? "Error#找不到Value值" : null]);
  }

  Value? getFieldValue(RecordModel record, int attrKey,
          {Value Function(int k)? orElse}) =>
      record.data.fields[attrKey] ?? orElse?.call(attrKey);

  MethodDto? tryGetMethodBy(
    int methodKey, {
    MethodDto Function(int k)? orElse,
  }) =>
      methods.firstWhereOrNull(
        (mth) => mth.k == methodKey,
      ) ??
      orElse?.call(methodKey);

  /// 根据属性名称获取属性值(同时调用表达式进行计算)
  Value getValueBy(RecordModel record, PropertyDto prop, FindRecordFn find) =>
      Value.of(record.eval(prop, find));

  PropertyDto getPropBy(String propId) =>
      properties.firstWhere((prop) => prop.propId == propId);
}

abstract class IMetaModel extends ModelSidecar<RecordMetaDto, BaseException?>
    with ModelStateChangeMx<RecordMetaDto, BaseException?> {
  IMetaModel(RecordMetaDto data) : super(data, ExceptionAdapter.of);

  String get id;

  List<RecordModel> get records;

  // 内部缓存表格数据
  RecordDataGridSourcePluto? get _cachedDataSource;

  set _cachedDataSource(RecordDataGridSourcePluto? value);

  cleanDataSourceCache();

  RecordModel _newRecordModel(RecordDto data);
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
  FutureOr<void> onSubscription() {
    _cachedRecordSubs =
        _recordDtoRepo.acc.watchAll().listen(_onWatchRecord, onError: (e, s) {
      if (e is AppwriteException &&
          e.code == 404 &&
          e.type == "collection_not_found") {
        // 不存在则无需抛出异常
        log("debug MetaModel.openBy: [$e], 由推测的`Record集合`尚未创建导致的,无需抛出异常");
      } else {
        // print("debug MetaModel.openBy: 抛出未知异常 [$e]");
        throw ExceptionAdapter.of(e, s);
      }
    });
  }

  /// 停止订阅流
  @override
  FutureOr<void> onCloseSubs() {
    _cachedRecordSubs?.cancel();
    records.clear();
    return null;
  }

  /// 单次刷新数据
  @override
  FutureOr<void> onFetch({bool isActive = false}) {
    _safeFetchAllRecord(_recordDtoRepo.findAll, onDto: _onEvtInsertRecord);
  }

  /// 重置充血数据
  @override
  FutureOr<void> onReset() {}

  _safeFetchAllRecord(
    Stream<RecordDto> Function() fetchAllRecordsFn, {
    required Function(RecordDto dto) onDto,
    int reRryCount = 0,
  }) async {
    try {
      // 出现异常,steam会自动关闭
      await for (final dto in fetchAllRecordsFn()) {
        _onEvtInsertRecord(dto);
      }
    } catch (e, s) {
      if (e is AppwriteException) {
        if (e.code == 404 && e.type == "collection_not_found") {
          // 不存在则无需抛出异常
          print("debug MetaModel.openBy: [$e], 由推测的`Record集合`尚未创建导致的,无需抛出异常");
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
      print("debug MetaModel.open: retry#[$reRryCount] 抛出未知异常 [$e], ");
      throw ExceptionAdapter.of(e, s);
    }
  }

  void _onWatchRecord(AccessorEvt<RecordDto> event) {
    print("debug #监听WatchRecord # $event");
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

  RecordDto _onEvtInsertRecord(RecordDto record) {
    final model = _newRecordModel(record);
    records.add(model);
    _cachedDataSource?.onInsertEvt(model);
    return record;
  }

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

  /// 用于Meta属性被更新时
  /// 删除缓存后会自动根据最新的Meta重建UI
  @override
  void cleanDataSourceCache() {
    _cachedDataSource = null;
    _refreshDataVer();
    print("debug 已清除DataSource缓存");
  }
}

class MetaModel extends IMetaModel with MetaStateChangeMx {
  MetaModel(super.data, this.at);

  // 附加状态
  final WorkspaceModel at;
  @override
  List<RecordModel> records = [];
  @override
  RecordDataGridSourcePluto? _cachedDataSource;

  @Deprecated('data')
  RecordMetaDto get meta => data;

  @override
  String get id => data.id;

  String get name => data.name;

  List<AttributeDto> get attrs => data.attrs;

  List<MethodDto> get methods => data.methods;

  List<PropertyDto> get properties => [...attrs, ...methods];

  RecordDataGridSourcePluto get dataSource {
    // print("当前是否为缓存DataSource# ${_cachedDataSource == null}");
    return _cachedDataSource ??= RecordDataGridSourcePluto(
      meta: this,
      findRecord: at.findRecord,
      cachedColumns: PlutoMetaModelX(this).toPlutoCols(),
      // cachedColumns: data.toPlutoCols(this),
      cachedRows: records.map((e) => toPlutoRow(e)).toList(),
      // cachedRows: records.map((e) => e.toPlutoRow(at.findRecord)).toList(),
    );
  }

  @override
  RecordModel _newRecordModel(RecordDto data) => RecordModel(this, data);
}

extension MetaModelX on MetaModel {
  MetaService get _metaService => MetaService.withDI(sl, at.id)!;

  RecordDtoRepo get _recordDtoRepo => RecordDtoRepo.withDI(sl, this);

  /// Meta
  Future<BaseException?> actUpdateMeta(
    RecordMetaDto? dto,
  ) async =>
      await actWrapper(() => setDone("保存元素 [$dto]", () async {
            if (dto == null) return null;
            await _metaService.updateWithRecordCollection(data, dto);
          }, false));

  Future<BaseException?> actUpdateMetaName(String? nName) async {
    if (nName == null) return null;
    final nDto = data..name = nName;
    return await actUpdateMeta(nDto);
  }

  /// Attr

  Future<BaseException?> actMetaUpdateAttr(
    AttributeDto? dto,
  ) async =>
      await actWrapper(() => setDone("更新属性 [$dto]", () async {
            if (dto == null) return null;
            await _metaService.updateAttribute(data, dto);
          }, false));

  /// View
  Future<BaseException?> actNewTableView(ViewType type) async =>
      await actWrapper(() async => await _metaService.updateTableView(
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
        await _metaService.updateTableView(data, v);
      });

  Future<BaseException?> actUpdateViewName(
      TableView view, String? nName) async {
    if (nName == null) return null;
    final nView = view.copyWith(name: nName);
    return await actUpdateView(nView);
  }

  Future<BaseException?> actDeleteView(int vId) async =>
      await actWrapper(() async {
        await _metaService.deleteTableView(data, vId);
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

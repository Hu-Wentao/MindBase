import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/provider/workspace_manager_provider.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/repo/repo.dart';
import 'package:mind_base/src/infra/dao/dao_aw_impl.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_source.dart';
import 'package:mind_base/src/interface/i_dto.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

/// 统一监听与处理工作空间内的所有数据
/// todo 当前假定本数据库为一个工作空间
class WorkspaceProvider extends ProviderSidecar {
  late MetaDtoRepo _metaDtoRepo;

  // <MetaId,Accessor>
  final Map<String, RecordEttAccessor> _recordAccessors = {};
  OpenedWorkspace? openedWorkspace;

  OpenedWorkspace get workspace => openedWorkspace!;

  WorkspaceProvider(this.openedWorkspace);

  @override
  onInitializing() {
    if (openedWorkspace == null) {
      setUninitialized("尚未打开工作空间");
      return;
    }
    _metaDtoRepo = MetaDtoRepo.withDI(sl, workspace.workspace.id);
    setInitialized("工作空间[${openedWorkspace!.workspace.id}]初始化完成");
  }

  RecordEttAccessor _recordAccessor(String metaId) =>
      _recordAccessors[metaId] ??= RecordEttAccessor(
          sl<Database>(), metaId, workspace.workspace.queryMeta);

  actSelectWorkspace(WorkspaceManagerProvider pManager, String wsId) async {
    setInitializing("正在打开工作空间[$wsId]");
    final opendsWs = await pManager.getOpenedWorkspace(wsId);
    openedWorkspace = opendsWs;
    setInitialized("已打开工作空间[${opendsWs.workspace.name}],ID[$wsId]");
  }

  /// 业务逻辑-Meta ==============================================================
  /// MetaProvider

  List<RecordMeta> get metaList => workspace.allMetas().toList();

  // todo 考虑改成 MetaDto
  Future<void> actInsertMeta(RecordMeta meta) =>
      actWrapper(() => setInitialized("新增Meta [$meta]", () async {
            await _metaDtoRepo.insert(meta.toDto());
          }));

  Future<BaseException?> actSaveMeta(RecordMetaDto? dto) async =>
      await actWrapper(() => setInitialized("保存元素 [$dto]", () async {
            if (dto == null) {
              return null;
            }
            await _metaDtoRepo.update(dto);
          }));

  Future<RecordMetaDto?> actQueryMeta(String metaId) =>
      _metaDtoRepo.findById(metaId);

  // 更新meta的指定Attr
  Future<BaseException?> actEditAttribute(
    RecordMetaDto metaDto,
    AttributeDto? attr,
  ) async {
    if (attr == null) {
      return null;
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
      _metaDtoRepo.findAllBy(metaName).toList();

  void actRemoveMeta(String metaId) =>
      actWrapper(() => setInitialized("删除Meta [$metaId]", () async {
            // 取消meta的监听
            actWatchMeta(null);
            // 从数据库中删除 Meta记录
            await _metaDtoRepo.deleteBy(metaId);
            // 从数据库中删除 Meta对应的Record集合
            await _recordAccessor(metaId).drop();
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

  Record actQueryRecordBy(
    String recordId, {
    String? metaId,
    @Deprecated("使用metaId查询") RecordMeta? meta,
    bool queryGlobal = false, // true表示查询所有类型的MetaId下的记录,只要recordId相符即可
  }) =>
      workspace.queryRecordBy(
        recordId,
        metaId: queryGlobal ? null : metaId ?? (meta ?? watchedMeta)?.id,
      );

  Future<void> actSaveRecord(RecordDto? dto) => actWrapper(() async {
        log("actSaveRecord ${dto?.toJson()}");
        // 无需set,因为插入成功后, watch会监听到新的变更
        if (dto == null) return;
        await _recordAccessor(dto.metaId).replace(dto);
        // await RecordAccessor(sl<Db>(), dto.metaIdHex).save(dto.id, dto);
      });

  Future<void> actRemoveRecordBy(int rowIndex) {
    final meta = watchedMeta;
    final rcd = workspace.getRecords(meta!.id)[rowIndex];
    return actRemoveRecord(meta, rcd.id);
  }

  Future<void> actRemoveRecord(RecordMeta meta, String ettId) =>
      actWrapper(() async {
        log("actRemoveRecord $ettId");
        await _recordAccessor(meta.id).deleteBy(ettId);
      });

  // <MetaId, 数据源>
  final Map<String, IRecordDataGridSource> _cacheSource = {};

  void _findCachedSource(
    String metaId,
    Function(IRecordDataGridSource source) onFind,
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

  void _onEvtRemoveRecordSource(String ettId, String metaId, int index) =>
      _findCachedSource(metaId, (source) => source.onRemoveEvt(ettId, index));

  /// 获取已缓存的数据源
  IRecordDataGridSource actGetDataSource([String? metaId]) =>
      _getByMetaId(metaId ?? watchedMeta!.id);

  IRecordDataGridSource _getByMetaId(String metaId) => _cacheSource[metaId] ??=
      _newDataSource(workspace.workspace.getMetaBy(metaId)!);

  /// 创建数据源, 以及数据源对应的[DataGridController]
  RecordDataGridSourcePluto _newDataSource(RecordMeta meta) =>
      RecordDataGridSourcePluto(
        meta: meta,
        cachedColumns: meta.toPlutoCols,
        cachedRows:
            getCachedRecordsByMeta(meta.id).map((e) => e.toPlutoRow()).toList(),
      );

  List<Record> getCachedRecordsByMeta(String metaId) =>
      workspace.getRecords(metaId);
//
// Record getCachedRecordByIndex(String metaId, int index) =>
//     getCachedRecordsByMeta(metaId)[index];
}

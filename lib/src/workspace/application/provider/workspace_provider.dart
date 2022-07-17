import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/workspace/application/service/meta_service.dart';
import 'package:mind_base/src/workspace/application/service/workspace_service.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/workspace/domain/repo/repo.dart';
import 'package:mind_base/src/workspace/domain/value/value.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/import_data_dialog.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/data_table_source.dart';
import 'package:provider_sidecar/provider_sidecar.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';

import 'opened_workspace.dart';

/// 统一监听与处理工作空间内的所有数据
class WorkspaceProvider extends ProviderSidecar {
  MetaService? _metaService;
  final WorkspaceService _workspaceSrv = sl<WorkspaceService>();

  // <MetaId,Accessor>
  final Map<String, RecordDtoRepo> _recordAccessors = {};

  // 核心状态
  OpenedWorkspace? openedWorkspace;

  List<OpenedMeta> get openedMetas => openedWorkspace!.openedMetas;

  OpenedMeta? selectedMeta;

  int? selectedVId; // 选中meta所适配的视图，可以为null
  TableView? get selectedTableView {
    final i =
        selectedMeta?.meta.views.indexWhere((v) => v.vId == selectedVId) ?? -1;
    print("debug selectedTableView i#$i,vId$selectedVId,views${selectedMeta?.meta.views}");
    return (i != -1) ? selectedMeta?.meta.views[i] : null;
  }

  WorkspaceProvider([this.openedWorkspace])
      : super(onCatch: ExceptionAdapter.of);

  @override
  onInitializing() => actOnSelectedWorkspaceUpdate(null);

  actOnSelectedWorkspaceUpdate(OpenedWorkspace? selectedWorkspace) {
    if (selectedWorkspace == null) {
      // 取消选择工作空间
      return (openedWorkspace == null)
          ? setUninitialized("尚未选择工作空间,无需重复取消选择")
          : _unSelectWorkspace();
    } else {
      // 选择新的工作空间
      if (openedWorkspace == null) {
        return _selectWorkspace(selectedWorkspace);
      } else {
        // 替换选择的工作空间
        return (openedWorkspace!.id == selectedWorkspace.id)
            ? setInitialized("工作空间[${openedWorkspace!.id}]已选中,无需重复选中")
            : _selectWorkspace(selectedWorkspace);
      }
    }
  }

  _selectWorkspace(OpenedWorkspace selectedWorkspace) =>
      setInitialized("选择新的工作空间[${selectedWorkspace.id}]", () {
        openedWorkspace = selectedWorkspace;
        _metaService = MetaService.withDI(sl, selectedWorkspace.id);
      });

  _unSelectWorkspace() => openedWorkspace == null
      ? log("_unSelectWorkspace#当前未选中工作空间")
      : setUninitialized("工作空间[${openedWorkspace!.id}]已取消选中", () {
          openedWorkspace = null;
          _metaService = null;
        });

  RecordDtoRepo _recordDtoRepo(RecordMeta meta) =>
      _recordAccessors[meta.id] ??= RecordDtoRepo.withDI(sl, meta);

  /// 业务逻辑-Meta ==============================================================
  /// MetaProvider

  List<RecordMeta> get metaList => openedWorkspace!.allMetas().toList();

  /// 注意,[actInsertMetaDto]与[actUpdateMeta]不能混用, Insert必须使用Meta,而不是Dto
  Future<BaseException?> actInsertMetaDto(RecordMetaDto meta) async =>
      await actWrapper(() => setInitialized("新增Meta [$meta]", () async {
            await _metaService!.insertMetaDto(meta);
          }));

  /// 同时更新Meta与数据
  Future<BaseException?> actUpdateByTable(TableDto dto) async =>
      await actWrapper(
          () => setInitialized("通过Table更新Meta/record [$dto]", () async {
                await _workspaceSrv.insertTable(_metaService!, dto);
              }));

  Future<BaseException?> actUpdateMeta(
    RecordMeta origin,
    RecordMetaDto? dto,
  ) async =>
      await actWrapper(() => setInitialized("保存元素 [$dto]", () async {
            if (dto == null) return null;
            await _metaService!.updateWithRecordCollection(origin.toDto(), dto);
          }));

  Future<BaseException?> actMetaUpdateAttr(
    RecordMeta origin,
    AttributeDto? dto,
  ) async =>
      await actWrapper(() => setInitialized("更新属性 [$dto]", () async {
            if (dto == null) return null;
            await _metaService!.updateAttribute(origin.toDto(), dto);
          }));

  // Future<RecordMetaDto?> actQueryMeta(String metaId) =>
  //     _metaService!.findById(metaId);

  // Future<List<RecordMetaDto>> actQueryMetaByName(String metaName) async =>
  //     _metaService!.findAllBy(metaName).toList();

  Future<BaseException?> actRemoveMeta(String metaId) async =>
      await actWrapper(() => setInitialized("删除Meta [$metaId]", () async {
            // 取消meta的监听
            actSelectOpenMeta(null);
            // 从数据库中删除 Meta记录和Record集合
            await _metaService!.deleteBy(metaId);
          }));

  /// 业务逻辑-Record ============================================================
  /// RecordProvider

  // 选择一个已经打开的meta
  Future<void> actSelectOpenMeta(OpenedMeta? meta) => actWrapper(
        () => selectedMeta != meta
            ? setInitialized(
                meta == null ? "取消监听Meta" : "开始/切换监听Meta[${meta.name}]",
                () => selectedMeta = meta)
            : null,
      );

  @Deprecated("尝试使用 FindRecordFn")
  Record actQueryRecordBy(
    String recordId, {
    String? metaId,
    bool queryGlobal = false, // true表示查询所有类型的MetaId下的记录,只要recordId相符即可
  }) =>
      openedWorkspace!.queryRecordBy(
        recordId,
        metaId: queryGlobal ? null : metaId ?? (selectedMeta)?.id,
      );

  Future<BaseException?> actSaveRecord(RecordDto? dto) async =>
      await actWrapper(() async {
        log("actSaveRecord ID[${dto?.id}]字段[${dto?.fields}]");
        // 无需set,因为插入成功后, watch会监听到新的变更
        if (dto == null) return;
        final meta = selectedMeta!;
        await _recordDtoRepo(meta.meta).update(dto);
      });

  @Deprecated("使用actRemoveRecord,避免使用rowIndex")
  Future<void> actRemoveRecordBy(int rowIndex) {
    final rcd = selectedMeta!.records[rowIndex];
    return actRemoveRecord(selectedMeta!.meta, rcd.id);
  }

  Future<void> actRemoveRecord(RecordMeta meta, String ettId) =>
      actWrapper(() async {
        log("actRemoveRecord $ettId");
        await _recordDtoRepo(meta).deleteBy(ettId);
      });

  Future<BaseException?> actNewTableView(
          ViewType type, RecordMeta meta) async =>
      await actWrapper(() async => await _metaService!.updateTableView(
            meta.toDto(),
            TableView.builder(
                name: "未命名[${type.name}]视图",
                type: type,
                cols: meta.properties
                    .map((e) => ColViewInfo.auto(e.propId))
                    .toList()),
          ));

  /// 获取已缓存的数据源
  IRecordDataGridSource actGetDataSource([String? metaId]) =>
      _getByMetaId(metaId ?? selectedMeta!.id);

  IRecordDataGridSource _getByMetaId(String metaId) =>
      openedMetas.firstWhere((element) => element.id == metaId).dataSource;

  List<Record> getCachedRecordsByMeta(String metaId) =>
      openedMetas.firstWhere((element) => element.id == metaId).records;

  Future<BaseException?> actSelectView(TableView v) async =>
      await actWrapper(() => setSelectedTableView(v));

  Future<BaseException?> actUpdateView(RecordMetaDto dto, TableView v) async =>
      await actWrapper(() async {
        await _metaService!.updateTableView(dto, v);
      });

  /// set方法 ======

  setSelectedTableView(TableView? v) => setInitialized('设置TableView[$v]', () {
        selectedVId = v?.vId;
      });
}

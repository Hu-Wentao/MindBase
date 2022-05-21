import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/domain/repo/repo.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_source.dart';
import 'package:mind_base/src/interface/i_dto.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

import 'model/opened_workspace.dart';

/// 统一监听与处理工作空间内的所有数据
class WorkspaceProvider extends ProviderSidecar {
  MetaDtoRepo? _metaDtoRepo;

  // <MetaId,Accessor>
  final Map<String, RecordDtoRepo> _recordAccessors = {};

  // 核心状态
  OpenedWorkspace? openedWorkspace;

  List<OpenedMeta> get openedMetas => openedWorkspace!.openedMetas;

  OpenedMeta? selectedMeta;

  @Deprecated("使用 openedWorkspace")
  OpenedWorkspace get workspace => openedWorkspace!;

  WorkspaceProvider([this.openedWorkspace])
      : super(onCatch: ExceptionAdapter.of);

  @override
  onInitializing() => actOnSelectedWorkspaceUpdate(null);

  actOnSelectedWorkspaceUpdate(OpenedWorkspace? selectedWorkspace) {
    if (selectedWorkspace == null) {
      // 取消选择工作空间
      return (openedWorkspace == null)
          ? setUninitialized("尚未选择工作空间,无需重复取消选择")
          : _setNoneWorkspace();
    } else {
      // 选择新的工作空间
      if (openedWorkspace == null) {
        return _setNewWorkspace(selectedWorkspace);
      } else {
        // 替换选择的工作空间
        return (openedWorkspace!.id == selectedWorkspace.id)
            ? setInitialized("工作空间[${openedWorkspace!.id}]已选中,无需重复选中")
            : _setNewWorkspace(selectedWorkspace);
      }
    }
  }

  _setNewWorkspace(OpenedWorkspace selectedWorkspace) =>
      setInitialized("选择新的工作空间[${selectedWorkspace.id}]", () {
        openedWorkspace = selectedWorkspace;
        _metaDtoRepo = MetaDtoRepo.withDI(sl, selectedWorkspace.id);
      });

  _setNoneWorkspace() =>
      setUninitialized("工作空间[${openedWorkspace!.workspace.id}]已取消选中", () {
        openedWorkspace = null;
        _metaDtoRepo = null;
      });

  RecordDtoRepo _recordDtoRepo(RecordMeta meta) =>
      _recordAccessors[meta.id] ??= RecordDtoRepo.withDI(sl, meta);

  /// 业务逻辑-Meta ==============================================================
  /// MetaProvider

  List<RecordMeta> get metaList => openedWorkspace!.allMetas().toList();

  /// 注意,[actInsertMeta]与[actUpdateMeta]不能混用, Insert必须使用Meta,而不是Dto
  Future<BaseException?> actInsertMeta(RecordMeta meta) async =>
      await actWrapper(() => setInitialized("新增Meta [$meta]", () async {
            await _metaDtoRepo!.insertEntity(meta);
          }));

  /// 必须时Meta已存在, 否则请使用[actInsertMeta]创建后再更新
  Future<BaseException?> actUpdateMeta(RecordMetaDto? dto) async =>
      await actWrapper(() => setInitialized("保存元素 [$dto]", () async {
            if (dto == null) return null;
            await _metaDtoRepo!.update(dto);
          }));

  Future<RecordMetaDto?> actQueryMeta(String metaId) =>
      _metaDtoRepo!.findById(metaId);

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
    return actUpdateMeta(metaDto);
  }

  Future<List<RecordMetaDto>> actQueryMetaByName(String metaName) async =>
      _metaDtoRepo!.findAllBy(metaName).toList();

  void actRemoveMeta(String metaId) =>
      actWrapper(() => setInitialized("删除Meta [$metaId]", () async {
            // 取消meta的监听
            actSelectOpenMeta(null);
            // 从数据库中删除 Meta记录
            await _metaDtoRepo!.deleteBy(metaId);
            // 从数据库中删除 Meta对应的Record集合
            // fixme 删除Record集合
            // await _recordAccessor(metaId).drop();
          }));

  /// 业务逻辑-Record ============================================================
  /// RecordProvider

  // 选择一个已经打开的meta
  Future<void> actSelectOpenMeta(OpenedMeta? meta) => actWrapper(
        () => setInitialized(
            meta == null ? "取消监听Meta" : "开始/切换监听Meta[${meta.name}]",
            () => selectedMeta = meta),
      );

  Record actQueryRecordBy(
    String recordId, {
    String? metaId,
    bool queryGlobal = false, // true表示查询所有类型的MetaId下的记录,只要recordId相符即可
  }) =>
      openedWorkspace!.queryRecordBy(
        recordId,
        metaId: queryGlobal ? null : metaId ?? (selectedMeta)?.id,
      );

  Future<void> actSaveRecord(RecordDto? dto) => actWrapper(() async {
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

  /// 获取已缓存的数据源
  IRecordDataGridSource actGetDataSource([String? metaId]) =>
      _getByMetaId(metaId ?? selectedMeta!.id);

  IRecordDataGridSource _getByMetaId(String metaId) =>
      openedMetas.firstWhere((element) => element.id == metaId).dataSource;

  List<Record> getCachedRecordsByMeta(String metaId) =>
      openedMetas.firstWhere((element) => element.id == metaId).records;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/workspace/application/provider/opened_workspace.dart';
import 'package:mind_base/src/workspace/application/provider/workspace_provider.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/workspace/domain/entity/entity.dart';
import 'package:mind_base/src/core/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/attribute_edit_dialog.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/record_edit_dialog.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

import 'data_table_source.dart';

/// 适配Pluto表格
class RecordDataGrid extends StatelessWidget {
  final OpenedMeta openedMeta;
  final WorkspaceProvider pWorkspace;

  const RecordDataGrid(
      {Key? key, required this.openedMeta, required this.pWorkspace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = openedMeta.dataSource;
    return Expanded(
      child: PlutoGrid(
        // key不一致的时候才会刷新UI
        key: ValueKey(openedMeta.ver),
        rows: data.cachedRows,
        columns: data.cachedColumns,
        onLoaded: (loadedEvt) {
          // 为数据源绑定新的stateManager, 以便在数据源更新的时候,能够同时刷新UI
          data.stateManager = loadedEvt.stateManager;
          loadedEvt.stateManager.eventManager!
              .listener((PlutoGridEvent plutoEvent) {
            switch (plutoEvent.runtimeType) {
              case PlutoGridInsertColumnEvent:
                // final evt =
                //     plutoEvent as PlutoGridInsertColumnEvent;
                // final columnIdx = evt.index;
                final origin = openedMeta.meta;
                showAttributeEditDialog(
                  context: context,
                  initKey: origin.nextKey(),
                  kAttrBuilder: GlobalKey<FormBuilderState>(),
                  queryMetaFn: pWorkspace.openedWorkspace!.queryMeta,
                  allMetas: () => pWorkspace.metaList,
                ).then((value) {
                  return pWorkspace.actMetaUpdateAttr(origin, value);
                });
                break;
              default:
                break;
            }
          });
        },
        onChanged: (_) {
          print("#debug #onChanged $_");
          final row = _.row!;
          final ettId = row.key as ValueKey<String>;

          // 更新的DTO
          final dto = openedMeta.records
              .firstWhere((element) => element.id == ettId.value)
              .toDto()
              .updateBy(row);
          pWorkspace.actSaveRecord(dto);
          // widget.onSaveRecord(dto); // 同步到服务器
        },
        onSelected: (_) {
          print("#debug #onSelected $_");
        },
        onRowChecked: (_) {
          print("#debug #onRowChecked $_");
        },
        // 开启双击会导致单击事件延迟, 在视觉上造成卡顿的效果
        // onRowDoubleTap: (_) {
        //   print("#debug #onRowDoubleTap $_");
        // },
        onRowSecondaryTap: (_) {
          print("#debug #onRowSecondaryTap $_");
        },
        onRowsMoved: (_) {
          print("#debug #onRowsMoved $_");
        },
        createHeader: (manager) => Consumer<OpenedWorkspace>(
          builder: (c, p, _) => DataFrameTitlePluto(
            meta: openedMeta.meta,
            stateManager: manager,
            // onSaveMeta: widget.onSaveMeta,
            onSaveMeta: (dto) => pWorkspace.actUpdateMeta(
              pWorkspace.selectedMeta!.meta,
              dto,
            ),
            // onSaveRecord: widget.onSaveRecord,
            onSaveRecord: pWorkspace.actSaveRecord,
            openedWorkspace: p,
            queryMetaFn: p.queryMeta,
            allMetas: p.allMetas,
          ),
        ),
        // createFooter: (_) {             },
        // rowColorCallback: (_) {},
        configuration: const PlutoGridConfiguration(
          // columnHeight: 30.0,
          // columnFilterHeight: 30.0,
          // rowHeight: 30.0,
          // defaultCellPadding: 15,
          // defaultColumnTitlePadding: 15,
          // iconSize: 15,
          enableColumnBorder: true,
          // enableGridBorderShadow: true,
          enableMoveHorizontalInEditing: true,
          // enableRowColorAnimation: false,
          // checkedColor: const Color(0x876FB0FF),
          /// 以下两项配置列移动,
          enableMoveDownAfterSelecting: true,
          enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveDown,
          gridBorderRadius: BorderRadius.all(Radius.circular(10)),
          gridPopupBorderRadius: BorderRadius.all(Radius.circular(7)),
          scrollbarConfig: PlutoGridScrollbarConfig(
            isAlwaysShown: false,
            scrollbarThickness: 8,
            scrollbarThicknessWhileDragging: 10,
          ),
          localeText: PlutoGridLocaleText.china(),
          //   columnFilterConfig: PlutoGridColumnFilterConfig(
          //     filters: const [
          //       ...FilterHelper.defaultFilters,
          //       // ClassYouImplemented(),
          //     ],
          //     resolveDefaultColumnFilter: (column, resolver) {
          //       if (column.field == 'column3') {
          //         return resolver<PlutoFilterTypeGreaterThan>()
          //             as PlutoFilterType;
          //       }
          //
          //       return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
          //     },
          //   ),
        ),
        mode: PlutoGridMode.normal, // 可以通过manager动态切换,以实现对不同类型列的处理
      ),
    );
  }
}

///
/// 表格标题栏
class DataFrameTitlePluto extends StatelessWidget {
  final RecordMeta meta;
  final OpenedWorkspace openedWorkspace;
  final PlutoGridStateManager stateManager;
  final Future<void> Function(RecordDto? dto) onSaveRecord;
  final Future<void> Function(RecordMetaDto? dto) onSaveMeta;
  final _kRecordBuilder = GlobalKey<FormBuilderState>();
  final kMetaBuilder = GlobalKey<FormBuilderState>();
  final kAttrBuilder = GlobalKey<FormBuilderState>();
  final kMethodBuilder = GlobalKey<FormBuilderState>();
  final QueryMetaFn queryMetaFn;
  final Iterable<RecordMeta> Function() allMetas;

  DataFrameTitlePluto({
    Key? key,
    required this.meta,
    required this.openedWorkspace,
    required this.stateManager,
    required this.onSaveMeta,
    required this.onSaveRecord,
    required this.queryMetaFn,
    required this.allMetas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<WorkspaceProvider>(
        builder: (c, pWorkspace, _) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              TextButton.icon(
                onPressed: () async => await onSaveRecord(
                  await showRecordEditDialog(
                    context: context,
                    meta: meta,
                    openedWorkspace: openedWorkspace,
                    kRecordBuilder: _kRecordBuilder,
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text("新增一行"),
              ),
              TextButton.icon(
                onPressed: () {
                  final checked = stateManager.checkedRows;
                  if (checked.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("您尚未选中记录"),
                    ));
                  } else {
                    showConfirmDialog(
                      context: context,
                      title: "确认删除选中的 ${checked.length} 条记录吗",
                      onConfirm: () async {
                        final recordIds = checked
                            .map((e) => (e.key as ValueKey<String>).value);
                        for (final recordId in recordIds) {
                          await pWorkspace.actRemoveRecord(meta, recordId);
                        }
                      },
                    );
                  }
                },
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text("删除选中"),
              ),
              TextButton.icon(
                onPressed: () async => await onSaveMeta(
                  await showRecordMetaEditDialog(
                    context: context,
                    originMeta: meta.toDto(),
                    kMetaBuilder: kMetaBuilder,
                    kAttrBuilder: kAttrBuilder,
                    kMethodBuilder: kMethodBuilder,
                    queryMetaFn: queryMetaFn,
                    allMetas: allMetas,
                  ),
                ),
                icon: const Icon(Icons.edit),
                label: const Text("修改结构"),
              ),
            ],
          ),
        ),
      );
}

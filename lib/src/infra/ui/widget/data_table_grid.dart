import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/entity/entity.dart';
import 'package:mind_base/src/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/record_edit_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/interface/i_dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show String;
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

import 'data_table_source.dart';

/// 适配Pluto表格
class RecordDataGrid extends StatefulWidget {
  const RecordDataGrid({
    Key? key,
    required this.dataGridSource,
    required this.onSaveRecord,
    required this.onSaveMeta,
  }) : super(key: key);

  final RecordDataGridSourcePluto dataGridSource;

  final Future<void> Function(RecordDto? dto) onSaveRecord;
  final Future<void> Function(RecordMetaDto? dto) onSaveMeta;

  @override
  _RecordDataGridState createState() => _RecordDataGridState();
}

class _RecordDataGridState extends State<RecordDataGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // todo 监听并调整行列样式
    // isLandscapeInMobileView = !isWebOrDesktop &&
    //     MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) => Consumer<WorkspaceProvider>(
        builder: (c, pWorkspace, _) {
          final meta = pWorkspace.watchedMeta!;
          final data =
              pWorkspace.actGetDataSource() as RecordDataGridSourcePluto;
          return Expanded(
            child: PlutoGrid(
              rows: data.cachedRows,
              columns: data.cachedColumns,
              onLoaded: (_) {
                // 为数据源绑定新的stateManager, 以便在数据源更新的时候,能够同时刷新UI
                data.stateManager = _.stateManager;
              },
              onChanged: (_) {
                print("#debug #onChanged $_");
                final row = _.row!;
                final ettId = row.key as ValueKey<String>;

                // 更新的DTO
                final dto = pWorkspace
                    .actQueryRecordBy(ettId.value, meta: meta)
                    .toDto()
                    .updateBy(meta, row);
                pWorkspace.actSaveRecord(dto); // 同步到服务器
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
              createHeader: (manager) => DataFrameTitlePluto(
                meta: meta,
                stateManager: manager,
                onSaveMeta: pWorkspace.actSaveMeta,
                onSaveRecord: pWorkspace.actSaveRecord,
                queryMetaFn: pWorkspace.workspace.queryMeta,
                allMetas: pWorkspace.workspace.allMetas,
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
                // localeText: const PlutoGridLocaleText.korean(),
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
        },
      );

// @override
// void dispose() {
//   super.dispose();
//   // timer.cancel();
//   // todo 关闭监听
// }
}

///
/// 表格标题栏
class DataFrameTitlePluto extends StatelessWidget {
  final RecordMeta meta;
  final PlutoGridStateManager stateManager;
  final Future<void> Function(RecordDto? dto) onSaveRecord;
  final Future<void> Function(RecordMetaDto? dto) onSaveMeta;
  final _kRecordBuilder = GlobalKey<FormBuilderState>();
  final kMetaBuilder = GlobalKey<FormBuilderState>();
  final kAttrBuilder = GlobalKey<FormBuilderState>();
  final kMethodBuilder = GlobalKey<FormBuilderState>();
  final QueryMetaFn? queryMetaFn;
  final Iterable<RecordMeta> Function() allMetas;

  DataFrameTitlePluto({
    Key? key,
    required this.meta,
    required this.stateManager,
    required this.onSaveMeta,
    required this.onSaveRecord,
    required this.queryMetaFn,
    required this.allMetas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
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
          TextButton.icon(
            onPressed: () async => await onSaveRecord(
              await showRecordEditDialog(
                context: context,
                meta: meta,
                kRecordBuilder: _kRecordBuilder,
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text("新增记录"),
          ),
          Consumer<WorkspaceProvider>(
              builder: (c, pWorkspace, _) => TextButton.icon(
                    onPressed: () => showConfirmDialog(
                        context: context,
                        title: "确认删除[${meta.name}]表吗",
                        onConfirm: () => pWorkspace.actRemoveMeta(meta.id)),
                    icon: const Icon(Icons.delete),
                    label: const Text("删除表"),
                  )),
        ],
      );
}

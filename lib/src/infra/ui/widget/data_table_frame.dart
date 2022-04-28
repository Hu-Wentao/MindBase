import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/record_edit_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'data_table_source.dart';

class RecordDataGrid extends StatefulWidget {
  factory RecordDataGrid.build({
    Key? key,
    dataGridSourceWithCtrl,
    onSaveRecord,
    onSaveMeta,
  }) =>
      RecordDataGrid(
        key: key,
        dataGridSource: dataGridSourceWithCtrl.value1,
        dataGridController: dataGridSourceWithCtrl.value2,
        onSaveRecord: onSaveRecord,
        onSaveMeta: onSaveMeta,
      );

  const RecordDataGrid({
    Key? key,
    required this.dataGridSource,
    required this.dataGridController,
    required this.onSaveRecord,
    required this.onSaveMeta,
  }) : super(key: key);

  final RecordDataGridSource dataGridSource;
  final DataGridController dataGridController;

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
        builder: (c, pMeta, _) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题栏按钮
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: DataFrameTitle(
                  onSaveMeta: widget.onSaveMeta,
                  onSaveRecord: widget.onSaveRecord,
                  meta: widget.dataGridSource.meta,
                ),
              ),
              Expanded(
                child: SfDataGrid(
                  source: widget.dataGridSource,
                  // 展示最左侧CheckBox列
                  // showCheckboxColumn: true,
                  // checkboxColumnSettings: const DataGridCheckboxColumnSettings(
                  //   showCheckboxOnHeader: true,
                  // ),
                  // 展示排序数
                  // showSortNumbers: true, //
                  // 填充宽度
                  columnWidthMode: ColumnWidthMode.fill,
                  // todo 使用 Column Resizing 以便调整列宽
                  columns: widget.dataGridSource.buildColumn(context, pMeta),
                  // 允许编辑单元格数据
                  allowEditing: true,
                  // 双击编辑
                  editingGestureType: EditingGestureType.doubleTap,
                  // 单击选中,再点取消
                  selectionMode: SelectionMode.singleDeselect,
                  // 选中单元格(以便编辑选中cell的值)
                  navigationMode: GridNavigationMode.cell,
                  // 选中单元格 需要配合[DataGridController]
                  // selectionManager: SelectionManagerBase(),
                  controller: widget.dataGridController,
                  // stackedHeaderRows: [StackedHeaderRow(cells: [StackedHeaderCell(columnNames: ['a0','a1'], child: Text("T形合并Header"))])],
                  // 冻结前n列
                  // frozenColumnsCount:1,
                  // todo #126
                  // onCellLongPress: (DataGridCellLongPressDetails details) {
                  //   if (!isDesktop) {
                  //     final RenderBox renderObject =
                  //     context.findRenderObject()! as RenderBox;
                  //     showMenu(
                  //         context: context,
                  //         position: RelativeRect.fromRect(
                  //             details.globalPosition & Size.zero,
                  //             Offset.zero & renderObject.size),
                  //         items: buildMenuItems(details.column));
                  //   }
                  // },
                  // onCellSecondaryTap: (DataGridCellTapDetails details) {
                  //   // if (isDesktop) {
                  //   final RenderBox renderObject =
                  //       context.findRenderObject()! as RenderBox;
                  //   final Offset localPosition =
                  //       renderObject.globalToLocal(details.globalPosition);
                  //   showMenu(
                  //       context: context,
                  //       position: RelativeRect.fromSize(
                  //           localPosition & Size.zero, renderObject.size),
                  //       items: buildMenuItems(details.column));
                  //   // }
                  // },
                  // 展示单元格/Header网格
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
    // timer.cancel();
    // todo 关闭监听
  }
}

///
/// 表格标题栏
class DataFrameTitle extends StatelessWidget {
  final RecordMeta meta;
  final Future<void> Function(RecordDto? dto) onSaveRecord;
  final Future<void> Function(RecordMetaDto? dto) onSaveMeta;
  final _kRecordBuilder = GlobalKey<FormBuilderState>();
  final kMetaBuilder = GlobalKey<FormBuilderState>();
  final kAttrBuilder = GlobalKey<FormBuilderState>();
  final kMethodBuilder = GlobalKey<FormBuilderState>();

  DataFrameTitle({
    Key? key,
    required this.meta,
    required this.onSaveMeta,
    required this.onSaveRecord,
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

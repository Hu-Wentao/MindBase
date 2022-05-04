import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/record_edit_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/interface/dto.dart';
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
        builder: (c, pMeta, _) => Expanded(
          child: PlutoGrid.of(
            stateManager: widget.dataGridSource.manager,
          ),
        ),
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

  DataFrameTitlePluto({
    Key? key,
    required this.meta,
    required this.stateManager,
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

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_grid.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_source.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _kMetaBuilder = GlobalKey<FormBuilderState>();
  final _kAttrBuilder = GlobalKey<FormBuilderState>();
  final _kMethodBuilder = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Consumer<WorkspaceProvider>(
          builder: (c, pWorkspace, _) => Row(
                children: [
                  /// Meta List
                  Container(
                    width: 200,
                    child: ListView.builder(
                      itemCount: pWorkspace.metaList.length,
                      itemBuilder: (c, i) => ListTile(
                        title: Text(pWorkspace.metaList[i].name),
                        onTap: () =>
                            pWorkspace.actWatchMeta(pWorkspace.metaList[i]),
                      ),
                    ),
                  ),

                  /// table
                  if (pWorkspace.watchedMeta == null)
                    const Expanded(
                      child: Center(child: Text("请选择/创建 一个Meta")),
                    ),
                  if (pWorkspace.watchedMeta != null)
                    RecordDataGrid(
                      key: ValueKey(pWorkspace.watchedMeta),
                      dataGridSource: pWorkspace.actGetDataSource()
                          as RecordDataGridSourcePluto,
                      onSaveRecord: pWorkspace.actSaveRecord,
                      onSaveMeta: pWorkspace.actSaveMeta,
                    ),
                ],
              )),
      floatingActionButton: Consumer<WorkspaceProvider>(
        builder: (c, t, _) => FloatingActionButton(
          child: const Icon(Icons.add),
          // onPressed: () {
          //   // _kDebugGlobalKey.currentState?.build(context);
          //
          //   //   _kDebugGlobalKey.currentState?.setState(() {
          //   //   print("_kDebugGlobalKey.currentState :: setState");
          //   // });
          // }
          onPressed: () async => await t.actSaveMeta(
            await showRecordMetaEditDialog(
              context: c,
              kAttrBuilder: _kAttrBuilder,
              kMetaBuilder: _kMetaBuilder,
              kMethodBuilder: _kMethodBuilder,
            ),
          ),
        ),
      ));
}

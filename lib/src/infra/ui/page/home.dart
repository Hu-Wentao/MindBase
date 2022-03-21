import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/application/provider/record_provider.dart';
import 'package:mind_base/src/application/provider/meta_provider.dart';
import 'package:mind_base/src/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_frame.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _kMetaBuilder = GlobalKey<FormBuilderState>();
  final _kAttrBuilder = GlobalKey<FormBuilderState>();
  final _kDebugGlobalKey = GlobalKey<State>(debugLabel: "全局debug Key");

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Consumer<MetaProvider>(
        builder: (c, pMeta, _) => Consumer<RecordProvider>(
            builder: (c, pRecord, _) => Row(
                  children: [
                    /// Meta List
                    Container(
                      width: 200,
                      child: ListView.builder(
                        itemCount: pMeta.data.length,
                        itemBuilder: (c, i) => ListTile(
                          title: Text(pMeta.data[i].name),
                          onTap: () => pRecord.actWatchMeta(pMeta.data[i]),
                        ),
                      ),
                    ),

                    /// table
                    if (pRecord.selectedMetaId == null)
                      const Expanded(
                        child: Center(child: Text("请选择/创建 一个Meta")),
                      ),
                    if (pRecord.selectedMetaId != null)
                      RecordDataGrid(
                        key: ValueKey(pRecord.getSelectedMeta(pMeta.getMeta)),
                        dataGridSource: pRecord.actGetDataSource(pMeta.getMeta),
                        onSaveRecord: pRecord.actSaveRecord,
                        onSaveMeta: pRecord.actSaveMeta,
                      ),
                  ],
                )),
      ),
      floatingActionButton: Consumer<MetaProvider>(
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
            ),
          ),
        ),
      ));
}

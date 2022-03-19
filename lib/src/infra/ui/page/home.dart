import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/application/provider/record_provider.dart';
import 'package:mind_base/src/application/provider/meta_provider.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/infra/ui/form/meta_form.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_frame.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

import '../dialog/record_meta_edit_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _kMetaBuilder = GlobalKey<FormBuilderState>();
  final _kAttrBuilder = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Consumer<RecordProvider>(
          builder: (c, pRecord, _) => Row(
                children: [
                  /// 展示 schema List
                  Consumer<MetaProvider>(
                    builder: (c, t, _) => Container(
                      width: 200,
                      child: ListView.builder(
                        itemCount: t.data.length,
                        itemBuilder: (c, i) => ListTile(
                          title: Text(t.data[i].name),
                          onTap: () => pRecord.actWatchMeta(t.data[i]),
                        ),
                      ),
                    ),
                  ),

                  /// table
                  if (pRecord.selectedMeta == null)
                    const Expanded(
                      child: Center(child: Text("请选择/创建 一个Meta")),
                    ),
                  if (pRecord.selectedMeta != null)
                    RecordDataGrid(
                      dataGridSource: pRecord.actGetDataSource(),
                      onSaveRecord: pRecord.actSaveRecord,
                    ),
                ],
              )),
      floatingActionButton: Consumer<MetaProvider>(
        builder: (c, t, _) => FloatingActionButton(
          child: const Icon(Icons.add),
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

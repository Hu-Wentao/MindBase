import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/application/provider/record_provider.dart';
import 'package:mind_base/src/application/provider/meta_provider.dart';
import 'package:mind_base/src/infra/ui/form/meta_form.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_frame.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

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
          onPressed: () async => await t.actSaveMeta(await _onEditMeta(c)),
        ),
      ));

  Future<RecordMetaDto?> _onEditMeta(BuildContext c) async =>
      await NAlertDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: const Text("添加新的表"),
        content: MetaForm(
          kMetaBuilder: _kMetaBuilder,
          kAttrBuilder: _kAttrBuilder,
        ),
        actions: <Widget>[
          TextButton(
              child: const Text("确认"),
              onPressed: () {
                final checkAttr =
                    _kAttrBuilder.currentState?.saveAndValidate() ?? false;
                _kAttrBuilder.currentState?.save();
                final checkMeta =
                    _kMetaBuilder.currentState?.saveAndValidate() ?? false;
                if (checkAttr && checkMeta) {
                  final schemaMap = _kMetaBuilder.currentState!.value;
                  final attrMap = _kAttrBuilder.currentState!.value;
                  // <key,<field,value>>
                  final attrFormatMap = <int, Map<String, String>>{};
                  for (final e in attrMap.entries) {
                    final k = e.key.split("@");
                    final ik = int.parse(k[0]);
                    final fk = k[1];
                    final v = e.value;
                    attrFormatMap[ik] ??= {};
                    attrFormatMap[ik]![fk] = v;
                  }
                  final attrs = attrFormatMap.entries.map((e) {
                    final json = e.value;
                    return AttributeDto.fromFrom(json);
                  }).toList();
                  final dto = RecordMetaDto.fromForm(schemaMap, attrs);
                  Navigator.pop<RecordMetaDto>(c, dto);
                } else {
                  ScaffoldMessenger.of(c).showSnackBar(
                    const SnackBar(content: Text("请检查表单")),
                  );
                }
              }),
          TextButton(
              child: const Text("取消"), onPressed: () => Navigator.pop(c)),
        ],
      ).show(context);
}

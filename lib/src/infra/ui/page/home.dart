import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/application/provider/record_provider.dart';
import 'package:mind_base/src/application/provider/schema_provider.dart';
import 'package:mind_base/src/infra/ui/form/schema_form.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_frame.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:responsive_table/responsive_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _kSchemaBuilder = GlobalKey<FormBuilderState>();
  final _kAttrBuilder = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Consumer<RecordProvider>(
          builder: (c, pRecord, _) => Row(
                children: [
                  /// 展示 schema List
                  Consumer<SchemaProvider>(
                    builder: (c, t, _) => Container(
                      width: 200,
                      child: ListView.builder(
                        itemCount: t.data.length,
                        itemBuilder: (c, i) => ListTile(
                          title: Text(t.data[i].name),
                          onTap: () => pRecord.actWatchSchema(t.data[i]),
                        ),
                      ),
                    ),
                  ),

                  /// table
                  if (pRecord.selectedSchema == null)
                    const Expanded(
                      child: Center(child: Text("请选择/创建 一个Schema")),
                    ),
                  if (pRecord.selectedSchema != null)
                    Expanded(
                      child: DataTableFrame(
                        schema: pRecord.selectedSchema!,
                        onSaveRecord: pRecord.actSaveRecord,
                        headers: pRecord.selectedSchema!.attributes
                            .map((attr) => DatatableHeader(
                                  text: attr.name,
                                  value: "${attr.k}",
                                ))
                            .toList()
                          ..insert(0, DatatableHeader(text: 'ID', value: "id")),
                        data: pRecord.data.map((e) => e.toTableMap()).toList(),
                      ),
                    ),
                ],
              )),
      floatingActionButton: Consumer<SchemaProvider>(
        builder: (c, t, _) => FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async => await t.actSaveSchema(await _onEditSchema(c)),
        ),
      ));

  Future<RecordMetaDto?> _onEditSchema(BuildContext c) async =>
      await NAlertDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: const Text("添加新的表"),
        content: SchemaForm(
          kSchemaBuilder: _kSchemaBuilder,
          kAttrBuilder: _kAttrBuilder,
        ),
        actions: <Widget>[
          TextButton(
              child: const Text("确认"),
              onPressed: () {
                final checkAttr =
                    _kAttrBuilder.currentState?.saveAndValidate() ?? false;
                _kAttrBuilder.currentState?.save();
                final checkSchema =
                    _kSchemaBuilder.currentState?.saveAndValidate() ?? false;
                if (checkAttr && checkSchema) {
                  final schemaMap = _kSchemaBuilder.currentState!.value;
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

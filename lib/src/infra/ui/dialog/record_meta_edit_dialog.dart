import 'package:flutter/material.dart';
import 'package:mind_base/src/infra/ui/form/meta_form.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:ndialog/ndialog.dart';

Future<RecordMetaDto?> showRecordMetaEditDialog({
  required BuildContext context,
  required kMetaBuilder,
  required kAttrBuilder,
}) async =>
    await NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: const Text("添加新的表"),
      content: MetaForm.create(
        kMetaBuilder: kMetaBuilder,
        kAttrBuilder: kAttrBuilder,
      ),
      actions: <Widget>[
        TextButton(
            child: const Text("确认"),
            onPressed: () {
              final checkAttr =
                  kAttrBuilder.currentState?.saveAndValidate() ?? false;
              kAttrBuilder.currentState?.save();
              final checkMeta =
                  kMetaBuilder.currentState?.saveAndValidate() ?? false;
              if (checkAttr && checkMeta) {
                final metaMap = kMetaBuilder.currentState!.value;
                final attrMap = kAttrBuilder.currentState!.value;
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
                final dto = RecordMetaDto.fromForm(metaMap, attrs);
                Navigator.pop<RecordMetaDto>(context, dto);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("请检查表单")),
                );
              }
            }),
        TextButton(
            child: const Text("取消"), onPressed: () => Navigator.pop(context)),
      ],
    ).show(context);

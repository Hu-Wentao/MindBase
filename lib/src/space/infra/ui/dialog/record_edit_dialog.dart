import 'package:flutter/material.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/space/infra/ui/form/record_form.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';
import 'package:ndialog/ndialog.dart';

Future<RecordDto?> showRecordEditDialog({
  required BuildContext context,
  required MetaModel meta,
  required SpaceModel space,
  required kRecordBuilder,
  RecordDto? origin,
}) =>
    NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: origin == null ? const Text("插入新的记录") : const Text("编辑记录"),
      content: RecordForm(
        meta: meta,
        space: space,
        origin: origin,
        kRecordBuilder: kRecordBuilder,
      ),
      actions: <Widget>[
        TextButton(
            child: const Text("确认"),
            onPressed: () {
              final checkAttr =
                  kRecordBuilder.currentState?.saveAndValidate() ?? false;
              if (checkAttr) {
                final map = kRecordBuilder.currentState!.value;
                final dto = RecordDto.fromForm(meta, map);
                Navigator.pop<RecordDto>(context, dto);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("请检查表单")),
                );
              }
            }),
        TextButton(
          child: const Text("取消"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ).show(context);

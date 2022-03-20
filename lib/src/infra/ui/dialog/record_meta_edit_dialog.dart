import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/config/common_config.dart';
import 'package:mind_base/src/infra/ui/form/meta_form.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:ndialog/ndialog.dart';

Future<RecordMetaDto?> showRecordMetaEditDialog({
  required BuildContext context,
  required GlobalKey<FormBuilderState> kMetaBuilder,
  required GlobalKey<FormBuilderState> kAttrBuilder,
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
              if (MetaForm.checkBy(kMetaBuilder, kAttrBuilder)) {
                final dto = MetaForm.fetchDtoBy(
                  kMetaBuilder: kMetaBuilder,
                  kAttrBuilder: kAttrBuilder,
                );
                slLogger.info("debug meta dto: $dto");
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

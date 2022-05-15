import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/domain/entity/entity.dart';
import 'package:mind_base/src/infra/ui/form/meta_form.dart';
import 'package:mind_base/src/interface/i_dto.dart';
import 'package:ndialog/ndialog.dart';

Future<RecordMetaDto?> showRecordMetaEditDialog({
  required BuildContext context,
  RecordMetaDto? originMeta,
  required GlobalKey<FormBuilderState> kMetaBuilder,
  required GlobalKey<FormBuilderState> kAttrBuilder,
  required GlobalKey<FormBuilderState> kMethodBuilder,
  required QueryMetaFn? queryMetaFn,
}) async =>
    await NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: false),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(originMeta == null ? "创建新的表" : "编辑表结构"),
      ),
      content: MetaForm(
        isCreate: originMeta == null,
        kMetaBuilder: kMetaBuilder,
        kAttrBuilder: kAttrBuilder,
        kMethodBuilder: kMethodBuilder,
        origin: originMeta ?? RecordMetaDto.builder(),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text("确认"),
            onPressed: () {
              if (MetaForm.checkBy(
                kMetaBuilder,
                kAttrBuilder,
                kMethodBuilder,
              )) {
                final dto = MetaForm.fetchDtoBy(
                  kMetaBuilder: kMetaBuilder,
                  kAttrBuilder: kAttrBuilder,
                  kMethodBuilder: kMethodBuilder,
                  queryMetaFn: queryMetaFn,
                );
                Navigator.pop<RecordMetaDto>(context, dto);
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

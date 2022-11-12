import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/space/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';
import 'package:ndialog/ndialog.dart';

import '../form/attribute_form.dart';

/// 编辑某个Meta的属性
Future<AttributeDto?> showAttributeEditDialog({
  required BuildContext context,
  AttributeDto? originAttr,
  required int initKey,
  required GlobalKey<FormBuilderState> kAttrBuilder,
  required QueryMetaFn queryMetaFn,
  required Iterable<MetaModel> Function() allMetas,
}) async =>
    await NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: false),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(originAttr == null ? "创建新的属性" : "编辑属性"),
      ),
      content: AttributeForm(
        // isCreate: originMeta == null,
        allMetas: allMetas,
        // queryMetaFn: queryMetaFn,
        kAttrBuilder: kAttrBuilder,
        origin: originAttr ?? AttributeDto.builder(k: initKey),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text("确认"),
            onPressed: () {
              if (AttributeForm.checkBy(kAttrBuilder)) {
                final dto = AttributeForm.fetchBy(
                  kAttrBuilder: kAttrBuilder,
                  // 新建Meta时不需要检查...
                  // kMethodBuilder: originAttr == null ? null : kMethodBuilder,
                  // queryMetaFn: queryMetaFn,
                );
                Navigator.pop<AttributeDto>(context, dto);
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

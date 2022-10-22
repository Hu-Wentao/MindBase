import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/space/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/infra/ui/form/meta_form.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';
import 'package:ndialog/ndialog.dart';

Future<MetaDto?> showMetaModelEditDialog({
  required BuildContext context,
  MetaDto? originMeta,
  required GlobalKey<FormBuilderState> kMetaBuilder,
  required GlobalKey<FormBuilderState> kAttrBuilder,
  required GlobalKey<FormBuilderState> kMethodBuilder,
  required QueryMetaFn queryMetaFn,
  required Iterable<MetaModel> Function() allMetas,
}) async =>
    await NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: false),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(originMeta == null ? "创建新的表" : "编辑表结构"),
      ),
      content: MetaForm(
        isCreate: originMeta == null,
        allMetas: allMetas,
        queryMetaFn: queryMetaFn,
        kMetaBuilder: kMetaBuilder,
        kAttrBuilder: kAttrBuilder,
        kMethodBuilder: kMethodBuilder,
        origin: originMeta ?? MetaDto.builder(),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text("确认"),
            onPressed: () {
              if (MetaForm.checkBy(
                kMetaBuilder,
                kAttrBuilder,
                originMeta == null
                    ? null
                    : kMethodBuilder, // 新建Meta时不需要检查方法,否则会导致新建失败(method check始终为false)
              )) {
                final dto = MetaForm.fetchDtoBy(
                  kMetaBuilder: kMetaBuilder,
                  kAttrBuilder: kAttrBuilder,
                  // 新建Meta时不需要检查...
                  kMethodBuilder: originMeta == null ? null : kMethodBuilder,
                  queryMetaFn: queryMetaFn,
                );
                // 仅用于修复 #490, 后续需要根据 表单视图 适配;
                MetaDto? r;
                if (originMeta != null && dto != null) {
                  r = originMeta
                    ..name = dto.name
                    ..memo = dto.memo
                    ..maxKey = dto.maxKey
                    ..attrs = dto.attrs
                    // ..views = dto.views; // 不更新view
                    ..methods = dto.methods;
                } else {
                  r = dto;
                }
                Navigator.pop<MetaDto>(context, r);
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

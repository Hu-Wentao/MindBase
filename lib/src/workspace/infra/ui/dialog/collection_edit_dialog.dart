import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';
import 'package:ndialog/ndialog.dart';

Future<CollectionDto?> showCollectionEditDialog(
  BuildContext context,
  CollectionDto data, {
  GlobalKey<FormBuilderState>? kAttrBuilder,
}) async {
  final kCollectionsBuilder = GlobalKey<FormBuilderState>();
  return await NAlertDialog(
    dialogStyle: DialogStyle(titleDivider: false),
    title: const Padding(padding: EdgeInsets.all(8.0), child: Text("编辑权限")),
    content: CollectionForm(data: data,kCollectionsBuilder:kCollectionsBuilder),
    actions: <Widget>[
      TextButton(
          child: const Text("确认"),
          onPressed: () {
            if (CollectionForm.checkBy(kCollectionsBuilder)) {
              final dto = CollectionForm.fetchBy(kCollectionsBuilder);
              Navigator.pop<CollectionDto>(context, dto);
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
}

///
/// 权限管理表单
class CollectionForm extends StatelessWidget {
  final CollectionDto data;
  final GlobalKey<FormBuilderState>  kCollectionsBuilder;

  const CollectionForm({Key? key, required this.data, required this.kCollectionsBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) => FormBuilder(
        key: kCollectionsBuilder,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            FormBuilderTextField(
              name: "reads",
              decoration: const InputDecoration(labelText: "读取权限"),
              initialValue: data.reads.join(','),
              validator: FormBuilderValidators.required(context),
            ),
            FormBuilderTextField(
              name: 'writes',
              decoration: const InputDecoration(labelText: "写入权限"),
              initialValue: data.writes.join(','),
              validator: FormBuilderValidators.required(context),
            ),
            FormBuilderCheckbox(
              name: "enabled",
              decoration: const InputDecoration(labelText: "启用"),
              initialValue: data.enabled,
              title: const Text("是否启用"),
              validator: FormBuilderValidators.required(context),
            ),
          ],
        ),
      );

  static bool checkBy(GlobalKey<FormBuilderState> kCollectionsBuilder) =>
      kCollectionsBuilder.currentState?.saveAndValidate() ?? false;

  static CollectionDto fetchBy(
          GlobalKey<FormBuilderState> kCollectionsBuilder) =>
      CollectionDto.fromForm(kCollectionsBuilder.currentState!.value);
}

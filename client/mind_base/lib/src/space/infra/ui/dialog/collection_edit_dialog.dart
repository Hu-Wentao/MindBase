import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';
import 'package:ndialog/ndialog.dart';

Future<CollectionDto?> showCollectionEditDialog(
  BuildContext context,
  CollectionDto data,
  String teamId,
) async {
  final kCollectionsBuilder = ValueNotifier<PermsType>(data.getType(teamId));
  return await NAlertDialog(
    dialogStyle: DialogStyle(titleDivider: false),
    title:
        const Padding(padding: EdgeInsets.all(8.0), child: Text("编辑本空间内表的权限")),
    content: CollectionForm2(
      data: data,
      kCollectionsBuilder: kCollectionsBuilder,
      teamId: teamId,
    ),
    actions: <Widget>[
      TextButton(
          child: const Text("确认"),
          onPressed: () {
            data.updateBy(kCollectionsBuilder.value, teamId);
            Navigator.pop<CollectionDto>(context, data);
          }),
      TextButton(
        child: const Text("取消"),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  ).show(context);
}

///
/// 权限管理表单- 4档权限 [PermsType]
class CollectionForm2 extends StatefulWidget {
  final String teamId;
  final CollectionDto? data;
  final ValueNotifier<PermsType> kCollectionsBuilder;

  const CollectionForm2(
      {Key? key,
      this.data,
      required this.kCollectionsBuilder,
      required this.teamId})
      : super(key: key);

  @override
  State<CollectionForm2> createState() => _CollectionForm2State();

  static bool checkBy(
          @Deprecated('无效') GlobalKey<FormBuilderState> kCollectionsBuilder) =>
      true;

  static CollectionDto fetchBy(CollectionDto origin, String teamId,
      ValueNotifier<PermsType> kCollectionsBuilder) {
    return origin.updateBy(kCollectionsBuilder.value, teamId);
  }
}

class _CollectionForm2State extends State<CollectionForm2> {
  PermsType get type => widget.kCollectionsBuilder.value;

  _onTap(PermsType tp) {
    setState(() {
      widget.kCollectionsBuilder.value = tp;
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            selected: type == PermsType.owner,
            leading: const Icon(Icons.person),
            title: const Text("团队创建人"),
            subtitle: const Text("创建人可读可写, 成员可读"),
            onTap: () => _onTap(PermsType.owner),
          ),
          // 团队成员 可读可写
          ListTile(
            selected: type == PermsType.member,
            leading: const Icon(Icons.people),
            title: const Text("团队成员"),
            subtitle: const Text("成员可读可写"),
            onTap: () => _onTap(PermsType.member),
          ),
          // 团队成员 可读可写, 所有人可读
          ListTile(
            selected: type == PermsType.openRead,
            leading: const Icon(Icons.people_outline_outlined),
            title: const Text("开放读取"),
            subtitle: const Text("成员可读可写, 外部人员可读"),
            onTap: () => _onTap(PermsType.openRead),
          ),
          // 所有人可读可写
          ListTile(
            selected: type == PermsType.openWrite,
            leading: const Icon(Icons.people_outline),
            title: const Text("开放读写"),
            subtitle: const Text("所有人可读可写"),
            onTap: () => _onTap(PermsType.openWrite),
          ),
          const Divider(),
          ListTile(
            isThreeLine: true,
            selected: type == PermsType.unknown,
            title: const Text("原始权限信息"),
            subtitle: Text(
                "写权限: ${widget.data?.writes}\n读权限: ${widget.data?.reads}"),
          ),
        ],
      );
}

///
/// 权限管理表单
class CollectionForm extends StatelessWidget {
  final CollectionDto data;
  final GlobalKey<FormBuilderState> kCollectionsBuilder;

  const CollectionForm(
      {Key? key, required this.data, required this.kCollectionsBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) => FormBuilder(
        key: kCollectionsBuilder,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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

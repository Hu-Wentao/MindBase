import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mind_base/src/workspace/application/provider/opened_workspace.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/workspace/domain/entity/entity.dart';
import 'package:mind_base/src/workspace/domain/value/value.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';
import 'package:pluto_grid/pluto_grid.dart';

/// 创建指定[RecordMeta]对应的Record
class RecordForm extends StatefulWidget {
  final RecordMeta meta; // Record对应的Meta的Id
  final OpenedWorkspace openedWorkspace; // 当前工作区
  final RecordDto? origin;
  final GlobalKey<FormBuilderState>? kRecordBuilder;

  const RecordForm({
    Key? key,
    required this.meta,
    required this.openedWorkspace,
    this.origin,
    this.kRecordBuilder,
  }) : super(key: key);

  @override
  State<RecordForm> createState() => _RecordFormState();
}

class _RecordFormState extends State<RecordForm> {
  late RecordDto _origin;
  late GlobalKey<FormBuilderState> _kRecordBuilder;

  @override
  initState() {
    _origin = widget.origin ?? RecordDto.builder(metaId: widget.meta.id);
    _kRecordBuilder = widget.kRecordBuilder ?? GlobalKey<FormBuilderState>();
    _refFieldCtrl = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FormBuilder(
        key: _kRecordBuilder,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.meta.attrs.map(_buildFormField).toList(),
          ),
        ),
      );

  /// <propId,ValueKey>
  late final Map<String, TextEditingController> _refFieldCtrl;

  Widget _buildFormField(Attribute attr) {
    final initFieldValue = _origin.fields[attr.k];
    switch (attr.type.tp) {
      case AttrTp.ref:
        final ctrl = TextEditingController(text: initFieldValue?.value);
        _refFieldCtrl[attr.propId] = ctrl;
        return FormBuilderTextField(
          name: attr.propId,
          // Attribute::k作为Map的key
          // initialValue: initFieldValue?.value,
          controller: ctrl,
          decoration: InputDecoration(
            // 字段名称与类型名称
            labelText: "${attr.name} (${attr.type.meta!.name})",
            hintText: attr.type.name,
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
          ]),
          onTap: () {
            final refDataSource = widget.openedWorkspace.openedMetas
                .firstWhere((element) => element.id == attr.type.r)
                .dataSource;
            // pop菜单
            PlutoGridPopup(
              context: context,
              columns: refDataSource.cachedColumns,
              rows: refDataSource.cachedRows,
              width: 600,
              mode: PlutoGridMode.select,
              onSelected: (PlutoGridOnSelectedEvent event) {
                // 选中记录的Id
                final selectRefRecordId =
                    (event.row!.key as ValueKey<String>).value;
                _refFieldCtrl[attr.propId]!.text = selectRefRecordId;
              },
            );
          },
        );
      case AttrTp.bool:
      // break;
      case AttrTp.objectId:
      case AttrTp.any:
      case AttrTp.string:
      case AttrTp.num:
        return FormBuilderTextField(
          name: attr.propId, // Attribute::k作为Map的key
          initialValue: initFieldValue?.value,
          decoration: InputDecoration(
            // 字段名称与类型名称
            labelText: "${attr.name} (${attr.type.name})",
            hintText: attr.type.name,
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
          ]),
        );
    }
  }
}

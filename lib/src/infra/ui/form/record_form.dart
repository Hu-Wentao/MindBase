import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/interface/dto.dart';

/// 创建指定[RecordMeta]对应的Record
class RecordForm extends StatefulWidget {
  final RecordMeta meta; // Record对应的Meta的Id
  final RecordDto? origin;
  final GlobalKey<FormBuilderState>? kRecordBuilder;

  const RecordForm({
    Key? key,
    required this.meta,
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FormBuilder(
        key: _kRecordBuilder,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          // height: 800,
          // width: 800,
          // todo 调整高度
          // height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...widget.meta.attrs.map((attr) {
                final field = _origin.fields[attr.k];
                return FormBuilderTextField(
                  name: attr.propId, // Attribute::k作为Map的key
                  initialValue: field?.v,
                  decoration: InputDecoration(
                    labelText: attr.name,
                    hintText: attr.type.name,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                );
              }).toList(),
              ...widget.meta.methods.map((methods) {
                final field = _origin.fields[methods.k];
                return FormBuilderTextField(
                  name: methods.propId, // Attribute::k作为Map的key
                  initialValue: field?.v,
                  decoration: InputDecoration(
                    labelText: methods.name,
                    hintText: methods.expr.toString(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                );
              }).toList()
            ],
          ),
        ),
      );
}

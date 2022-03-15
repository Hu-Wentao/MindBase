import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/interface/dto.dart';

/// 创建指定Schema对应的Record
class RecordForm extends StatefulWidget {
  final RecordMeta schema; // Record对应的Schema的Id
  final RecordDto? origin;
  final GlobalKey<FormBuilderState>? kRecordBuilder;

  const RecordForm({
    Key? key,
    required this.schema,
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
    _origin = widget.origin ?? RecordDto.builder(schemaId: widget.schema.id);
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
              FormBuilderTextField(
                name: 'id',
                initialValue: _origin.id.toHexString(),
                decoration: const InputDecoration(labelText: 'ID'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
              ),
              FormBuilderTextField(
                name: 'metaId',
                initialValue: _origin.metaId.toHexString(),
                decoration: const InputDecoration(labelText: 'SchemaId'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
              ),
              ...widget.schema.attributes.map((attr) {
                final field = _origin.fields[attr.k];
                return FormBuilderTextField(
                  name: attr.k.toString(), // Attribute::k作为Map的key
                  initialValue: field?.v,
                  decoration: InputDecoration(
                    labelText: attr.name,
                    hintText: attr.type.toString(),
                    // hintText: "${field?.v}  ${field?.e}",
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

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';

class MetaForm extends StatelessWidget {
  const MetaForm(
      {Key? key, required this.kMetaBuilder, required this.kAttrBuilder})
      : super(key: key);
  final GlobalKey<FormBuilderState> kMetaBuilder;
  final GlobalKey<FormBuilderState> kAttrBuilder;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MetaMainForm(kMetaBuilder: kMetaBuilder),
          AttributeListForm(kAttrBuilder: kAttrBuilder),
        ],
      );
}

class MetaMainForm extends StatefulWidget {
  final RecordMetaDto? origin;

  final GlobalKey<FormBuilderState>? kMetaBuilder;

  const MetaMainForm({
    Key? key,
    this.origin,
    this.kMetaBuilder,
  }) : super(key: key);

  @override
  State<MetaMainForm> createState() => _MetaMainFormState();
}

class _MetaMainFormState extends State<MetaMainForm> {
  late RecordMetaDto _origin;
  late GlobalKey<FormBuilderState> _kMetaBuilder;

  @override
  initState() {
    _origin = widget.origin ?? RecordMetaDto.builder();
    _kMetaBuilder = widget.kMetaBuilder ?? GlobalKey<FormBuilderState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FormBuilder(
        key: _kMetaBuilder,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          // height: 800,
          // width: 800,
          // todo 调整高度
          // height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              FormBuilderTextField(
                name: 'id',
                initialValue: _origin.id.toHexString(),
                decoration: const InputDecoration(labelText: 'ID'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'name',
                initialValue: _origin.name,
                decoration: const InputDecoration(labelText: '表/类 名称'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'memo',
                initialValue: _origin.memo,
                decoration: const InputDecoration(labelText: '表/类 备注'),
                validator: FormBuilderValidators.compose([
                  // FormBuilderValidators.required(context),
                ]),
              ),
            ],
          ),
        ),
      );
}

class AttributeListForm extends StatefulWidget {
  final int kStartAt; // ::nextKey()
  final List<AttributeDto> origin;

  final GlobalKey<FormBuilderState>? kAttrBuilder;

  const AttributeListForm({
    Key? key,
    this.kStartAt = 0,
    this.origin = const [],
    this.kAttrBuilder,
  }) : super(key: key);

  @override
  State<AttributeListForm> createState() => _AttributeListFormState();
}

class _AttributeListFormState extends State<AttributeListForm> {
  late List<AttributeDto> _origin;
  late GlobalKey<FormBuilderState> _kAttrBuilder;

  @override
  initState() {
    _origin = widget.origin.isNotEmpty
        ? widget.origin
        : [AttributeDto.builder(k: widget.kStartAt)];
    _kAttrBuilder = widget.kAttrBuilder ?? GlobalKey<FormBuilderState>();
    super.initState();
  }

  _addNewAttr() => setState(() =>
      _origin.add(AttributeDto.builder(k: widget.kStartAt + _origin.length)));

  _removeAttr(AttributeDto a) => setState(() => _origin.remove(a));

  @override
  Widget build(BuildContext context) => FormBuilder(
        key: _kAttrBuilder,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ..._origin.map((a) => _buildAttributeForm(context, a)).toList(),
          ElevatedButton(onPressed: _addNewAttr, child: const Text('添加属性')),
        ]),
      );

  /// 特殊处理： 对所有的键添加 ”${a.k}@“开头，以区别不同的Attribute
  Widget _buildAttributeForm(BuildContext context, AttributeDto a) => ListTile(
      leading: SizedBox(
        width: 45, // todo debug
        child: FormBuilderTextField(
          // name: 'k',
          name: '${a.k}@k',
          initialValue: a.k.toString(),
          decoration: const InputDecoration(labelText: 'Key'),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
          ]),
        ),
      ),
      title: SizedBox(
        // todo debug 必须设定高度
        width: 800,
        child: Row(
          children: [
            SizedBox(
              width: 200,
              child: FormBuilderTextField(
                // name: 'name',
                name: '${a.k}@name',
                initialValue: a.name,
                decoration: const InputDecoration(labelText: '属性名称'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
              ),
            ),
            SizedBox(
              width: 200,
              child: FormBuilderDropdown(
                // name: 'type',
                name: '${a.k}@type',
                decoration: const InputDecoration(labelText: '属性类型'),
                initialValue: a.type.name,
                items: AttrType.values
                    .map((e) => DropdownMenuItem<String>(
                          value: e.name,
                          child: Text(e.name),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(
              width: 150,
              child: FormBuilderDropdown(
                // name: 'checkFuncName',
                name: '${a.k}@checkFuncName',
                decoration: const InputDecoration(labelText: '值校验函数'),
                initialValue: a.checkFuncName,
                items: FuncManager.funcList
                    .map((e) => DropdownMenuItem<String>(
                          value: e.name,
                          child: Text(e.name),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(
              width: 150,
              child: FormBuilderTextField(
                // name: 'memo',
                name: '${a.k}@memo',
                initialValue: a.memo,
                decoration: const InputDecoration(labelText: '备注'),
                validator: FormBuilderValidators.compose([
                  // FormBuilderValidators.required(context),
                ]),
              ),
            ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _removeAttr(a),
      ));
}

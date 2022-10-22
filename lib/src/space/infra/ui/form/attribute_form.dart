import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mind_base/src/space/domain/value/value.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';

import '../../../domain/aggregate/aggregate.dart';

/// 编辑单个AttributeDto
class AttributeForm extends StatefulWidget {
  final AttributeDto origin;
  final Iterable<MetaModel> Function() allMetas;
  final GlobalKey<FormBuilderState> kAttrBuilder;

  const AttributeForm({
    Key? key,
    required this.origin,
    required this.allMetas,
    required this.kAttrBuilder,
  }) : super(key: key);

  @override
  State<AttributeForm> createState() => _AttributeFormState();

  static checkBy(GlobalKey<FormBuilderState> kAttrBuilder) {
    final attrState = kAttrBuilder.currentState?.saveAndValidate() ?? false;
    return attrState;
  }

  static fetchBy({required GlobalKey<FormBuilderState> kAttrBuilder}) {
    final attrMap = kAttrBuilder.currentState!.value;
    final attr = AttributeDto.fromFrom(attrMap);
    return attr;
  }
}

class _AttributeFormState extends State<AttributeForm> {
  @override
  Widget build(BuildContext context) {
    final attr = widget.origin;
    return FormBuilder(
        key: widget.kAttrBuilder,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            ListTile(
              leading: SizedBox(
                width: 45,
                child: FormBuilderTextField(
                  name: 'k',
                  initialValue: attr.k.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Key',
                    border: OutlineInputBorder(),
                  ),
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
                        name: 'name',
                        initialValue: attr.name,
                        decoration: const InputDecoration(
                          labelText: '属性名称',
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 8),

                    /// 属性类型选择
                    SizedBox(
                      width: 200,
                      // 选择String类型,以便序列化(fromForm)
                      child: FormBuilderDropdown<String>(
                        name: 'type',
                        decoration: const InputDecoration(
                          labelText: '属性类型',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: attr.type.tpName,
                        items: AttrTypeDto.values
                            .map((e) => DropdownMenuItem<String>(
                                  value: e.name,
                                  child: Text(e.name),
                                ))
                            .toList(),
                        onChanged: (v) => _onChangeType(attr, v),
                      ),
                    ),
                    // const SizedBox(width: 8),
                    // if (attr.type.tp == AttrTp.ref) const SizedBox(width: 8),
                  ],
                ),
              ),
              // trailing: IconButton(
              //   icon: const Icon(Icons.delete),
              //   onPressed: () => _removeAttr(attr),
              // )),
            ),

            /// Meta选择器
            if (attr.type.tp == AttrTp.ref)
              SizedBox(
                width: 200,
                child: FormBuilderDropdown<String>(
                  name: 'ref',
                  decoration: const InputDecoration(
                    labelText: '类型选择',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: attr.type.r,
                  // 注意: 必须为空,否则报错 https://github.com/danvick/flutter_form_builder/issues/220
                  items: widget
                      .allMetas()
                      .map((e) => DropdownMenuItem<String>(
                            value: e.id,
                            child: Text(e.name),
                          ))
                      .toList(),
                ),
              ),
            SizedBox(
              width: 150,
              child: FormBuilderTextField(
                name: 'memo',
                initialValue: attr.memo,
                decoration: const InputDecoration(
                  labelText: '备注',
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.compose([
                  // FormBuilderValidators.required(context),
                ]),
              ),
            ),
          ]),
        ));
  }

  _onChangeType(AttributeDto attr, String? update) {
    // 如果类型切换了,就刷新一下UI, 以便更新 AttrType.ref 的类型选择器
    if (attr.type.tpName != update) {
      setState(() => attr.type = AttrTypeDto.by(update!));
    }
  }
}

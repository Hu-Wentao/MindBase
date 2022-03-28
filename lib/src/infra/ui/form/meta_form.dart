import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mind_base/src/config/common_config.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

class MetaForm extends StatelessWidget {
  final bool isCreate;
  final RecordMetaDto origin;
  final GlobalKey<FormBuilderState> kMetaBuilder;
  final GlobalKey<FormBuilderState> kAttrBuilder;

  const MetaForm({
    Key? key,
    required this.isCreate,
    required this.kMetaBuilder,
    required this.kAttrBuilder,
    required this.origin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MetaMainForm(
            kMetaBuilder: kMetaBuilder,
            origin: origin,
          ),
          AttributeListForm.build(
            isCreate: isCreate,
            kAttrBuilder: kAttrBuilder,
            origin: origin,
          ),
        ],
      );

  static checkBy(
    GlobalKey<FormBuilderState> kMetaBuilder,
    GlobalKey<FormBuilderState> kAttrBuilder,
  ) {
    final metaState = kMetaBuilder.currentState?.saveAndValidate() ?? false;
    final attrState = kAttrBuilder.currentState?.saveAndValidate() ?? false;
    return metaState && attrState;
  }

  /// 通过 k获取 MetaForm和AttrForm 中的数据, 最后转换成DTO
  static RecordMetaDto? fetchDtoBy({
    required GlobalKey<FormBuilderState> kMetaBuilder,
    required GlobalKey<FormBuilderState> kAttrBuilder,
  }) {
    if (!checkBy(kMetaBuilder, kAttrBuilder)) {
      return null;
    }
    final metaMap = kMetaBuilder.currentState!.value;
    final attrMap = kAttrBuilder.currentState!.value;
    slLogger.info("fetchDtoBy # metaMap: $metaMap, attrMap: $attrMap");
    // <key,<field,value>>
    final attrFormatMap = <int, Map<String, String>>{};
    for (final e in attrMap.entries) {
      final k = e.key.split("@");
      final ik = int.parse(k[0]);
      final fk = k[1];
      final v = e.value;
      attrFormatMap[ik] ??= {};
      attrFormatMap[ik]![fk] = v;
    }
    final attrs = attrFormatMap.entries.map((e) {
      final json = e.value;
      // todo 手动修正 expr
      // final metaId = ObjectId.fromHexString(attrMap['id'] as String);
      final key = int.parse(json['k'] as String);
      return AttributeDto(
        k: key,
        // Form的序列化与原序列化不同
        name: json['name'] as String,
        memo: json['memo'] as String,
        calc: Expression(
          key,
          AttrType.values.byName(json['expr.rType'] as String),
        ),
        // expr: Expression.fromJson(json['expr'] as Map<String, dynamic>),
        checkFuncName: json['checkFuncName'] as String,
      );
    }).toList();
    print("debug # attrs: $attrs");
    return RecordMetaDto.fromForm(metaMap, attrs);
  }
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
  final bool isCreate; // true:表单将会新增一个待编辑的属性
  final int nextKey; // ::nextKey()
  final List<AttributeDto> originList;

  final GlobalKey<FormBuilderState>? kAttrBuilder;

  factory AttributeListForm.build({
    Key? key,
    required isCreate,
    required RecordMetaDto origin,
    GlobalKey<FormBuilderState>? kAttrBuilder,
  }) =>
      AttributeListForm(
        isCreate: isCreate,
        nextKey: origin.nextKey(),
        originList: origin.attributes,
        kAttrBuilder: kAttrBuilder,
      );

  const AttributeListForm({
    Key? key,
    required this.isCreate,
    required this.originList,
    required this.nextKey,
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
    _origin = [
      ...widget.originList,
      if (widget.isCreate) AttributeDto.builder(k: widget.nextKey),
    ];
    _kAttrBuilder = widget.kAttrBuilder ?? GlobalKey<FormBuilderState>();
    super.initState();
  }

  _addNewAttr() => setState(() =>
      _origin.add(AttributeDto.builder(k: widget.nextKey + _origin.length)));

  _removeAttr(AttributeDto a) {
    setState(() {
      // 从数据源移除
      _origin.remove(a);
      // 选中表单中相关的字段名
      final targetFields = _kAttrBuilder.currentState?.instantValue.keys
          .where((element) => element.startsWith("${a.k}@"));
      // 从表单中移除相关键值对 (由于_origin已移除, 因此无需在这里 setState)
      targetFields?.forEach((fieldNames) => _kAttrBuilder.currentState
          ?.removeInternalFieldValue(fieldNames, isSetState: false));
    });
  }

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
        width: 45,
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
              // child: FormBuilderSearchableDropdown<String>(
              //   name: '${a.k}@expr',
              //   // items: allCountries,
              //   // onChanged: _onChanged,
              //   showSearchBox: true,
              //   isFilteredOnline: true,
              //   compareFn: (item, selectedItem) =>
              //       item.toLowerCase() == selectedItem.toLowerCase(),
              //   onFind: (text) async {
              //     await Future.delayed(const Duration(seconds: 1));
              //     return allCountries
              //         .where((element) =>
              //             element.toLowerCase().contains(text.toLowerCase()))
              //         .toList();
              //   },
              //   decoration: const InputDecoration(
              //       labelText: 'Searchable Dropdown Online'),
              // ),
              // fixme 如何通过下拉配置表达式?
              /// 非引用型字段
              child: FormBuilderDropdown(
                name: '${a.k}@expr.rType',
                decoration: const InputDecoration(labelText: '属性/表达式 类型'),
                initialValue: a.calc.type.name,
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

// /// 用于创建表达式[Expression]
// class ExpressionForm extends StatefulWidget {
//   const ExpressionForm({Key? key}) : super(key: key);
//
//   @override
//   State<ExpressionForm> createState() => _ExpressionFormState();
// }
//
// class _ExpressionFormState extends State<ExpressionForm> {
//   @override
//   Widget build(BuildContext context) {
//     return FormBuilderSearchableDropdown<String>(
//       name: 'searchable_dropdown_online',
//       // items: allCountries,
//       onChanged: _onChanged,
//       showSearchBox: true,
//       isFilteredOnline: true,
//       compareFn: (item, selectedItem) =>
//       item.toLowerCase() == selectedItem.toLowerCase(),
//       onFind: (text) async {
//         await Future.delayed(const Duration(seconds: 1));
//         return allCountries
//             .where((element) =>
//             element.toLowerCase().contains(text.toLowerCase()))
//             .toList();
//       },
//       decoration: const InputDecoration(
//           labelText: 'Searchable Dropdown Online'),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/space/application/service/expr/expression_parser.dart';
import 'package:mind_base/src/core/config/common_config.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/domain/value/value.dart';
import 'package:mind_base/src/space/infra/dto/dto_token_impl.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';
import 'package:mind_base/src/space/inter/dto/expr_token_dto.dart';
import 'package:ndialog/ndialog.dart';

class MetaForm extends StatelessWidget {
  final bool isCreate;
  final MetaDto origin;
  final Iterable<MetaModel> Function() allMetas;
  final QueryMetaFn queryMetaFn;
  final GlobalKey<FormBuilderState> kMetaBuilder;
  final GlobalKey<FormBuilderState> kAttrBuilder;
  final GlobalKey<FormBuilderState> kMethodBuilder;

  const MetaForm({
    Key? key,
    required this.isCreate,
    required this.allMetas,
    required this.kMetaBuilder,
    required this.kAttrBuilder,
    required this.kMethodBuilder,
    required this.queryMetaFn,
    required this.origin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MetaMainForm(
              isCreate: isCreate,
              origin: origin,
              kMetaBuilder: kMetaBuilder,
            ),
            AttributeListForm.build(
              isCreate: isCreate,
              allMetas: allMetas,
              kAttrBuilder: kAttrBuilder,
              origin: origin,
            ),
            if (!isCreate) // 如果是新建Meta, 则暂不提供"创建方法"按钮
              MethodListForm.build(
                isCreate: isCreate,
                kMethodBuilder: kMethodBuilder,
                origin: origin,
                queryMetaFn: queryMetaFn,
              ),
          ],
        ),
      );

  /// 允许 [kMethodBuilder]为空, 因为创建时可能会不展示MethodBuilder,如果此时传入,会导致MethodBuilder始终报错
  static checkBy(
    GlobalKey<FormBuilderState> kMetaBuilder,
    GlobalKey<FormBuilderState> kAttrBuilder,
    GlobalKey<FormBuilderState>? kMethodBuilder,
  ) {
    final metaState = kMetaBuilder.currentState?.saveAndValidate() ?? false;
    final attrState = kAttrBuilder.currentState?.saveAndValidate() ?? false;
    if (kMethodBuilder != null) {
      final methodState =
          kMethodBuilder.currentState?.saveAndValidate() ?? false;
      return metaState && attrState && methodState;
    } else {
      return metaState && attrState;
    }
  }

  /// 通过 k获取 MetaForm和AttrForm 中的数据, 最后转换成DTO
  static MetaDto? fetchDtoBy({
    required GlobalKey<FormBuilderState> kMetaBuilder,
    required GlobalKey<FormBuilderState> kAttrBuilder,
    required GlobalKey<FormBuilderState>? kMethodBuilder,
    required QueryMetaFn? queryMetaFn,
  }) {
    assert(checkBy(kMetaBuilder, kAttrBuilder, kMethodBuilder),
        "校验Meta,Attr和MethodBuilder失败");
    final metaMap = kMetaBuilder.currentState!.value;
    final attrMap = kAttrBuilder.currentState!.value;
    final methodMap = kMethodBuilder?.currentState!.value;
    slLogger.info(
        "fetchDtoBy # metaMap: $metaMap, attrMap: $attrMap, methodMap: $methodMap");
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
      final key = int.parse(json['k'] as String);
      return AttributeDto(
        k: key,
        // Form的序列化与原序列化不同
        name: json['name'] as String,
        memo: json['memo'] as String,
        type: AttrTypeDto.by(json['type'] as String, json['ref']),
      );
    }).toList();

    // 为空表示当前From没有构造Method输入框
    if (methodMap == null) {
      return MetaDto.fromForm(metaMap, attrs, []);
    } else {
      final methodFormatMap = <int, Map<String, String>>{};
      for (final e in methodMap.entries) {
        final k = e.key.split("@");
        final ik = int.parse(k[0]);
        final fk = k[1];
        final v = e.value;
        methodFormatMap[ik] ??= {};
        methodFormatMap[ik]![fk] = v;
      }
      // expr12 由于持久化为Json,需要 Readable->Domain(Meta)->Json, 显然此时Meta尚未持久化(尚未被创建)
      // 所以在expr12中, 无法在创建Meta之前,创建方法
      final metaId = metaMap['id'] as String?;
      // 尝试查询Meta,如果查不到就取消添加方法(因为Meta还没被创建)
      // final meta = sl<SpaceModelDataHolder>().getMetaBy(ObjectId.fromHexString(metaId));
      // 注意, 由于 attr-v7.2 新增QueryMetaFn, 所以只要MetaId!=null,就可以新建方法
      final methods = (metaId == null)
          ? const <MethodDto>[]
          : methodFormatMap.entries.map((e) {
              final json = e.value;
              final key = int.parse(json['k'] as String);
              return MethodDto(
                k: key,
                name: json['name'] as String,
                memo: json['memo'] as String,
                // 可读Token->Domain(包含上下文)->IExprJson(持久化)
                expr: IExprNodeDto.fromDomain(
                  ExprTokenDto.of(exprParser, json['expr'] as String).toDomain(
                    metaId,
                    queryMetaFn,
                  ),
                ),
              );
            }).toList();

      // print("debug # attrs: $attrs");
      return MetaDto.fromForm(metaMap, attrs, methods);
    }
  }
}

class MetaMainForm extends StatefulWidget {
  final bool isCreate;
  final MetaDto origin;

  final GlobalKey<FormBuilderState>? kMetaBuilder;

  const MetaMainForm({
    Key? key,
    required this.isCreate,
    required this.origin,
    this.kMetaBuilder,
  }) : super(key: key);

  @override
  State<MetaMainForm> createState() => _MetaMainFormState();
}

class _MetaMainFormState extends State<MetaMainForm> {
  late MetaDto _origin;
  late GlobalKey<FormBuilderState> _kMetaBuilder;

  @override
  initState() {
    _origin = widget.origin;
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilderTextField(
                  name: 'id',
                  initialValue: _origin.id,
                  decoration: const InputDecoration(
                    labelText: 'ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilderTextField(
                  name: 'name',
                  initialValue: _origin.name,
                  decoration: const InputDecoration(
                    labelText: '表/类 名称',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilderTextField(
                  name: 'memo',
                  initialValue: _origin.memo,
                  decoration: const InputDecoration(
                    labelText: '表/类 备注',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    // FormBuilderValidators.required(context),
                  ]),
                ),
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
  final Iterable<MetaModel> Function() allMetas;

  final GlobalKey<FormBuilderState>? kAttrBuilder;

  factory AttributeListForm.build({
    Key? key,
    required isCreate,
    required MetaDto origin,
    required Iterable<MetaModel> Function() allMetas,
    GlobalKey<FormBuilderState>? kAttrBuilder,
  }) =>
      AttributeListForm(
        isCreate: isCreate,
        allMetas: allMetas,
        nextKey: origin.nextKey(),
        originList: origin.attrs,
        kAttrBuilder: kAttrBuilder,
      );

  const AttributeListForm({
    Key? key,
    required this.isCreate,
    required this.originList,
    required this.allMetas,
    required this.nextKey,
    this.kAttrBuilder,
  }) : super(key: key);

  @override
  State<AttributeListForm> createState() => _AttributeListFormState();
}

class _AttributeListFormState extends State<AttributeListForm> {
  late List<AttributeDto> _origin;
  late GlobalKey<FormBuilderState> _kAttrBuilder;

  _onChangeType(AttributeDto attr, String? update) {
    // 如果类型切换了,就刷新一下UI, 以便更新 AttrType.ref 的类型选择器
    if (attr.type.tpName != update) {
      setState(() => attr.type = AttrTypeDto.by(update!));
    }
  }

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
  Widget _buildAttributeForm(BuildContext context, AttributeDto a) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
            leading: SizedBox(
              width: 45,
              child: FormBuilderTextField(
                name: '${a.k}@k',
                initialValue: a.k.toString(),
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
                      name: '${a.k}@name',
                      initialValue: a.name,
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
                      name: '${a.k}@type',
                      decoration: const InputDecoration(
                        labelText: '属性类型',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: a.type.tpName,
                      items: AttrTypeDto.values
                          .map((e) => DropdownMenuItem<String>(
                                value: e.name,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (v) => _onChangeType(a, v),
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// Meta选择器
                  if (a.type.tp == AttrTp.ref)
                    SizedBox(
                      width: 200,
                      child: FormBuilderDropdown<String>(
                        name: '${a.k}@ref',
                        decoration: const InputDecoration(
                          labelText: '类型选择',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: a.type.r,
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
                  if (a.type.tp == AttrTp.ref) const SizedBox(width: 8),
                  SizedBox(
                    width: 150,
                    child: FormBuilderTextField(
                      name: '${a.k}@memo',
                      initialValue: a.memo,
                      decoration: const InputDecoration(
                        labelText: '备注',
                        border: OutlineInputBorder(),
                      ),
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
            )),
      );
}

class MethodListForm extends StatefulWidget {
  final bool isCreate; // true:表单将会新增一个待编辑的属性
  final int nextKey; // ::nextKey()
  final List<MethodDto> originList;
  final QueryMetaFn queryMetaFn;
  final GlobalKey<FormBuilderState>? kMethodBuilder;

  factory MethodListForm.build({
    Key? key,
    required isCreate,
    required MetaDto origin,
    required QueryMetaFn queryMetaFn,
    GlobalKey<FormBuilderState>? kMethodBuilder,
  }) =>
      MethodListForm(
        isCreate: isCreate,
        nextKey: origin.nextKey(),
        originList: origin.methods,
        kMethodBuilder: kMethodBuilder,
        queryMetaFn: queryMetaFn,
      );

  const MethodListForm({
    Key? key,
    required this.isCreate,
    required this.originList,
    required this.nextKey,
    this.kMethodBuilder,
    required this.queryMetaFn,
  }) : super(key: key);

  @override
  State<MethodListForm> createState() => _MethodListFormState();
}

class _MethodListFormState extends State<MethodListForm> {
  late List<MethodDto> _origin;
  late GlobalKey<FormBuilderState> _kMethodBuilder;

  @override
  initState() {
    _origin = [
      ...widget.originList,
      if (widget.isCreate) MethodDto.builder(k: widget.nextKey),
    ];
    _kMethodBuilder = widget.kMethodBuilder ?? GlobalKey<FormBuilderState>();
    super.initState();
  }

  _addNewMethod() => setState(
      () => _origin.add(MethodDto.builder(k: widget.nextKey + _origin.length)));

  _removeMethod(MethodDto a) {
    setState(() {
      // 从数据源移除
      _origin.remove(a);
      // 选中表单中相关的字段名
      final targetFields = _kMethodBuilder.currentState?.instantValue.keys
          .where((element) => element.startsWith("${a.k}@"));
      // 从表单中移除相关键值对 (由于_origin已移除, 因此无需在这里 setState)
      targetFields?.forEach((fieldNames) => _kMethodBuilder.currentState
          ?.removeInternalFieldValue(fieldNames, isSetState: false));
    });
  }

  @override
  Widget build(BuildContext context) => FormBuilder(
        key: _kMethodBuilder,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ..._origin
              .map((a) => _buildMethodForm(
                    context,
                    a,
                    widget.queryMetaFn,
                  ))
              .toList(),
          ElevatedButton(onPressed: _addNewMethod, child: const Text('添加方法')),
        ]),
      );

  /// 特殊处理： 对所有的键添加 ”${a.k}@“开头，以区别不同的Attribute
  Widget _buildMethodForm(
          BuildContext context, MethodDto m, QueryMetaFn queryMetaFn) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
            leading: SizedBox(
              width: 45,
              child: FormBuilderTextField(
                name: '${m.k}@k',
                initialValue: m.k.toString(),
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
                      name: '${m.k}@name',
                      initialValue: m.name,
                      decoration: const InputDecoration(
                        labelText: '方法名称',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 200,
                    child: FormBuilderTextField(
                      name: '${m.k}@expr',
                      initialValue: m.expr.toTokenString(queryMetaFn),
                      decoration: const InputDecoration(
                        labelText: '方法体',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        // FormBuilderValidators.required(context),
                      ]),
                    ),
                  ),
                  // SizedBox(
                  //   width: 200,
                  //   child: FormBuilderExpressionInputFields(
                  //     name: '${m.k}@expr',
                  //     initialValue: m.expr,
                  //     initExprContexts: [
                  //       // ...FuncManager.getFuncExprContexts,
                  //     ],
                  //   ),
                  // ),
                  // FormBuilderTextField(name: '${m.k}@expr2'),
                  // SizedBox(
                  //   width: 150,
                  //   child: FormBuilderDropdown(
                  //     name: '${a.k}@checkFuncName',
                  //     decoration: const InputDecoration(labelText: '值校验函数'),
                  //     initialValue: a.checkFuncName,
                  //     items: FuncManager.funcList
                  //         .map((e) => DropdownMenuItem<String>(
                  //               value: e.name,
                  //               child: Text(e.name),
                  //             ))
                  //         .toList(),
                  //   ),
                  // ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 150,
                    child: FormBuilderTextField(
                      name: '${m.k}@memo',
                      initialValue: m.memo,
                      decoration: const InputDecoration(
                        labelText: '备注',
                        border: OutlineInputBorder(),
                      ),
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
              onPressed: () => _removeMethod(m),
            )),
      );
}

/// 表达式输入框
/// Expr输入方案B
/// 展示：对象 -> EditString
/// 输入；EditString -> 对象
class FormBuilderExpressionInputFields extends StatefulWidget {
  final String name;
  final String initialValue;

  // 应该放入 {"this":<当前的Meta>, "全局Func的name":<Func>...}
  final Map<String, dynamic> initExprContexts;

  const FormBuilderExpressionInputFields({
    Key? key,
    required this.name,
    required this.initialValue,
    required this.initExprContexts,
  }) : super(key: key);

  @override
  State<FormBuilderExpressionInputFields> createState() =>
      _FormBuilderExpressionInputFieldsState();
}

class _FormBuilderExpressionInputFieldsState
    extends State<FormBuilderExpressionInputFields> {
  bool visible = false;

  late TextEditingController _ctrl;

  // 属性上下文集合：相关的 属性，方法列表
  // 1. 当前Meta的所有方法，属性；
  // 2. 所有全局函数
  // 3. 新添加，尚未持久化的当前方案、属性
  Map<String, dynamic> exprContexts = {};

  // final _focusNode = FocusNode();

  @override
  void initState() {
    _ctrl = TextEditingController(text: widget.initialValue)
      // _ctrl = TextEditingController(text: widget.initialValue.toEditString())
      ..addListener(() {
        print("#debug _ctrl.text: ${_ctrl.value}");
        onEdit(_ctrl.value.text, _ctrl.value.selection);
      });
    exprContexts.addAll(widget.initExprContexts);
    super.initState();
  }

  /// 用户输入，选择事件
  /// 移动光标(鼠标、键盘操作) TextSelection.collapsed(offset: 1, affinity: TextAffinity.downstream, isDirectional: false)
  /// 选择一段文字 TextSelection(baseOffset: 1, extentOffset: 4, isDirectional: false),
  onEdit(String text, TextSelection selection) {
    // selection.isCollapsed; // 是否为点击（开始==结束）
    selection.start; // 开始位置
    /// 手动解析方案
  }

  // 要save的时候才会调用本方法， 考虑做一个每次用户输入即save一次，并添加节流（每秒一次）
  String? onValidate(String? text) {
    print("#debug #validate $text");
    return "$text".isEmpty ? '不能为空' : null;
  }

  @override
  Widget build(BuildContext context) => TextField(
        decoration: const InputDecoration(
          labelText: "方法体",
          border: OutlineInputBorder(),
        ),
        controller: _ctrl,
        onTap: _exprEditDialog,
      );

  Future<void> _exprEditDialog() async => await NDialog(
        dialogStyle: DialogStyle(),
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0, left: 4, right: 4),
          child: Text("表达式编辑器"),
        ),
        content: Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4),
          child: SizedBox(
            width: 500,
            height: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: FormBuilderTextField(
                    name: widget.name,
                    controller: _ctrl,
                    validator: onValidate,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text("左侧"),
                      onPressed: () {},
                    ),
                    const VerticalDivider(
                      color: Colors.grey,
                      width: 4,
                      thickness: 1,
                      indent: 4,
                      endIndent: 4,
                    ),
                    TextButton(
                      child: const Text("右边"),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text("确认"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          TextButton(
              child: const Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ).show(context);
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

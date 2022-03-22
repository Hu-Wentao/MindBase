import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/infra/ui/form/meta_form.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:ndialog/ndialog.dart';

Future<RecordMetaDto?> showRecordMetaEditDialog({
  required BuildContext context,
  RecordMetaDto? originMeta,
  required GlobalKey<FormBuilderState> kMetaBuilder,
  required GlobalKey<FormBuilderState> kAttrBuilder,
}) async =>
    await NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: const Text("添加新的表"),
      content: MetaForm(
        isCreate: originMeta == null,
        kMetaBuilder: kMetaBuilder,
        kAttrBuilder: kAttrBuilder,
        origin: originMeta ?? RecordMetaDto.builder(),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text("确认"),
            onPressed: () {
              if (MetaForm.checkBy(kMetaBuilder, kAttrBuilder)) {
                final dto = MetaForm.fetchDtoBy(
                  kMetaBuilder: kMetaBuilder,
                  kAttrBuilder: kAttrBuilder,
                );
                Navigator.pop<RecordMetaDto>(context, dto);
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

/// 本表单编辑的是当前Meta下，当前/新增 的Attr属性
Future<AttributeDto?> showAttributeEditDialog({
  required BuildContext context,
  required RecordMetaDto selfMeta, // 当前表的Meta,防止出现当前表尚未持久化导致无法使用的问题
  required Future<RecordMetaDto?> Function(ObjectId metaId) queryMeta,
  required Future<List<RecordMetaDto>> Function(String metaName)
      queryMetaByName, // todo remove 应该是查询所有/当前工作区,然后根据name筛选
  AttributeDto? origin, // 空表示新增属性
  // RecordMetaDto? originMeta,
  // required GlobalKey<FormBuilderState> kMetaBuilder,
  // required GlobalKey<FormBuilderState> kAttrBuilder,
}) async {
// 表示被编辑、新增的 Attr属性
  final attr = origin ?? AttributeDto.builder();
  // final expr = attr.expr;
  final kAttrBuilder = GlobalKey<FormBuilderState>();
  final kExprBuilder = GlobalKey<FormBuilderState>();

  // fixme 查询所有/当前工作区,然后根据name筛选
  var allMetaInWorkspace = sl<RecordMetaAccessor>().findAll().toList();
  var currentMeta = selfMeta; // 选中的引用目标Meta
  // 表达式的参数<AttributeDto>, 暂时只支持输入单个参数, 默认首个参数为当前列
  AttributeDto currentArg = origin ?? AttributeDto.builder();
  Func currentFunc = FuncManager.selfFunc; // 当前选中的表达式
  AttrType currentType = AttrType.string; // 当前表达式返回值类型

  print("debug originMeta: $origin");

  return await NAlertDialog(
    dialogStyle: DialogStyle(titleDivider: true),
    title: const Text("编辑属性(列)"),
    content: FormBuilder(
      key: kAttrBuilder,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 200,
              child: FormBuilderTextField(
                name: 'name',
                initialValue: attr.name,
                decoration: const InputDecoration(labelText: '属性名称'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
              ),
            ),
            SizedBox(
              width: 200,
              child: FormBuilder(
                key: kExprBuilder,
                child: Column(
                  children: [
                    // FormBuilderTextField(
                    //   decoration: const InputDecoration(labelText: '表达式'),
                    //   name: 'calls',
                    //   initialValue: "${expr.calls}",
                    //   validator: FormBuilderValidators.compose([
                    //     // FormBuilderValidators.required(context),
                    //   ]),
                    // ),

                    FormBuilderSearchableDropdown<RecordMetaDto>(
                      decoration:
                          const InputDecoration(labelText: '表达式入参所在Meta'),
                      name: 'metaId',
                      initialValue: selfMeta,
                      itemAsString: (meta) => meta?.name ?? "",
                      // items: allCountries,
                      onChanged: (value) {
                        currentMeta = (value == null) ? selfMeta : value;
                      },
                      showSearchBox: true,
                      isFilteredOnline: true,
                      compareFn: (item, selected) => item?.id == selected?.id,
                      onFind: (text) async {
                        if (text?.isEmpty ?? true) {
                          return allMetaInWorkspace;
                        } else {
                          final lowerText = text!.toLowerCase();
                          return allMetaInWorkspace.then((value) => value
                              .where((element) => element.name
                                  .toLowerCase()
                                  .contains(lowerText))
                              .toList());
                        }
                      },
                    ),
                    FormBuilderSearchableDropdown<AttributeDto>(
                      decoration: const InputDecoration(labelText: '表达式入参'),
                      name: 'params',
                      initialValue: currentArg,
                      itemAsString: (at) => "${at?.name} (${at?.k})",
                      // items: allCountries,
                      onChanged: (value) {
                        print("修改表达式 [$value]");
                        currentArg = value!;
                        // currentMeta = (value == null) ? selfMeta : value;
                      },
                      showSearchBox: true,
                      isFilteredOnline: true,
                      compareFn: (ex, selected) => ex == selected,
                      onFind: (text) async {
                        if (text?.isEmpty ?? true) {
                          return currentMeta.attributes;
                        } else {
                          final lowerText = text!.toLowerCase();
                          return currentMeta.attributes
                              .where((element) => element.name
                                  .toLowerCase()
                                  .contains(lowerText))
                              .toList();
                        }
                      },
                    ),
                    FormBuilderSearchableDropdown<Func>(
                      decoration: const InputDecoration(labelText: '表达式Func'),
                      name: 'calls',
                      initialValue: FuncManager.selfFunc,
                      itemAsString: (fn) =>
                          "${fn?.rType.name} ${fn?.name}( ${currentArg.name} )",
                      // items: allCountries,
                      onChanged: (fn) {
                        print("修改表达式 [$fn]");
                        currentFunc = fn!;
                        // currentMeta = (value == null) ? selfMeta : value;
                      },
                      showSearchBox: true,
                      isFilteredOnline: true,
                      compareFn: (ex, selected) => ex == selected,
                      onFind: (text) async {
                        if (text?.isEmpty ?? true) {
                          return [];
                        } else {
                          final lowerText = text!.toLowerCase();
                          return FuncManager.funcList
                              .where((element) => element.name
                                  .toLowerCase()
                                  .contains(lowerText))
                              .toList();
                        }
                      },
                    ),
                    // FormBuilderSearchableDropdown<Func>(
                    //   decoration: const InputDecoration(labelText: '表达式Func'),
                    //   name: 'calls',
                    //   initialValue: expr.calls.first,
                    //   itemAsString: (ex) => "(${ex?.pKeys}):${ex?.rType}",
                    //   // items: allCountries,
                    //   onChanged: (value) {
                    //     print("修改表达式 [$value]");
                    //     // currentMeta = (value == null) ? selfMeta : value;
                    //   },
                    //   showSearchBox: true,
                    //   isFilteredOnline: true,
                    //   compareFn: (ex, selected) => ex == selected,
                    //   onFind: (text) async {
                    //     if (text?.isEmpty ?? true) {
                    //       return [ ];
                    //     } else {
                    //       final lowerText = text!.toLowerCase();
                    //       return allMetaInWorkspace.then((value) => value
                    //           .where((element) => element.name
                    //           .toLowerCase()
                    //           .contains(lowerText))
                    //           .toList());
                    //     }
                    //   },
                    // ),
                    // /// 可选项[currentMeta]对应的Attr列表
                    // ChipsInput<AttributeDto>(
                    //   initialValue: expr.pKeys.map(currentMeta.findAttr).toList(),
                    //   findSuggestions: (String query) async {
                    //     if (query.isNotEmpty) {
                    //       var lowCaseQuery = query.toLowerCase();
                    //       return currentMeta.attributes
                    //           .where((a) =>
                    //           a.name.toLowerCase().contains(lowCaseQuery))
                    //           .toList();
                    //     } else {
                    //       return currentMeta.attributes;
                    //     }
                    //   },
                    //   onChanged: (data) {
                    //     print(data);
                    //   },
                    //   chipBuilder: (context, state, AttributeDto dto) {
                    //     return InputChip(
                    //       key: ObjectKey(dto),
                    //       label: Text(dto.name),
                    //       // avatar: CircleAvatar(
                    //       //   backgroundImage: NetworkImage(dto.imageUrl),
                    //       // ),
                    //       onDeleted: () => state.deleteChip(dto),
                    //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //     );
                    //   },
                    //   suggestionBuilder: (context, AttributeDto profile) {
                    //     return ListTile(
                    //       key: ObjectKey(profile),
                    //       // leading: CircleAvatar(
                    //       //   backgroundImage: NetworkImage(profile.imageUrl),
                    //       // ),
                    //       title: Text(profile.name),
                    //       // subtitle: Text(profile.email),
                    //     );
                    //   },
                    // ),
                    ///
                    // FormBuilderChipsInput<AttributeDto>(
                    //   decoration: const InputDecoration(labelText: '入参属性列表'),
                    //   name: 'pKeys',
                    //   initialValue:
                    //       expr.pKeys.map(currentMeta.findAttr).toList(),
                    //   // maxChips: 5,
                    //   findSuggestions: (String query) async {
                    //     if (query.isNotEmpty) {
                    //       var lowCaseQuery = query.toLowerCase();
                    //       return currentMeta.attributes
                    //           .where((a) =>
                    //               a.name.toLowerCase().contains(lowCaseQuery))
                    //           .toList();
                    //     } else {
                    //       return currentMeta.attributes;
                    //     }
                    //   },
                    //   suggestionBuilder: (context, state, attrDto) => ListTile(
                    //     key: ObjectKey(attrDto),
                    //     title: Text(attrDto.name),
                    //     subtitle: Text(attrDto.expr.rType.name),
                    //     onTap: () => state.selectSuggestion(attrDto),
                    //   ),
                    //   chipBuilder: (context, state, attrDto) => InputChip(
                    //     key: ObjectKey(attrDto),
                    //     label: Text(attrDto.name),
                    //     // avatar: CircleAvatar(
                    //     //   backgroundImage: NetworkImage(attrDto.imageUrl),
                    //     // ),
                    //     onDeleted: () => state.deleteChip(attrDto),
                    //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //   ),
                    // ),

                    // FormBuilderTextField(
                    //   name: 'rType',
                    //   initialValue: "${expr.rType}",
                    //   decoration: const InputDecoration(labelText: '返回值类型'),
                    //   validator: FormBuilderValidators.compose([
                    //     // FormBuilderValidators.required(context),
                    //   ]),
                    // ),
                    FormBuilderSearchableDropdown<AttrType>(
                      decoration: const InputDecoration(labelText: '返回值类型'),
                      name: 'rType',
                      initialValue: currentType,
                      itemAsString: (ty) => "${ty?.name}",
                      // items: allCountries,
                      onChanged: (tp) {
                        print("修改tp [$tp]");
                        currentType = tp!;
                      },
                      showSearchBox: true,
                      isFilteredOnline: true,
                      compareFn: (ex, selected) => ex == selected,
                      onFind: (text) async {
                        if (text?.isEmpty ?? true) {
                          return AttrType.values.toList();
                        } else {
                          final lowerText = text!.toLowerCase();
                          return AttrType.values
                              .where((element) => element.name
                                  .toLowerCase()
                                  .contains(lowerText))
                              .toList();
                        }
                      },
                    ),
                  ],
                ),
              ),
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
            ),
            // SizedBox(
            //   width: 150,
            //   child: FormBuilderDropdown(
            //     name: 'checkFuncName',
            //     decoration: const InputDecoration(labelText: '值校验函数'),
            //     initialValue: attr.checkFuncName,
            //     items: FuncManager.funcList
            //         .map((e) => DropdownMenuItem<String>(
            //               value: e.name,
            //               child: Text(e.name),
            //             ))
            //         .toList(),
            //   ),
            // ),
            // SizedBox(
            //   width: 150,
            //   child: FormBuilderTextField(
            //     name: 'memo',
            //     initialValue: attr.memo,
            //     decoration: const InputDecoration(labelText: '备注'),
            //     validator: FormBuilderValidators.compose([
            //       // FormBuilderValidators.required(context),
            //     ]),
            //   ),
            // ),
          ],
        ),
      ),
    ),
    actions: <Widget>[
      TextButton(
          child: const Text("确认"),
          onPressed: () {
            // 当前最终表达式
            try {
              Expression currentExpr = Expression(
                  metaId: currentMeta.id,
                  pKeys:  [currentArg.k],
                  calls: [currentFunc],
                  rType: currentType);

              AttributeDto rst = attr.copyWith(
                expr: currentExpr,
              );

              Navigator.pop<AttributeDto>(context, rst);
            } catch (e, s) {
              print("debug expr error: $e, $s");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("请检查表单")),
              );
            }

            // if (MetaForm.checkBy(kMetaBuilder, kAttrBuilder)) {
            //   final dto = MetaForm.fetchDtoBy(
            //     kMetaBuilder: kMetaBuilder,
            //     kAttrBuilder: kAttrBuilder,
            //   );
            //   Navigator.pop<RecordMetaDto>(context, dto);
            // } else {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text("请检查表单")),
            //   );
            // }
          }),
      TextButton(
        child: const Text("取消"),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  ).show(context);
}

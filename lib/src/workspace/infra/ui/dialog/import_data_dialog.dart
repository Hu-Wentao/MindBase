import 'package:flutter/material.dart';
import 'package:json_editor/json_editor.dart';
import 'package:mind_base/src/workspace/domain/entity/entity.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';
import 'package:ndialog/ndialog.dart';

/// 导入数据 [RecordMeta] + [Record]
/// json,csv等等

/// 用于表示一个[RecordMeta] + [Record]
/// [isCreate] 为true表示更新结构与插入数据
class TableDto {
  final bool isCreate;
  final RecordMetaDto meta;
  final List<RecordDto> data;

  TableDto(this.isCreate, this.meta, this.data);

  /// [metaId] 为null表示新建一个meta,并导入数据
  static TableDto? of(List<dynamic> rawJsList, {String? metaId}) {
    if (rawJsList.isEmpty) return null;
    final dto = TableDto(metaId == null, RecordMetaDto.builder(id: metaId), []);
    final meta = dto.meta;
    final typedNoneNameAttrs = <AttrTypeDto, AttributeDto>{};
    for (final js in rawJsList) {
      print("debug ## e = $js");

      final rcd = RecordDto.builder();
      if (js is Map) {
        // Map，单条record的内容
        for (final kv in js.entries) {
          final attrName = kv.key.toString();
          final valueType = AttrTypeDto.of(kv.value);
          //
          var at = meta.findAttrByName(attrName);
          if (at == null) {
            at = AttributeDto.builder(
                k: meta.nextKey(), name: attrName, type: valueType);
            meta.attrs.add(at);
          }
          rcd.fields[at.k] = Value.of(kv.value);
        }
      } else {
        // 只有值，全部归类为无名属性的value
        final valueType = AttrTypeDto.of(js.value);
        typedNoneNameAttrs[valueType] ??= AttributeDto.builder(
            k: meta.nextKey(), name: '${valueType.name} Attr', type: valueType);
        rcd.fields[typedNoneNameAttrs[valueType]!.k] = Value.of(js.value);
      }
      dto.data.add(rcd);
    }
    meta.attrs.addAll(typedNoneNameAttrs.values);
    return dto;
  }

  @override
  String toString() {
    return 'TableDto{meta: $meta, data: $data}';
  }
}

Future<TableDto?> showImportDataDialog({
  required BuildContext context,
  // required ValueChanged<Map> onChanged,
}) {
  List list = const [];
  return NAlertDialog(
    dialogStyle: DialogStyle(titleDivider: false),
    title: const Padding(
      padding: EdgeInsets.all(8),
      child: Text("导入数据"),
    ),
    content: ImportDataByJsonPanel(
      onChanged: (ls) {
        list = ls;
      },
    ),
    actions: [
      TextButton(
          child: const Text("确认"),
          onPressed: () {
            if (list.isNotEmpty) {
              Navigator.pop<TableDto>(context, TableDto.of(list));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("不能导入空Json")),
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

class ImportDataByJsonPanel extends StatelessWidget {
  final ValueChanged<List> onChanged;
  final Map<String, dynamic>? origin;

  const ImportDataByJsonPanel({
    Key? key,
    required this.onChanged,
    this.origin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 500,
              height: 500,
              child: JsonEditor.object(
                object: origin,
                onValueChanged: (e) {
                  // print(
                  //     "debug json ele# ${e.comment} # ${e.key} # ${e.valueType} #${e.value}");
                  onChanged(e.value);
                },
              ),
            )
          ],
        ),
      );
}

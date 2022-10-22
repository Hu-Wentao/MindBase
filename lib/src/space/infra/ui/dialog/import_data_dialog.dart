import 'package:flutter/material.dart';
import 'package:json_editor/json_editor.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';
import 'package:ndialog/ndialog.dart';

/// 导入数据 [MetaModel] + [Record]
/// json,csv等等

/// 用于表示一个[MetaModel] + [Record]
/// [isCreate] 为true表示更新结构与插入数据
class TableDto {
  final bool isCreate;
  final MetaDto meta;
  final List<RecordDto> data;

  TableDto(this.isCreate, this.meta, this.data);

  // List, 多条记录的信息
  static _parseEleArray(JsonElement element, TableDto dto,
      Map<AttrTypeDto, AttributeDto> typedNoneNameAttrs) {
    assert(element.valueType == JsonElementValueType.array);
    final metaMemo = element.comment ?? '';
    final meta = dto.meta..memo += metaMemo;
    for (final ele in element.value as List) {
      final rcd = RecordDto.builder();
      assert(ele is JsonElement);
      if (ele.valueType == JsonElementValueType.map) {
        // Map，单条record的内容
        // print("deebug ## ele.value = ${ele.value}");
        _parseEleMap(ele, meta, rcd);
      } else {
        // 只有值，全部归类为无名属性的value
        final valueType = AttrTypeDto.ofJsonType(ele.value);
        typedNoneNameAttrs[valueType] ??= AttributeDto.builder(
            k: meta.nextKey(), name: '${valueType.name} Attr', type: valueType);
        rcd.fields[typedNoneNameAttrs[valueType]!.k] = Value.of(ele.value);
      }
      dto.data.add(rcd);
    }
    meta.attrs.addAll(typedNoneNameAttrs.values);
  }

  // Map，单条record的信息
  static _parseEleMap(JsonElement element, MetaDto meta, RecordDto rcd) {
    assert(element.valueType == JsonElementValueType.map);
    for (final JsonElement kv in (element.value as List)) {
      // print(
      //     "debug kv = ${kv.key}, type ${kv.valueType}, value=${kv.value}, comment ${kv.comment}");
      final valueType = AttrTypeDto.ofJsonType(kv.valueType);
      final attrName = kv.key ?? '${valueType.name} Attr';
      //
      var at = meta.findAttrByName(attrName);
      if (at == null) {
        at = AttributeDto.builder(
          k: meta.nextKey(),
          name: attrName,
          memo: kv.comment ?? '',
          type: valueType,
        );
        meta.attrs.add(at);
      }
      rcd.fields[at.k] = Value.of(kv.value);
    }
    print("debug meta = $meta, rcd = $rcd");
  }

  /// [metaId] 为null表示新建一个meta,并导入数据
  static TableDto? of(JsonElement? element, {String? metaId}) {
    if (element == null) return null;
    final dto = TableDto(
        metaId == null, MetaDto.builder(id: metaId, name: "未命名表"), []);
    final typedNoneNameAttrs = <AttrTypeDto, AttributeDto>{};
    if (element.valueType == JsonElementValueType.array) {
      // 解析List， 即多条记录
      _parseEleArray(element, dto, typedNoneNameAttrs);
    } else {
      // 否则是map，即只有单条记录的信息
      final meta = dto.meta;
      final rcd = RecordDto.builder();
      _parseEleMap(element, meta, rcd);
      dto.data.add(rcd);
    }
    return dto;
  }

  @override
  String toString() {
    return 'TableDto{meta: $meta, data: $data}';
  }
}

Future<TableDto?> showImportDataDialog({
  required BuildContext context,
}) {
  JsonElement? ele;
  return NAlertDialog(
    dialogStyle: DialogStyle(titleDivider: false),
    title: const Padding(
      padding: EdgeInsets.all(8),
      child: Text("导入数据"),
    ),
    content: ImportDataByJsonPanel(
      onChanged: (e) => ele = e,
    ),
    actions: [
      TextButton(
          child: const Text("确认"),
          onPressed: () {
            if (ele != null) {
              Navigator.pop<TableDto>(context, TableDto.of(ele));
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
  final ValueChanged<JsonElement> onChanged;
  final List origin;

  const ImportDataByJsonPanel({
    Key? key,
    required this.onChanged,
    // todo 考虑换成JsonElement， 以添加comment示例
    this.origin = const [
      {"姓名": "张三", "年龄": 123, "性别": true},
      {"姓名": "李四", "年龄": 789, "性别": false}
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(
              onPressed: () {},
              child: const Text("Json"),
            ),
            SizedBox(
              width: 500,
              height: 450,
              child: JsonEditor.object(
                object: origin,
                onValueChanged: onChanged,
              ),
            ),
            Text(
              "注意：请勿将Int类型数据作为Key使用，否则会产生不符合预期的结果",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
}

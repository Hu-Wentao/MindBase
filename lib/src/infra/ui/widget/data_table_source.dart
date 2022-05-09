import 'package:flutter/material.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:pluto_grid/pluto_grid.dart';

/// 用于缓存一个表格的Cell Widget, 当数据源更新时,也同步更新Widget
abstract class IRecordDataGridSource {
  const IRecordDataGridSource();

  RecordMeta get meta;

  // 后端插入事件
  onInsertEvt(Record record);

  // 后端更新事件
  onUpdateEvt(Record record, int index);

  // 后端移除事件
  onRemoveEvt(ObjectId recordId, int index);
}

extension PlutoRecordMetaX on RecordMeta {
  List<PlutoColumn> get toColumnsHeader => properties
      .map((prop) => PlutoColumn(
            title: prop.name,
            // 展示在UI的列标题
            // titleSpan:  // 会覆盖 title参数的效果
            field: prop.propId,
            // 字段propId
            type: _buildColumnTypeBy(prop),
            // readOnly: // 某些字段需要标记为只读
            // frozen:  // 冻结列
            //  sort:  // 排序
            //   renderer // 渲染为自定义Widget
            enableColumnDrag: true,
            enableAutoEditing: true,
            // 自动切换编辑
            enableEditingMode: true, // 允许编辑
            // this.hide = false,// 隐藏列
          ))
      .toList()
    ..[0].enableRowDrag = true
    ..[0].enableRowChecked = true;

  PlutoColumnType _buildColumnTypeBy(Property prop) {
    switch (prop.type.tp) {
      case AttrTp.any:
      case AttrTp.objectId:
      case AttrTp.string:
        return PlutoColumnType.text();
      case AttrTp.num:
        return PlutoColumnType.number();
      case AttrTp.bool:
        return PlutoColumnType.select([true, false]);
      case AttrTp.ref:
        // todo 关系型怎么展示 ?
        return PlutoColumnType.text();
      // return PlutoColumnType.select(prop.type.ref.map((ref)=>ref.name).toList());
    }
  }
}

extension PlutoRecordX on Record {
  PlutoRow toPlutoRow() => PlutoRow(
        key: ValueKey<ObjectId>(id), // 将id作为key,以便接收更新事件时,查询是哪一个record
        cells: Map.fromEntries(meta.properties.map((prop) => MapEntry(
              prop.propId,
              PlutoCell(value: getValueBy(prop).v),
            ))),
      );
}

extension PlutoRecordDtoX on RecordDto {
  // 更新全部,(其实可以只更新一个字段)
  RecordDto updateBy(RecordMeta meta, PlutoRow row) {
    assert(meta.id.$oid == metaIdHex);
    row.cells.forEach((propId, value) {
      fields[propId.parsePropK] = Value.of(value.value);
    });
    return this;
  }
}

/// Pluto 表格数据源实现
class RecordDataGridSourcePluto extends IRecordDataGridSource {
  RecordDataGridSourcePluto({
    required this.meta,
    required this.cachedRows,
    required this.cachedColumns,
    this.stateManager,
  });

  @override
  final RecordMeta meta; // 地址不变,但属性值会变

  final List<PlutoRow> cachedRows;

  final List<PlutoColumn> cachedColumns;

  // 在活跃时,通过[stateManager]更新UI
  PlutoGridStateManager? stateManager;

  @override
  onInsertEvt(Record record) {
    print("onInsertEvt $record");
    // 如果是非活跃状态下... 则只添加Widget, 因为不需要刷新UI
    cachedRows.add(record.toPlutoRow());
    // 活跃状态下, 提醒刷新UI, 由于List<Row>地址值是一致的, manager内部的List也会被更新
    // todo 优化:只刷新指定行
    stateManager?.notifyListeners();
  }

  @override
  onUpdateEvt(Record record, int index) {
    print("onUpdateEvt $record $index");
    // todo 优化:只刷新指定行
    stateManager?.notifyListeners();
  }

  @override
  onRemoveEvt(ObjectId recordId, int index) {
    print("onRemoveEvt $index");
    // 如果是非活跃状态下... 则只移除Widget, 因为不需要刷新UI
    cachedRows.removeWhere((element) => element.key == ValueKey(recordId));
    // todo 优化:只刷新指定行
    stateManager?.notifyListeners();
  }
}

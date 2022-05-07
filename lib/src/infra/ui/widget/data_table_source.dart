import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:logging/logging.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/config/common_config.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_edit.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// 用于构建一张表的数据源, 包含Meta和Rows的数据, 相关Rows的Stream
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
      .toList();

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

/// Pluto 表格实现
class RecordDataGridSourcePluto extends IRecordDataGridSource {
  const RecordDataGridSourcePluto(this.meta, this.manager);

  factory RecordDataGridSourcePluto.of({
    required RecordMeta meta,
    required List<Record> cachedRecords,
    required Record Function(ObjectId recordId, {ObjectId? metaId}) queryRecord,
    required Future<void> Function(RecordDto? dto) onSaveRecord,
    required Widget Function(PlutoGridStateManager manager) createTitleBar,
    required Future<void> Function(ObjectId ettId) onRemoveRecord,
  }) =>
      RecordDataGridSourcePluto(
        meta,
        // actSaveRecord,
        PlutoGridStateManager(
          columns: meta.toColumnsHeader,
          rows: cachedRecords.map((e) => e.toPlutoRow()).toList(),
          // scroll: , // 可空, 自动填充
          // columnGroups: columnGroups, // 列组,暂不需要
          // select 选择模式: 配合 onSelect回调,执行被选中时的事件
          mode: PlutoGridMode.normal,
          onChangedEventCallback: (e) {
            assert(e.row != null, "row is null!");
            assert(e.column != null, "column is null!");
            // 更新一整行数据 todo 在这里修改更新单个字段
            final recordId = (e.row!.key as ValueKey<ObjectId>).value;
            // 查询本地已缓存数据,并得到用于提交的DTO
            final dto = queryRecord(recordId, metaId: meta.id)
                .toDto()
                .updateBy(meta, e.row!);
            // print("debug # 更新数据 $dto");
            onSaveRecord(dto);
          },
          onSelectedEventCallback: (e) {
            print("onSelectedEventCallback $e");
          },
          onRowCheckedEventCallback: (e) {
            print("onRowCheckedEventCallback $e");
          },
          onRowDoubleTapEventCallback: (e) {
            print("onRowDoubleTapEventCallback $e");
          },
          onRowSecondaryTapEventCallback: (e) {
            print("onRowSecondaryTapEventCallback $e");
          },
          onRowsMovedEventCallback: (e) {
            print("onRowsMovedEventCallback $e");
            assert(e.rows != null, "row is null!");
            for (var row in e.rows!) {
              final recordId = (row!.key as ValueKey<ObjectId>).value;
              onRemoveRecord(recordId);
            }
          },
          // 这是表格标题! 不是列头
          createHeader: createTitleBar,
          // createFooter: createFooter,
          configuration: const PlutoGridConfiguration(
            // columnHeight: 30.0,
            // columnFilterHeight: 30.0,
            // rowHeight: 30.0,
            // defaultCellPadding: 15,
            // defaultColumnTitlePadding: 15,
            // iconSize: 15,
            enableColumnBorder: true,
            // enableGridBorderShadow: true,
            enableMoveHorizontalInEditing: true,
            // enableRowColorAnimation: false,
            // checkedColor: const Color(0x876FB0FF),
            /// 以下两项配置列移动,
            enableMoveDownAfterSelecting: true,
            enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveDown,
            gridBorderRadius: BorderRadius.all(Radius.circular(10)),
            gridPopupBorderRadius: BorderRadius.all(Radius.circular(7)),
            scrollbarConfig: PlutoGridScrollbarConfig(
              isAlwaysShown: false,
              scrollbarThickness: 8,
              scrollbarThicknessWhileDragging: 10,
            ),
            // localeText: const PlutoGridLocaleText.korean(),
            //   columnFilterConfig: PlutoGridColumnFilterConfig(
            //     filters: const [
            //       ...FilterHelper.defaultFilters,
            //       // ClassYouImplemented(),
            //     ],
            //     resolveDefaultColumnFilter: (column, resolver) {
            //       if (column.field == 'column3') {
            //         return resolver<PlutoFilterTypeGreaterThan>()
            //             as PlutoFilterType;
            //       }
            //
            //       return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
            //     },
            //   ),
          ),
          // rowColorCallback: rowColorCallback,  // 行颜色
        ),
      );

  @override
  final RecordMeta meta;
  final PlutoGridStateManager manager;

  @override
  onInsertEvt(Record record) {
    print("onInsertEvt $record");
    manager.appendRows([
      record.toPlutoRow(),
    ]);
  }

  @override
  onUpdateEvt(Record record, int index) {
    print("onUpdateEvt $record $index");
  }

  @override
  onRemoveEvt(ObjectId recordId, int index) {
    print("onRemoveEvt $index");
    final row =
        manager.rows.firstWhere((element) => element.key == ValueKey(recordId));
    manager.removeRows([row]);
  }
}


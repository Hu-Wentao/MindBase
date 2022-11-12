import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/domain/value/value.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';
import 'package:pluto_grid/pluto_grid.dart';

/// 用于缓存一个表格的Cell Widget, 当数据源更新时,也同步更新Widget
abstract class IRecordDataGridSource {
  const IRecordDataGridSource();

  MetaModel get meta;

  // 后端插入事件
  onInsertEvt(RecordModel record);

  // 后端更新事件
  onUpdateEvt(RecordModel record, int index);

  // 后端移除事件
  onRemoveEvt(String recordId, int index);
}

extension TableViewX on TableView {
  /// 转换列，适配View
  List<PlutoColumn> transformCols(List<PlutoColumn> plutoCols) {
    final r = <PlutoColumn>[];
    for (final info in cols) {
      final col = plutoCols.firstWhereOrNull((col) => col.field == info.propId)
        ?..width = info.width
        ..minWidth = info.minWidth
        ..hide = !info.visible;
      if (col != null) r.add(col);
    }
    return r;
  }
}

// extension PlutoMetaModelX on MetaModel {
//   List<PlutoColumn> toPlutoCols(MetaModel openedMeta) => properties
//       .map((prop) => PlutoColumn(
//             title: prop.name,
//             // 展示在UI的列标题
//             // titleSpan:  // 会覆盖 title参数的效果
//             field: prop.propId,
//             // 字段propId
//             type: _buildColumnTypeBy(prop),
//             // readOnly: // 某些字段需要标记为只读
//             // frozen:  // 冻结列
//             //  sort:  // 排序
//             //   renderer // 渲染为自定义Widget
//             enableColumnDrag: true,
//             enableAutoEditing: true,
//             // 自动切换编辑
//             enableEditingMode: true,
//             // 允许编辑
//             // this.hide = false,// 隐藏列
//             renderer: prop.type.isRef
//                 ? (rdCtx) => GridRefCellWidget(prop.type, rdCtx, openedMeta)
//                 : null,
//           ))
//       .toList()
//     ..[0].enableRowDrag = true
//     ..[0].enableRowChecked = true;
//
//   PlutoColumnType _buildColumnTypeBy(PropertyDto prop) {
//     switch (prop.type.tp) {
//       case AttrTp.any:
//       case AttrTp.objectId:
//       case AttrTp.string:
//         return PlutoColumnType.text();
//       case AttrTp.num:
//         return PlutoColumnType.number();
//       case AttrTp.bool:
//         return PlutoColumnType.select([true, false]);
//       case AttrTp.ref:
//         // todo 关系型怎么展示 ?
//         return PlutoColumnType.text();
//       // return PlutoColumnType.select(prop.type.ref.map((ref)=>ref.name).toList());
//     }
//   }
// }

/// Ref单元格, 可以通过弹出GridPopup来选择其他记录
/// Ref单元格, 可以通过弹出GridPopup来选择其他记录
class GridRefCellWidget extends StatefulWidget {
  final MetaModel meta;
  final AttrTypeDto type;
  final PlutoColumnRendererContext rdCtx;

  const GridRefCellWidget(this.type, this.rdCtx, this.meta, {Key? key})
      : super(key: key);

  @override
  State<GridRefCellWidget> createState() => _GridRefCellWidgetState();
}

class _GridRefCellWidgetState extends State<GridRefCellWidget> {
  @override
  Widget build(BuildContext context) {
    PlutoColumnRendererContext rdCtx = widget.rdCtx;
    final refMetaId = (widget.type.r!);
    return TextButton(
      onPressed: () {
        final refDataSource = widget.meta.at.findMeta(refMetaId)!.dataSource;
        /// pop菜单
        PlutoGridPopup(
          context: context,
          columns: refDataSource.cachedColumns,
          rows: refDataSource.cachedRows,
          width: 600,
          mode: PlutoGridMode.select,
          // onLoaded: (PlutoGridOnLoadedEvent event) {
          //   // rows
          //   //     .asMap()
          //   //     .entries
          //   //     .forEach((element) {
          //   //   final cell = element.value.cells[selectFieldName]!;
          //   //
          //   //   if (cell.value.toString() == controller.text) {
          //   //     event.stateManager.setCurrentCell(cell, element.key);
          //   //     event.stateManager
          //   //         .moveScrollByRow(PlutoMoveDirection.up, element.key + 1);
          //   //   }
          //   // });
          //   // event.stateManager.setShowColumnFilter(true);
          // },
          onSelected: (PlutoGridOnSelectedEvent event) {
            // 选择记录之后..
            print("onSelected $event, ${event.row!.cells}");
            // 选中记录的Id
            final selectRefRecordId =
                (event.row!.key as ValueKey<String>).value;
            final originRecordId = rdCtx.row.key as ValueKey<String>;

            // 更新的Record(todo 考虑改为只更新单个字段)
            final dto = widget.meta.records
                .firstWhere((rcd) => rcd.id == originRecordId.value)
                .toDto()
                .updateOnlyBy(rdCtx.column, selectRefRecordId);
            widget.meta.actSaveRecord(dto);
          },
        );
      },
      child: Text(
        // 展示RecordId
        '${rdCtx.row.cells[rdCtx.column.field]!.value}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Pluto 表格数据源实现
extension PlutoMetaModelX on MetaModel {
  List<PlutoColumn> toPlutoCols() => properties
      .map((prop) => PlutoColumn(
            title: prop.name,
            // 展示在UI的列标题
            // titleSpan:  // 会覆盖 title参数的效果
            field: prop.propId,
            // 字段propId
            type: _buildColumnTypeBy(prop.type),
            // readOnly: // 某些字段需要标记为只读
            // frozen:  // 冻结列
            //  sort:  // 排序
            //   renderer // 渲染为自定义Widget
            enableColumnDrag: true,
            enableAutoEditing: true,
            // 自动切换编辑
            enableEditingMode: true,
            // 允许编辑
            // this.hide = false,// 隐藏列
            renderer: prop.type.isRef
                ? (rdCtx) => GridRefCellWidget(prop.type, rdCtx, this)
                : null,
          ))
      .toList()
    ..[0].enableRowDrag = true
    ..[0].enableRowChecked = true;

  PlutoRow toPlutoRow(RecordModel record) => PlutoRow(
        // 将id作为key,以便接收更新事件时,查询是哪一个record
        key: ValueKey<String>(record.id),
        cells: Map.fromEntries(properties.map((prop) => MapEntry(
              prop.propId,
              PlutoCell(value: record.eval(prop)),
            ))),
      );

  PlutoColumnType _buildColumnTypeBy(AttrTypeDto type) {
    switch (type.tp) {
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

extension PlutoRecordDtoX on RecordDto {
  // 更新全部,(其实可以只更新一个字段)
  RecordDto updateBy(PlutoRow row) {
    row.cells.forEach((propId, value) {
      fields[propId.parsePropK] = Value.of(value.value);
    });
    return this;
  }

  /// 更新某个属性
  RecordDto updateOnly(PlutoColumn col, PlutoRow row) {
    final propId = col.field;
    final newValue = row.cells[propId]!.value;
    return updateOnlyBy(col, newValue);
  }

  /// 更新某个属性
  RecordDto updateOnlyBy(PlutoColumn col, dynamic value) {
    final propId = col.field;
    fields[propId.parsePropK] = ValueDto.of(value);
    return this;
  }
}

/// Pluto 表格数据源实现
class RecordDataGridSourcePluto extends IRecordDataGridSource {
  RecordDataGridSourcePluto({
    required this.meta,
    required this.findRecord,
    required this.cachedRows,
    required this.cachedColumns,
    this.stateManager,
  });

  @override
  final MetaModel meta; // 地址不变,但属性值会变
  final FindRecordFn findRecord;
  final List<PlutoRow> cachedRows;

  final List<PlutoColumn> cachedColumns;

  // 在活跃时,通过[stateManager]更新UI
  PlutoGridStateManager? stateManager;

  // 新的insert方案[cachedRows]和[cachedColumns]交给stateManager管理
  @override
  onInsertEvt(RecordModel record) {
    // print("onInsertEvt ${record.fields.values}");
    stateManager!.appendRows([meta.toPlutoRow(record)]);
  }

  @override
  onUpdateEvt(
    RecordModel record,
    @Deprecated("已更新为通过record::id查询对应row,不再需要index") int index,
  ) {
    final rowKey = ValueKey<String>(record.id);
    // 通过key找到指定的row
    final originRow = stateManager!.refRows.originalList
        .firstWhere((element) => element.key == rowKey);

    // 更新该行的所有cell (字段与方法)
    originRow.cells.forEach((propId, cell) {
      final pId = propId.parsePropId();
      if (pId.isField) {
        final v = record.getField(propId.parsePropK).value;
        stateManager!.changeCellValue(cell, v);
      } else if (pId.isMethod) {
        final v = record.eval(meta.getPropBy(propId));
        stateManager!.changeCellValue(cell, v);
      }
    });
  }

  @override
  onRemoveEvt(String recordId, @Deprecated("本实现类不需要index") int index) {
    final rowKey = ValueKey<String>(recordId);
    final originRow = stateManager!.refRows.originalList
        .firstWhere((element) => element.key == rowKey);
    stateManager!.removeRows([originRow]);
  }
}

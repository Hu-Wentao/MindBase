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
  onRemoveEvt(int index);
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
  onRemoveEvt(int index) {
    print("onRemoveEvt $index");
  }
}

/// Syncfusion DataGrid的数据源
class RecordDataGridSource extends DataGridSource
    implements IRecordDataGridSource {
  late final Logger log;

  @override
  final RecordMeta meta;

  final Future<void> Function(RecordDto? dto) actSaveRecord;

  final List<Record> Function(ObjectId metaId) getCachedRecords;
  final Record Function(ObjectId metaId, int index) getCachedRecordByIndex;

  // Rows与Provider中的Record一一对应,包括元素顺序
  final List<DataGridRow> _cacheRows = [];

  // 用于查询 Attr的Key 在Grid中的index
  // late final List<String> _attrKeyList;
  RecordDataGridSource(
    this.meta,
    this.actSaveRecord,
    this.getCachedRecords,
    this.getCachedRecordByIndex,
  ) {
    log = Logger("$runtimeType");

    // 同步rows
    getCachedRecords(meta.id).forEach(onInsertEvt);
    // 全部插入后再 notifyAll
    // for (var element in cache) {
    //   renderRecord(element, null, notify: false);
    // }
    // notifyAll();
    // recordSub.onData(_onEvent);
  }

  // 源数据List 新增
  @override
  void onInsertEvt(Record record) => renderRecord(record, null);

  // 源数据List 更新
  @override
  void onUpdateEvt(Record record, int index) => renderRecord(record, index);

  // 源数据List 删除
  @override
  void onRemoveEvt(int index) => removeRecordBy(index);

  /// [rowIndex]为null时, 表示新增
  void renderRecord(Record entity, int? rowIndex, {bool notify = true}) {
    if (rowIndex == null) {
      _cacheRows.add(entityToRow(entity));
      if (notify) notifyAll();
    } else {
      _cacheRows[rowIndex] = entityToRow(entity);
      if (notify) notifyDataRow(rowIndex, entity);
    }
  }

  void removeRecordBy(int rowIndex) {
    // print("removeRecordBy: $rowIndex");
    _cacheRows.removeAt(rowIndex);
    notifyAll();
  }

  @override
  List<DataGridRow> get rows => _cacheRows;

  /// 构建Header
  /// todo #3 后期根据`视图表`,控制列展示顺序(List<GridColumn> buildColumn的元素排列顺序)与Attr的对应关系(显式)
  List<GridColumn> buildColumn(BuildContext context, WorkspaceProvider pMeta) =>
      meta.properties
          .map((prop) => GridColumn(
                columnName: prop.propId,
                label: ListTile(
                  // todo ToolTip 展示部分memo内容
                  title: Text(prop.name, overflow: TextOverflow.ellipsis),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == "edit_type") {
                        if (prop is Method) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("尚未实现 编辑表达式, 敬请期待...")));
                        } else {
                          final metaDto = meta.toDto();
                          await pMeta.actEditAttribute(
                            metaDto,
                            await showAttributeEditDialog(
                              context: context,
                              origin: (prop as Attribute).toDto(),
                              // fixme 只能编辑字段,无法编辑方法
                              queryMeta: pMeta.actQueryMeta,
                              selfMeta: metaDto,
                              queryMetaByName: pMeta.actQueryMetaByName,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("OK")));
                          // _showMetaEditDialog(context, attr);
                          // } else if (value == "delete") {
                          // _showMetaDeleteDialog(context, attr);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("尚未实现[$value]敬请期待..")));
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                          value: "edit_type",
                          padding: EdgeInsets.zero,
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text("修改类型"),
                            // trailing: Text("( ${attr.expr.rType.name} )"),
                            dense: true,
                          )),
                      const PopupMenuItem(
                          value: "edit_memo",
                          padding: EdgeInsets.zero,
                          child: ListTile(
                            leading: Icon(Icons.notes),
                            title: Text("修改描述"),
                            // trailing: Text(attr.expr.rType.name),
                            dense: true,
                          )),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                          value: "edit_insert_attr",
                          padding: EdgeInsets.zero,
                          child: ListTile(
                            leading: Icon(Icons.chevron_right),
                            title: Text("插入一列"),
                            // trailing: Text(attr.expr.rType.name),
                            dense: true,
                          )),
                      // PopupMenuItem(
                      //     child: ListTile(
                      //   leading: const Text("列类型"),
                      //   title: Text(attr.expr.rType.name),
                      // )),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                          value: "view_hide_attr",
                          padding: EdgeInsets.zero,
                          child: ListTile(
                            leading: Icon(Icons.visibility_outlined),
                            title: Text("隐藏本列"),
                            // trailing: Text(attr.expr.rType.name),
                            dense: true,
                          )),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: "edit_delete_attr",
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text("删除"),
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                ),
                columnWidthMode: ColumnWidthMode.fill,
              ))
          .toList();

  /// 实体类-> Row对象
  /// 在这里指定Row的类型
  DataGridRow entityToRow(Record record) => DataGridRow(
        cells: meta.properties.map((prop) {
          final value = record.getValueBy(prop);
          return DataGridCell<Value>(columnName: prop.propId, value: value);
        }).toList(),
      );

  /// DataGridRow -> Widget
  /// DataGridRow由[entityToRow]构成
  /// 在这里为不同Attr的数据返回不同类型的 Show Widget
  /// 可以考虑提交一个而入Column的PR, 以便实现调整Column顺序的功能
  int c = 0; // 记录删除记录的index值
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) => DataGridRowAdapter(
          cells: row.getCells().asMap().entries.map((entry) {
        final cell = entry.value as DataGridCell<Value>;
        final cellColIndex = entry.key;
        // todo #3 后期需要根据`视图表`获取列展示顺序与Attr的对应关系
        final prop = meta.properties[cellColIndex];
        int index = c;
        late Widget cellWidget;
        switch (prop.type.tp) {
          case AttrTp.objectId:
            cellWidget = _buildShowObjectId(cell.value!);
            break;
          case AttrTp.num:
          case AttrTp.string:
            cellWidget = _buildShowString(cell.value!);
            break;
          case AttrTp.bool:
            cellWidget = _buildShowBool(cell.value!);
            break;
          case AttrTp.ref:
          case AttrTp.any:

            /// fixme 考虑改用contextMenu
            cell.columnName == "a0"
                ? cellWidget = _buildShowAnyButton(cell.value!, index++)
                : cellWidget = _buildShowAny(cell.value!);
            break;
        }
        return cellWidget;
      }).toList());

  Widget _buildShowObjectId(Value value) => Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        // color: Colors.black12,
        child: Text(
          value.value,
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
      );

  Widget _buildShowAny(Value value) => _buildShowString(value);

  _buildShowAnyButton(Value value, int index) => Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Consumer<WorkspaceProvider>(
            builder: (c, pWorkspace, _) => PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                iconSize: 18,
                itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                          value: "delete",
                          padding: EdgeInsets.zero,
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text("删除记录"),
                            dense: true,
                          ))
                    ],
                onSelected: (String val) {
                  if (val == "delete") {
                    pWorkspace.actRemoveRecordBy(index);

                    ScaffoldMessenger.of(c)
                        .showSnackBar(const SnackBar(content: Text("OK")));
                  } else {
                    ScaffoldMessenger.of(c).showSnackBar(
                        SnackBar(content: Text("尚未实现[$val]敬请期待..")));
                  }
                }),
          ),
          Text(
            value.toString(),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ));

  Widget _buildShowString(Value value) => Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(
          value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _buildShowBool(Value value) => Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Checkbox(
          // fixme 尚未完全实现类型模式,只能通过字符串匹配
          value: value.value == "true",
          onChanged: (bool? value) {
            // fixme 应该屏蔽CheckBox的点击事件, 或者点击后立即切换到 buildWidget,并应用新的值
            print("onChanged: $value");
          },
        ),
      );

  /// todo 可编辑的单元格
  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

  // String? newCellValue;
  /// 在这里为不同Attr的数据返回不同类型的 Edit Widget
  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    // fixme 通过index查询prop容易出错, #125 如果新增了checkbox列,通过index查列会导致真实值偏移
    final sourceProp = meta.properties[rowColumnIndex.columnIndex];
    // 选择指定行的数据
    final sourceRow = getCachedRecordByIndex(meta.id, rowColumnIndex.rowIndex);

    // fixme 如果动态新增了列,则原有对象是没有与新列对应的value的
    final sourceValue = sourceRow.getFieldByColumn(column.columnName);
    final displayText = sourceValue.value;
    // final displayText = sourceRow.toGridKeyValueMap()[column.columnName]!.v;
    slLogger.info("buildEditWidget:displayText# $displayText");

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    // newCellValue = null;

    // if (column.columnName == 'Shipped Date') {
    //   return _buildDateTimePicker(displayText, submitCell);
    // } else if (column.columnName == 'Ship Country') {
    //   return _buildDropDownWidget(displayText, submitCell, _shipCountry);
    // } else if (column.columnName == 'Ship City') {
    //   final String shipCountry = dataGridRow
    //           .getCells()
    //           .firstWhereOrNull((DataGridCell dataGridCell) =>
    //               dataGridCell.columnName == 'Ship Country')
    //           ?.value
    //           ?.toString() ??
    //       '';
    //   return _buildDropDownWidget(displayText == '' ? null : displayText,
    //       submitCell, _shipCity[shipCountry]!);
    // } else {\
    late Widget editWidget;
    switch (sourceProp.type.tp) {
      case AttrTp.objectId:
        if (sourceProp is Attribute) {
          editWidget = _buildEditObjectId(sourceProp, sourceValue, submitCell);
        } else {
          editWidget = const Text("暂不支持编辑Method");
        }
        break;
      case AttrTp.string:
        editWidget = DataTableEditText(
          editingController: editingController..text = displayText,
          // displayText: displayText,
          rowColumnIndex: rowColumnIndex,
          column: column,
          submitCell: submitCell,
        );
        break;
      case AttrTp.ref:
        editWidget = DataTableEditRef(
          type: sourceProp.type,
          editCtrl: editingController..text = displayText,
          rowColumnIndex: rowColumnIndex,
          column: column,
          submitCell: submitCell,
        );
        break;
      case AttrTp.any:
      case AttrTp.num:
      case AttrTp.bool:
        // case AttrTp.date:
        editWidget = DataTableEditText(
          editingController: editingController..text = displayText,
          // displayText: displayText,
          rowColumnIndex: rowColumnIndex,
          column: column,
          submitCell: submitCell,
        );
        // TODO: Handle this case.
        break;
    }
    return editWidget;
  }

  /// 编辑对象ID Widget
  Widget _buildEditObjectId(
    Attribute attr,
    Value sourceValue,
    CellSubmit submitCell,
  ) {
    // 如果k==0||k==1,则不可编辑(Id和metaId) #3 属于-1级权限
    if (attr.k == 0 || attr.k == 1) {
      return Tooltip(
        child: _buildShowObjectId(sourceValue),
        message: '[ID]与[MetaID]不可编辑',
      );
    }
    // return _buildShowObjectId(sourceValue);

    // todo #5 后期改为弹出metaId对应的Record列表,以供选择
    // final metaDto = meta.toDto();
    // 选取 Attr上指定的MetaId下的Record::Id
    final metaId = attr.meta!.id;
    //fixme #4 Expression::metaId不能为null! 需要新增dto
    final allRecordInMeta = getCachedRecords(metaId);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 220,
          child: FormBuilderSearchableDropdown<Record>(
            decoration: const InputDecoration(labelText: '所选Meta下的RecordId'),
            name: 'recordId',
            // initialValue: null,
            itemAsString: (meta) => meta?.id.toHexString() ?? sourceValue.value,
            //空则选择默认值
            // items: allCountries,
            onChanged: (value) {
              editingController.text =
                  // newCellValue =
                  (value == null) ? sourceValue.value : value.id.toHexString();
            },
            showSearchBox: true,
            isFilteredOnline: true,
            compareFn: (item, selected) => item?.id == selected?.id,
            onFind: (text) async {
              if (text?.isEmpty ?? true) {
                return allRecordInMeta;
              } else {
                final lowerText = text!.toLowerCase();
                return allRecordInMeta
                    .where((element) =>
                        element.id.toHexString().contains(lowerText))
                    .toList();
              }
            },
          ),
        ),
        IconButton(
            onPressed: () {
              print("debug ## 选中记录: ${editingController.text}");
              // print("debug ## 选中记录: $newCellValue");
              submitCell();
            },
            icon: const Icon(Icons.check))
      ],
    );
  }

  /// todo 单元格数据提交
  /// 本方法结束后将会自动刷新指定[RowColumnIndex]对应的Cell
  /// fixme 当前是假设 [cache]和[_cacheRows]对视index一一对应的,
  /// 一旦后期允许row重排序,对应关系将只能依赖::firstWhere遍历查询得到,详见官方示例代码
  @override
  void onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn col,
  ) {
    print("debug onCellSubmit text# ${editingController.text}");

    final Record oldEntity =
        getCachedRecordByIndex(meta.id, rowColumnIndex.rowIndex);
    final oldValue = oldEntity.tryGetFieldByColumn(col.columnName);
    if (oldValue?.value == editingController.text) {
      // if (newCellValue == null ||
      //     oldValue == null ||
      //     oldValue.v == newCellValue) {
      return;
    }
    // final nGridMap = oldGridMap
    //   ..[col.columnName] = Value.of(newCellValue, oldValue.e);
    //
    // final entity = Record.fromGridKeyValueMap(oldEntity, nGridMap);
    final entity = oldEntity.updateWith(
      propId: col.columnName,
      value: Value.of(editingController.text),
      // value: Value.of(newCellValue),
    );
    // ..setFieldByColumn(col.columnName, Value.of(newCellValue, oldValue.e));

    // 替换单元格内的值 (save成功后,watch到消息将会自动notify)
    renderRecord(entity, rowColumnIndex.rowIndex, notify: false);
    // fixme 没有检查保存是否成功， 考虑添加保存失败时回滚初始值的逻辑
    actSaveRecord(entity.toDto());
  }

  // 更新一整行
  notifyDataRow(int rowIndex, Record entity) {
    log.info("刷新一行数据");
    // fixme 如果后期支持手动排序列,本方法将出错
    meta.properties.map((e) {
      // final colIndex = _attrKeyList.indexOf("${e.k}");
      final colIndex = meta.properties.indexOf(e);
      // 更新指定单元格
      notifyDataSourceListeners(
        rowColumnIndex: RowColumnIndex(rowIndex, colIndex),
      );
    });
  }

  // 更新全体数据, 当row新增或移除时调用
  notifyAll() {
    log.info("刷新全部数据");
    notifyListeners();
  }

  void dispose() {
    // recordSub.cancel();
    super.dispose();
  }
}

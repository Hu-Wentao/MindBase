import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:logging/logging.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/config/common_config.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/record_edit_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_edit.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../domain/entity/func.dart';

/// 用于构建一张表的数据源, 包含Meta和Rows的数据, 相关Rows的Stream
abstract class IRecordDataGridSource extends DataGridSource {
  RecordMeta get meta;

  // Future<void> Function(RecordDto? dto) get actSaveRecord;

  void renderRecord(Record entity, int? rowIndex, {bool notify = true});

  void removeRecordBy(int rowIndex);

  // @override
  // List<DataGridRow> get rows => _cacheRows;

  /// 构建Header
  List<GridColumn> buildColumn(BuildContext context, WorkspaceProvider pMeta);

  /// 实体类-> Row对象
  /// todo 在这里指定Row的类型
  @visibleForOverriding
  DataGridRow entityToRow(Record recordDto);

  /// DataGridRow -> Widget
  /// DataGridRow由[entityToRow]构成
  /// todo 在这里为不同Attr的数据返回不同类型的Widget
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) => DataGridRowAdapter(
      cells: row
          .getCells()
          .map((e) => Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  e.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList());

  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  );

  /// todo 单元格数据提交
  /// 本方法结束后将会自动刷新指定[RowColumnIndex]对应的Cell
  /// fixme 当前是假设 [cache]和[_cacheRows]对视index一一对应的,
  /// 一旦后期允许row重排序,对应关系将只能依赖::firstWhere遍历查询得到,详见官方示例代码
  @override
  void onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn col,
  );

  // 更新一整行
  @visibleForOverriding
  notifyDataRow(int rowIndex, Record entity);

  // 更新全体数据, 当row新增或移除时调用
  @visibleForOverriding
  notifyAll() {
    // log.info("刷新全部数据");
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RecordDataGridSource2 extends IRecordDataGridSource {
  late final Logger log;

  @override
  final RecordMeta meta;

  @override
  final Future<void> Function(RecordDto? dto) actSaveRecord;

  final List<Record> Function(ObjectId metaId) getCachedRecords;
  final Record Function(ObjectId metaId, int index) getCachedRecordByIndex;

  // Rows与Provider中的Record一一对应,包括元素顺序
  final List<DataGridRow> _cacheRows = [];

  // 用于查询 Attr的Key 在Grid中的index
  // late final List<String> _attrKeyList;
  RecordDataGridSource2(
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
  void onInsertEvt(Record record) => renderRecord(record, null);

  // 源数据List 更新
  void onUpdateEvt(Record record, int index) => renderRecord(record, index);

  // 源数据List 删除
  void onRemoveEvt(int index) => removeRecordBy(index);

  /// [rowIndex]为null时, 表示新增
  @override
  void renderRecord(Record entity, int? rowIndex, {bool notify = true}) {
    if (rowIndex == null) {
      _cacheRows.add(entityToRow(entity));
      if (notify) notifyAll();
    } else {
      _cacheRows[rowIndex] = entityToRow(entity);
      if (notify) notifyDataRow(rowIndex, entity);
    }
  }

  @override
  void removeRecordBy(int rowIndex) {
    // print("removeRecordBy: $rowIndex");
    _cacheRows.removeAt(rowIndex);
    notifyAll();
  }

  @override
  List<DataGridRow> get rows => _cacheRows;

  /// 构建Header
  /// todo #3 后期根据`视图表`,控制列展示顺序(List<GridColumn> buildColumn的元素排列顺序)与Attr的对应关系(显式)
  @override
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
  /// todo 在这里指定Row的类型
  @override
  DataGridRow entityToRow(Record record) => DataGridRow(
        cells: meta.properties.map((prop) {
          final value = record.getValueBy(prop);
          return DataGridCell<Value>(columnName: prop.propId, value: value);
        }).toList(),
      );

  /// DataGridRow -> Widget
  /// DataGridRow由[entityToRow]构成
  /// todo 在这里为不同Attr的数据返回不同类型的Widget
  /// todo 可以考虑提交一个而入Column的PR, 以便实现调整Column顺序的功能

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
  @override
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
  @override
  notifyAll() {
    log.info("刷新全部数据");
    notifyListeners();
  }

  @override
  void dispose() {
    // recordSub.cancel();
    super.dispose();
  }
}

class RecordDataGrid extends StatefulWidget {
  factory RecordDataGrid.build({
    Key? key,
    dataGridSourceWithCtrl,
    onSaveRecord,
    onSaveMeta,
  }) =>
      RecordDataGrid(
        key: key,
        dataGridSource: dataGridSourceWithCtrl.value1,
        dataGridController: dataGridSourceWithCtrl.value2,
        onSaveRecord: onSaveRecord,
        onSaveMeta: onSaveMeta,
      );

  const RecordDataGrid({
    Key? key,
    required this.dataGridSource,
    required this.dataGridController,
    required this.onSaveRecord,
    required this.onSaveMeta,
  }) : super(key: key);

  final RecordDataGridSource2 dataGridSource;
  final DataGridController dataGridController;

  final Future<void> Function(RecordDto? dto) onSaveRecord;
  final Future<void> Function(RecordMetaDto? dto) onSaveMeta;

  @override
  _RecordDataGridState createState() => _RecordDataGridState();
}

class _RecordDataGridState extends State<RecordDataGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // todo 监听并调整行列样式
    // isLandscapeInMobileView = !isWebOrDesktop &&
    //     MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) => Consumer<WorkspaceProvider>(
        builder: (c, pMeta, _) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题栏按钮
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: DataFrameTitle(
                  onSaveMeta: widget.onSaveMeta,
                  onSaveRecord: widget.onSaveRecord,
                  meta: widget.dataGridSource.meta,
                ),
              ),
              Expanded(
                child: SfDataGrid(
                  source: widget.dataGridSource,
                  // 展示最左侧CheckBox列
                  // showCheckboxColumn: true,
                  // checkboxColumnSettings: const DataGridCheckboxColumnSettings(
                  //   showCheckboxOnHeader: true,
                  // ),
                  // 展示排序数
                  // showSortNumbers: true, //
                  // 填充宽度
                  columnWidthMode: ColumnWidthMode.fill,
                  // todo 使用 Column Resizing 以便调整列宽
                  columns: widget.dataGridSource.buildColumn(context, pMeta),
                  // 允许编辑单元格数据
                  allowEditing: true,
                  // 双击编辑
                  editingGestureType: EditingGestureType.doubleTap,
                  // 单击选中,再点取消
                  selectionMode: SelectionMode.singleDeselect,
                  // 选中单元格(以便编辑选中cell的值)
                  navigationMode: GridNavigationMode.cell,
                  // 选中单元格 需要配合[DataGridController]
                  // selectionManager: SelectionManagerBase(),
                  controller: widget.dataGridController,
                  // stackedHeaderRows: [StackedHeaderRow(cells: [StackedHeaderCell(columnNames: ['a0','a1'], child: Text("T形合并Header"))])],
                  // 冻结前n列
                  // frozenColumnsCount:1,
                  // todo #126
                  // onCellLongPress: (DataGridCellLongPressDetails details) {
                  //   if (!isDesktop) {
                  //     final RenderBox renderObject =
                  //     context.findRenderObject()! as RenderBox;
                  //     showMenu(
                  //         context: context,
                  //         position: RelativeRect.fromRect(
                  //             details.globalPosition & Size.zero,
                  //             Offset.zero & renderObject.size),
                  //         items: buildMenuItems(details.column));
                  //   }
                  // },
                  // onCellSecondaryTap: (DataGridCellTapDetails details) {
                  //   // if (isDesktop) {
                  //   final RenderBox renderObject =
                  //       context.findRenderObject()! as RenderBox;
                  //   final Offset localPosition =
                  //       renderObject.globalToLocal(details.globalPosition);
                  //   showMenu(
                  //       context: context,
                  //       position: RelativeRect.fromSize(
                  //           localPosition & Size.zero, renderObject.size),
                  //       items: buildMenuItems(details.column));
                  //   // }
                  // },
                  // 展示单元格/Header网格
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
    // timer.cancel();
    // todo 关闭监听
  }
}

///
/// 表格标题栏
class DataFrameTitle extends StatelessWidget {
  final RecordMeta meta;
  final Future<void> Function(RecordDto? dto) onSaveRecord;
  final Future<void> Function(RecordMetaDto? dto) onSaveMeta;
  final _kRecordBuilder = GlobalKey<FormBuilderState>();
  final kMetaBuilder = GlobalKey<FormBuilderState>();
  final kAttrBuilder = GlobalKey<FormBuilderState>();
  final kMethodBuilder = GlobalKey<FormBuilderState>();

  DataFrameTitle({
    Key? key,
    required this.meta,
    required this.onSaveMeta,
    required this.onSaveRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          TextButton.icon(
            onPressed: () async => await onSaveMeta(
              await showRecordMetaEditDialog(
                context: context,
                originMeta: meta.toDto(),
                kMetaBuilder: kMetaBuilder,
                kAttrBuilder: kAttrBuilder,
                kMethodBuilder: kMethodBuilder,
              ),
            ),
            icon: const Icon(Icons.edit),
            label: const Text("修改结构"),
          ),
          TextButton.icon(
            onPressed: () async => await onSaveRecord(
              await showRecordEditDialog(
                context: context,
                meta: meta,
                kRecordBuilder: _kRecordBuilder,
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text("新增记录"),
          ),
          Consumer<WorkspaceProvider>(
              builder: (c, pWorkspace, _) => TextButton.icon(
                    onPressed: () => showConfirmDialog(
                        context: context,
                        title: "确认删除[${meta.name}]表吗",
                        onConfirm: () => pWorkspace.actRemoveMeta(meta.id)),
                    icon: const Icon(Icons.delete),
                    label: const Text("删除表"),
                  )),
        ],
      );
}

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
import 'package:mind_base/src/infra/ui/dialog/record_edit_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
  void removeRecordBy(int index) {
    _cacheRows.removeAt(index);
    notifyAll();
  }

  @override
  List<DataGridRow> get rows => _cacheRows;

  /// 构建Header
  /// todo #3 后期根据`视图表`,控制列展示顺序(List<GridColumn> buildColumn的元素排列顺序)与Attr的对应关系(显式)
  @override
  List<GridColumn> buildColumn(BuildContext context, WorkspaceProvider pMeta) =>
      meta.attributes
          .map((attr) => GridColumn(
                columnName: "${attr.k}",
                label: ListTile(
                  // todo ToolTip 展示部分memo内容
                  title: Text(attr.name, overflow: TextOverflow.ellipsis),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == "edit_type") {
                        final metaDto = meta.toDto();
                        await pMeta.actEditAttribute(
                          metaDto,
                          await showAttributeEditDialog(
                            context: context,
                            origin: attr.toDto(),
                            queryMeta: pMeta.actQueryMeta,
                            selfMeta: metaDto,
                            queryMetaByName: pMeta.actQueryMetaByName,
                          ),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text("OK")));
                        // _showMetaEditDialog(context, attr);
                        // } else if (value == "delete") {
                        // _showMetaDeleteDialog(context, attr);
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
        cells: meta.attributes.map((attr) {
          final value = record.getValueWithCalc(attr);
          return DataGridCell<Value>(columnName: "${attr.k}", value: value);
        }).toList(),
      );

  /// DataGridRow -> Widget
  /// DataGridRow由[entityToRow]构成
  /// todo 在这里为不同Attr的数据返回不同类型的Widget
  /// todo 可以考虑提交一个而入Column的PR, 以便实现调整Column顺序的功能
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) => DataGridRowAdapter(
          cells: row.getCells().asMap().entries.map((entry) {
        final cell = entry.value as DataGridCell<Value>;
        final cellIndex = entry.key;
        // todo #3 后期需要根据`视图表`获取列展示顺序与Attr的对应关系
        final attr = meta.attributes[cellIndex];

        late Widget cellWidget;
        switch (attr.expr.rType) {
          case AttrType.objectId:
            cellWidget = _buildShowObjectId(cell.value!);
            break;
          case AttrType.string:
          case AttrType.num:
          case AttrType.bool:
          case AttrType.date:
          case AttrType.any:
            cellWidget = _buildShowAny(cell.value!);
        }
        return cellWidget;
      }).toList());

  Widget _buildShowObjectId(Value value) => Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        // color: Colors.black12,
        child: Text(
          value.v,
          maxLines: 1,
          // style: TextStyle(background: Paint()..color = Colors.black12),
          overflow: TextOverflow.fade,
        ),
      );

  Widget _buildShowAny(Value value) => Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(
          value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      );

  /// todo 可编辑的单元格
  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();
  String? newCellValue;

  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    final sourceAttr = meta.attributes[rowColumnIndex.columnIndex];
    // 选择指定行的数据
    final sourceRow = getCachedRecordByIndex(meta.id, rowColumnIndex.rowIndex);

    // 这个值作为 EditWidget的初始值
    // final String displayText = dataGridRow
    //     .getCells()
    //     .firstWhere(
    //       (DataGridCell cell) => cell.columnName == column.columnName,
    //       orElse: () =>
    //           DataGridCell<String>(columnName: column.columnName, value: ''),
    //     )
    //     .value
    //     .toString();

    // fixme 如果动态新增了列,则原有对象是没有与新列对应的value的
    final sourceValue = sourceRow.getFieldByColumn(column.columnName);
    final displayText = sourceValue.v;
    // final displayText = sourceRow.toGridKeyValueMap()[column.columnName]!.v;
    slLogger.info("buildEditWidget:displayText# $displayText");

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

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
    switch (sourceAttr.expr.rType) {
      case AttrType.objectId:
        editWidget = _buildEditObjectId(sourceAttr, sourceValue, submitCell);
        break;
      case AttrType.any:
      case AttrType.string:
      case AttrType.num:
      case AttrType.bool:
      case AttrType.date:
        editWidget = _buildTextFieldWidget(
          displayText,
          rowColumnIndex,
          column,
          submitCell,
        );
    }
    return editWidget;
  }

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
    final metaId =
        attr.expr.metaId!; //fixme #4 Expression::metaId不能为null! 需要新增dto
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
            itemAsString: (meta) => meta?.id.toHexString() ?? sourceValue.v,
            //空则选择默认值
            // items: allCountries,
            onChanged: (value) {
              newCellValue =
                  (value == null) ? sourceValue.v : value.id.toHexString();
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
              print("debug ## 选中记录: $newCellValue");
              submitCell();
            },
            icon: const Icon(Icons.check))
      ],
    );
  }

  /// Building a [TextField] for numeric and text column.
  Widget _buildTextFieldWidget(
    String displayText,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    // final bool isTextAlignRight = column.columnName == 'Product No' ||
    //     column.columnName == 'Shipped Date' ||
    //     column.columnName == 'Price';

    // final bool isNumericKeyBoardType =
    //     column.columnName == 'Product No' || column.columnName == 'Price';
    //
    // // Holds regular expression pattern based on the column type.
    // final RegExp regExp = _getRegExp(isNumericKeyBoardType, column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft, // 文本居左
      // isTextAlignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: TextAlign.left,
        // 文本居左
        // textAlign: isTextAlignRight ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        // 键盘 日间/夜间模式
        // keyboardAppearance: sampleModel.themeData.colorScheme.brightness,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          // 主题: 下划线
          focusedBorder: UnderlineInputBorder(
              // 主题色
              borderSide: BorderSide(color: Colors.black)),
        ),
        // style: textStyle,
        // cursorColor: sampleModel.backgroundColor,
        // todo 文本格式化输入, 自动过滤字符,只保留数值等等, regex仅仅针对输入的单个字符,如 "[0-9]"表示只能输入数值
        // inputFormatters: <TextInputFormatter>[
        //   FilteringTextInputFormatter.allow(regExp)
        // ],
        keyboardType: TextInputType.text,
        // todo 输入类型
        // isNumericKeyBoardType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          print("debug #onchange # $value");

          if (value.isNotEmpty) {
            // if (isNumericKeyBoardType) {
            //   newCellValue = column.columnName == 'Price'
            //       ? double.parse(value)
            //       : int.parse(value);
            // } else {
            //   newCellValue = value;
            // }
            newCellValue = value;
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          slLogger.info("buildEditWidget:onSubmitted# $value");

          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
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
    final Record oldEntity =
        getCachedRecordByIndex(meta.id, rowColumnIndex.rowIndex);
    final oldValue = oldEntity.tryGetFieldByColumn(col.columnName);
    if (newCellValue == null ||
        oldValue == null ||
        oldValue.v == newCellValue) {
      return;
    }
    // final nGridMap = oldGridMap
    //   ..[col.columnName] = Value.of(newCellValue, oldValue.e);
    //
    // final entity = Record.fromGridKeyValueMap(oldEntity, nGridMap);
    final entity = oldEntity.updateWith(
      attrKey: int.parse(col.columnName),
      value: Value.of(newCellValue),
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
    meta.attributes.map((e) {
      // final colIndex = _attrKeyList.indexOf("${e.k}");
      final colIndex = meta.attributes.indexOf(e);
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
  const RecordDataGrid({
    Key? key,
    required this.dataGridSource,
    required this.onSaveRecord,
    required this.onSaveMeta,
  }) : super(key: key);

  final RecordDataGridSource2 dataGridSource;
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
                  columnWidthMode: ColumnWidthMode.fill,
                  // todo 使用 Column Resizing 以便调整列宽
                  columns: widget.dataGridSource.buildColumn(context, pMeta),
                  allowEditing: true,
                  editingGestureType: EditingGestureType.doubleTap,
                  // 单击选中
                  selectionMode: SelectionMode.single,
                  // 选中单元格
                  navigationMode: GridNavigationMode.cell,
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

class DataFrameTitle extends StatelessWidget {
  final RecordMeta meta;
  final Future<void> Function(RecordDto? dto) onSaveRecord;
  final Future<void> Function(RecordMetaDto? dto) onSaveMeta;
  final _kRecordBuilder = GlobalKey<FormBuilderState>();
  final kMetaBuilder = GlobalKey<FormBuilderState>();
  final kAttrBuilder = GlobalKey<FormBuilderState>();

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
        ],
      );
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:logging/logging.dart';
import 'package:mind_base/src/application/provider/meta_provider.dart';
import 'package:mind_base/src/config/common_config.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/repo.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/infra/ui/dialog/record_edit_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// 用于构建一张表的数据源, 包含Meta和Rows的数据, 相关Rows的Stream
abstract class IRecordDataGridSource extends DataGridSource {
  RecordMeta get meta;

  StreamSubscription<WatchEvent<RecordDto>> get recordSub;

  Future<void> Function(RecordDto? dto) get actSaveRecord;

  void saveRecordDto(RecordDto entity, int? rowIndex, {bool notify = true}) {
    // if (rowIndex == null) {
    //   _cache.add(entity);
    //   _cacheRows.add(_entityToRow(entity));
    //   if (notify) _notifyAll();
    // } else {
    //   _cache[rowIndex] = entity;
    //   _cacheRows[rowIndex] = _entityToRow(entity);
    //   if (notify) _notifyDataRow(rowIndex, entity);
    // }
  }

  void removeRecordBy(ObjectId ettId) {
    // final ettIdHex = ettId.toHexString();
    // final index = _cache.indexWhere((element) => element.idHex == ettIdHex);
    // _cache.removeAt(index);
    // _cacheRows.removeAt(index);
    // _notifyAll();
  }

  // @override
  // List<DataGridRow> get rows => _cacheRows;

  /// 构建Header
  List<GridColumn> buildColumn(BuildContext context, MetaProvider pMeta);

  /// 实体类-> Row对象
  /// todo 在这里指定Row的类型
  @visibleForOverriding
  DataGridRow entityToRow(RecordDto recordDto);

  /// DataGridRow -> Widget
  /// DataGridRow由[entityToRow]构成
  /// todo 在这里为不同Attr的数据返回不同类型的Widget
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((e) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(
          e.value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList());
  }

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
  );

  /// todo 单元格数据提交
  /// 本方法结束后将会自动刷新指定[RowColumnIndex]对应的Cell
  /// fixme 当前是假设 [_cache]和[_cacheRows]对视index一一对应的,
  /// 一旦后期允许row重排序,对应关系将只能依赖::firstWhere遍历查询得到,详见官方示例代码
  @override
  void onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn col,
  );

  // 更新一整行
  @visibleForOverriding
  notifyDataRow(int rowIndex, RecordDto entity);

  // 更新全体数据, 当row新增或移除时调用
  @visibleForOverriding
  notifyAll() {
    // log.info("刷新全部数据");
    notifyListeners();
  }

  @override
  void dispose() {
    // initDataSub.cancel();
    recordSub.cancel();
    super.dispose();
  }
}

class RecordDataGridSource extends IRecordDataGridSource {
  late final Logger log;

  @override
  final RecordMeta meta;
  final StreamSubscription<RecordDto> initDataSub;
  @override
  final StreamSubscription<WatchEvent<RecordDto>> recordSub;
  @override
  final Future<void> Function(RecordDto? dto) actSaveRecord;

  late RecordMetaDto _metaDto;

  // 防止同一个对象状态更新后被重复缓存
  final List<RecordDto> _cache = [];
  final List<DataGridRow> _cacheRows = [];

  // 用于查询 Attr的Key 在Grid中的index
  late final List<String> _attrKeyList;

  @override
  void saveRecordDto(RecordDto entity, int? rowIndex, {bool notify = true}) {
    if (rowIndex == null) {
      _cache.add(entity);
      _cacheRows.add(entityToRow(entity));
      if (notify) notifyAll();
    } else {
      _cache[rowIndex] = entity;
      _cacheRows[rowIndex] = entityToRow(entity);
      if (notify) notifyDataRow(rowIndex, entity);
    }
  }

  @override
  void removeRecordBy(ObjectId ettId) {
    final ettIdHex = ettId.toHexString();
    final index = _cache.indexWhere((element) => element.idHex == ettIdHex);
    _cache.removeAt(index);
    _cacheRows.removeAt(index);
    notifyAll();
  }

  RecordDataGridSource(
    this.meta,
    this.initDataSub,
    this.recordSub,
    this.actSaveRecord,
  ) {
    initDataSub.onData((e) => saveRecordDto(e, null));
    recordSub.onData(_onEvent);
    _metaDto = meta.toDto();
    _attrKeyList = _metaDto.toGridKeyNameMap().keys.toList();
    log = Logger("$runtimeType");
  }

  @override
  List<DataGridRow> get rows => _cacheRows;

  /// 构建Header
  @override
  List<GridColumn> buildColumn(BuildContext context, MetaProvider pMeta) =>
      _metaDto.attributes
          .map((attr) => GridColumn(
                columnName: "${attr.k}",
                label: ListTile(
                  // todo ToolTip 展示部分memo内容
                  title: Text(attr.name, overflow: TextOverflow.ellipsis),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == "edit_type") {
                        await pMeta.actEditAttribute(
                          _metaDto,
                          await showAttributeEditDialog(
                            context: context,
                            origin: attr,
                            queryMeta: pMeta.actQueryMeta,
                            selfMeta: _metaDto,
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
  DataGridRow entityToRow(RecordDto recordDto) => DataGridRow(
        cells: _metaDto.attributes.map((attr) {
          // todo 在 orElse中根据 Attr::k 创建一个填充null的Value 实例
          final value = recordDto.getValueWithCalc(attr);
          // final value = recordDto.getValueBy(
          //   attr.k,
          //   orElse: (k) => Value.of(''),
          // );
          return DataGridCell(columnName: "${attr.k}", value: value);
        }).toList(),
      );

  /// DataGridRow -> Widget
  /// DataGridRow由[entityToRow]构成
  /// todo 在这里为不同Attr的数据返回不同类型的Widget
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((e) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(
          e.value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList());
  }

  /// todo 可编辑的单元格
  /// Help to control the editable text in [TextField] widget.
  @override
  TextEditingController editingController = TextEditingController();
  @override
  String? newCellValue;

  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    // 选择指定行的数据
    final sourceValue = _cache[rowColumnIndex.rowIndex];
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
    final displayText = sourceValue.toGridKeyValueMap()[column.columnName]!.v;
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
    // } else {
    return _buildTextFieldWidget(
      displayText,
      rowColumnIndex,
      column,
      submitCell,
    );
    // }
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
  /// fixme 当前是假设 [_cache]和[_cacheRows]对视index一一对应的,
  /// 一旦后期允许row重排序,对应关系将只能依赖::firstWhere遍历查询得到,详见官方示例代码
  @override
  void onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn col,
  ) {
    final RecordDto oldEntity = _cache[rowColumnIndex.rowIndex];
    final oldGridMap = oldEntity.toGridKeyValueMap();
    final oldValue = oldGridMap[col.columnName];
    if (newCellValue == null || oldValue!.v == newCellValue) {
      return;
    }
    final nGridMap = oldGridMap
      ..[col.columnName] = Value.of(newCellValue, oldValue.e);

    final entity = RecordDto.fromGridKeyValueMap(oldEntity, nGridMap);

    // 替换单元格内的值 (会面会自动notify)
    saveRecordDto(entity, rowColumnIndex.rowIndex, notify: false);
    // fixme 没有检查保存是否成功， 考虑添加保存失败时回滚初始值的逻辑
    actSaveRecord(entity);
  }

  // 更新一整行
  @override
  notifyDataRow(int rowIndex, RecordDto entity) {
    log.info("刷新一行数据");
    meta.attributes.map((e) {
      final colIndex = _attrKeyList.indexOf("${e.k}");
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

  void _onEvent(WatchEvent<RecordDto> event) {
    log.fine("_onEvent 数据刷新\n$event");

    // todo 本方法会在首次初始化时被调用, 短时间内连续刷新可能会造成卡顿...,
    //todo 考虑首次加载转换为Future,然后一次性转为Row后再notify / 直接为Stream做缓存节流每次返回一个List<>
    switch (event.type) {
      case WatchEventType.insert:
        saveRecordDto(event.entity!, null);
        break;
      case WatchEventType.update: // todo      update
      case WatchEventType.replace:
        final index = _cache.indexWhere((element) => element.id == event.ettId);
        saveRecordDto(event.entity!, index);
        break;
      case WatchEventType.drop: // todo         drop
      case WatchEventType.rename: // todo       rename
      case WatchEventType.dropDatabase: // todo dropDatabase
      case WatchEventType.invalidate: // todo   invalidate
      case WatchEventType.delete:
        if (event.type != WatchEventType.delete)
          print("###debug drop 尚未确认 '${event.type}'事件的机制, 按照delete处理");
        removeRecordBy(event.ettId);
        break;
    }
  }

  @override
  void dispose() {
    initDataSub.cancel();
    recordSub.cancel();
    super.dispose();
  }
}

class RecordDataGridSource2 extends IRecordDataGridSource {
  late final Logger log;

  @override
  StreamSubscription<WatchEvent<RecordDto>> get recordSub =>
      throw UnimplementedError();

  @override
  final RecordMeta meta;
  final StreamSubscription<RepoEvent<Record>> recordSub2;
  @override
  final Future<void> Function(RecordDto? dto) actSaveRecord;

  late RecordMetaDto _metaDto;

  // 防止同一个对象状态更新后被重复缓存
  List<RecordDto> _cache = [];
  final List<DataGridRow> _cacheRows = [];

  // 用于查询 Attr的Key 在Grid中的index
  late final List<String> _attrKeyList;

  @override
  void saveRecordDto(RecordDto entity, int? rowIndex, {bool notify = true}) {
    if (rowIndex == null) {
      _cache.add(entity);
      _cacheRows.add(entityToRow(entity));
      if (notify) notifyAll();
    } else {
      _cache[rowIndex] = entity;
      _cacheRows[rowIndex] = entityToRow(entity);
      if (notify) notifyDataRow(rowIndex, entity);
    }
  }

  @override
  void removeRecordBy(ObjectId ettId) {
    final ettIdHex = ettId.toHexString();
    final index = _cache.indexWhere((element) => element.idHex == ettIdHex);
    _cache.removeAt(index);
    _cacheRows.removeAt(index);
    notifyAll();
  }

  RecordDataGridSource2(
    this.meta,
    List<RecordDto> cache,
    this.recordSub2,
    this.actSaveRecord,
  ) {
    _cache = cache;
    // initDataSub.onData((e) => saveRecordDto(e, null));
    recordSub2.onData(_onEvent);
    _metaDto = meta.toDto();
    _attrKeyList = _metaDto.toGridKeyNameMap().keys.toList();
    log = Logger("$runtimeType");
  }

  @override
  List<DataGridRow> get rows => _cacheRows;

  /// 构建Header
  @override
  List<GridColumn> buildColumn(BuildContext context, MetaProvider pMeta) =>
      _metaDto.attributes
          .map((attr) => GridColumn(
                columnName: "${attr.k}",
                label: ListTile(
                  // todo ToolTip 展示部分memo内容
                  title: Text(attr.name, overflow: TextOverflow.ellipsis),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == "edit_type") {
                        await pMeta.actEditAttribute(
                          _metaDto,
                          await showAttributeEditDialog(
                            context: context,
                            origin: attr,
                            queryMeta: pMeta.actQueryMeta,
                            selfMeta: _metaDto,
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
  DataGridRow entityToRow(RecordDto recordDto) => DataGridRow(
        cells: _metaDto.attributes.map((attr) {
          // todo 在 orElse中根据 Attr::k 创建一个填充null的Value 实例
          final value = recordDto.getValueWithCalc(attr);
          // final value = recordDto.getValueBy(
          //   attr.k,
          //   orElse: (k) => Value.of(''),
          // );
          return DataGridCell(columnName: "${attr.k}", value: value);
        }).toList(),
      );

  /// DataGridRow -> Widget
  /// DataGridRow由[entityToRow]构成
  /// todo 在这里为不同Attr的数据返回不同类型的Widget
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((e) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(
          e.value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList());
  }

  /// todo 可编辑的单元格
  /// Help to control the editable text in [TextField] widget.
  @override
  TextEditingController editingController = TextEditingController();
  @override
  String? newCellValue;

  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    // 选择指定行的数据
    final sourceValue = _cache[rowColumnIndex.rowIndex];
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
    final displayText = sourceValue.toGridKeyValueMap()[column.columnName]!.v;
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
    // } else {
    return _buildTextFieldWidget(
      displayText,
      rowColumnIndex,
      column,
      submitCell,
    );
    // }
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
  /// fixme 当前是假设 [_cache]和[_cacheRows]对视index一一对应的,
  /// 一旦后期允许row重排序,对应关系将只能依赖::firstWhere遍历查询得到,详见官方示例代码
  @override
  void onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn col,
  ) {
    final RecordDto oldEntity = _cache[rowColumnIndex.rowIndex];
    final oldGridMap = oldEntity.toGridKeyValueMap();
    final oldValue = oldGridMap[col.columnName];
    if (newCellValue == null || oldValue!.v == newCellValue) {
      return;
    }
    final nGridMap = oldGridMap
      ..[col.columnName] = Value.of(newCellValue, oldValue.e);

    final entity = RecordDto.fromGridKeyValueMap(oldEntity, nGridMap);

    // 替换单元格内的值 (会面会自动notify)
    saveRecordDto(entity, rowColumnIndex.rowIndex, notify: false);
    // fixme 没有检查保存是否成功， 考虑添加保存失败时回滚初始值的逻辑
    actSaveRecord(entity);
  }

  // 更新一整行
  @override
  notifyDataRow(int rowIndex, RecordDto entity) {
    log.info("刷新一行数据");
    meta.attributes.map((e) {
      final colIndex = _attrKeyList.indexOf("${e.k}");
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

  void _onEvent(RepoEvent<Record> event) {
    log.fine("_onEvent 数据刷新\n$event");

    // todo 本方法会在首次初始化时被调用, 短时间内连续刷新可能会造成卡顿...,
    //todo 考虑首次加载转换为Future,然后一次性转为Row后再notify / 直接为Stream做缓存节流每次返回一个List<>
    switch (event.type) {
      case RepoEventType.insert:
        saveRecordDto(event.entity!.toDto(), null);
        break;
      case RepoEventType.update: // todo      update
      case RepoEventType.replace:
        final index = _cache.indexWhere((element) => element.id == event.ettId);
        saveRecordDto(event.entity!.toDto(), index);
        break;
      case RepoEventType.drop: // todo         drop
      case RepoEventType.rename: // todo       rename
      case RepoEventType.dropDatabase: // todo dropDatabase
      case RepoEventType.invalidate: // todo   invalidate
      case RepoEventType.delete:
        if (event.type != WatchEventType.delete)
          print("###debug drop 尚未确认 '${event.type}'事件的机制, 按照delete处理");
        removeRecordBy(event.ettId);
        break;
    }
  }

  @override
  void dispose() {
    recordSub2.cancel();
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

  final IRecordDataGridSource dataGridSource;
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
  Widget build(BuildContext context) => Consumer<MetaProvider>(
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

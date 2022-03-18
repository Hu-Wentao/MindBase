import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logging/logging.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/infra/ui/form/record_form.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:ndialog/ndialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// 用于构建一张表的数据源, 包含Meta和Rows的数据, 相关Rows的Stream
class RecordDataGridSource extends DataGridSource {
  late final Logger log;

  final RecordMeta schema;
  final StreamSubscription<RecordDto> initDataSub;
  final StreamSubscription<WatchEvent<RecordDto>> recordSub;

  late RecordMetaDto _schemaDto;

  // 用于查询 Attr的Key 在Grid中的index
  late final List<String> _attrKeyList;

  RecordDataGridSource(this.schema, this.initDataSub, this.recordSub) {
    initDataSub.onData(_eventInsertDto);
    recordSub.onData(_onEvent);
    _schemaDto = schema.toDto();
    _attrKeyList = _schemaDto.toGridKeyNameMap().keys.toList();
    log = Logger("$runtimeType");
  }

  // 防止同一个对象状态更新后被重复缓存
  final List<RecordDto> _cache = [];
  final List<DataGridRow> _cacheRows = [];

  @override
  List<DataGridRow> get rows => _cacheRows;

  // 更新一整行
  _notifyDataRow(int rowIndex, RecordDto entity) {
    log.info("刷新一行数据");
    schema.attributes.map((e) {
      final colIndex = _attrKeyList.indexOf("${e.k}");
      // 更新指定单元格
      notifyDataSourceListeners(
        rowColumnIndex: RowColumnIndex(rowIndex, colIndex),
      );
    });
  }

  // 更新全体数据, 当row新增或移除时调用
  _notifyAll() {
    log.info("刷新全部数据");
    notifyListeners();
  }

  void _eventInsertDto(RecordDto entity) {
    _cache.add(entity);
    _cacheRows.add(entityToRow(entity));
    _notifyAll();
  }

  void _onInsert(WatchEvent<RecordDto> event) => _eventInsertDto(event.entity!);

  void _onEvent(WatchEvent<RecordDto> event) {
    log.fine("_onEvent 数据刷新\n$event");

    // todo 本方法会在首次初始化时被调用, 短时间内连续刷新可能会造成卡顿...,
    //todo 考虑首次加载转换为Future,然后一次性转为Row后再notify / 直接为Stream做缓存节流每次返回一个List<>
    switch (event.type) {
      case WatchEventType.insert:
        _onInsert(event);
        break;
      case WatchEventType.update: // todo      update
      case WatchEventType.replace:
        final index = _cache.indexWhere((element) => element.id == event.ettId);
        _cache[index] = event.entity!;
        _cacheRows[index] = entityToRow(event.entity!);
        _notifyDataRow(index, event.entity!);
        break;
      case WatchEventType.drop: // todo         drop
      case WatchEventType.rename: // todo       rename
      case WatchEventType.dropDatabase: // todo dropDatabase
      case WatchEventType.invalidate: // todo   invalidate
      case WatchEventType.delete:
        if (event.type != WatchEventType.delete)
          print("###debug drop 尚未确认 '${event.type}'事件的机制, 按照delete处理");
        final index = _cache.indexWhere((element) => element.id == event.ettId);
        _cache.removeAt(index);
        _cacheRows.removeAt(index);
        _notifyAll();
        break;
    }
  }

  /// 构建Header
  List<GridColumn> buildColumn() => _schemaDto
      .toGridKeyNameMap()
      .entries
      .map((e) => GridColumn(
            columnName: e.key,
            label: Text(e.value),
            columnWidthMode: ColumnWidthMode.fill,
            // tooltip: _schemaDto.getAttrByKeyOr(int.tryParse(e.key))?.memo,
          ))
      .toList();

  /// DataGridRow -> Widget
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) => DataGridRowAdapter(
      cells: row
          .getCells()
          .map((e) => Container(
                alignment: Alignment.center,
                child: Text(e.value.toString()),
              ))
          .toList());

  DataGridRow entityToRow(RecordDto recordDto) {
    final dtoMap = recordDto.toGridKeyNameMap();
    return DataGridRow(
      cells: _schemaDto
          .toGridKeyNameMap()
          .entries
          .map((e) =>
              DataGridCell<String>(columnName: e.key, value: dtoMap[e.key]))
          .toList(),
    );
  }

  @override
  void dispose() {
    initDataSub.cancel();
    recordSub.cancel();
    super.dispose();
  }
}

class RecordDataGrid extends StatefulWidget {
  const RecordDataGrid({
    Key? key,
    required this.dataGridSource,
    required this.onSaveRecord,
  }) : super(key: key);

  final RecordDataGridSource dataGridSource;
  final Future<void> Function(RecordDto? dto) onSaveRecord;

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
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题栏按钮
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: DataFrameTitle(
                onSaveRecord: widget.onSaveRecord,
                schema: widget.dataGridSource.schema,
              ),
            ),
            Expanded(
              child: SfDataGrid(
                source: widget.dataGridSource,
                columnWidthMode: ColumnWidthMode.fill,
                // todo 使用 Column Resizing 以便调整列宽
                columns: widget.dataGridSource.buildColumn(),
                selectionMode: SelectionMode.single,
                // 单击选中
                navigationMode: GridNavigationMode.cell,
                // 选中单元格
                editingGestureType: EditingGestureType.doubleTap, // 双击编辑
              ),
            ),
          ],
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
  final RecordMeta schema;
  final Future<void> Function(RecordDto? dto) onSaveRecord;
  final _kRecordBuilder = GlobalKey<FormBuilderState>();

  DataFrameTitle({
    Key? key,
    required this.schema,
    required this.onSaveRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton.icon(
        onPressed: () async => await onSaveRecord(
          await _createRecord(context, schema),
        ),
        icon: const Icon(Icons.add),
        label: const Text("new item"),
      );

  //
  Future<RecordDto?> _createRecord(
    BuildContext c,
    RecordMeta schema,
  ) =>
      NAlertDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: const Text("插入新的记录"),
        content: RecordForm(
          meta: schema,
          kRecordBuilder: _kRecordBuilder,
        ),
        actions: <Widget>[
          TextButton(
              child: const Text("确认"),
              onPressed: () {
                final checkAttr =
                    _kRecordBuilder.currentState?.saveAndValidate() ?? false;
                if (checkAttr) {
                  final map = _kRecordBuilder.currentState!.value;
                  final dto = RecordDto.fromForm(map);
                  Navigator.pop<RecordDto>(c, dto);
                } else {
                  ScaffoldMessenger.of(c).showSnackBar(
                    const SnackBar(content: Text("请检查表单")),
                  );
                }
              }),
          TextButton(
              child: const Text("取消"), onPressed: () => Navigator.pop(c)),
        ],
      ).show(c);
}

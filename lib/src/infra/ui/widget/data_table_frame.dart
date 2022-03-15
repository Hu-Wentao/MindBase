import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/infra/ui/form/record_form.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:ndialog/ndialog.dart';
import 'package:responsive_table/responsive_table.dart';

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
          schema: schema,
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

class DataTableFrame extends StatefulWidget {
  final RecordMeta schema;
  final Future<void> Function(RecordDto? dto) onSaveRecord;

  // todo 改为Function schema::attr->DatatableHeader
  final List<DatatableHeader> headers;
  final List<Map<String, dynamic>> data;

  const DataTableFrame({
    Key? key,
    required this.schema,
    required this.headers,
    required this.data,
    required this.onSaveRecord,
  }) : super(key: key);

  @override
  State<DataTableFrame> createState() => _DataTableFrameState();
}

class _DataTableFrameState extends State<DataTableFrame> {
  late List<Map<String, dynamic>> _selectedList;
  late List<bool> _expandedList;
  final bool _showSelect = true;

  @override
  initState() {
    super.initState();
    _selectedList = [];
    // fixme _expandedList 的长度必须与data长度相同,但问题在于data长度会变化,而初始值总是0
    // fixme 原因未知, 可尝试不用 data.length,而是手动输入一个较大数值,会有效果
    _expandedList = List.generate(widget.data.length, (i) => false);
    print(
        "initState data ${widget.data} expandedList: $_expandedList, selectedList: $_selectedList");
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(maxHeight: 700),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  title: DataFrameTitle(
                    schema: widget.schema,
                    onSaveRecord: widget.onSaveRecord,
                  ),
                  reponseScreenSizes: const [ScreenSize.xs],
                  // actions: [
                  // if (_isSearch)
                  //   Expanded(
                  //       child: TextField(
                  //     decoration: InputDecoration(
                  //         hintText: 'Enter search term based on ' +
                  //             _searchKey!
                  //                 .replaceAll(new RegExp('[\\W_]+'), ' ')
                  //                 .toUpperCase(),
                  //         prefixIcon: IconButton(
                  //             icon: const Icon(Icons.cancel),
                  //             onPressed: () {
                  //               setState(() {
                  //                 _isSearch = false;
                  //               });
                  //               _initializeData();
                  //             }),
                  //         suffixIcon: IconButton(
                  //             icon: const Icon(Icons.search),
                  //             onPressed: () {})),
                  //     onSubmitted: (value) {
                  //       _filterData(value);
                  //     },
                  //   )),
                  // if (!_isSearch)
                  //   IconButton(
                  //       icon: const Icon(Icons.search),
                  //       onPressed: () {
                  //         setState(() {
                  //           _isSearch = true;
                  //         });
                  //       })
                  // ],
                  headers: widget.headers,
                  source: widget.data,
                  selecteds: _selectedList,
                  // 被选中的data
                  showSelect: _showSelect,
                  autoHeight: false,
                  dropContainer: (data) {
                    print("dropContainer data: $data");
                    // if (int.tryParse(data['id'].toString())!.isEven) {
                    //   return const Text("is Even");
                    // }
                    // return _DropDownContainer(data: data);
                    return Container();
                  },
                  onChangedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                  },
                  onSubmittedRow: (value, header) {
                    /// print(value);
                    /// print(header);
                  },
                  onTabRow: (data) {
                    print(data);
                  },
                  onSort: (value) {
                    print("## todo onSort");
                    // setState(() => _isLoading = true);
                    //
                    // setState(() {
                    //   _sortColumn = value;
                    //   _sortAscending = !_sortAscending;
                    //   if (_sortAscending) {
                    //     _sourceFiltered.sort((a, b) =>
                    //         b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                    //   } else {
                    //     _sourceFiltered.sort((a, b) =>
                    //         a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                    //   }
                    //   var _rangeTop = _currentPerPage! < _sourceFiltered.length
                    //       ? _currentPerPage!
                    //       : _sourceFiltered.length;
                    //   _source = _sourceFiltered.getRange(0, _rangeTop).toList();
                    //   _searchKey = value;
                    //
                    //   _isLoading = false;
                    // });
                  },
                  expanded: _expandedList,
                  // sortAscending: _sortAscending,
                  // sortColumn: _sortColumn,
                  // isLoading: _isLoading,
                  onSelect: (value, item) {
                    print("## todo onSelect");
                    // print("$value  $item ");
                    // if (value!) {
                    //   setState(() => _selecteds.add(item));
                    // } else {
                    //   setState(
                    //       () => _selecteds.removeAt(_selecteds.indexOf(item)));
                    // }
                  },
                  onSelectAll: (value) {
                    print("## todo onSelectAll");
                    // if (value!) {
                    //   setState(() => _selecteds =
                    //       _source.map((entry) => entry).toList().cast());
                    // } else {
                    //   setState(() => _selecteds.clear());
                    // }
                  },
                  footers: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: const Text("Rows per page:"),
                    ),
                    // if (_perPages.isNotEmpty)
                    //   Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 15),
                    //     child: DropdownButton<int>(
                    //       value: _currentPerPage,
                    //       items: _perPages
                    //           .map((e) => DropdownMenuItem<int>(
                    //                 child: Text("$e"),
                    //                 value: e,
                    //               ))
                    //           .toList(),
                    //       onChanged: (dynamic value) {
                    //         setState(() {
                    //           _currentPerPage = value;
                    //           _currentPage = 1;
                    //           _resetData();
                    //         });
                    //       },
                    //       isExpanded: false,
                    //     ),
                    //   ),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 15),
                    //   child:
                    //       Text("$_currentPage - $_currentPerPage of $_total"),
                    // ),
                    // IconButton(
                    //   icon: const Icon(Icons.arrow_back_ios, size: 16),
                    //   onPressed: _currentPage == 1
                    //       ? null
                    //       : () {
                    //           var _nextSet = _currentPage - _currentPerPage!;
                    //           setState(() {
                    //             _currentPage = _nextSet > 1 ? _nextSet : 1;
                    //             _resetData(start: _currentPage - 1);
                    //           });
                    //         },
                    //   padding: const EdgeInsets.symmetric(horizontal: 15),
                    // ),
                    // IconButton(
                    //   icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    //   onPressed: _currentPage + _currentPerPage! - 1 > _total
                    //       ? null
                    //       : () {
                    //           var _nextSet = _currentPage + _currentPerPage!;
                    //
                    //           setState(() {
                    //             _currentPage = _nextSet < _total
                    //                 ? _nextSet
                    //                 : _total - _currentPerPage!;
                    //             _resetData(start: _nextSet - 1);
                    //           });
                    //         },
                    //   padding: const EdgeInsets.symmetric(horizontal: 15),
                    // )
                  ],
                  headerDecoration: const BoxDecoration(
                      color: Colors.grey,
                      border: Border(
                          bottom: BorderSide(color: Colors.red, width: 1))),
                  selectedDecoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.green[300]!, width: 1)),
                    color: Colors.green,
                  ),
                  headerTextStyle: const TextStyle(color: Colors.white),
                  rowTextStyle: const TextStyle(color: Colors.green),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]));
}

class _DropDownContainer extends StatelessWidget {
  final Map<String, dynamic> data;

  const _DropDownContainer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          const Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();

    return Container(
      /// height: 100,
      child: Column(
        /// children: [
        ///   Expanded(
        ///       child: Container(
        ///     color: Colors.red,
        ///     height: 50,
        ///   )),
        /// ],
        children: _children,
      ),
    );
  }
}

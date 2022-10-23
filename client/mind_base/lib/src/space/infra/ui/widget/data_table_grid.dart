import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/core/infra/ui/dialog/dialog.dart';
import 'package:mind_base/src/space/domain/value/value.dart';
import 'package:mind_base/src/space/infra/ui/dialog/attribute_edit_dialog.dart';
import 'package:mind_base/src/space/infra/ui/dialog/record_edit_dialog.dart';
import 'package:mind_base/src/space/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/space/infra/ui/widget/column_menu_delegate.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:slowly/slowly.dart';

import 'data_table_source.dart';

/// 适配Pluto表格
class RecordDataGrid extends StatelessWidget {
  final SpaceModel space;
  final MetaModel meta;
  final TableView? view;

  const RecordDataGrid({
    Key? key,
    required this.space,
    required this.meta,
    this.view,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = meta.dataSource;
    final metaDto = meta.data;
    return Expanded(
      child: PlutoGrid(
        // key不一致的时候才会刷新UI
        key: ValueKey("${meta.ver}-${view?.vId}"),
        rows: data.cachedRows,
        columns: view?.transformCols(data.cachedColumns) ?? data.cachedColumns,
        onLoaded: (loadedEvt) {
          // 为数据源绑定新的stateManager, 以便在数据源更新的时候,能够同时刷新UI
          data.stateManager = loadedEvt.stateManager
            ..setAutoEditing(false)
            // 配置列菜单项
            ..setColumnMenuDelegate(MindBaseColumnMenuDelegate(
                // 向左/右新增列
                onInsertCol: (context, stateManager, column, isInsertLeft) {
                  showAttributeEditDialog(
                    context: context,
                    initKey: metaDto.nextKey(),
                    kAttrBuilder: GlobalKey<FormBuilderState>(),
                    queryMetaFn: space.queryMeta,
                    allMetas: space.allMetas,
                  ).then((value) =>
                      meta.actMetaUpdateAttr(value).thenDialog(context));
                },
                // 隐藏列
                onHideCol: view == null
                    ? null
                    : (context, stateManager, column) {
                        final propId = column.field;
                        final originIndex =
                            view!.cols.indexWhere((c) => c.propId == propId);
                        final originCol = view!.cols[originIndex];
                        final nCol = originCol.copyWith(visible: false);
                        final nCols = view!.cols
                          ..replaceRange(originIndex, originIndex + 1, [nCol]);
                        meta
                            .actUpdateView(view!.copyWith(cols: nCols))
                            .thenDialog(context);
                      }));
        },
        onColWidthChanged: (view == null)
            ? null
            : (evt) {
                // 防抖, 避免无效更新
                final accept = sl<Slowly>()
                    .seconds('on调整列宽度', tp: SlowlyTp.debounce, sec: 1);
                if (!accept) return;
                var nWidth = evt.column.width;
                final propId = evt.column.field;
                final originIndex =
                    view!.cols.indexWhere((c) => c.propId == propId);
                final originCol = view!.cols[originIndex];
                final originWidth = originCol.width;
                // 如果新旧宽度差小于 0.1, 则不更新; 否则保留1位小数并更新
                if ((originWidth - nWidth).abs() < 0.1) return;
                nWidth = (nWidth * 10).toInt() / 10;
                final nCol = originCol.copyWith(width: nWidth);
                final nCols = view!.cols
                  ..replaceRange(originIndex, originIndex + 1, [nCol]);
                meta.actUpdateView(
                  view!.copyWith(cols: nCols),
                );
              },
        onColMoved: (view == null)
            ? null
            : (_) {
                // print("debug onColMoved evt $_");
                // 注意，evt提供到index都是基于可见列的排序，而cols内还包含列不可见列的信息
                final isMoveLeftToRight = _.originIdx < _.targetIdx;
                var moveCount = (_.originIdx - _.targetIdx).abs(); // 剩余需要移动的个数

                final propId = _.column.field;
                final startInfoIndex = view!.cols
                    .indexWhere((element) => element.propId == propId);
                int destInfoIndex = startInfoIndex;
                do {
                  // 移动
                  destInfoIndex += (isMoveLeftToRight ? 1 : -1);
                  // 是否有效(如果不可见，则剩余移动步数-0)
                  moveCount -= (view!.cols[destInfoIndex].visible ? 1 : 0);
                } while (!(moveCount == 0 ||
                    destInfoIndex < 0 ||
                    destInfoIndex >= view!.cols.length));

                final nInfo = view!.cols.removeAt(startInfoIndex);
                final nCols = view!.cols..insert(destInfoIndex, nInfo);
                meta.actUpdateView(
                  view!.copyWith(cols: nCols),
                );
              },
        onChanged: (_) {
          // print("#debug #onChanged $_");
          final row = _.row!;
          final ettId = row.key as ValueKey<String>;

          // 更新的DTO
          final dto = meta.records
              .firstWhere((element) => element.id == ettId.value)
              .toDto()
              .updateBy(row);
          meta.actSaveRecord(dto).thenDialog(context);
          // widget.onSaveRecord(dto); // 同步到服务器
        },
        onSelected: (_) {
          print("#debug #onSelected $_");
        },
        onRowChecked: (_) {
          print("#debug #onRowChecked $_");
        },
        // 开启双击会导致单击事件延迟, 在视觉上造成卡顿的效果
        // onRowDoubleTap: (_) {
        //   print("#debug #onRowDoubleTap $_");
        // },
        onRowSecondaryTap: (_) {
          print("#debug #onRowSecondaryTap $_");
        },
        onRowsMoved: (_) {
          print("#debug #onRowsMoved $_");
        },
        createHeader: (manager) => DataFrameTitlePluto(
          meta: meta,
          view: view,
          stateManager: manager,
          onSaveMeta: meta.actUpdateMeta,
          onSaveRecord: meta.actSaveRecord,
          onUpdateView: (m, v) => meta.actUpdateView(v),
          space: space,
          queryMetaFn: space.queryMeta,
          allMetas: space.allMetas,
        ),
        // createFooter: (_) {             },
        // rowColorCallback: (_) {},
        configuration: const PlutoGridConfiguration(
          // columnHeight: 30.0,
          // columnFilterHeight: 30.0,
          // rowHeight: 30.0,
          // defaultCellPadding: 15,
          // defaultColumnTitlePadding: 15,
          // iconSize: 15,
          // enableColumnBorder: true,
          // enableGridBorderShadow: true,
          enableMoveHorizontalInEditing: true,
          // enableRowColorAnimation: false,
          // checkedColor: const Color(0x876FB0FF),
          /// 以下两项配置列移动,
          enableMoveDownAfterSelecting: true,
          enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveDown,
          // gridBorderRadius: BorderRadius.all(Radius.circular(10)),
          // gridPopupBorderRadius: BorderRadius.all(Radius.circular(7)),
          // scrollbarConfig: PlutoGridScrollbarConfig(
          //   isAlwaysShown: false,
          //   scrollbarThickness: 8,
          //   scrollbarThicknessWhileDragging: 10,
          // ),
          localeText: MindBaseLocalText.china(),
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
        mode: PlutoGridMode.normal, // 可以通过manager动态切换,以实现对不同类型列的处理
      ),
    );
  }
}

///
/// 表格标题栏
class DataFrameTitlePluto extends StatelessWidget {
  final MetaModel meta;
  final TableView? view; // 当前视图，可以为空
  final SpaceModel space;
  final PlutoGridStateManager stateManager;
  final Future<BaseException?> Function(RecordDto? dto) onSaveRecord;
  final Future<void> Function(MetaDto? dto) onSaveMeta;
  final Future<BaseException?> Function(MetaDto dto, TableView v)
      onUpdateView;
  final _kRecordBuilder = GlobalKey<FormBuilderState>();
  final kMetaBuilder = GlobalKey<FormBuilderState>();
  final kAttrBuilder = GlobalKey<FormBuilderState>();
  final kMethodBuilder = GlobalKey<FormBuilderState>();
  final QueryMetaFn queryMetaFn;
  final Iterable<MetaModel> Function() allMetas;

  DataFrameTitlePluto({
    Key? key,
    required this.meta,
    this.view,
    required this.space,
    required this.stateManager,
    required this.onSaveMeta,
    required this.onSaveRecord,
    required this.queryMetaFn,
    required this.allMetas,
    required this.onUpdateView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TextButton.icon(
              onPressed: () async => await onSaveRecord(
                await showRecordEditDialog(
                  context: context,
                  meta: meta,
                  space: space,
                  kRecordBuilder: _kRecordBuilder,
                ),
              ).thenDialog(context),
              icon: const Icon(Icons.add),
              label: const Text("新增一行"),
            ),
            // 只有在 指定了视图 时，才提供"字段管理"功能
            if (view != null)
              TextButton.icon(
                onPressed: () => _fieldManager(context, meta.toDto(), view!),
                icon: const Icon(Icons.blur_linear_outlined),
                label: const Text("字段管理"),
              ),
            TextButton.icon(
              onPressed: () async {
                final checked = stateManager.checkedRows;
                if (checked.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("您尚未选中记录"),
                  ));
                } else {
                  final r = await showConfirmDialog(
                      context: context,
                      title: "确认删除选中的 ${checked.length} 条记录吗");
                  if (r == true) {
                    final recordIds =
                        checked.map((e) => (e.key as ValueKey<String>).value);
                    for (final recordId in recordIds) {
                      await meta
                          .actRemoveRecord(recordId)
                          .thenDialog(context);
                    }
                  }
                }
              },
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text("删除选中"),
            ),
            TextButton.icon(
              onPressed: () async => await onSaveMeta(
                await showMetaModelEditDialog(
                  context: context,
                  originMeta: meta.toDto(),
                  kMetaBuilder: kMetaBuilder,
                  kAttrBuilder: kAttrBuilder,
                  kMethodBuilder: kMethodBuilder,
                  queryMetaFn: queryMetaFn,
                  allMetas: allMetas,
                ),
              ),
              icon: const Icon(Icons.edit),
              label: const Text("修改结构"),
            ),
          ],
        ),
      );

  // 字段管理
  void _fieldManager(BuildContext context, MetaDto dto, TableView view) {
    const propIdField = 'propIdField';
    var columns = [
      PlutoColumn(
        title: '字段管理',
        field: 'name',
        type: PlutoColumnType.text(),
        enableRowChecked: true,
        enableEditingMode: false,
        enableDropToResize: true,
        enableContextMenu: false,
        enableColumnDrag: false,
        enableRowDrag: true,
      ),
      // 隐藏列，用于存储 propId
      PlutoColumn(
        title: '字段PropId',
        field: propIdField,
        type: PlutoColumnType.text(),
        hide: true,
      ),
    ];
    // 构建 属性名-propId 行
    final attrRows = meta.properties
        .map((e) => PlutoRow(
              cells: {
                'name': PlutoCell(value: e.name),
                propIdField: PlutoCell(value: e.propId),
              },
              // 可见即勾选
              checked: view.cols
                      .firstWhereOrNull((element) => element.propId == e.propId)
                      ?.visible ??
                  false,
            ))
        .toList();
    // fixme "view有，meta没有"的情况，会对"列drag移动"，""，产生影；考虑在加载view的时候，就自动清理view中meta已删除的列
    // 根据view元素顺序为排序权重，没有的就放最后
    // <propId,权重> 权重越小，越靠左
    final weightMap = Map.fromEntries(view.cols
        .map((e) => e.propId)
        .toList()
        .mapIndexed((index, element) => MapEntry(element, index)));
    attrRows.sort((r1, r2) {
      final r1propId = r1.cells[propIdField]!.value;
      final r1w = weightMap[r1propId] ?? double.infinity;
      final r2propId = r2.cells[propIdField]!.value;
      final r2w = weightMap[r2propId] ?? double.infinity;
      return r1w.compareTo(r2w);
    });

    PlutoGridStateManager? popUpGridManger;

    PlutoGridPopup(
      context: context,
      configuration: stateManager.configuration,
      columns: columns,
      rows: attrRows,
      width: 200,
      height: 500,
      mode: PlutoGridMode.popup,
      onLoaded: (e) {
        popUpGridManger = e.stateManager;
        popUpGridManger!.setSelectingMode(PlutoGridSelectingMode.none);
      },
      onRowsMoved: (e) {
        // 设置排序 (移动前，移动后事件会调用两次，也导致更新了两次，考虑去重)
        // print(
        //     "debug #${e.idx}} 排序后的行： ${popUpGridManger!.refRows.originalList.map((e) => e.cells.entries.map((e) => "${e.key}-${e.value.value}"))}");

        // 重新构建一个符合列表顺序的Cols
        final nCols = <ColViewInfo>[];
        for (var e in popUpGridManger!.refRows.originalList) {
          final propId = e.cells[propIdField]!.value;
          final col = view.cols.firstWhere((col) => col.propId == propId);
          nCols.add(col);
        }
        // 提交请求
        onUpdateView(dto, view.copyWith(cols: nCols)).thenDialog(context);
      },
      onRowChecked: (e) {
        // 设置是否隐藏
        // print(
        //     "debug onRowChecked #${e.isChecked}, ${e.rowIdx}, ${e.row?.cells.entries.map((e) => "${e.key}-${e.value.value}")}");
        final visible = e.isChecked ?? true;
        final propId = e.row?.cells[propIdField]?.value;
        final idx = view.cols.indexWhere((e) => e.propId == propId);
        ColViewInfo nInfo;
        List<ColViewInfo> nInfos;
        if (idx == -1) {
          // 在view创建时，该字段尚未创建，所以在view中找不到
          nInfo = ColViewInfo.build(
            propId: propId,
            visible: visible,
          );
          nInfos = [...view.cols, nInfo];
        } else {
          nInfo = view.cols[idx].copyWith(visible: visible);
          // 由于直接刷新了对应list，因此无需赋值
          nInfos = view.cols..replaceRange(idx, idx + 1, [nInfo]);
        }
        // 提交请求
        onUpdateView(dto, view.copyWith(cols: nInfos)).thenDialog(context);
      },
      // onChanged: (e){
      //   print("debug onChanged ${e.value}, ${e.rowIdx}, ${e.row?.cells.entries.map((e) => "${e.key}-${e.value.value}")}");
      // }
    );
  }
}

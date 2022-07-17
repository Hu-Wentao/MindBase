import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

/// 新增多语言

class MindBaseLocalText extends PlutoGridLocaleText {
  final String insertToLeft;
  final String insertToRight;

  const MindBaseLocalText.china({
    this.insertToLeft = '向左插入',
    this.insertToRight = '向右插入',
    // Column menu
    super.unfreezeColumn = '解冻列',
    super.freezeColumnToStart = '冻结列至起点',
    super.freezeColumnToEnd = '冻结列至终点',
    super.autoFitColumn = '自动列宽',
    super.hideColumn = '隐藏列',
    super.setColumns = '设置列',
    super.setFilter = '设置过滤器',
    super.resetFilter = '重置过滤器',
    // SetColumns popup
    super.setColumnsTitle = '列标题',
    // Filter popup
    super.filterColumn = '列',
    super.filterType = '类型',
    super.filterValue = '值',
    super.filterAllColumns = '全部列',
    super.filterContains = '包含',
    super.filterEquals = '等于',
    super.filterStartsWith = '开始于',
    super.filterEndsWith = '结束于',
    super.filterGreaterThan = '大于',
    super.filterGreaterThanOrEqualTo = '大于等于',
    super.filterLessThan = '小于',
    super.filterLessThanOrEqualTo = '小于等于',
    // Date popup
    super.sunday = '日',
    super.monday = '一',
    super.tuesday = '四',
    super.wednesday = '三',
    super.thursday = '二',
    super.friday = '五',
    super.saturday = '六',
    // Time column popup
    super.hour = '时',
    super.minute = '分',
    // Common
    super.loadingText = '加载中',
  });
}

/// 新增菜单选项

enum MindBaseColumnMenu {
  insertToLeft,
  insertToRight,
  //
  unfreeze,
  freezeToStart,
  freezeToEnd,
  hideColumn,
  // setColumns, // 被字段管理取代
  autoFit,
  setFilter,
  resetFilter,
}

class MindBaseColumnMenuDelegate
    implements PlutoColumnMenuDelegate<MindBaseColumnMenu> {
  const MindBaseColumnMenuDelegate({this.onInsertCol, this.onHideCol});

  final void Function(
    BuildContext context,
    PlutoGridStateManager stateManager,
    PlutoColumn column,
    bool isInsertLeft,
  )? onInsertCol;

  final void Function(
    BuildContext context,
    PlutoGridStateManager stateManager,
    PlutoColumn column,
  )? onHideCol;

  @override
  List<PopupMenuEntry<MindBaseColumnMenu>> buildMenuItems({
    required PlutoGridStateManager stateManager,
    required PlutoColumn column,
  }) {
    return _getColumnMenuItems(
      stateManager: stateManager,
      column: column,
    );
  }

  @override
  void onSelected({
    required BuildContext context,
    required PlutoGridStateManager stateManager,
    required PlutoColumn column,
    required bool mounted,
    required MindBaseColumnMenu? selected,
  }) {
    switch (selected) {
      case MindBaseColumnMenu.insertToLeft:
      case MindBaseColumnMenu.insertToRight:
        onInsertCol?.call(
          context,
          stateManager,
          column,
          selected == MindBaseColumnMenu.insertToLeft,
        );
        break;
      case MindBaseColumnMenu.hideColumn:
        onHideCol?.call(
          context,
          stateManager,
          column,
        );
        // stateManager.hideColumn(column, true);
        break;
      case MindBaseColumnMenu.unfreeze:
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.none);
        break;
      case MindBaseColumnMenu.freezeToStart:
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.start);
        break;
      case MindBaseColumnMenu.freezeToEnd:
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.end);
        break;
      case MindBaseColumnMenu.autoFit:
        if (!mounted) return;
        stateManager.autoFitColumn(context, column);
        stateManager.notifyResizingListeners();
        break;
      // case MindBaseColumnMenu.setColumns:
      //   if (!mounted) return;
      //   stateManager.showSetColumnsPopup(context);
      //   break;
      case MindBaseColumnMenu.setFilter:
        if (!mounted) return;
        stateManager.showFilterPopup(context, calledColumn: column);
        break;
      case MindBaseColumnMenu.resetFilter:
        stateManager.setFilter(null);
        break;
      default:
        break;
    }
  }

  List<PopupMenuEntry<MindBaseColumnMenu>> _getColumnMenuItems({
    required PlutoGridStateManager stateManager,
    required PlutoColumn column,
  }) {
    final Color textColor = stateManager.style.cellTextStyle.color!;

    final Color disableTextColor = textColor.withOpacity(0.5);

    final bool enoughFrozenColumnsWidth = stateManager.enoughFrozenColumnsWidth(
      stateManager.maxWidth! - column.width,
    );

    final localeText = stateManager.localeText as MindBaseLocalText;

    return [
      _buildMenuItem(
        value: MindBaseColumnMenu.insertToLeft,
        text: localeText.insertToLeft,
        textColor: textColor,
      ),
      _buildMenuItem(
        value: MindBaseColumnMenu.insertToRight,
        text: localeText.insertToRight,
        textColor: textColor,
      ),
      const PopupMenuDivider(),
      if (column.frozen.isFrozen == true)
        _buildMenuItem(
          value: MindBaseColumnMenu.unfreeze,
          text: localeText.unfreezeColumn,
          textColor: textColor,
        ),
      if (column.frozen.isFrozen != true) ...[
        _buildMenuItem(
          value: MindBaseColumnMenu.freezeToStart,
          enabled: enoughFrozenColumnsWidth,
          text: localeText.freezeColumnToStart,
          textColor: enoughFrozenColumnsWidth ? textColor : disableTextColor,
        ),
        _buildMenuItem(
          value: MindBaseColumnMenu.freezeToEnd,
          enabled: enoughFrozenColumnsWidth,
          text: localeText.freezeColumnToEnd,
          textColor: enoughFrozenColumnsWidth ? textColor : disableTextColor,
        ),
      ],
      const PopupMenuDivider(),
      _buildMenuItem(
        value: MindBaseColumnMenu.autoFit,
        text: localeText.autoFitColumn,
        textColor: textColor,
      ),
      // if (column.enableHideColumnMenuItem == true)
      if (onHideCol != null)
        _buildMenuItem(
          value: MindBaseColumnMenu.hideColumn,
          text: localeText.hideColumn,
          textColor: textColor,
          enabled: stateManager.refColumns.length > 1,
        ),
      // if (column.enableSetColumnsMenuItem == true)
      //   _buildMenuItem(
      //     value: MindBaseColumnMenu.setColumns,
      //     text: localeText.setColumns,
      //     textColor: textColor,
      //   ),
      if (column.enableFilterMenuItem == true) ...[
        const PopupMenuDivider(),
        _buildMenuItem(
          value: MindBaseColumnMenu.setFilter,
          text: localeText.setFilter,
          textColor: textColor,
        ),
        _buildMenuItem(
          value: MindBaseColumnMenu.resetFilter,
          text: localeText.resetFilter,
          textColor: textColor,
          enabled: stateManager.hasFilter,
        ),
      ],
    ];
  }
}

PopupMenuItem<MindBaseColumnMenu> _buildMenuItem<MindBaseColumnMenu>({
  required String text,
  required Color? textColor,
  bool enabled = true,
  MindBaseColumnMenu? value,
}) {
  return PopupMenuItem<MindBaseColumnMenu>(
    value: value,
    height: 36,
    enabled: enabled,
    child: Text(
      text,
      style: TextStyle(
        color: enabled ? textColor : textColor!.withOpacity(0.5),
        fontSize: 13,
      ),
    ),
  );
}

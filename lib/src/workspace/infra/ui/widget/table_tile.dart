part of 'widget.dart';
class TableTile extends StatelessWidget {
  final OpenedWorkspace openedSpace;
  final OpenedMeta openedMeta;
  final bool selected;
  final GestureTapCallback? onTap;

  const TableTile({
    Key? key,
    required this.openedSpace,
    required this.openedMeta,
    required this.selected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
    selected: selected,
    title: Text(openedMeta.name),
    onTap: onTap,
    trailing: PopupMenuButton<String>(
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: "renameTableEvt",
          child: ListTile(
            leading: Icon(Icons.drive_file_rename_outline_rounded),
            title: Text("重命名表"),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
            value: "newTableViewSheet",
            child: ListTile(
              leading: Icon(Icons.add_chart_rounded),
              title: Text("新增表格视图"),
            )),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'deleteMetaEvt',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text("删除表"),
          ),
        ),
      ],
      onSelected: (value) async {
        // 选中Item后,在这里会被二次调用
        switch (value) {
          case "renameTableEvt":
            openedMeta
                .actUpdateMetaName(await showTextInputDialog(
              context: context,
              title: "重命名表",
              origin: openedMeta.name,
              hint: openedMeta.name,
            ))
                .thenDialog(context);
            break;
          case 'newTableViewSheet':
            openedMeta.actNewTableView(ViewType.sheet).thenDialog(context);
            break;
          case 'deleteMetaEvt':
            openedSpace.actRemoveOpenedMeta(openedMeta).thenDialog(context);
            break;
          default:
            print("debug#未知的value#$value");
            break;
        }
      },
    ),
  );
}

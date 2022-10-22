part of 'widget.dart';

class TableTile extends StatelessWidget {
  final MetaModel meta;
  final bool selected;
  final GestureTapCallback? onTap;

  const TableTile({
    Key? key,
    required this.meta,
    required this.selected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        selected: selected,
        title: Text(meta.name),
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
                meta
                    .actUpdateMetaName(await showTextInputDialog(
                      context: context,
                      title: "重命名表",
                      origin: meta.name,
                      hint: meta.name,
                    ))
                    .thenDialog(context);
                break;
              case 'newTableViewSheet':
                meta.actNewTableView(ViewType.sheet).thenDialog(context);
                break;
              case 'deleteMetaEvt':
                context
                    .read<SpaceModel>()
                    .actEntrance(SpaceAct.deleteMeta(meta.id))
                    // .actRemoveMetaModel(openedMeta)
                    .thenDialog(context);
                break;
              default:
                print("debug#未知的value#$value");
                break;
            }
          },
        ),
      );
}

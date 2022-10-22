part of 'widget.dart';

class TableViewTile extends StatelessWidget {
  final MetaModel openedMeta;
  final TableView view;
  final Uri viewUri;

  const TableViewTile({
    Key? key,
    required this.openedMeta,
    required this.view,
    required this.viewUri,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Link(
    uri: viewUri,
    builder: (c, callback) => ListTile(
      title: Text(view.name),
      trailing: PopupMenuButton<String>(
        itemBuilder: (ctx) => [
          const PopupMenuItem(
            value: "rename",
            child: Text("重命名视图"),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: "delete",
            child: Text("删除"),
          )
        ],
        onSelected: (key) async {
          // final dto = meta.toDto();
          switch (key) {
            case "rename":
              await openedMeta
                  .actUpdateViewName(
                view,
                await showTextInputDialog(
                  context: context,
                  title: "重命名视图",
                  origin: view.name,
                  hint: view.name,
                ),
              )
                  .thenDialog(context);
              break;
            case "delete":
              await showConfirmDialog(
                  context: context,
                  title: "确认删除视图[${view.name}]吗?",
                  onConfirm: () async {
                    await openedMeta
                        .actDeleteView(view.vId)
                        .thenDialog(context);
                  });
              break;
            default:
              throw "error 未知的 key[$key]";
          }
        },
      ),
      onTap: callback,
    ),
  );
}

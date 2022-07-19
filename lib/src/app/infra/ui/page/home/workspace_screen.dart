part of 'home.dart';

class WorkspacesScreen extends StatelessWidget {
  const WorkspacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              RadiusInkWell(
                margin: const EdgeInsets.all(10),
                child: TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("创建工作空间"),
                  onPressed: () {
                    context
                        .read<WorkspaceManagerProvider>()
                        .actCreateWorkspace(null, '新建空间', onCreated: (t, w) {
                      // 创建完成后进入新建空间
                      context.go('/workspace/${w.id}');
                    }).thenDialog(context);
                  },
                ),
              ),
            ],
          ),
          const Divider(),
          Consumer<WorkspaceManagerProvider>(
              builder: (c, pManger, _) => Expanded(
                child: SingleChildScrollView(
                  child: Column(
                        // key: ValueKey(pManger.ver),
                        mainAxisSize: MainAxisSize.min,
                        children: pManger.workspaces.entries
                            .expand((entry) => entry.value.map(
                                  (e) => Tuple2(entry.key, e),
                                ))
                            .map(
                          (e) {
                            final team = e.value1;
                            final space = e.value2;
                            return ListTile(
                              leading: const Icon(Icons.space_dashboard_rounded),
                              title: Text(space.name),
                              subtitle: Text(team.name),
                              trailing: PopupMenuButton<String>(
                                itemBuilder: (ctx) => [
                                  const PopupMenuItem(
                                    value: "rename",
                                    child: Text("重命名空间"),
                                  ),
                                  const PopupMenuDivider(),
                                  const PopupMenuItem(
                                    value: "delete",
                                    child: Text("删除"),
                                  )
                                ],
                                onSelected: (key) async {
                                  switch (key) {
                                    case "rename":
                                      await pManger
                                          .actRenameSpace(
                                            space,
                                            await showTextInputDialog(
                                              context: context,
                                              title: "重命名工作空间",
                                              origin: space.name,
                                              hint: space.name,
                                            ),
                                          )
                                          .thenDialog(context);
                                      break;
                                    case "delete":
                                      await showConfirmDialog(
                                          context: context,
                                          title: "确认删除工作空间[${space.name}]吗?",
                                          onConfirm: () async {
                                            await pManger
                                                .actDeleteSpace(space.id)
                                                .thenDialog(context);
                                          });
                                      break;
                                    default:
                                      throw "error 未知的 key[$key]";
                                  }
                                },
                              ),
                              onTap: () => context.go('/workspace/${e.value2.id}'),
                            );
                          },
                        ).toList(),
                      ),
                ),
              ))
        ],
      );
}

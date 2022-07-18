part of 'home.dart';

class WorkspacesScreen extends StatelessWidget {
  const WorkspacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<WorkspaceManagerProvider>(
        builder: (c, pManger, _) => Column(
          children: [
            Row(
              children: [
                RadiusInkWell(
                  margin: const EdgeInsets.all(10),
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("创建工作空间"),
                    onPressed: () {
                      pManger
                          .actCreateWorkspace(null, '新建空间')
                          .thenDialog(context);
                    },
                  ),
                ),
              ],
            ),
            const Divider(),
            Column(
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
                    subtitle: Text(e.value1.name),
                    onTap: () => context.go('/workspace/${e.value2.id}'),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      );
}

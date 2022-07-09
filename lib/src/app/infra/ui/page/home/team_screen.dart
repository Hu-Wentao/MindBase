part of 'home.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final Map<int, bool> _panelExpanded = {};
  bool _expandedAll = false;

  @override
  Widget build(BuildContext context) =>
      Consumer<UserProvider>(builder: (c, pUser, _) {
        if (pUser.isLogged) {
          return _buildTeamPanel(c);
        } else {
          return _buildUnLogged(c);
        }
      });

  Widget _buildUnLogged(BuildContext c) => Center(
        child: OutlinedButton(
            onPressed: () async =>
                Future.value(UnLoginException("登录后再查看团队", "")).thenDialog(c),
            child: const Text('请先登录')),
      );

  Widget _buildTeamPanel(BuildContext c) =>
      Consumer<WorkspaceManagerProvider>(builder: (c, pManger, _) {
        return Column(
          children: [
            _buildTitleBar(c),
            Expanded(
              child: _buildTeamList2(c, pManger),
            )
          ],
        );
      });

  _buildTitleBar(c) => Row(
        children: [
          OutlinedButton(
              onPressed: () {
                setState(() {
                  _expandedAll = !_expandedAll;
                  // print("debug _expanedeAll $_expandedAll");
                  _panelExpanded.forEach((k, v) {
                    _panelExpanded[k] = _expandedAll;
                  });
                });
              },
              child: const Text("展开/收缩"))
        ],
      );

  _buildTeamList2(BuildContext c, WorkspaceManagerProvider pManger) {
    final lst = pManger.workspaces.keys.toList();
    return SingleChildScrollView(
      child: ExpansionPanelList(
        // key: panelKey,
        expansionCallback: _switchExpanded,
        children: List.generate(
            lst.length,
            (index) => ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: _panelExpanded[index] ??= false,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    final team = lst[index];
                    return ListTile(
                      leading: Icon(Icons.group,
                          color: (isExpanded ? Colors.blue : null)),
                      title: Text(
                        team.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                          "成员: ${team.total}  工作空间: ${pManger.workspaces[team]!.length}"),
                      trailing: PopupMenuButton<String>(
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(
                            value: "rename",
                            child: Text("重命名"),
                          ),
                          const PopupMenuItem(
                            value: "delete",
                            child: Text("删除"),
                          )
                        ],
                        onSelected: (key) async {
                          switch (key) {
                            case "rename":
                              await pManger.actRenameTeam(
                                team,
                                await showTextInputDialog(
                                    context: context,
                                    title: "重命名团队",
                                    origin: team.name),
                              );
                              break;
                            case "delete":
                              await showConfirmDialog(
                                  context: context,
                                  title: "确认删除团队[${team.name}]吗?",
                                  onConfirm: () {
                                    pManger.actDeleteTeam(team.$id);
                                  });
                              break;
                            default:
                              throw "error 未知的 key[$key]";
                          }
                        },
                      ),
                    );
                  },
                  body: ListView.separated(
                    itemCount: pManger.workspaces[lst[index]]!.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        leading: const Icon(Icons.workspaces),
                        title: Text(
                            pManger.workspaces[lst[index]]![i].name.toString()),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                          height: 1.0, color: const Color(0xfff2f2f2));
                    },
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                  ),
                )),
        animationDuration: const Duration(microseconds: 50),
      ),
    );
  }

  void _switchExpanded(int panelIndex, bool isExpanded) => setState(() {
        _panelExpanded[panelIndex] = !isExpanded;
      });
}

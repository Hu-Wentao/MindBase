part of 'home.dart';

class WorkspacesScreen extends StatelessWidget {
  const WorkspacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer<UserProvider>(builder: (c, pUser, _) {
        if (pUser.isLogged) {
          return Column(
            children: const [
              TeamPanel(),
            ],
          );
        } else {
          return _buildUnLogged(c);
        }
      });

  Widget _buildUnLogged(BuildContext c) => Center(
        child: OutlinedButton(
            onPressed: () async =>
                Future.value(UnLoginException("登录后再查看", "")).thenDialog(c),
            child: const Text('请先登录')),
      );
}

class TeamPanel extends StatefulWidget {
  const TeamPanel({Key? key}) : super(key: key);

  @override
  State<TeamPanel> createState() => _TeamPanelState();
}

class _TeamPanelState extends State<TeamPanel> {
  final _panelExpanded = <int, bool>{};

  // 此处添加Future避免报错
  void _onExpandedCall(int panelIndex, bool isExpanded) => setState(() {
        _panelExpanded[panelIndex] = !isExpanded;
      });

  @override
  Widget build(BuildContext context) => Expanded(
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Consumer<TeamManagerModel>(
              builder: (c, teamManger, _) => ExpansionPanelList(
                    // 当元素增减,强制刷新ExpansionPanelList,否则展开/折叠会报错
                    key: ValueKey(teamManger.teams.length),
                    expansionCallback: _onExpandedCall,
                    children: List.generate(
                      teamManger.teams.length,
                      (index) {
                        final team = teamManger.teams[index];
                        return ExpansionPanel(
                          canTapOnHeader: true,
                          isExpanded: _panelExpanded[index] ??= true,
                          headerBuilder: (c, bool isExpanded) => TeamTile(
                            isExpanded: isExpanded,
                            team: team,
                          ),
                          body: ListView.separated(
                            itemCount: team.workspaces.length,
                            itemBuilder: (BuildContext context, int i) {
                              final space = team.workspaces[i];
                              return Link(
                                uri: Uri.tryParse('/workspace/${space.id}'),
                                builder: (ctx, followLink) => ListTile(
                                  leading:
                                      const Icon(Icons.space_dashboard_rounded),
                                  title: Text(space.name),
                                  onTap: followLink,
                                ),
                              );
                            },
                            separatorBuilder: (context, int index) =>
                                const Divider(),
                            shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                          ),
                        );
                      },
                    ),
                    animationDuration: const Duration(microseconds: 50),
                  )),
        ),
      );
}

class TeamTile extends StatelessWidget {
  final bool isExpanded;
  final TeamModel team;

  const TeamTile({Key? key, required this.isExpanded, required this.team})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.group, color: (isExpanded ? Colors.blue : null)),
      title: Text(
        team.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text("成员: ${team.total}  工作空间: ${team.workspaces.length}"),
      trailing: PopupMenuButton<String>(
        itemBuilder: (ctx) => [
          const PopupMenuItem(
            value: "rename",
            child: Text("重命名团队"),
          ),
          const PopupMenuItem(
            value: "invite",
            child: Text("邀请成员"),
          ),
          const PopupMenuItem(
            value: "create_space",
            child: Text("创建工作空间"),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: "delete",
            child: Text("删除团队"),
          )
        ],
        onSelected: (key) async {
          switch (key) {
            case "rename":
              await team.actRenameTeam(
                await showTextInputDialog(
                  context: context,
                  title: "重命名团队",
                  origin: team.name,
                  hint: team.name,
                ),
              );
              break;
            case "invite":
              await team
                  .actInviteMember(
                    await showTextInputDialog(
                      context: context,
                      title: "${team.name} 团队邀请成员",
                      label: "请输入用户邮箱",
                      hint: "被邀请人的注册邮箱",
                    ),
                  )
                  .thenDialog(context);
              break;
            case "create_space":
              context
                  .read<OpenedSpaceManagerModel>()
                  .actCreateWorkspace(team.id, '新建空间', onCreated: (w) {
                // 创建完成后进入新建空间
                context.go('/workspace/${w.id}');
              }).thenDialog(context);
              break;
            case "delete":
              await showConfirmDialog(
                  context: context,
                  title: "确认删除团队[${team.name}]吗?",
                  onConfirm: () =>
                      context.read<TeamManagerModel>().actDeleteTeam(team.id));
              break;
            default:
              throw "error 未知的 key[$key]";
          }
        },
      ),
    );
  }
}

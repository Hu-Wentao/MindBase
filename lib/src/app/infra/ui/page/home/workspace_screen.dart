part of 'home.dart';

class WorkspacesScreen extends StatelessWidget {
  const WorkspacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<UserModel>(
      builder: (c, mUser, _) => MdMainColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  _buildCreateTeamBtn(context, mUser),
                ]),
              ),
              const Divider(),
              TeamPanel(teams: mUser.teams),
            ],
          ));

  _buildCreateTeamBtn(BuildContext context, UserModel mUser) =>
      ElevatedButton.icon(
          onPressed: () async {
            final name = await showTextInputDialog(
              context: context,
              title: "新团队名称",
              origin: "${mUser.name}'s Team",
            );
            if (name == null) return;
            mUser.actEntrance(UserAct.createTeam(name)).thenDialog(context);
          },
          icon: const Icon(Icons.add),
          label: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("新建团队"),
          ));
}

class TeamPanel extends StatefulWidget {
  final List<TeamModel> teams;

  const TeamPanel({Key? key, required this.teams}) : super(key: key);

  @override
  State<TeamPanel> createState() => _TeamPanelState();
}

class _TeamPanelState extends State<TeamPanel> {
  final _panelExpanded = <int, bool>{};

  // 此处添加Future避免报错
  void _onExpandedCall(int panelIndex, bool isExpanded) => setState(() {
        _panelExpanded[panelIndex] = !isExpanded;
      });

  List<TeamModel> get teams => widget.teams;

  @override
  Widget build(BuildContext context) => ExpansionPanelList(
        // 当元素增减,强制刷新ExpansionPanelList,否则展开/折叠会报错
        key: ValueKey(teams.length),
        expansionCallback: _onExpandedCall,
        children: [
          for (int index = 0; index < teams.length; index++)
            ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: _panelExpanded[index] ??= true,
                headerBuilder: (c, bool isExpanded) =>
                    ChangeNotifierProvider<TeamModel>.value(
                      value: teams[index],
                      child: Consumer<TeamModel>(builder: (c, team, _) {
                        // 自动初始化TeamModel
                        team.state.isOrNull<TeamStateInit>((_) {
                          team.actEntrance(TeamAct.initModel(team.id));
                        });
                        return TeamTile(
                          isExpanded: isExpanded,
                          team: team,
                        );
                      }),
                    ),
                body: ChangeNotifierProvider<TeamModel>.value(
                    value: teams[index],
                    child: Consumer<TeamModel>(
                      builder: (c, team, _) => ListView.separated(
                        itemCount: team.workspaces.length,
                        itemBuilder: (BuildContext context, int i) =>
                            WorkspaceTile(
                          team: team,
                          space: team.workspaces[i].data,
                        ),
                        separatorBuilder: (c, i) => const Divider(),
                        shrinkWrap: true,
                      ),
                    )))
        ],
        animationDuration: const Duration(microseconds: 50),
      );
}

class WorkspaceTile extends StatelessWidget {
  final TeamModel team;
  final WorkspaceDto space;

  const WorkspaceTile({Key? key, required this.space, required this.team})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Link(
        uri: Uri.tryParse(
            workspaceRouterPathBuilder(teamId: team.id, workspaceId: space.id)),
        builder: (ctx, followLink) => ListTile(
          leading: const Icon(Icons.space_dashboard_rounded),
          title: Text(space.name),
          trailing: PopupMenuButton<String>(
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: "rename",
                child: Text("重命名空间"),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: "delete",
                child: Text("删除空间"),
              )
            ],
            onSelected: (key) async {
              switch (key) {
                case "rename":
                  await team.actRenameSpaceName(
                    space,
                    await showTextInputDialog(
                      context: context,
                      title: "重命名空间",
                      origin: space.name,
                      hint: space.name,
                    ),
                  );
                  break;
                case "delete":
                  await showConfirmDialog(
                    context: context,
                    title: "确认删除空间[${space.name}]吗?",
                    onConfirm: () =>
                        team.actDeleteSpace(space.id).thenDialog(context),
                  );
                  break;
                default:
                  throw "error 未知的 key[$key]";
              }
            },
          ),
          onTap: followLink,
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
      subtitle: Text(
          "成员: ${team.total}  工作空间: ${team.state.isOrNull<TeamStateDone>()?.workspaces.length ?? '--'}"),
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
            child: Text("新建工作空间"),
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
              await team.actCreateWorkspace('新建空间', onCreated: (w) {
                context.go(workspaceRouterPathBuilder(
                    teamId: team.id, workspaceId: w.id));
              }).thenDialog(context);
              break;
            case "delete":
              await showConfirmDialog(
                context: context,
                title: "确认删除团队[${team.name}]吗?",
                onConfirm: () => context
                    .read<UserModel>()
                    .actDeleteTeam(team.id)
                    .thenDialog(context),
              );
              break;
            default:
              throw "error 未知的 key[$key]";
          }
        },
      ),
    );
  }
}

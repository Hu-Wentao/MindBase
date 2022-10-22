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
  Widget build(BuildContext context) => Consumer<UserModel?>(
      builder: (c, pUser, _) =>
          (pUser != null) ? _buildTeamPanel(c) : _buildUnLogged(c));

  Widget _buildUnLogged(BuildContext c) => Center(
        child: OutlinedButton(
            onPressed: () async =>
                Future.value(UnLoginException("登录后再查看团队", "")).thenDialog(c),
            child: const Text('请先登录')),
      );

  Widget _buildTeamPanel(BuildContext c) => Column(
        children: [
          _buildTitleBar(c),
          Consumer<UserModel>(
              builder: (c, model, _) => Expanded(
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: ExpansionPanelList(
                        expansionCallback: _switchExpanded,
                        children: List.generate(model.teams.length, (index) {
                          final team = model.teams[index];
                          return ExpansionPanel(
                            canTapOnHeader: true,
                            isExpanded: _panelExpanded[index] ??= false,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) =>
                                    _buildTeamTile(context, isExpanded, team),
                            body: ListView.separated(
                              itemCount: team.workspaces.length,
                              itemBuilder: (BuildContext context, int i) {
                                final space = team.workspaces[i];
                                return Link(
                                  uri: Uri.tryParse('/workspace/${space.id}'),
                                  builder: (ctx, followLink) => ListTile(
                                    leading: const Icon(
                                        Icons.space_dashboard_rounded),
                                    title: Text(space.name),
                                    onTap: followLink,
                                  ),
                                );
                              },
                              separatorBuilder: (context, int index) =>
                                  const Divider(),
                              shrinkWrap: true,
                              // physics: const Neve
                              // physics: const NeverScrollableScrollPhysics(),
                            ),
                          );
                        }),
                        animationDuration: const Duration(microseconds: 50),
                      ),
                    ),
                  )),
        ],
      );

  _buildTitleBar(c) => Row(
        children: [
          OutlinedButton(
              onPressed: () {
                setState(() {
                  _expandedAll = !_expandedAll;
                  _panelExpanded.forEach((k, v) {
                    _panelExpanded[k] = _expandedAll;
                  });
                });
              },
              child: const Text("展开/收缩"))
        ],
      );

  void _switchExpanded(int panelIndex, bool isExpanded) => setState(() {
        _panelExpanded[panelIndex] = !isExpanded;
      });

  _buildTeamTile(
    BuildContext c,
    bool isExpanded,
    TeamModel team,
  ) =>
      ListTile(
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
              child: Text("重命名"),
            ),
            const PopupMenuItem(
              value: "invite",
              child: Text("邀请成员"),
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
                final name = await showTextInputDialog(
                  context: context,
                  title: "重命名团队",
                  origin: team.name,
                  hint: team.name,
                );
                if (name == null) return;
                await team.actEntrance(TeamAct.renameTeam(name));
                break;
              case "invite":
                final email = await showTextInputDialog(
                  context: context,
                  title: "${team.name} 团队邀请成员",
                  label: "请输入用户邮箱",
                  hint: "被邀请人的注册邮箱",
                );
                if (email == null) return;
                await team
                    .actEntrance(TeamAct.inviteMember(email))
                    .thenDialog(c);
                break;
              case "delete":
                await showConfirmDialog(
                    context: context,
                    title: "确认删除团队[${team.name}]吗?",
                    onConfirm: () => context
                        .read<UserModel>()
                        .actEntrance(UserAct.deleteTeam(team.id)));
                break;
              default:
                throw "error 未知的 key[$key]";
            }
          },
        ),
      );
}

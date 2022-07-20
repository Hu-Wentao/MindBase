part of 'model.dart';

/// Team
/// todo 实时刷新用户数据
class TeamModel extends ProviderSidecar {
  String get id => _team.$id;

  String get name => _team.name;
  aw.Team _team;
  List<WorkspaceDto> workspaces = [];

  int get createAt => _team.dateCreated;

  // todo 人员列表
  int get total => _team.total;

  @override
  onInitializing() {}

  TeamModel(this._team) : super(onCatch: ExceptionAdapter.of);
}

extension TeamModelX on TeamModel {
  TeamService get _teamSrv => sl<TeamService>();

  WorkspaceService get _workspaceSrv => sl<WorkspaceService>();

  actRefreshSpace() async => await actWrapper(() async {
        workspaces = await _workspaceSrv.queryWorkspaceDto(_team.$id);
        setInitialized("刷新[${_team.name}]团队的工作空间列表");
      });

  Future<Team?> actRenameTeam(String? newName) async =>
      await actWrapper(() async {
        if (newName == null) return null;
        _team = await _teamSrv.updateName(_team, newName);
        setInitialized("重命名团队[${_team.name}]");
      });

  Future<BaseException?> actInviteMember(String? userEmail) async =>
      await actWrapper(() async {
        if (userEmail == null) return;
        await _teamSrv.inviteMember(_team, userEmail);
        setUninitialized("邀请用户[$userEmail]加入团队[${_team.name}]");
      });
}

part of 'model.dart';

/// 管理登录用户相关的团队
class TeamManagerModel extends ProviderSidecar {
  /// 核心状态
  List<TeamModel> teams = [];

  ///
  /// 上级状态
  aw.User? _user;

  @override
  onInitializing() {}

  TeamManagerModel() : super(onCatch: ExceptionAdapter.of);
}

extension TeamManagerModelX on TeamManagerModel {
  TeamService get _teamSrv => sl<TeamService>();

  /// User相关

  onUserUpdate(aw.User? nUser) => actUpdateUser(nUser);

  Future<BaseException?> actUpdateUser(aw.User? nUser) async {
    if (_user != nUser) {
      _user = nUser;
      if (_user != null) {
        setInitialized("新用户已登录[${_user!.name}]");
        return actRefreshTeams();
      } else {
        setUninitialized("用户退出登录");
        return null;
      }
    }
    return null;
  }

  // 刷新用户名下Team数据
  Future<BaseException?> actRefreshTeams() async => await actWrapper(() async {
        final tms = await _teamSrv.getTeams();
        for (final t in tms) {
          final m = TeamModel(t);
          await m.actRefreshSpace();
          teams.add(m);
          setInitialized("刷新Team信息");
        }
        setInitialized("Team信息刷新完成");
      });

  Future<BaseException?> actDeleteTeam(String teamId) async =>
      await actWrapper(() async {
        await _teamSrv.deleteTeam(teamId);
        teams.removeWhere((tm) => tm.id == teamId);
        setInitialized("删除Team[$teamId]");
      });

  Future<BaseException?> actCreateTeam(String name) async =>
      await actWrapper(() async {
        final tm = await _teamSrv.createTeam(name);
        teams.add(TeamModel(tm));
        setInitialized("创建Team[${tm.$id}]");
      });
}

part of 'model.dart';

@freezed
class UserAct with _$UserAct {
  const factory UserAct.initSubTeams() = UserActInitSubTeams;

  const factory UserAct.refreshTeams() = UserActRefreshTeams;

  const factory UserAct.createTeam(String name) = UserActCreateTeam;

  const factory UserAct.deleteTeam(String teamId) = UserActDeleteTeam;
}

@freezed
class UserState with _$UserState {
  const factory UserState.init() = UserStateInit;

  const factory UserState.done(
    List<TeamModel> teams,
    String? markId,
  ) = UserStateDone;
}

class UserModel extends BaseActEntranceModel<UserAct, UserState> {
  UserModel(
    this.data,
    this.session, {
    super.state = const UserState.init(),
  });

  /// 核心状态
  final aw.Session session;
  final aw.User data;

  String? get id => data.$id;

  String? get name => data.name;

  String? get email => data.email;

  // 当前登录用户是否为 "匿名用户"
  bool get isAnonymous => (session.provider == 'anonymous');

  // 首选团队
  TeamModel? get markedTeam => state.mapOrNull<TeamModel?>(
      done: (it) => it.teams.firstWhereOrNull((team) => team.id == it.markId));

  @override
  onActEntrance(UserAct act) => act.when(
        refreshTeams: refreshTeams,
        deleteTeam: deleteTeam,
        createTeam: createTeam,
        initSubTeams: initSubTeams,
      );

  @protected
  List<TeamModel> get teams => state.mapOrNull(done: (it) => it.teams) ?? [];

  @override
  String toString() =>
      'UserModel{user: ${data.toMap()} session: ${session.toMap()}, teams: $teams}';
}

extension UserTeamX on UserModel {
  initSubTeams() async {
    _realtimeSrv.watchTeams().listen((event) async {
      final Tuple2<List<TeamModel>, String?> s = state.map(
          // ignore: prefer_const_constructors
          init: (e) => Tuple2([], null),
          done: (e) => Tuple2(e.teams, e.markId));
      setState(
          UserStateDone(
              s.value1.updateDataSet<aw.Team>(
                event,
                equals: (a, b) => a.id == b.id,
                transform: (data) => TeamModel(data, this),
              ),
              s.value2),
          '更新List状态');
      await refreshTeams();
    });
  }

  createTeam(String name) async {
    if (isAnonymous) {
      throw UnLoginException('当前以匿名身份登录, 无法创建团队', '请先注册或登录新账号');
    }
    final tm = await _teamSrv.createTeam(name);
    setState(state, '创建team[${tm.$id}]');
  }

  deleteTeam(String teamId) async {
    await _teamSrv.deleteTeam(teamId);
    state.mapOrNull(
        done: (it) => it.teams.removeWhere((tm) => tm.id == teamId));
    setState(state, '删除team[$teamId]');
  }

  refreshTeams() async {
    final tms =
        (await _teamSrv.getTeams()).map((e) => TeamModel(e, this)).toList();
    setState(UserState.done(tms, markedTeam?.id), '刷新teams列表');
  }

  RealtimeSrv get _realtimeSrv => sl<RealtimeSrv>();

  TeamService get _teamSrv => sl<TeamService>();
}

extension UserDepreX on UserModel {
  @Deprecated('存在即登陆')
  bool get isLogged => true;

  @Deprecated('判断状态')
  TeamModel? getTeam(String teamId) =>
      teams.firstWhereOrNull((tm) => tm.id == teamId);

  @Deprecated("避免使用")
  aw.User loggedUser() => data;

  /// 退出登录
  /// 同时重置当前Model状态
  @Deprecated('使用AppStateModel的logout')
  Future<BaseException?> actLogout() async => throw '使用AppStateModel的logout';

  /// 尝试加载指定[TeamModel]
  /// 1. 查询当前用户名下是否存在team
  ///   1.1 如果存在, 则加载该team; 结束;
  ///   1.2 如果不存在, 则尝试以访客身份加入team; 结束;
  @Deprecated('refreshTeams')
  Future<BaseException?> actLoadTeam(String teamId) =>
      actEntrance(const UserAct.refreshTeams());

  @Deprecated('deleteTeam')
  Future<BaseException?> actDeleteTeam(String teamId) =>
      actEntrance(UserAct.deleteTeam(teamId));

  @Deprecated('createTeam')
  Future<BaseException?> actCreateTeam(String name) async =>
      actEntrance(UserAct.createTeam(name));
}

part of '../model.dart';

@freezed
class UserAct with _$UserAct {
  const factory UserAct.initModel() = UserActInitModel;

  const factory UserAct.updateTeams() = UserActUpdateTeams;

  const factory UserAct.createTeam(String name) = UserActCreateTeam;

  const factory UserAct.deleteTeam(String teamId) = UserActDeleteTeam;
}

@Freezed(makeCollectionsUnmodifiable: false)
class UserState with _$UserState {
  const factory UserState.init() = UserStateInit;

  const factory UserState.done(
    List<TeamModel> teams,
  ) = UserStateDone;
}

class UserModel extends BaseActEntranceModel<UserAct, UserState> {
  final Session session;
  final User data;

  UserModel(this.data, this.session) : super(state: const UserState.init());

  @override
  String get id => data.$id;

  String? get name => data.name;

  String? get email => data.email;

  // 当前登录用户是否为 "匿名用户"
  bool get isAnonymous => (session.provider == 'anonymous');

  TeamModel? findTeam(String teamId) => state.mapOrNull<TeamModel?>(
      done: (it) => it.teams.firstWhereOrNull((team) => team.id == teamId));

  @override
  onActEntrance(UserAct act) => act.when(
        updateTeams: updateTeams,
        deleteTeam: deleteTeam,
        createTeam: createTeam,
        initModel: initModel,
      );

  @protected
  List<TeamModel> get teams => state.mapOrNull(done: (it) => it.teams) ?? [];

  @override
  String toString() =>
      'UserModel{user: ${data.toMap()} session: ${session.toMap()}, teams: $teams}';
}

extension UserTeamX on UserModel {
  @protected
  initModel() async {
    _realtimeSrv.watchTeams().listen((event) async {
      final nState = UserStateDone(teams.updateDataSet<Team>(
        event,
        equals: (a, b) => a.id == b.id,
        transform: TeamModel.new,
      ));
      setState(nState, '更新TeamList[${event.type}]');
    });
    await updateTeams();
  }

  @protected
  createTeam(String name) async {
    if (isAnonymous) {
      throw UnLoginException('当前以匿名身份登录, 无法创建团队', '请先注册或登录新账号');
    }
    final tm = await _teamSrv.createTeam(name);
    setState(state, '创建team[${tm.$id}]');
  }

  @protected
  deleteTeam(String teamId) async {
    await _teamSrv.deleteTeam(teamId);
    state.mapOrNull(
        done: (it) => it.teams.removeWhere((tm) => tm.id == teamId));
    setState(state, '删除team[$teamId]');
  }

  // 因为TeamModel内部包含子状态，因此team列表需要更新data，而不是替换列表
  @protected
  updateTeams() async {
    final modelLs = state.isOrNull<UserStateDone>()?.teams ?? [];
    final dataLs = await _teamSrv.getTeams();
    final rst = <TeamModel>[];
    // 复用老Model（以新team为基础）
    for (final model in modelLs) {
      final nTeam = (dataLs.removeWhereOrNull((t) => t.$id == model.id));
      // 新列表没有，表明该team已经被删除
      if (nTeam == null) continue;
      // 将有效Model添加到新List
      rst.add(model..actEntrance(TeamAct.updateTeam(nTeam)));
    }
    // 添加新Model
    for (final data in dataLs) {
      rst.add(TeamModel(data));
    }
    setState(UserState.done(rst), '刷新teams列表[${rst.length}]');
  }

  RealtimeSrv get _realtimeSrv => sl<RealtimeSrv>();

  TeamService get _teamSrv => sl<TeamService>();
}

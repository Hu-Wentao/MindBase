part of '../model.dart';

@freezed
class TeamAct with _$TeamAct {
  /// 初始化：更新spaces/members,并watch spaces/members变更
  const factory TeamAct.initModel() = TeamActInitModel;

  // const factory TeamAct.closeModel() = TeamActCloseSpaces;

  ///
  const factory TeamAct.updateTeam(aw.Team team) = TeamActUpdateTeam;

  const factory TeamAct.renameTeam(String name) = TeamActRenameTeam;

  ///
  const factory TeamAct.updateSpaces() = TeamActUpdateSpaces;

  ///
  const factory TeamAct.createSpace(String name) = TeamActCreateSpace;

  const factory TeamAct.deleteSpace(String spaceId) = TeamActDeleteSpace;

  ///
  const factory TeamAct.updateMembers() = TeamActUpdateMembers;

  const factory TeamAct.inviteMember(String userEmail) = TeamActInviteMember;
}

@freezed
class TeamState with _$TeamState {
  const factory TeamState.init() = TeamStateInit;

  const factory TeamState.done({
    required List<SpaceModel> workspaces,
    required List<MemberModel> members,
  }) = TeamStateDone;
}

/// Team
/// todo 实时刷新用户数据
/// todo #517 没有字段用于存储roles枚举, 如果member过多,可能会导致某些roles不能立即加载
class TeamModel extends BaseActEntranceModel<TeamAct, TeamState> {
  aw.Team data; // 可变

  TeamModel(this.data, {super.state = const TeamState.init()});

  @override
  String get id => data.$id;

  String get name => data.name;

  int get createAt => int.parse(data.$createdAt);

  int get total => data.total;

  /// 子状态Model
  @protected
  List<SpaceModel> get workspaces =>
      state.isOrNull<TeamStateDone>()?.workspaces ?? const [];

  @protected
  List<MemberModel> get members =>
      state.isOrNull<TeamStateDone>()?.members ?? const [];

  MemberModel? get teamOwner =>
      members.firstWhereOrNull((mbr) => mbr.roles.contains(RoleX.owner(id)));

  SpaceModel? findSpace(spaceId) =>
      workspaces.firstWhereOrNull((s) => s.id == spaceId);

  @override
  onActEntrance(TeamAct act) => act.when(
        initModel: initModel,
        updateTeam: updateTeam,
        renameTeam: renameTeam,
        updateSpaces: updateSpaces,
        createSpace: createSpace,
        deleteSpace: deleteSpace,
        updateMembers: updateMembers,
        inviteMember: inviteMember,
      );

  initModel() async {
    // todo 订阅 member + space变更
    // 刷新数据
    await updateSpaces();
    await updateMembers();
  }

  updateTeam(aw.Team team) async {
    data = team;
    setState(state, '更新team[$id]');
  }
}

extension TeamModelX on TeamModel {
  renameTeam(String name) async {
    final data = await _teamSrv.updateNameBy(id, name);
    updateTeam(data);
  }

  TeamService get _teamSrv => sl<TeamService>();
}

extension TeamSpaceX on TeamModel {
  deleteSpace(String spaceId) async {
    await _workspaceSrv.deleteSpace(spaceId);
    setState(state, "删除工作空间[$spaceId]完成");
  }

  createSpace(String name) async {
    final data = await _workspaceSrv.createSpaceModelDtoBy(id, name);
    state.isOrNull<TeamStateDone>()?.workspaces.add(SpaceModel(data));
    setState(state, '新增space[${data.id}]');
  }

  updateSpaces() async {
    final dataLs = await _workspaceSrv.querySpaceModelDto(id);
    final rst = <SpaceModel>[];
    // 以新spaceLs为基础，复用老Model
    for (final model in workspaces) {
      final nData = dataLs.removeWhereOrNull((s) => s.id == model.id);
      if (nData == null) continue;
      rst.add(model..updateData(nData));
    }
    for (var data in dataLs) {
      rst.add(SpaceModel(data));
    }
    setState(TeamStateDone(workspaces: rst, members: members),
        '刷新SpaceModels[${rst.length}]');
  }

  SpaceService get _workspaceSrv => sl<SpaceService>();
}

extension TeamMemberX on TeamModel {
  inviteMember(String userEmail) async {
    await _teamSrv.inviteMember(data, userEmail);
    setState(state, "邀请用户[$userEmail]加入团队[$name]");
  }

  updateMembers() async {
    final dataLs = (await _tmSrv.listMemberships(teamId: id)).memberships;
    final rst = <MemberModel>[];
    for (final model in members) {
      final nData = dataLs.removeWhereOrNull((_) => _.$id == model.id);
      if (nData == null) continue;
      rst.add(model..updateData(nData));
    }
    for (var data in dataLs) {
      rst.add(MemberModel(data, this));
    }
    setState(TeamStateDone(workspaces: workspaces, members: rst),
        '刷新Members[${rst.length}]');
  }

  cli.Teams get _tmSrv => sl<cli.Teams>();
}

extension TeamDeprecatedX on TeamModel {
  @Deprecated('createSpace')
  Future<BaseException?> actCreateSpaceModel(
    String spaceName, {
    Function(SpaceDto w)? onCreated,
  }) =>
      actEntrance(TeamAct.createSpace(spaceName));
}

/// ============================================================================

abstract class IMemberModel
    extends ModelSidecar<aw.Membership, BaseException?> {
  IMemberModel(aw.Membership data) : super(data, ExceptionAdapter.of);
}

class MemberModel extends IMemberModel {
  MemberModel(super.data, this.at);

  String get id => data.$id;

  String get userId => data.userId;

  String get userName => data.userName;

  // String get teamId => data.teamId;
  String get name => data.teamName;

  String get email => data.userEmail;

  String get invited => data.invited; // ts
  String get joined => data.joined; // ts
  bool get confirm => data.confirm;

  List get roles => data.roles;

  // 上层状态
  final TeamModel at;
}

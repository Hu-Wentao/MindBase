part of '../model.dart';

@freezed
class TeamAct with _$TeamAct {
  /// 初始化：更新spaces/members,并watch spaces/members变更
  const factory TeamAct.initModel() = TeamActInitModel;

  // const factory TeamAct.closeModel() = TeamActCloseSpaces;

  ///
  const factory TeamAct.updateTeam(Team team) = TeamActUpdateTeam;

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
}

/// Team
/// todo 实时刷新用户数据
/// todo 没有字段用于存储roles枚举, 如果member过多,可能会导致某些roles不能立即加载
class TeamModel extends BaseActEntranceModel<TeamAct, TeamState> {
  final Team data;

  TeamModel(this.data,{super.state = const TeamState.init()});

  @override
  onActEntrance(TeamAct act) {
    // TODO: implement onActEntrance
    throw UnimplementedError();
  } // 可变
}
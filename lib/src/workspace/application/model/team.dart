part of 'model.dart';

@Deprecated('TeamModel')
typedef OpenedSpaceManagerModel = TeamModel;

abstract class ITeamModel extends ModelSidecar<aw.Team, BaseException?>
    with ModelStateChangeMx<aw.Team, BaseException?> {
  ITeamModel(aw.Team data) : super(data, ExceptionAdapter.of);

  String get id;

  List<WorkspaceModel> get workspaces;

  List<MemberModel> get members;

  WorkspaceModel addNewWorkspaceModel(WorkspaceDto data);

  MemberModel addNewMemberModel(aw.Membership data);
}

mixin TeamStateChangeMx on ITeamModel {
  final WorkspaceService _workspaceSrv = sl<WorkspaceService>();
  final _tmSrv = sl<Teams>();

  @override
  Future<FutureOr<void>> onFetch({bool isActive = false}) async {
    // 全量拉取数据,原有数据将在 onReset方法中被清除
    // workspace
    for (var data in (await _workspaceSrv.queryWorkspaceDto(id))) {
      addNewWorkspaceModel(data);
    }
    // member
    for (var data in (await _tmSrv.getMemberships(teamId: id)).memberships) {
      addNewMemberModel(data);
    }
  }

  @override
  FutureOr<void> onReset() {
    workspaces.clear();
    members.clear();
  }

  @override
  FutureOr<void> onSubscription() {
    log('onSubscription 尚未实现...');
  }

  @override
  FutureOr<void> onCloseSubs() {
    log('onCloseSubs 尚未实现...');
  }
}

/// Team
/// todo 实时刷新用户数据
class TeamModel extends ITeamModel with TeamStateChangeMx {
  @override
  String get id => data.$id;

  String get name => data.name;

  int get createAt => data.$createdAt;

  int get total => data.total;

  // todo
  @Deprecated('后期实现人员列表后更新为纯getter,目前通过手动配置')
  bool tmpIsMember = true;

  bool get isMember => tmpIsMember;

  /// 上层状态引用
  final UserModel at;

  /// 子状态Model
  // 懒初始化 (初始化一个工作空间比较昂贵)
  @override
  List<WorkspaceModel> workspaces = [];
  @override
  List<MemberModel> members = [];

  TeamModel(super.data, this.at);

  @Deprecated("workspaces")
  List<WorkspaceModel> get openedWorkspaces => workspaces;

  @override
  WorkspaceModel addNewWorkspaceModel(WorkspaceDto data) {
    final m = WorkspaceModel(data, this);
    // 没有必要立即初始化工作空间, 打开空间比较昂贵, 在Page中手动调用比较合适
    workspaces.add(m);
    setDoneKeepState("新增 WorkspaceModel[${m.id}]");
    return m;
  }

  @override
  MemberModel addNewMemberModel(aw.Membership data) {
    final m = MemberModel(data, this);
    members.add(m);
    setDoneKeepState("新增 MemberModel[${m.id}]");
    return m;
  }
}

extension TeamModelX on TeamModel {
  TeamService get _teamSrv => sl<TeamService>();

  WorkspaceService get _workspaceSrv => sl<WorkspaceService>();

  Future<BaseException?> actRenameTeam(String? newName) async =>
      await actWrapper(() async {
        if (newName == null) return null;
        data = await _teamSrv.updateName(data, newName);
        setDone("重命名团队[$name]", null, false);
      });

  Future<BaseException?> actInviteMember(String? userEmail) async =>
      await actWrapper(() async {
        if (userEmail == null) return;
        await _teamSrv.inviteMember(data, userEmail);
        setDone("邀请用户[$userEmail]加入团队[$name]");
      });

  /// 新建工作空间
  Future<BaseException?> actCreateWorkspace(
    String spaceName, {
    Function(WorkspaceDto w)? onCreated,
  }) async =>
      await actWrapper(() async {
        final data = await _workspaceSrv.createWorkspaceDtoBy(id, spaceName);
        addNewWorkspaceModel(data);
        onCreated?.call(data);
      });

  Future<BaseException?> actRenameSpaceName(
          WorkspaceDto space, String? nName) async =>
      await actWrapper(() async {
        if (nName == null) return;
        final r = await _workspaceSrv.updateWorkspaceName(space, nName);
        setDone("重命名工作空间[$nName]完成", null, false);
      });

  Future<BaseException?> actDeleteSpace(String spaceId) async =>
      await actWrapper(() async {
        final r = await _workspaceSrv.deleteSpace(spaceId);
        workspaces.removeWhere((w) => w.id == spaceId);
        setDone("删除工作空间[$spaceId]完成", null, false);
      });
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

  int get invited => data.invited; // ts
  int get joined => data.joined; // ts
  bool get confirm => data.confirm;

  List get roles => data.roles;

  // 上层状态
  final TeamModel at;
}

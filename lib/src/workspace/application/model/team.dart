part of 'model.dart';

@Deprecated('TeamModel')
typedef OpenedSpaceManagerModel = TeamModel;

abstract class ITeamModel extends ModelSidecar<aw.Team, BaseException?>
    with ModelStateChangeMx<aw.Team, BaseException?> {
  ITeamModel(aw.Team data) : super(data, ExceptionAdapter.of);

  String get id;

  List<WorkspaceModel> get workspaces;
}

mixin TeamStateChangeMx on ITeamModel {
  final WorkspaceService _workspaceSrv = sl<WorkspaceService>();

  @override
  FutureOr<void> onCloseSubs() {
    log('onCloseSubs 尚未实现...');
  }

  @override
  Future<FutureOr<void>> onFetch({bool isActive = false}) async {
    final wsList = (await _workspaceSrv.queryWorkspaceDto(id))
        .map((e) =>
            workspaces.firstWhereOrNull((element) {
              if (element.id == e.id) {
                element.updateData(e);
                return true;
              }
              return false;
            }) ??
            WorkspaceModel(e))
        .toList();
    workspaces.addAll(wsList);
  }

  @override
  FutureOr<void> onReset() {
    workspaces.clear();
  }

  @override
  FutureOr<void> onSubscription() {
    log('onSubscription 尚未实现...');
  }
}

/// Team
/// todo 实时刷新用户数据
class TeamModel extends ITeamModel with TeamStateChangeMx {
  @override
  String get id => data.$id;

  String get name => data.name;

  int get createAt => data.dateCreated;

  int get total => data.total;

  // todo
  @Deprecated('后期实现人员列表后更新为纯getter,目前通过手动配置')
  bool tmpIsMember = true;

  bool get isMember => tmpIsMember;

  // 子状态Model // todo 人员列表
  final UserModel at;
  @override
  List<WorkspaceModel> workspaces = [];

  TeamModel(super.data, this.at);

  @Deprecated("workspaces")
  List<WorkspaceModel> get openedWorkspaces => workspaces;
}

extension TeamModelX on TeamModel {
  TeamService get _teamSrv => sl<TeamService>();

  WorkspaceService get _workspaceSrv => sl<WorkspaceService>();

  /// 通过REST 刷新, 因此最后调用 [setDone]
  @Deprecated('actRefresh')
  actRefreshSpace() async => await actWrapper(() async {
        workspaces = (await _workspaceSrv.queryWorkspaceDto(id))
            .map((e) =>
                workspaces.firstWhereOrNull((element) {
                  if (element.id == e.id) {
                    element.updateData(e);
                    return true;
                  }
                  return false;
                }) ??
                WorkspaceModel(e))
            .toList();
        setDone("刷新[$name]团队的工作空间列表", null, false);
      });

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
        final r = await _workspaceSrv.createWorkspaceDtoBy(id, spaceName);
        workspaces.add(WorkspaceModel(r));
        setDone("创建工作空间成功", null, false);
        onCreated?.call(r);
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

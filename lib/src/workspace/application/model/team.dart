part of 'model.dart';

// typedef OpenedSpaceManagerModel = TeamModel;

/// Team
/// todo 实时刷新用户数据
class TeamModel extends ModelSidecar<aw.Team, BaseException?> {
  String get id => data.$id;

  String get name => data.name;

  int get createAt => data.dateCreated;

  // todo 人员列表
  int get total => data.total;

  // 子状态Model
  List<WorkspaceModel> workspaces = [];

  TeamModel(aw.Team data) : super(data, ExceptionAdapter.of);
}

extension TeamModelX on TeamModel {
  TeamService get _teamSrv => sl<TeamService>();

  WorkspaceService get _workspaceSrv => sl<WorkspaceService>();

  /// 通过REST 刷新, 因此最后调用 [setDone]
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
        setDone("刷新[$name]团队的工作空间列表");
      });

  Future<BaseException?> actRenameTeam(String? newName) async =>
      await actWrapper(() async {
        if (newName == null) return null;
        data = await _teamSrv.updateName(data, newName);
        setDone("重命名团队[$name]");
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
        setDone("创建工作空间成功");
        onCreated?.call(r);
      });

  Future<BaseException?> actRenameSpaceName(
          WorkspaceDto space, String? nName) async =>
      await actWrapper(() async {
        if (nName == null) return;
        final r = await _workspaceSrv.updateWorkspaceName(space, nName);
        setInitialized("重命名工作空间[$nName]完成");
      });

  Future<BaseException?> actDeleteSpace(String spaceId) async =>
      await actWrapper(() async {
        final r = await _workspaceSrv.deleteSpace(spaceId);
        workspaces.removeWhere((w) => w.id == spaceId);
        setInitialized("删除工作空间[$spaceId]完成");
      });

  // 打开一个空间
  Future<BaseException?> actOpenWorkspaceById(String workspaceId) async => await actWrapper((){
      // 在team中查询是否存在该空间

    });

}

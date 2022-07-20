part of 'model.dart';

/// 管理所有`已打开的`工作空间, 包括已加入团队的空间和访客身份浏览的空间
/// 与 TeamModel 不同, Team管理下管理成员与Team所属空间, 之上的UserModel管理所有Team
/// todo 可以考虑缓存工作空间对应的Team,以便处理协作权限问题
class OpenedSpaceManagerModel extends ProviderSidecar {
  final WorkspaceService _workspaceSrv = sl<WorkspaceService>();

  // 状态
  List<OpenedWorkspace> openedWorkspaces = [];

  /// 清理所有缓存
  actCleanCache(String msg) {
    openedWorkspaces
      ..forEach((ws) => ws.close())
      ..clear();
    setUninitialized("工作空间管理器已清空 [$msg]");
  }

  /// 打开Workspace,并缓存;
  Future<BaseException?> actOpenWorkspaceById(String workspaceId,
          {bool andSelect = true}) async =>
      await actWrapper(() async {
        // 选中工作空间
        openedWorkspaces.firstWhereOrNull((w) => w.id == workspaceId) ??
            await _openCacheWorkspaceById(workspaceId);
      });

  /// 关闭工作空间
  Future<BaseException?> actCloseWorkspace(String workspaceId) async =>
      await actWrapper(() => setInitialized("关闭工作空间[$workspaceId]成功", () {
            openedWorkspaces.removeWhere((element) {
              if (element.id == workspaceId) {
                element.close();
                return true;
              } else {
                return false;
              }
            });
          }));

  /// 打开并缓存
  Future<OpenedWorkspace> _openCacheWorkspaceById(String workspaceId) async {
    final ws = await _workspaceSrv.openWorkspaceBy(workspaceId);
    openedWorkspaces.add(ws);
    return ws;
  }

  /// ==========================================================================

  /// 当上层状态 [User] 刷新时的处理
  onUserUpdate(User? user) {
    // 当前"空间管理器"与登录用户状态无关, 不做处理
  }

  //

  @override
  onInitializing() => null;

  OpenedSpaceManagerModel() : super(onCatch: ExceptionAdapter.of);
}

extension OpenedSpaceManagerModelX on OpenedSpaceManagerModel {
  /// 新建工作空间
  Future<BaseException?> actCreateWorkspace(
    String teamId,
    String spaceName, {
    Function(WorkspaceDto w)? onCreated,
  }) async =>
      await actWrapper(() async {
        final r = await _workspaceSrv.createWorkspaceDtoBy(teamId, spaceName);
        // _addWorkspace(r.value1, r.value2);
        onCreated?.call(r);
        setInitialized("创建工作空间成功");
      });
}

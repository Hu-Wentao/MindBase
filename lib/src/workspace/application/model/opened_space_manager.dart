part of 'model.dart';

/// 管理所有`已打开的`工作空间, 包括已加入团队的空间和访客身份浏览的空间
/// 与 TeamModel 不同, Team管理下管理成员与Team所属空间, 之上的UserModel管理所有Team
/// todo 可以考虑缓存工作空间对应的Team,以便处理协作权限问题
class OpenedSpaceManagerModel extends ProviderSidecar {
  final WorkspaceService _workspaceSrv = sl<WorkspaceService>();

  /// 打开某个空间前,备份该空间id,以便[actReopenSpace]重试
  final List<String> _readyOpenList = [];

  // 状态
  final List<OpenedWorkspace> openedWorkspaces = [];

  /// 重新打开空间
  Stream<BaseException?> actReopenSpace(String msg) async* {
    final ls = openedWorkspaces.map((e) => e.id).toList();
    _readyOpenList.addAll(ls);
    setEmptyState(msg);
    log('尝试重新打开空间[$_readyOpenList]');
    final len = _readyOpenList.length;
    for (var i = 0; i < len; i++) {
      // 从头部抽取id,尝试重新打开; 如果失败,则还会将失败的id插入到尾部
      final r = await actOpenWorkspaceById(_readyOpenList.removeAt(0));
      if (r != null) yield ExceptionAdapter.of(r);
    }
  }

  /// 清理所有缓存
  setEmptyState(String msg) {
    openedWorkspaces
      ..forEach((ws) => ws.close())
      ..clear();
    setUninitialized("[$msg] 工作空间管理器已清空");
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
    // 先存到[_readyOpenList],防止打开失败后找不到要重开的工作空间Id
    _readyOpenList.add(workspaceId);
    final ws = await _workspaceSrv.openWorkspaceBy(workspaceId);
    openedWorkspaces.add(ws);
    // 打开成功后从List移除
    _readyOpenList.remove(workspaceId);
    setInitialized("打开工作空间[$workspaceId]成功");
    return ws;
  }

  /// ==========================================================================

  /// 当上层状态 [User] 刷新时, 重置所有工作空间
  User? _cacheUser;

  Future<BaseException?> actOnUserUpdate(User? user) async {
    print(
        'debug OpenedSpaceManagerModel.onUserUpdate: ${user?.name}, ${_cacheUser?.name}');
    if (user != _cacheUser) {
      if (user == null) {
        setEmptyState("用户已登出,重置空间");
      } else {
        _cacheUser = user;
        return await actReopenSpace("用户[${user.name}]已登录,重置空间").first;
      }
    }
    return null;
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

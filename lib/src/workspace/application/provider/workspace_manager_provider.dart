import 'package:appwrite/models.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/workspace/application/service/workspace_service.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

import 'opened_workspace.dart';

/// 管理用户名下的所有工作空间
/// 包括对`已打开的的Workspace的数据同步工作`
class WorkspaceManagerProvider extends ProviderSidecar {
  // final EventBus _eventBus = sl<EventBus>();
  final WorkspaceService _workspaceSrv = sl<WorkspaceService>();

  // 父级状态 缓存当前已登录的用户, 确保登录用户与缓存的工作空间是一致的;
  User? user;

  // 状态
  Map<Team, List<WorkspaceDto>> workspaces = {};
  List<OpenedWorkspace> openedWorkspaces = [];
  OpenedWorkspace? selectedWorkspace;

  // 用户登录成功后,才能够获取到 工作空间列表
  WorkspaceManagerProvider() : super(onCatch: ExceptionAdapter.of);

  @override
  onInitializing() async {
    // _workspaceSrv =;
    // _eventBus = ;
    // _initEventBus();
    // _initWorkspaces();
    // todo 考虑添加一层OpenTeam,以监听工作空间的创建与关闭
    setInitialized("工作空间同步完成");
  }

  // _initEventBus() => _eventBus
  //   ..on<WorkspaceOpenedEvt>().listen((event) {
  //     // 获取数据
  //   });

  onUserUpdate(User? nUser) {
    if (nUser != user) {
      return (nUser == null) ? actCleanCache("尚未登录") : actSyncUserInfo(nUser);
    }
  }

  actCleanCache(String msg) {
    user = null;
    workspaces.clear();
    openedWorkspaces.clear();
    selectedWorkspace = null;
    setUninitialized(msg);
  }

  actSyncUserInfo(User nUser) async => await actWrapper(() async {
        if (user != nUser) {
          setInitialized("刷新已登录用户", () {
            user = nUser;
          });
        }
        workspaces = await (_workspaceSrv.queryAllUserWorkspaceDtoList());
        setInitialized("已同步用户数据");
      });

  /// 新建工作空间
  Future<BaseException?> actCreateWorkspace(
    Team? team,
    String spaceName,
  ) async =>
      await actWrapper(() async {
        final r = await _workspaceSrv.createWorkspaceDto(team, spaceName);
        _addWorkspace(r.value1, r.value2);
        setInitialized("创建工作空间成功");
      });

  /// 打开或返回已存在的OpenedWorkspace
  Future<BaseException?> actOpenWorkspaceById(String workspaceId,
          {bool andSelect = true}) async =>
      await actWrapper(() async {
        // 选中工作空间
        final idx = openedWorkspaces.indexWhere((w) => w.id == workspaceId);
        final ws = (idx == -1)
            ? await _openCacheWorkspaceById(workspaceId)
            : openedWorkspaces[idx];
        if (andSelect && selectedWorkspace != ws) {
          selectedWorkspace = ws;
          // 延迟刷新
          Future.delayed(Duration.zero, () {
            setInitialized("切换工作空间[$workspaceId]成功", () async {});
          });
        }
        return ws;
      });

  /// 关闭工作空间
  Future<BaseException?> actCloseWorkspace(Workspace workspace) async =>
      await actWrapper(() => setInitialized("关闭工作空间[${workspace.id}]成功", () {
            openedWorkspaces
                .removeWhere((element) => element.id == workspace.id);
          }));

  /// 打开并缓存
  Future<OpenedWorkspace> _openCacheWorkspaceById(String workspaceId) async {
    final ws = await _openWorkspace(workspaces.values
        .expand((element) => element)
        .firstWhere((element) => element.id == workspaceId));
    // 首次打开,发送事件
    // _eventBus.fire(WorkspaceOpenedEvt(ws.workspace));
    openedWorkspaces.add(ws);
    return ws;
  }

  // `real` 打开工作空间, 并缓存
  Future<OpenedWorkspace> _openWorkspace(WorkspaceDto workspace) async {
    final w = await _workspaceSrv.openWorkspace(workspace);
    openedWorkspaces.add(w);
    return w;
  }

  _isOpened(String workspaceId) =>
      openedWorkspaces.any((element) => element.id == workspaceId);

  // 缓存工作空间
  _addWorkspace(Team team, WorkspaceDto workspace) {
    (workspaces[team] ??= []).add(workspace);
  }

  Future<Team?> actRenameTeam(Team team, String? newName) async {
    if (newName == null) return null;
    await _workspaceSrv.updateName(team, newName);
    await actSyncUserInfo(user!);
    return null;
  }

  Future<void> actDeleteTeam(String teamId) async {
    await _workspaceSrv.deleteTeam(teamId);
    await actSyncUserInfo(user!);
  }

  Future<BaseException?> actInviteMember(Team team, String? userEmail) async =>
      await actWrapper(() async {
        if (userEmail == null) return;
        await _workspaceSrv.inviteMember(team, userEmail);
      });

  Future<BaseException?> actRenameSpace(
          WorkspaceDto space, String? nName) async =>
      await actWrapper(() async {
        if (nName == null) return;
        await _workspaceSrv.updateWorkspaceName(space, nName);
        setInitialized('更新工作空间名称[$nName]', () async {
          // 刷新缓存
          await actSyncUserInfo(user!);
        });
      });

  Future<BaseException?> actDeleteSpace(String id) async =>
      await actWrapper(() async {
        await _workspaceSrv.deleteSpace(id);
        setInitialized('删除工作空间[$id]', () async {
          // 刷新缓存
          await actSyncUserInfo(user!);
        });
      });
}

import 'package:appwrite/models.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/provider/event_provider.dart';
import 'package:mind_base/src/application/service/workspace_service.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/exceptions/exceptions.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

/// 管理用户名下的所有工作空间
/// todo
class WorkspaceManagerProvider extends ProviderSidecar {
  late WorkspaceService workspaceSrv;

  // 父级状态
  User? user;

  // 状态
  Map<Team, List<Workspace>> workspaces = {};
  List<OpenedWorkspace> openedWorkspaces = [];

  // 用户登录成功后,才能够获取到 工作空间列表
  WorkspaceManagerProvider(this.user) : super(onCatch: ExceptionAdapter.of);

  @override
  onInitializing() async {
    // user为null,表示尚未登录X
    if (user == null) {
      setUninitialized("尚未登录");
      return;
    }
    workspaceSrv = sl<WorkspaceService>();
    // realTimeSrv = sl<RealTimeService>();
    // 同步当前用户的工作空间 等
    final teams = await workspaceSrv.allTeams();
    workspaces = await (workspaceSrv.getWorkspaces(teams));
    // print("teams: ${teams.map((e) => e.toMap())}");
    // print("workspaces: $workspaces");
    setInitialized("工作空间同步完成");
  }

  actUpdate(User? nUser) {
    // print("actUpdate user: $nUser, judge: ${nUser != user}; ${nUser == null}");
    if (nUser != user) {
      if (nUser == null) {
        setUninitialized("尚未登录");
      } else {
        user = nUser;
        actInitializing(m: "更新已登录用户信息");
      }
    }
  }

  /// 新建工作空间
  Future<BaseException?> actCreateWorkspace(
    Team? team,
    String spaceName,
  ) async =>
      await actWrapper(() async {
        final r = await workspaceSrv.createWorkspace(team, spaceName);
        _addWorkspace(r.value1, r.value2);
        setInitialized("创建工作空间成功");
      });

  /// 打开或返回已存在的OpenedWorkspace
  // actOpenWorkspace(Workspace workspace) => actOpenWorkspaceById(workspace.id);

  actOpenWorkspaceById(String workspaceId) => actWrapper(() {
        final ws = openedWorkspaces.firstWhere(
          (opened) => opened.workspace.id == workspaceId,
          orElse: () => _openWorkspaceById(workspaceId),
        );
        sl<EventBus>().fire(WorkspaceOpenedEvt(ws.workspace));
        setInitialized("打开工作空间$workspaceId成功");
      });

  /// 关闭工作空间
  closeWorkspace(Workspace workspace) =>
      openedWorkspaces.removeWhere((element) => element.workspace == workspace);

  // 打开工作空间, 并缓存
  _openWorkspace(Workspace workspace) {
    final w = workspace.open();
    openedWorkspaces.add(w);
    return w;
  }

  _openWorkspaceById(String workspaceId) {
    final w = workspaces.values
        .expand((element) => element)
        .firstWhere((element) => element.id == workspaceId);
    return _openWorkspace(w);
  }

  _isOpened(String workspaceId) =>
      openedWorkspaces.any((element) => element.workspace.id == workspaceId);

  // 缓存工作空间
  _addWorkspace(Team team, Workspace workspace) {
    (workspaces[team] ??= []).add(workspace);
  }

  getOpenedWorkspace(String workspaceId) async {
    if (_isOpened(workspaceId)) {
      return openedWorkspaces
          .firstWhere((element) => element.workspace.id == workspaceId);
    } else {
      final err = await actOpenWorkspaceById(workspaceId);
      if (err != null) {
        throw err;
      }
      return getOpenedWorkspace(workspaceId);
    }
  }
}

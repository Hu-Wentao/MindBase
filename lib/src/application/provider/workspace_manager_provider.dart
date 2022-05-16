import 'package:appwrite/models.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/service/workspace_service.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

/// 管理用户名下的所有工作空间
/// todo
class WorkspaceManagerProvider extends ProviderSidecar {
  late WorkspaceService workspaceSrv;

  // late RealTimeService realTimeSrv;

  // 父级状态
  final User? user;

  // 状态
  Map<Team, List<Workspace>> workspaces = {};
  List<OpenedWorkspace> openedWorkspaces = [];

  // 用户登录成功后,才能够获取到 工作空间列表
  WorkspaceManagerProvider(this.user);

  @override
  onInitializing() async {
    // user为null,表示尚未登录
    if (user == null) return;
    workspaceSrv = sl<WorkspaceService>();
    // realTimeSrv = sl<RealTimeService>();
    // 同步当前用户的工作空间 等
    final teams = await workspaceSrv.allTeams();
    workspaces = await (workspaceSrv.getWorkspaces(teams));
    setInitialized("工作空间同步完成");
  }

  /// 新建工作空间
  actCreateWorkspace(Team? team, String spaceName) => actWrapper(() async {
        final r = await workspaceSrv.createWorkspace(team, spaceName);
        _addWorkspace(r.value1, r.value2);
        setInitialized("创建工作空间成功");
      });

  /// 打开或返回已存在的OpenedWorkspace
  openWorkspace(Workspace workspace) => openedWorkspaces.firstWhere(
        (opened) => opened.workspace == workspace,
        orElse: () => _openWorkspace(workspace),
      );

  /// 关闭工作空间
  closeWorkspace(Workspace workspace) =>
      openedWorkspaces.removeWhere((element) => element.workspace == workspace);

  // 打开工作空间, 并缓存
  _openWorkspace(Workspace workspace) {
    final w = workspace.open();
    openedWorkspaces.add(w);
    return w;
  }

  // 缓存工作空间
  _addWorkspace(Team team, Workspace workspace) {
    (workspaces[team] ??= []).add(workspace);
  }
}

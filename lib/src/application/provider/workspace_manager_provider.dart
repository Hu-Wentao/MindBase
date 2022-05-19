import 'package:appwrite/models.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/service/workspace_service.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/domain/value/event.dart';
import 'package:mind_base/src/interface/i_dao.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

/// 管理用户名下的所有工作空间
/// 包括对`已打开的的Workspace的数据同步工作`
class WorkspaceManagerProvider extends ProviderSidecar {
  late EventBus _eventBus;
  late WorkspaceService _workspaceSrv;

  // 父级状态 缓存当前已登录的用户, 确保登录用户与缓存的工作空间是一致的;
  User? user;

  // 状态
  Map<Team, List<Workspace>> workspaces = {};
  List<OpenedWorkspace> openedWorkspaces = [];
  OpenedWorkspace? selectedWorkspace;

  // 用户登录成功后,才能够获取到 工作空间列表
  WorkspaceManagerProvider() : super(onCatch: ExceptionAdapter.of);

  @override
  onInitializing() async {
    _workspaceSrv = sl<WorkspaceService>();
    _eventBus = sl<EventBus>();
    // _initEventBus();
    _initWorkspaces();
    // todo 考虑添加一层OpenTeam,以监听工作空间的创建与关闭
    setInitialized("工作空间同步完成");
  }

  // _initEventBus() => _eventBus
  //   ..on<WorkspaceOpenedEvt>().listen((event) {
  //     // 获取数据
  //   });

  // 同步当前用户的工作空间 等
  _initWorkspaces() async =>
      workspaces = await (_workspaceSrv.queryAllUserWorkspaces());

  actOnUserUpdate(User? nUser) {
    if (nUser != user) {
      if (nUser == null) {
        setUninitialized("尚未登录");
      } else {
        setInitialized("更新已登录用户信息", () {
          user = nUser;
        });
      }
    }
  }

  /// 新建工作空间
  Future<BaseException?> actCreateWorkspace(
    Team? team,
    String spaceName,
  ) async =>
      await actWrapper(() async {
        final r = await _workspaceSrv.createWorkspace(team, spaceName);
        _addWorkspace(r.value1, r.value2);
        setInitialized("创建工作空间成功");
      });

  /// 打开或返回已存在的OpenedWorkspace
  // actOpenWorkspace(Workspace workspace) => actOpenWorkspaceById(workspace.id);

  Future<BaseException?> actOpenWorkspaceById(String workspaceId) async =>
      await actWrapper(() {
        // 选中工作空间
        setInitialized("打开工作空间[$workspaceId]成功", () {
          final ws = openedWorkspaces.firstWhere(
            (opened) => opened.workspace.id == workspaceId,
            orElse: () => _openWorkspaceById(workspaceId),
          );
          selectedWorkspace = ws;
        });
      });

  /// 关闭工作空间
  Future<BaseException?> actCloseWorkspace(Workspace workspace) async =>
      await actWrapper(() => setInitialized("关闭工作空间[${workspace.id}]成功", () {
            openedWorkspaces
                .removeWhere((element) => element.workspace == workspace);
          }));

  _openWorkspaceById(String workspaceId) {
    final ws = _openWorkspace(workspaces.values
        .expand((element) => element)
        .firstWhere((element) => element.id == workspaceId));
    // 首次打开,发送事件
    _eventBus.fire(WorkspaceOpenedEvt(ws.workspace));
    return ws;
  }

  // `real` 打开工作空间, 并缓存
  _openWorkspace(Workspace workspace) {
    final w = _workspaceSrv.openWorkspace(workspace);
    openedWorkspaces.add(w);
    return w;
  }

  _isOpened(String workspaceId) =>
      openedWorkspaces.any((element) => element.workspace.id == workspaceId);

  // 缓存工作空间
  _addWorkspace(Team team, Workspace workspace) {
    (workspaces[team] ??= []).add(workspace);
  }

  // todo 考虑换个写法, 或者转移到Service中
  Future<OpenedWorkspace> getOpenedWorkspace(String workspaceId) async {
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

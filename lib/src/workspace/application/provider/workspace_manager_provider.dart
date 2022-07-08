import 'package:appwrite/models.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/workspace/application/service/workspace_service.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/workspace/domain/value/event.dart';
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
  Map<Team, List<Workspace>> workspaces = {};
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
      return (nUser == null)
          ? actCleanCache("尚未登录")
          : actSyncUserInfo(nUser);
    }
  }

  actCleanCache(String msg){
    user =null;
    workspaces.clear();
    openedWorkspaces.clear();
    selectedWorkspace = null;
    setUninitialized(msg);
  }

  actSyncUserInfo(User nUser) async => await actWrapper(() async {
        setInitialized("刷新已登录用户", () {
          user = nUser;
        });
        workspaces = await (_workspaceSrv.queryAllUserWorkspaces());
        setInitialized("已同步用户数据");
      });

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

  Future<BaseException?> actOpenWorkspaceById(String workspaceId,
          {bool andSelect = true}) async =>
      await actWrapper(() {
        // 选中工作空间
        setInitialized("打开工作空间[$workspaceId]成功", () {
          final ws = openedWorkspaces.firstWhere(
            (opened) => opened.id == workspaceId,
            orElse: () => _openWorkspaceById(workspaceId),
          );
          if (andSelect) selectedWorkspace = ws;
        });
      });

  /// 关闭工作空间
  Future<BaseException?> actCloseWorkspace(Workspace workspace) async =>
      await actWrapper(() => setInitialized("关闭工作空间[${workspace.id}]成功", () {
            openedWorkspaces
                .removeWhere((element) => element.id == workspace.id);
          }));

  OpenedWorkspace _openWorkspaceById(String workspaceId) {
    final ws = _openWorkspace(workspaces.values
        .expand((element) => element)
        .firstWhere((element) => element.id == workspaceId));
    // 首次打开,发送事件
    // _eventBus.fire(WorkspaceOpenedEvt(ws.workspace));
    return ws;
  }

  // `real` 打开工作空间, 并缓存
  OpenedWorkspace _openWorkspace(Workspace workspace) {
    final w = _workspaceSrv.openWorkspace(workspace);
    openedWorkspaces.add(w);
    return w;
  }

  _isOpened(String workspaceId) =>
      openedWorkspaces.any((element) => element.id == workspaceId);

  // 缓存工作空间
  _addWorkspace(Team team, Workspace workspace) {
    (workspaces[team] ??= []).add(workspace);
  }

  // todo 考虑换个写法, 或者转移到Service中
  Future<OpenedWorkspace> getOpenedWorkspace(String workspaceId) async {
    if (_isOpened(workspaceId)) {
      return openedWorkspaces
          .firstWhere((element) => element.id == workspaceId);
    } else {
      final err = await actOpenWorkspaceById(workspaceId);
      if (err != null) {
        throw err;
      }
      return getOpenedWorkspace(workspaceId);
    }
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:mind_base/src/app/infra/ui/page/home/home.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route,Screen',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: HomePage, children: [
      AutoRoute(
          initial: true,
          path: 'workspace',
          name: 'WorkspaceRoute',
          page: EmptyRouterPage,
          children: [
            // 未打开工作空间
            AutoRoute(
              path: '',
              // page: WorkspaceScreen,
              page: EmptyWorkspaceScreen,
              // page: WorkspaceRouter,
            ),
            // 打开指定工作空间
            AutoRoute(
              path: ':workspaceId',
              page: WorkspaceScreen,
            ),
          ]),
      AutoRoute(
        path: 'team',
        page: TeamScreen,
      ),
      AutoRoute(
        path: 'discover',
        page: DiscoverScreen,
      ),
      AutoRoute(
        path: 'settings',
        page: SettingScreen,
      )
    ]),
  ],
)
class $AppRouter {}

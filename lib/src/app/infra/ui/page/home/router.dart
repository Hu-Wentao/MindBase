part of 'home.dart';

@TypedGoRoute<HomeRoute>(path: '/home/:screen', routes: [
  TypedGoRoute<WorkspaceRoute>(
      path: 'team/:teamId/space/:spaceId/meta/:metaId/view/:viewId'),
])
class HomeRoute extends GoRouteData {
  final ScreenType screen;

  const HomeRoute(this.screen);

  const HomeRoute.auto([this.screen = ScreenType.workspaces]);

  @override
  Widget build(BuildContext context) => HomePage(
        key: const ValueKey('home'),
        screenType: screen,
      );
}

class WorkspaceRoute extends GoRouteData {
  final ScreenType screen;
  final String teamId;
  final String spaceId;
  final String metaId;
  final String viewId;

  const WorkspaceRoute(
    this.screen,
    this.teamId,
    this.spaceId,
    this.metaId,
    this.viewId,
  );

  const WorkspaceRoute.auto({
    required this.teamId,
    required this.spaceId,
    this.metaId = 'null',
    this.viewId = 'null',
    this.screen = ScreenType.workspaces,
  });

  @override
  Widget build(BuildContext context) => WorkspacePage(
        teamId: teamId,
        spaceId: spaceId,
        metaId: metaId,
        viewId: viewId,
      );
}

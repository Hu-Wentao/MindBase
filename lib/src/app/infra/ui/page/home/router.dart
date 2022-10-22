part of 'home.dart';

@TypedGoRoute<HomeRoute>(path: '/home/:screen', routes: [
  TypedGoRoute<SpaceRoute>(
      path: 'team/:teamId/space/:spaceId/meta/:metaId/view/:viewId'),
])
class HomeRoute extends GoRouteData {
  final ScreenTp screen;

  const HomeRoute(this.screen);

  const HomeRoute.auto([this.screen = ScreenTp.workspaces]);

  @override
  Widget build(BuildContext context) => HomePage(
        key: const ValueKey('home'),
        screenType: screen,
      );
}

class SpaceRoute extends GoRouteData {
  final ScreenTp screen;
  final String teamId;
  final String spaceId;
  final String metaId;
  final int viewId;

  const SpaceRoute(
    this.screen,
    this.teamId,
    this.spaceId,
    this.metaId,
    this.viewId,
  );

  const SpaceRoute.auto({
    required this.teamId,
    required this.spaceId,
    this.metaId = 'null',
    this.viewId = -1,
    this.screen = ScreenTp.workspaces,
  });

  @override
  Widget build(BuildContext context) => SpaceModelPage(
        teamId: teamId,
        spaceId: spaceId,
        metaId: metaId,
        viewId: viewId,
      );
}

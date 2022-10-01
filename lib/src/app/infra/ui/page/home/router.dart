part of 'home.dart';

@TypedGoRoute<HomeRoute>(path: '/home/:screen', routes: [])
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

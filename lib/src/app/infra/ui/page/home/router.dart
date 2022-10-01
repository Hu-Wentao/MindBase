part of 'home.dart';

@TypedGoRoute<HomeRoute>(path: '/home:screen', routes: [])
class HomeRoute extends GoRouteData {
  final ScreenType screen;

  const HomeRoute(this.screen);

  @override
  Widget build(BuildContext context) => HomePage(
        key: const ValueKey('home'),
        screenType: screen,
      );
}

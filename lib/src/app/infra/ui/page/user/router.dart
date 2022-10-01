part of 'user.dart';

@TypedGoRoute<UserRoute>(path: '/user', routes: [])
class UserRoute extends GoRouteData {
  const UserRoute();

  @override
  Widget build(BuildContext context) => const UserPage();
}

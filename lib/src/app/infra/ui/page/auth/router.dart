part of 'auth.dart';

@TypedGoRoute<AuthRoute>(path: '/auth/:login', routes: [])
class AuthRoute extends GoRouteData {
  final bool login;

  const AuthRoute(this.login);

  const AuthRoute.auto([this.login = true]);

  @override
  Widget build(BuildContext context) => AuthPage(login: login);
}

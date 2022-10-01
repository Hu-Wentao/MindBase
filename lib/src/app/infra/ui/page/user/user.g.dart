// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
      $userRoute,
    ];

GoRoute get $userRoute => GoRouteData.$route(
      path: '/user',
      factory: $UserRouteExtension._fromState,
    );

extension $UserRouteExtension on UserRoute {
  static UserRoute _fromState(GoRouterState state) => const UserRoute();

  String get location => GoRouteData.$location(
        '/user',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

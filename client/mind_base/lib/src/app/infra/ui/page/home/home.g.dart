// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
      $homeRoute,
    ];

GoRoute get $homeRoute => GoRouteData.$route(
      path: '/home/:screen',
      factory: $HomeRouteExtension._fromState,
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute(
        _$ScreenTpEnumMap._$fromName(state.params['screen']!),
      );

  String get location => GoRouteData.$location(
        '/home/${Uri.encodeComponent(_$ScreenTpEnumMap[screen]!)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

const _$ScreenTpEnumMap = {
  ScreenTp.workspaces: 'workspaces',
  ScreenTp.teams: 'teams',
  ScreenTp.discover: 'discover',
  ScreenTp.settings: 'settings',
};

extension<T extends Enum> on Map<T, String> {
  T _$fromName(String value) =>
      entries.singleWhere((element) => element.value == value).key;
}

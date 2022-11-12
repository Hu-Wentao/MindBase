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
      routes: [
        GoRouteData.$route(
          path: 'team/:teamId/space/:spaceId/meta/:metaId/view/:viewId',
          factory: $SpaceRouteExtension._fromState,
        ),
      ],
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

extension $SpaceRouteExtension on SpaceRoute {
  static SpaceRoute _fromState(GoRouterState state) => SpaceRoute(
        _$ScreenTpEnumMap._$fromName(state.params['screen']!),
        state.params['teamId']!,
        state.params['spaceId']!,
        state.params['metaId']!,
        int.parse(state.params['viewId']!),
      );

  String get location => GoRouteData.$location(
        '/home/${Uri.encodeComponent(_$ScreenTpEnumMap[screen]!)}/team/${Uri.encodeComponent(teamId)}/space/${Uri.encodeComponent(spaceId)}/meta/${Uri.encodeComponent(metaId)}/view/${Uri.encodeComponent(viewId.toString())}',
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

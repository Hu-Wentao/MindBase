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
          factory: $WorkspaceRouteExtension._fromState,
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute(
        _$ScreenTypeEnumMap._$fromName(state.params['screen']!),
      );

  String get location => GoRouteData.$location(
        '/home/${Uri.encodeComponent(_$ScreenTypeEnumMap[screen]!)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $WorkspaceRouteExtension on WorkspaceRoute {
  static WorkspaceRoute _fromState(GoRouterState state) => WorkspaceRoute(
        _$ScreenTypeEnumMap._$fromName(state.params['screen']!),
        state.params['teamId']!,
        state.params['spaceId']!,
        state.params['metaId']!,
        state.params['viewId']!,
      );

  String get location => GoRouteData.$location(
        '/home/${Uri.encodeComponent(_$ScreenTypeEnumMap[screen]!)}/team/${Uri.encodeComponent(teamId)}/space/${Uri.encodeComponent(spaceId)}/meta/${Uri.encodeComponent(metaId)}/view/${Uri.encodeComponent(viewId)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

const _$ScreenTypeEnumMap = {
  ScreenType.workspaces: 'workspaces',
  ScreenType.teams: 'teams',
  ScreenType.discover: 'discover',
  ScreenType.settings: 'settings',
};

extension<T extends Enum> on Map<T, String> {
  T _$fromName(String value) =>
      entries.singleWhere((element) => element.value == value).key;
}

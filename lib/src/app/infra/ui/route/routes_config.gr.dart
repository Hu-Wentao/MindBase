// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i2;
import 'package:flutter/foundation.dart' as _i4;
import 'package:flutter/material.dart' as _i3;

import '../page/home/home.dart' as _i1;

class AppRouter extends _i2.RootStackRouter {
  AppRouter([_i3.GlobalKey<_i3.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    HomePageRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.HomePage());
    },
    WorkspaceRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.EmptyRouterPage());
    },
    TeamScreenRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.TeamScreen());
    },
    DiscoverScreenRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.DiscoverScreen());
    },
    SettingScreenRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SettingScreen());
    },
    EmptyWorkspaceScreenRoute.name: (routeData) {
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.EmptyWorkspaceScreen());
    },
    WorkspaceScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkspaceScreenRouteArgs>(
          orElse: () => WorkspaceScreenRouteArgs(
              workspaceId: pathParams.getString('workspaceId', '')));
      return _i2.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i1.WorkspaceScreen(
              key: args.key, workspaceId: args.workspaceId));
    }
  };

  @override
  List<_i2.RouteConfig> get routes => [
        _i2.RouteConfig(HomePageRoute.name, path: '/', children: [
          _i2.RouteConfig('#redirect',
              path: '',
              parent: HomePageRoute.name,
              redirectTo: 'workspace',
              fullMatch: true),
          _i2.RouteConfig(WorkspaceRoute.name,
              path: 'workspace',
              parent: HomePageRoute.name,
              children: [
                _i2.RouteConfig(EmptyWorkspaceScreenRoute.name,
                    path: '', parent: WorkspaceRoute.name),
                _i2.RouteConfig(WorkspaceScreenRoute.name,
                    path: ':workspaceId', parent: WorkspaceRoute.name)
              ]),
          _i2.RouteConfig(TeamScreenRoute.name,
              path: 'team', parent: HomePageRoute.name),
          _i2.RouteConfig(DiscoverScreenRoute.name,
              path: 'discover', parent: HomePageRoute.name),
          _i2.RouteConfig(SettingScreenRoute.name,
              path: 'settings', parent: HomePageRoute.name)
        ])
      ];
}

/// generated route for
/// [_i1.HomePage]
class HomePageRoute extends _i2.PageRouteInfo<void> {
  const HomePageRoute({List<_i2.PageRouteInfo>? children})
      : super(HomePageRoute.name, path: '/', initialChildren: children);

  static const String name = 'HomePageRoute';
}

/// generated route for
/// [_i2.EmptyRouterPage]
class WorkspaceRoute extends _i2.PageRouteInfo<void> {
  const WorkspaceRoute({List<_i2.PageRouteInfo>? children})
      : super(WorkspaceRoute.name,
            path: 'workspace', initialChildren: children);

  static const String name = 'WorkspaceRoute';
}

/// generated route for
/// [_i1.TeamScreen]
class TeamScreenRoute extends _i2.PageRouteInfo<void> {
  const TeamScreenRoute() : super(TeamScreenRoute.name, path: 'team');

  static const String name = 'TeamScreenRoute';
}

/// generated route for
/// [_i1.DiscoverScreen]
class DiscoverScreenRoute extends _i2.PageRouteInfo<void> {
  const DiscoverScreenRoute()
      : super(DiscoverScreenRoute.name, path: 'discover');

  static const String name = 'DiscoverScreenRoute';
}

/// generated route for
/// [_i1.SettingScreen]
class SettingScreenRoute extends _i2.PageRouteInfo<void> {
  const SettingScreenRoute() : super(SettingScreenRoute.name, path: 'settings');

  static const String name = 'SettingScreenRoute';
}

/// generated route for
/// [_i1.EmptyWorkspaceScreen]
class EmptyWorkspaceScreenRoute extends _i2.PageRouteInfo<void> {
  const EmptyWorkspaceScreenRoute()
      : super(EmptyWorkspaceScreenRoute.name, path: '');

  static const String name = 'EmptyWorkspaceScreenRoute';
}

/// generated route for
/// [_i1.WorkspaceScreen]
class WorkspaceScreenRoute extends _i2.PageRouteInfo<WorkspaceScreenRouteArgs> {
  WorkspaceScreenRoute({_i4.Key? key, String workspaceId = ''})
      : super(WorkspaceScreenRoute.name,
            path: ':workspaceId',
            args: WorkspaceScreenRouteArgs(key: key, workspaceId: workspaceId),
            rawPathParams: {'workspaceId': workspaceId});

  static const String name = 'WorkspaceScreenRoute';
}

class WorkspaceScreenRouteArgs {
  const WorkspaceScreenRouteArgs({this.key, this.workspaceId = ''});

  final _i4.Key? key;

  final String workspaceId;

  @override
  String toString() {
    return 'WorkspaceScreenRouteArgs{key: $key, workspaceId: $workspaceId}';
  }
}

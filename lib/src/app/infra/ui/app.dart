import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/app/application.dart';
import 'package:mind_base/src/app/application/model/model.dart';
import 'package:mind_base/src/app/infra/ui/page/home/home.dart';
import 'package:mind_base/src/app/infra/ui/page/workspace/workspace.dart';
import 'package:provider_sidecar/provider_sidecar_ex.dart';

/// 由于路由参数可能从 地址栏 直接传入,因此入参必须是 String? 类型
workspaceRouterPathBuilder({
  String? teamId,
  String? workspaceId,
  String? metaId,
  int? viewId,
}) =>
    (teamId == null || workspaceId == null)
        ? "/"
        : '/team/$teamId/workspace/$workspaceId/meta/${metaId ?? "-"}/view/${viewId ?? -1}';

final _router = GoRouter(
    // 必须打开,否则全局logging都将被取消
    debugLogDiagnostics: true,
    initialLocation: '/${ScreenType.workspaces.name}',
    routes: [
      GoRoute(path: '/', redirect: (_) => '/${ScreenType.workspaces.name}'),
      GoRoute(
        path: '/:homeScreen(${ScreenType.values.map((e) => e.name).join('|')})',
        builder: (c, s) => HomePage(
          key: s.pageKey,
          screenType: ScreenType.values.byName(s.params['homeScreen']!),
        ),
      ),
      GoRoute(path: '/team', redirect: (_) => '/${ScreenType.teams.name}'),
      GoRoute(
          // /team/:teamId/workspace/:workspaceId/meta/:metaId/view/:viewId
          // /team/628895eb97858942e1ddb007/workspace/629393c8ebbbf5094df3e564/meta/''/view/-1
          path: '/team/:teamId',
          redirect: (_) => '/${ScreenType.teams.name}', // todo 尚未完成独立Team页面
          routes: [
            GoRoute(path: 'workspace', redirect: (_) => '/'),
            GoRoute(
                path: 'workspace/:workspaceId',
                redirect: (_) => workspaceRouterPathBuilder(
                    teamId: _.params['teamId'],
                    workspaceId: _.params['workspaceId']),
                routes: [
                  GoRoute(
                      path: 'meta',
                      redirect: (_) => workspaceRouterPathBuilder(
                          teamId: _.params['teamId'],
                          workspaceId: _.params['workspaceId'])),
                  GoRoute(
                      path: 'meta/:metaId',
                      redirect: (_) => workspaceRouterPathBuilder(
                            teamId: _.params['teamId'],
                            workspaceId: _.params['workspaceId'],
                            metaId: _.params['metaId'],
                          ),
                      routes: [
                        GoRoute(
                            path: 'view',
                            redirect: (_) => workspaceRouterPathBuilder(
                                  teamId: _.params['teamId'],
                                  workspaceId: _.params['workspaceId'],
                                  metaId: _.params['metaId'],
                                )),
                        GoRoute(
                            path: 'view/:viewId',
                            builder: (c, s) {
                              var metaId = s.params['metaId'];
                              if (metaId == null || metaId.length < 24) {
                                metaId = null;
                              }
                              var viewId = s.params['viewId'] == null
                                  ? null
                                  : int.tryParse(s.params['viewId']!);
                              if (viewId == null || viewId == -1) {
                                viewId = null;
                              }
                              return WorkspacePage2(
                                  // key 必须是 workspaceId,因为页面以单个工作空间刷新
                                  key: ValueKey(s.params['workspaceId']),
                                  teamId: s.params['teamId']!,
                                  workspaceId: s.params['workspaceId'],
                                  metaId: metaId,
                                  viewId: viewId);
                            }),
                      ]),
                ]),
          ]),
    ]);

class MindBaseApp extends StatelessWidget {
  final GetIt sl;
  final MindBaseConfig config;

  const MindBaseApp({Key? key, required this.sl, required this.config})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      // 配置Provider
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppStateModel>(
            create: (_) => AppStateModel(config)..actInitSubscription(),
          ),
          ChangeNotifierProxyProvider<AppStateModel, UserModel>.value(
            update: (c, m, o) => m.user,
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          // 配置 router
          routeInformationProvider: _router.routeInformationProvider,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          title: 'Mind Base',
          localizationsDelegates: const [
            FormBuilderLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: const [
            Locale('zh', ''),
            Locale('en', ''),
            Locale('es', ''),
            Locale('fa', ''),
            Locale('fr', ''),
            Locale('ja', ''),
            Locale('pt', ''),
            Locale('sk', ''),
            Locale('pl', ''),
          ],
        ),
      );
}

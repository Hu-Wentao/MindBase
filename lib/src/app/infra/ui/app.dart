import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/app/infra/ui/page/home/home.dart';
import 'package:mind_base/src/app/infra/ui/page/workspace/workspace.dart';
import 'package:mind_base/src/user/application/model/model.dart';
import 'package:provider/provider.dart';

/// 由于路由参数可能从 地址栏 直接传入,因此入参必须是 String? 类型
workspaceRouterPathBuilder({
  String? teamId,
  String? workspaceId,
  String? metaId,
  int? viewId,
}) =>
    (teamId == null || workspaceId == null)
        ? "/"
        : '/team/$teamId/workspace/$workspaceId/meta/${metaId ?? ""}/view/${viewId ?? -1}';

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
          path: '/team/:teamId',
          redirect: (_) => '/team', // todo 尚未完成独立Team页面
          routes: [
            GoRoute(path: 'workspace', redirect: (_) => '/'),
            GoRoute(
                // 新路由规则: /workspace/:teamId/space/:workspaceId/meta/:metaId/view/:viewId
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
                            builder: (c, s) => WorkspacePage(
                                key: ValueKey(s.params['workspaceId']),
                                teamId: s.params['teamId']!,
                                workspaceId: s.params['workspaceId'],
                                metaId: s.params['metaId'],
                                viewId:
                                int.tryParse(s.params['viewId']!))),
                      ]),
                ]),
          ]),
    ]);

class MindBaseApp extends StatelessWidget {
  const MindBaseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      // 配置Provider
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserModel>(
            create: (_) => UserModel()..actInitSubscription(),
          ),
        ],
        child:
            // 配置 AutoRoute
            MaterialApp.router(
          debugShowCheckedModeBanner: false,
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

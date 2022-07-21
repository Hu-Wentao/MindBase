import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/app/infra/ui/page/home/home.dart';
import 'package:mind_base/src/app/infra/ui/page/workspace/workspace.dart';
import 'package:mind_base/src/user/application/provider/user_provider.dart';
import 'package:mind_base/src/workspace/application/model/model.dart';
import 'package:provider/provider.dart';

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
      GoRoute(
          path: '/workspace/:workspaceId',
          redirect: (_) =>
              '/workspace/${_.params['workspaceId']}/meta/""/view/-1',
          routes: [
            GoRoute(
                path: 'meta/:metaId',
                redirect: (_) =>
                    '/workspace/${_.params['workspaceId']}/meta/${_.params['metaId']}/view/-1',
                routes: [
                  GoRoute(
                      path: 'view/:viewId',
                      builder: (c, s) => WorkspacePage(
                          key: ValueKey(s.params['workspaceId']),
                          workspaceId: s.params['workspaceId'],
                          metaId: s.params['metaId'],
                          viewId: int.tryParse(s.params['viewId']!))),
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
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider()..actInitializing(),
          ),
          ChangeNotifierProxyProvider<UserProvider, OpenedSpaceManagerModel>(
              create: (_) => OpenedSpaceManagerModel(),
              update: (c, u, pre) => pre!..onUserUpdate(u.user)),
          ChangeNotifierProxyProvider<UserProvider, TeamManagerModel>(
              create: (_) => TeamManagerModel(),
              update: (c, u, pre) => pre!..onUserUpdate(u.user)),
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

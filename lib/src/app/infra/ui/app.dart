import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:mind_base/src/user/application/provider/user_provider.dart';
import 'package:mind_base/src/workspace/application/provider/workspace_manager_provider.dart';
import 'package:mind_base/src/workspace/application/provider/workspace_provider.dart';
import 'package:mind_base/src/app/infra/ui/route/routes_config.gr.dart';
import 'package:provider/provider.dart';

final _router = AppRouter();

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
          // 根据User登录状态自动切换状态
          ChangeNotifierProxyProvider<UserProvider, WorkspaceManagerProvider>(
              create: (_) => WorkspaceManagerProvider(),
              update: (c, u, pre) => pre!..actOnUserUpdate(u.user)),
          ChangeNotifierProxyProvider<WorkspaceManagerProvider,
              WorkspaceProvider>(
            create: (_) => WorkspaceProvider(),
            update: (c, wm, pre) =>
                pre!..actOnSelectedWorkspaceUpdate(wm.selectedWorkspace),
          ),
        ],
        child:
            // 配置 AutoRoute
            MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerDelegate: _router.delegate(),
          routeInformationParser: _router.defaultRouteParser(),
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

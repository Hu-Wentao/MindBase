import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:mind_base/src/application/provider/event_provider.dart';
import 'package:mind_base/src/application/provider/user_provider.dart';
import 'package:mind_base/src/application/provider/workspace_manager_provider.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/infra/ui/routes_config.gr.dart';
import 'package:provider/provider.dart';

final _router = AppRouter();

class MindBaseApp extends StatelessWidget {
  const MindBaseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<EventProvider>(
            create: (_) => EventProvider()..actInitializing(),
          ),
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider()..actInitializing(),
          ),
          ChangeNotifierProxyProvider<UserProvider, WorkspaceManagerProvider>(
              create: (_) => WorkspaceManagerProvider(null),
              update: (c, u, pre) => pre!..actUpdate(u.user)),
          ChangeNotifierProxyProvider<WorkspaceManagerProvider,
              WorkspaceProvider>(
            create: (_) => WorkspaceProvider(null),
            update: (c, wm, pre) =>
                // fixme 固定选择首个工作空间
                pre!..actInitializing(),
          ),
        ],
        child: Consumer<EventProvider>(
          // 必须使用Consumer，否则无法获取到EventProvider
          builder: (c, p, __) => MaterialApp.router(
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
        ),
      );
}

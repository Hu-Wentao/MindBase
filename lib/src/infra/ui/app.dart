import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:mind_base/src/infra/ui/routes_config.gr.dart';
import 'package:provider/provider.dart';

final _router = AppRouter();

class MindBaseApp extends StatelessWidget {
  const MindBaseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider.value(value: "value"),
          // Provider.value(value: sl<Repo>()),
          // ChangeNotifierProvider(create: (_) => sl<SchemaProvider>())
          // ChangeNotifierProvider(create: (c) => sl<ShopEnvInfoProvider>()),
        ],
        child: MaterialApp.router(
          routerDelegate: _router.delegate(),
          routeInformationParser: _router.defaultRouteParser(),
          title: 'Mind Base',
          localizationsDelegates: const [
            FormBuilderLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
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

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get_it/get_it.dart';
import 'package:get_sweet/get_sweet.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/app/application.dart';
import 'package:mind_base/src/app/application/model/model.dart';
import 'package:mind_base/src/app/infra/ui/page/auth/auth.dart';
import 'package:mind_base/src/app/infra/ui/page/home/home.dart';
import 'package:mind_base/src/app/infra/ui/page/splash/splash.dart';
import 'package:mind_base/src/app/infra/ui/page/user/user.dart';
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
  debugLogDiagnostics: true,
  initialLocation: const SplashRoute().location,
  routes: [
    $splashRoute,
    $authRoute,
    $userRoute,
    $homeRoute,
  ],
);

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
          ChangeNotifierProvider<AppModel>(
            create: (_) => AppModel(config),
          ),
          ChangeNotifierProxyProvider<AppModel, UserModel?>.value(
            update: (c, m, o) => m.state.isOrNull<AppStateLogged>()?.user,
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

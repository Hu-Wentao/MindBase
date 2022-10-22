import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:get_sweet/get_sweet.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/app/infra/ui/page/splash/splash.dart';
import 'package:mind_base/src/core/config/config.dart';
import 'package:provider_sidecar/provider_sidecar_ex.dart';
part 'router.dart';

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
          supportedLocales: const [
            Locale('zh', ''),
            Locale('en', ''),
          ],
        ),
      );
}

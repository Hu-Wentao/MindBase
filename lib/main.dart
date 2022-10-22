import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:logging/logging.dart';
import 'package:mind_base/src/core/config/common_config.dart';
import 'package:mind_base/src/core/config/const.dart';
import 'package:mind_base/src/app/infra/ui/app.dart';
import 'package:mind_base/src/core/config/injector.dart';
import 'package:mind_base/src/core/mindbase_application.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

void main() {
  MindBaseApplication(
    onBeforeAppInit: (g, c) async => WidgetsFlutterBinding.ensureInitialized(),
    onBeforeAppRun: (g) async {
      // 配置全局Logger
      slLogger = sl<Logger>();
      // 配置 ProviderSidecar Log
      final _sidecarLogger = Logger("sidecar");
      SidecarLoggerMx.setLogger(_sidecarLogger.info);
    },
    onAppInit: initPackageDI,
    onApplicationRun: (g, c) async => runApp(MindBaseApp(sl: g, config: c)),
  ).run(GetIt.I, kEnvDev);
}
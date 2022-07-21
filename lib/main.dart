import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:logging/logging.dart';
import 'package:mind_base/src/app/config/common_config.dart';
import 'package:mind_base/src/app/config/const.dart';
import 'package:mind_base/src/app/application.dart';
import 'package:mind_base/src/app/infra/ui/app.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

void main() {
  MindBaseApplication(
    onBeforeAppInit: (g, c) async => WidgetsFlutterBinding.ensureInitialized(),
    onBeforeAppRun: (g) async {
      // 配置全局Logger
      slLogger = sl<Logger>();
      // 配置 ProviderSidecar Log
      final _sidecarLogger = Logger("sidecar");
      ProviderSidecar.setLogger(_sidecarLogger.info);
    },
    onApplicationRun: (g, c) async => runApp(const MindBaseApp()),
  ).run(
    GetIt.I,
    kEnvDev,
  );
}

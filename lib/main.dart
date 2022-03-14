import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:logging/logging.dart';
import 'package:mind_base/src/config/const.dart';
import 'package:mind_base/src/application.dart';
import 'package:mind_base/src/infra/ui/app.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

void main() {
  MindBaseApplication(
    onBeforeAppInit: (g, c) async => WidgetsFlutterBinding.ensureInitialized(),
    onBeforeAppRun: () async {
      // 配置Logger日志打印输出
      Logger.root.onRecord.listen((_) {
        if (kDebugMode) print(_);
      });
      // 配置 ProviderSidecar Log
      ProviderSidecar.setLogger(Logger.root.info);
    },
    onApplicationRun: (g, c) async => runApp(const MindBaseApp()),
  ).run(
    GetIt.I,
    kEnvDev,
  );
}

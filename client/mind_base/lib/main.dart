import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/app/infra/ui/app.dart';
import 'package:mind_base/src/core/config/config.dart';
import 'package:mind_base/src/core/mindbase_application.dart';

void main() {
  MindBaseApplication(
    onBeforeAppInit: (g, c) async => WidgetsFlutterBinding.ensureInitialized(),
    onBeforeAppRun: (g) async {},
    onAppInit: initPackageDI,
    onApplicationRun: (g, c) async => runApp(MindBaseApp(sl: g, config: c)),
  ).run(GetIt.I, kEnvDev);
}

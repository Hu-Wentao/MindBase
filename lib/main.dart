import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/config/const.dart';
import 'package:mind_base/src/application.dart';
import 'package:mind_base/src/infra/ui/app.dart';

void main() {
  MindBaseApplication(
    onBeforeAppInit: (g, c) async => WidgetsFlutterBinding.ensureInitialized(),
    onApplicationRun: (g, c) async => runApp(const MindBaseApp()),
  ).run(
    GetIt.I,
    kEnvDev,
  );
}

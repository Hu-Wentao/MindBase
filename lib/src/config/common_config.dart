import 'package:flutter/foundation.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:logging/logging.dart';
import 'package:mind_base/src/application.dart';

// 在onBeforeAppRun中赋值
late Logger slLogger;

@module
abstract class ConfigCommon {
  // 注入Logger， 配置日志打印输出
  Logger logger(MindBaseConfig config) {
    Logger.root
      ..level = Level.CONFIG
      ..onRecord.listen((_) {
        if (kDebugMode) print("$_");
      });
    return Logger(config.name);
  }
}

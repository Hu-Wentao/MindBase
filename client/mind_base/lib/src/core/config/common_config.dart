import 'package:get_arch_core/get_arch_core.dart';
import 'package:logging/logging.dart';
import 'package:mind_base/src/core/config/config.dart';

Logger get slLogger => _logger ??  Logger("Logger_For_Test");

Logger? _logger;
// 在onBeforeAppRun中赋值
set slLogger(l) => _logger = l;

@module
abstract class ConfigCommon {
  // 注入Logger， 配置日志打印输出
  @lazySingleton
  Logger logger(MindBaseConfig config) {
    // Logger.root
    //   ..level = Level.CONFIG
    //   ..onRecord.listen((_) {
    //     if (kDebugMode) print("$_");
    //   });
    return Logger(config.name);
  }
}

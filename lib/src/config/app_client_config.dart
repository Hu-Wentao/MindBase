import 'package:get_arch_core/get_arch_core.dart';
import 'package:appwrite/appwrite.dart';

@module
abstract class AppClientConfig {
  Client get client => Client()
    ..setEndpoint("http://app.shuttlecloud.cn/v1")
    ..setProject("627f35455d30081f4a5c")
    ..setSelfSigned(status: true); // 可能只适用于dev环境
  // Register User
  Account get account => Account(client);

  // Subscribe to files channel
  Realtime get realtime => Realtime(client);
}

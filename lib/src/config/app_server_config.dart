import 'package:get_arch_core/get_arch_core.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

@module
abstract class AppServerConfig {
  Client get client => Client()
    ..setEndpoint("http://app.shuttlecloud.cn/v1")
    ..setProject("627f35455d30081f4a5c")
    ..setKey(
        '4fda75fef6a1cbe8a2cf3efd9918e586432f0484487bf3ddefacd7688b89d5973802d6effc5cb129369bfad9c37b1f371bf2c165255d9b6573289a2d925a75050b6a5e9c4baf13d9139030032e02e2df7467cb12a4f80959d92fea3182e1df360d38369fda8f6c3971f26878b13a4164b8764193aae90b98c2b0ff4995bd1d62')
    ..setSelfSigned(status: true); // 可能只适用于dev环境

  // Register User
  Account get account => Account(sl<Client>());

  Teams get teams => Teams(sl<Client>());

  Database get database => Database(sl<Client>());

  Storage get storage => Storage(sl<Client>());

  Avatars get avatars => Avatars(sl<Client>());
}

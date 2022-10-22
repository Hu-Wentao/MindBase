import 'package:get_arch_core/get_arch_core.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

const mainDataBaseId = 'default';

@module
abstract class AppServerConfig {
  @lazySingleton
  Client get client => Client()
    ..setEndpoint("http://app.shuttlecloud.cn/v1")
    ..setKey(
        '72e647b351006727c7889de11f6546a1a642f8500c66ade97868c359b05e71f4493284a4c6716bcc63a6fc4d70e6a2313fba1332f21aaa5b754edb45474123c6ad549bdb4a246d5743ce5d96e34538774cc01deee2bfafb9fc1d0ac0dd420298dfe14120eeb171e4066714cd15265c16d7cc0b909aafbca99f804ab631e480a2')
    ..setSelfSigned(status: true) // 可能只适用于dev环境
    ..setProject("627f35455d30081f4a5c");

  // Register User
  @lazySingleton
  Account get account => Account(sl<Client>());

  @lazySingleton
  Teams get teams => Teams(sl<Client>());

  @lazySingleton
  Databases get database => Databases(sl<Client>());

  @lazySingleton
  Storage get storage => Storage(sl<Client>());

  @lazySingleton
  Avatars get avatars => Avatars(sl<Client>());
}

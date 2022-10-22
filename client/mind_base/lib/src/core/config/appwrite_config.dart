import 'package:get_arch_core/get_arch_core.dart';
import 'package:appwrite/appwrite.dart' as cli;
import 'package:dart_appwrite/dart_appwrite.dart' as srv;

const mainDataBaseId = 'default';

@module
abstract class AppClientConfig {
  @lazySingleton
  cli.Client get client => cli.Client()
    ..setEndpoint("http://app.shuttlecloud.cn/v1")
    ..setProject("627f35455d30081f4a5c")
    ..setSelfSigned(status: true); // 可能只适用于dev环境

  // Register User
  @lazySingleton
  cli.Account get account => cli.Account(sl<cli.Client>());

  // Subscribe to files channel
  @lazySingleton
  cli.Realtime get realtime => cli.Realtime(sl<cli.Client>());

  @lazySingleton
  cli.Teams get teams => cli.Teams(sl<cli.Client>());

  @lazySingleton
  cli.Databases get database =>
      cli.Databases(sl<cli.Client>());

  @lazySingleton
  cli.Storage get storage => cli.Storage(sl<cli.Client>());

  @lazySingleton
  cli.Avatars get avatars => cli.Avatars(sl<cli.Client>());
}

@module
abstract class AppServerConfig {
  @lazySingleton
  srv.Client get client => srv.Client()
    ..setEndpoint("http://app.shuttlecloud.cn/v1")
    ..setKey(
        '72e647b351006727c7889de11f6546a1a642f8500c66ade97868c359b05e71f4493284a4c6716bcc63a6fc4d70e6a2313fba1332f21aaa5b754edb45474123c6ad549bdb4a246d5743ce5d96e34538774cc01deee2bfafb9fc1d0ac0dd420298dfe14120eeb171e4066714cd15265c16d7cc0b909aafbca99f804ab631e480a2')
    ..setSelfSigned(status: true) // 可能只适用于dev环境
    ..setProject("627f35455d30081f4a5c");

  // Register User
  @lazySingleton
  srv.Account get account => srv.Account(sl<srv.Client>());

  @lazySingleton
  srv.Teams get teams => srv.Teams(sl<srv.Client>());

  @lazySingleton
  srv.Databases get database =>
      srv.Databases(sl<srv.Client>());

  @lazySingleton
  srv.Storage get storage => srv.Storage(sl<srv.Client>());

  @lazySingleton
  srv.Avatars get avatars => srv.Avatars(sl<srv.Client>());
}

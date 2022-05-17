import 'package:get_arch_core/get_arch_core.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mind_base/src/infra/dao/dao_aw_impl.dart';

// 如果需要由服务器创建的ID, 则使用该值
const genUniqueId = 'unique()';

@module
abstract class AppClientConfig {
  @lazySingleton
  Client get client => Client()
    ..setEndpoint("http://app.shuttlecloud.cn/v1")
    ..setProject("627f35455d30081f4a5c")
    ..setSelfSigned(status: true); // 可能只适用于dev环境
  @lazySingleton
  WorkspaceEttAccessor get wsEttAcc => WorkspaceEttAccessor(
        sl<Database>(),
        "627faa18b854b07aa9a8",
      );

  // Register User
  @lazySingleton
  Account get account => Account(sl<Client>());

  // Subscribe to files channel
  @lazySingleton
  Realtime get realtime => Realtime(sl<Client>());

  @lazySingleton
  Teams get teams => Teams(sl<Client>());

  @lazySingleton
  Database get database => Database(sl<Client>());

  @lazySingleton
  Storage get storage => Storage(sl<Client>());

  @lazySingleton
  Avatars get avatars => Avatars(sl<Client>());
}

import 'package:get_arch_core/get_arch_core.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mind_base/src/infra/dao/dao_aw_impl.dart';

// 如果需要由服务器创建的ID, 则使用该值
const genUniqueId = 'unique()';

@module
abstract class AppClientConfig {
  Client get client => Client()
    ..setEndpoint("http://app.shuttlecloud.cn/v1")
    ..setProject("627f35455d30081f4a5c")
    ..setSelfSigned(status: true); // 可能只适用于dev环境
  WorkspaceEttAccessor get wsEttAcc => WorkspaceEttAccessor(
        database,
        "627faa18b854b07aa9a8",
      );

  // Register User
  Account get account => Account(client);

  // Subscribe to files channel
  Realtime get realtime => Realtime(client);

  Teams get teams => Teams(client);

  Database get database => Database(client);

  Storage get storage => Storage(client);

  Avatars get avatars => Avatars(client);
}

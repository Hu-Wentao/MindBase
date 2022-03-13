import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';

@module
abstract class ConfigMongo {
  IMongoStorage get mongoStorage => BaseMongoStorage(MongoStorageConfig(
        host: "localhost",
        port: 30001,
        databaseName: "dev_mind_base",
      ));
}

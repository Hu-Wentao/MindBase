import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';
import 'package:mongo_dart/mongo_dart.dart';

@module
abstract class ConfigMongo {
  IMongoStorage get mongoStorage => BaseMongoStorage(MongoStorageConfig.ofUrl(
        "mongodb://base.shuttlecloud.cn:11151/test_db/?replicaSet=my-replica-set&authSource=admin",
      ));

  @preResolve
  Future<Db> getDb(IMongoStorage mongoStorage) async =>
      await mongoStorage.asyncDb;
}

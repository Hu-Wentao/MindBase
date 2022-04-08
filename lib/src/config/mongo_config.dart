import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';
import 'package:mongo_dart/mongo_dart.dart';

@module
abstract class ConfigMongo {
  IMongoStorage get mongoStorage => BaseMongoStorage(MongoStorageConfig.ofUrl(
        "mongodb+srv://mind_base_dev:ud16tt2bOgNRqs4B@cluster0.nqkse.mongodb.net/dev_set_v2_1?retryWrites=true&w=majority",
      ));

  @preResolve
  Future<Db> getDb(IMongoStorage mongoStorage) async =>
      await mongoStorage.asyncDb;
}

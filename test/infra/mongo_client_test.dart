import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';

main() {
  // test("mongo client- Localhost", () async {
  //   IMongoStorage client = BaseMongoStorage(MongoStorageConfig(
  //     // auth: const MongoAuthBasic(
  //     //   username: "root",
  //     //   password: "example",
  //     // ),
  //     databaseName: 'test',
  //     port: 30001,
  //   ));
  //
  //   final db = await client.asyncDb;
  //   expect(db.isConnected, true);
  // });
  // test("mongo client- MongoAtlas1", () async {
  //   print("start");
  //   IMongoStorage client = BaseMongoStorage(MongoStorageConfig.ofUrl(
  //        "mongodb+srv://mind_base_dev:ud16tt2bOgNRqs4B@cluster0.nqkse.mongodb.net/myFirstDatabase?retryWrites=true&w=majority"
  //     // "mongodb+srv://mind_base_dev:ud16tt2bOgNRqs4B@cluster0.nqkse.mongodb.net/dev_set1?retryWrites=true&w=majority",
  //   ));
  //
  //   final db = await client.asyncDb;
  //   expect(db.isConnected, true);
  // });
  // test("mongo client- MongoAtlas", () async {
  //   print("start");
  //   IMongoStorage client = BaseMongoStorage(MongoStorageConfig.ofUrl(
  //     "mongodb+srv://mind_base_dev:ud16tt2bOgNRqs4B@cluster0.nqkse.mongodb.net/dev_set_v2_1?retryWrites=true&w=majority",
  //   ));
  //
  //   final db = await client.asyncDb;
  //   expect(db.isConnected, true);
  // });
  test("mongo client- ShuttleCloud", () async {
    print("start");
    IMongoStorage client = BaseMongoStorage(MongoStorageConfig.ofUrl(
      "mongodb://base.shuttlecloud.cn:11151/test_db/?replicaSet=my-replica-set&authSource=admin",
      // "mongodb://mind_base_dev:ud16tt2bOgNRqs4B@cluster0.nqkse.mongodb.net/dev_set_v2_1?retryWrites=true&w=majority",
    ));

    final db = await client.asyncDb;
    expect(db.isConnected, true);
  });
}

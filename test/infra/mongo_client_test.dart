import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';

main() {
  test("mongo client", () async {
    IMongoStorage client = BaseMongoStorage(MongoStorageConfig(
      // auth: const MongoAuthBasic(
      //   username: "root",
      //   password: "example",
      // ),
      databaseName: 'test',
      port: 30001,
    ));

    final db = await client.asyncDb;
    expect(db.isConnected, true);
  });
}

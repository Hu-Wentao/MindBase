import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart/src/database/commands/aggreagation_commands/aggregate/return_classes/change_event.dart'
    as mg;

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
  IMongoStorage client;
  Db? db;
  DbCollection? col;
  test("mongo_client connect ShuttleCloud", () async {
    print("start");
    client = BaseMongoStorage(MongoStorageConfig.ofUrl(
      "mongodb://base.shuttlecloud.cn:11151/test_db/?replicaSet=my-replica-set&authSource=admin",
      // "mongodb://mind_base_dev:ud16tt2bOgNRqs4B@cluster0.nqkse.mongodb.net/dev_set_v2_1?retryWrites=true&w=majority",
    ));

    db = await client.asyncDb;
    expect(db!.isConnected, true);
    col = db!.collection('test_collection');
  });

  test("insertOne", () async {
    col!
        .watch(
      // 监控所有包含 `_id` 属性的记录
      AggregationPipelineBuilder().addStage(
        Match(where.exists('_id').toQuery()),
      ),
    )
        .listen((event) {
      final evt = (event as mg.ChangeEvent);
      print(
          "#${DateTime.now()} #event #type# ${evt.operationType} # ${evt.fullDocument}");
    });
    final r = await col!.insertOne({"name": "test"});
    print("#${DateTime.now()} #insertOne # ${r.document}");
  });
  test("updateOne", () async {
    final r = await col!.updateOne(
      where.eq("name", "test").toQuery(),
      ModifierBuilder().set('status', 'A').inc('points', 1),
    );
    print(
        "#${DateTime.now()} #updateOne #id ${r.id}  #doc ${r.document} #err ${r.writeError} #${r.serverResponses}");
  });
  test("findOne", () async {
    final r = await col!.findOne(
      where.eq("name", "test").toQuery(), // 加不加`toQuery都一样`
    );
    print("#${DateTime.now()} #findOne: $r");
  });
  test("deleteOne", () async {
    final r = await col!.deleteOne(where.eq("name", "test").toQuery());
    print(
        "#${DateTime.now()} #deleteOne #id ${r.id} #doc ${r.document} #err  ${r.writeError} #${r.serverResponses}");
  });
  test("drop", () async {
    final r = await col!.drop();
    print("#${DateTime.now()} #drop #  $r");
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

final dto1 = RecordDto.builder(
    // id: ObjectId.fromHexString("6232ae5d5c918fa41061f449"),
    metaId: ObjectId.fromHexString("62314b932f929ede7dfebc8f"));

main() async {
  var flowSign = 1;
  int getFlowSign([int add = 2]) => flowSign += add;
  IMongoStorage client = BaseMongoStorage(MongoStorageConfig(
    // auth: const MongoAuthBasic(
    //   username: "root",
    //   password: "example",
    // ),
    databaseName: 'test',
    port: 30001,
  ));
  final db = await client.asyncDb;

  test("connect", () {
    expect(db.state, State.OPEN, reason: "db is not open");
  });

  test("dao ", () async {
    print("start");
    RecordAccessor acc = RecordAccessor(
        db, ObjectId.parse("623b5479ddef0b3eea5d1aa4").toHexString());
    // RecordAccessor acc = RecordAccessor(db,dto1.metaId.toHexString());

    acc.watchAll().listen((event) {
      print("receive# at[${DateTime.now()}]#:$event");
      // expect(event.entity, dto1);
    });
    await Future.delayed(Duration(seconds: getFlowSign())).then((value) async {
      print("等待后插入新Record[${DateTime.now()}]# $dto1");
      final r = await acc.insert(dto1);
      expect(r.writeError, null);
      print("插入结果 id[${DateTime.now()}]# ${r.id}");
      print("   结果 err.code# ${r.writeError?.code}");
      print("   结果 err.eMsg# ${r.writeError?.errmsg}");
      print("   结果 document# ${r.document}");
    });
    // await Future.delayed(Duration(seconds: getFlowSign())).then((value) {
    //   print("等待后移除新Record# $dto1");
    //   final r = acc.insert(dto1);
    // });

    // RecordMetaAccessor acc2 = RecordMetaAccessor(db);
    // acc2.watchAll().listen((records) {
    //   print("ac2 records $records");
    // });
    // RecordRepo repo = RecordRepo(mongoStorage, schemaRepo)
    // SchemaRepo schemaRepo = SchemaRepo(client);
    // schemaRepo.watchAll().listen((records) {
    //   print("schemaRepo records $records");
    // });
    //
    // schemaRepo.findAll().listen((event) {
    //   print("schemaRepo findAll $event");
    // });

    await Future.delayed(const Duration(seconds: 20));
    print("end");
  });
}

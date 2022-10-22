// import 'package:flutter_test/flutter_test.dart';
// import 'package:mind_base/src/domain/entity/entity.dart';
// import 'package:mind_base/src/inter/i_dao.dart';
// import 'package:mind_base/src/inter/i_dto.dart';
//
// main() async {
//   var flowSign = 1;
//   int getFlowSign([int add = 2]) => flowSign += add;
//
//   final pRecordDto1 = RecordDto.builder(
//       id: ("6232ae5d5c918fa41061f449"),
//       metaId: ("623b5479ddef0b3eea5d1aa4"),
//       fields: {
//         2: Value.of("123"),
//       });
//
//   // final pClient = BaseMongoStorage(MongoStorageConfig(
//   //   // auth: const MongoAuthBasic(
//   //   //   username: "root",
//   //   //   password: "example",
//   //   // ),
//   //   databaseName: 'test',
//   //   port: 30001,
//   // ));
//   final pClient = BaseMongoStorage(MongoStorageConfig.ofUrl(
//     "mongodb://base.shuttlecloud.cn:11151/unit_test/?replicaSet=my-replica-set&authSource=admin",
//   ));
//
//   final db = await pClient.asyncDb;
//
//   test("connect", () {
//     expect(db.state, State.OPEN, reason: "db is not open");
//   });
//   final pRcdAcc = RecordAccessor(db, pRecordDto1.metaId.toHexString());
//
//   test("变更监听", () {
//     pRcdAcc.watchAll().subs((event) {
//       print("#监听变更receive# at[${DateTime.now()}]#:$event");
//       // expect(event.entity, dto1);
//     });
//   });
//   test("记录插入", () async {
//     await Future.delayed(Duration(seconds: getFlowSign()));
//     // print("等待后插入新Record[${DateTime.now()}]# $pRecordDto1");
//     final r = await pRcdAcc.insert(pRecordDto1);
//     print("插入结果 [${DateTime.now()}]# ${r.document}");
//   });
//   test("记录更新", () async {
//     final r = await pRcdAcc.replace(pRecordDto1..fields[2] = Value.of("456"));
//     print("更新结果 [${DateTime.now()}]# ${r.document}");
//   });
//   test("记录删除", () async {
//     final r = await pRcdAcc.deleteBy(pRecordDto1.id);
//     print("删除结果 [${DateTime.now()}]# ${r.document}");
//   });
//
//   test("移除表", () async {
//     // final r = await pRcdAcc.drop();
//     // print("移除结果# $r");
//   });
//
//   // await Future.delayed(Duration(seconds: getFlowSign())).then((value) {
//   //   print("等待后移除新Record# $dto1");
//   //   final r = acc.insert(dto1);
//   // });
//
//   // MetaModelAccessor acc2 = MetaModelAccessor(db);
//   // acc2.watchAll().listen((records) {
//   //   print("ac2 records $records");
//   // });
//   // RecordRepo repo = RecordRepo(mongoStorage, schemaRepo)
//   // SchemaRepo schemaRepo = SchemaRepo(pClient);
//   // schemaRepo.watchAll().listen((records) {
//   //   print("schemaRepo records $records");
//   // });
//   //
//   // schemaRepo.findAll().listen((event) {
//   //   print("schemaRepo findAll $event");
//   // });
//
//   await Future.delayed(const Duration(seconds: 5));
//   print("end");
// }

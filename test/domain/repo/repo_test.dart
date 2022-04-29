import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/repo.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

main() async {
  final mongoStorage = BaseMongoStorage(MongoStorageConfig(
    databaseName: 'test_repo',
    // host: '',
    port: 30001,
  ));
  final db = await mongoStorage.asyncDb;

  test("db", () => expect(db.isConnected, true));
  final metaRepo = MetaRepo(mongoStorage);
  // test("test schema", () {
  //   // todo test schema
  //   expect(1 + 2, 3);
  // });
  test("recordRepo", () async {
    final metaId = ObjectId.fromHexString("622d8e7ab1e16c6095af8989");
    final meta = RecordMeta(
      id: metaId,
      name: 'test',
      memo: "..",
      maxKey: 3,
      attrs: [
        AttributeDto.builder(
          k: 3,
          name: "test",
        ).toDm(),
      ],
      methods: [
        Method(
            k: 0,
            name: 'name',
            memo: 'memo',
            expr: Expression(
                fn:FuncManager.findBy('add'), ag:[
              Value.of(1),
              Value.of(2),
            ],type: AttrType.num))
        // MethodDto.builder(expr: "3+4"
        //         // expr: ExpressionDto(
        //         //   func: "sum",
        //         //   args: [const ValueDto("3", null), const ValueDto("4", null)],
        //         // ),
        //         )
        //     .toDomain(),
      ],
    );
    final recordRepo = RecordRepo(mongoStorage, metaRepo, metaId.toHexString());
    final record = Record.of(
        id: ObjectId.fromHexString("622d8e7ab1e16c6095af898a"),
        meta: meta,
        fields: {3: Value.of('asdfs')});

    /// 插入
    print("##插入数据# ${RecordDto.fromDomain(record).toJson()}");
    await recordRepo.insert(record);

    final r = await recordRepo.findBy(record.id);
    print("##查询数据# ${r.toDto().toJson()}");

    await Future.delayed(const Duration(seconds: 20));

    // fixme repo监听不到消息！
    recordRepo.watchAllByMeta(meta).listen((event) {
      print("##监听数据# $event");
    });
    // final allEvt = (await recordRepo.watchAllByMeta(meta).toList());
    // for (var element in allEvt) {
    //   print("##监听数据# $element");
    // }
    // expect(allEvt.length, 2);
  });

  db.drop();
}

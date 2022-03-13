import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/repo.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/infra/mongo_storage.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

main() {
  test("repo", () async {
    final mongoStorage = BaseMongoStorage(MongoStorageConfig(
      databaseName: '',
      // host: '',
      port: 30001,
    ));
    final db = await mongoStorage.asyncDb;
    expect(db.isConnected, true);

    final repo = RecordRepo(mongoStorage);
    final record = Record.of(
        id: ObjectId.fromHexString("622d8e7ab1e16c6095af898a"),
        meta: RecordMeta.of(
            id: ObjectId.fromHexString("622d8e7ab1e16c6095af8989"),
            name: 'test',
            attributes: [
              AttrInMetaBuilder(
                "name2",
                "...",
                AttrType.string,
                "none",
              ),
            ]),
        fields: {});

    /// 插入
    print("### ${RecordDto.fromDomain(record).toJson()}");
    repo.insert(record);

    final r = await repo.find(record.id);
    print("##r ${r.toDto().toJson()}");
  });
}

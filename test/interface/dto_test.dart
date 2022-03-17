import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

main() {
  test("dto", () {
    final mp = {
      "_id": ObjectId.fromHexString("6232ae5d5c918fa41061f449"),
      "metaId": ObjectId.fromHexString("62314b932f929ede7dfebc8f"),
      "0": {"v": "2", "e": null}
    };
    // fromMongoJson会修改数据, 因此同一个map只能传入1次
    RecordDto dto = RecordDto.fromMongoJson(mp);
    print(dto);
  });
}

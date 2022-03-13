import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

main() {
  test("dto", () {
    final mp = {
      "_id": ObjectId.fromHexString("622d8e7ab1e16c6095af898a"),
      "metaId": ObjectId.fromHexString("622d8e7ab1e16c6095af8989")
    };
    RecordDto dto = RecordDto.fromMongoJson(mp);
    print(dto);
  });
}

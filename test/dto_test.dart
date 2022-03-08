import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/domain.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

main() {
  test("Dto test", () {
    TupleDto tupleDto =
        TupleDto(ObjectId().toHexString(), ObjectId().toHexString(), [
      Field.of(1, '123'),
      Field.of(2, 'aaa'),
      Field.of(3, 'ccc'),
    ]);

    final js = tupleDto.toJson();
    print(js);
    // expect(1, 1);
  });
}

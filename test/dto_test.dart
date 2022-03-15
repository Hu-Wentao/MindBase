import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

main() {
  test("RecordDto", () {
    final dto = RecordDto(
        id: ObjectId.fromHexString('62275a65418db3d74941d6b3'),
        metaId: ObjectId.fromHexString('62275a65418db3d74941d6b4'),
        fields: {
          1: Value.of('123'),
          2: Value.of('aaa'),
          3: Value.of('ccc'),
        });

    final js = dto.toJson();
    final jsStr = json.encode(js);

    print(jsStr);
    expect(js, {
      '_id': '62275a65418db3d74941d6b3',
      'metaId': '62275a65418db3d74941d6b4',
      '1': {'v': '123', 'e': null},
      '2': {'v': 'aaa', 'e': null},
      '3': {'v': 'ccc', 'e': null}
    });

    final js2 = json.decode(jsStr);
    final dto2 = RecordDto.fromJson(js2);
    print(dto2);
    expect(dto2.toJson(), {
      "_id": "62275a65418db3d74941d6b3",
      "metaId": "62275a65418db3d74941d6b4",
      "1": {"v": "123", "e": null},
      "2": {"v": "aaa", 'e': null},
      "3": {'v': 'ccc', 'e': null}
    });
  });
}

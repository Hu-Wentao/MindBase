import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

main() {
  test("RecordMetaDto", () {
    // todo test
    final dto = RecordMetaDto.builder(
      // id: ObjectId.fromHexString('62275a65418db3d74941d6b3'),
      id: "62275a65418db3d74941d6b3",
      // metaId: ObjectId.fromHexString('62275a65418db3d74941d6b4'),
      attributes: [],
      // {
      //   // 0: Value.of('62275a65418db3d74941d6b3'), // id
      //   // 1: Value.of('62275a65418db3d74941d6b4'), // meta
      //   2: Value.of('aaa'),
      //   3: Value.of('ccc'),
      // }
    );

    final js = dto.toJson();
    final jsStr = json.encode(js);
    print(jsStr);
    expect(js, {
      '0': {'v': '62275a65418db3d74941d6b3', 'e': null},
      '1': {'v': '62275a65418db3d74941d6b4', 'e': null},
      '2': {'v': 'aaa', 'e': null},
      '3': {'v': 'ccc', 'e': null},
      '_id': '62275a65418db3d74941d6b3',
    });

    final js2 = json.decode(jsStr);
    final dto2 = RecordDto.fromJson(js2);
    print(dto2);
    expect(dto2.toJson(), {
      "0": {"v": "62275a65418db3d74941d6b3", "e": null},
      "1": {"v": "62275a65418db3d74941d6b4", "e": null},
      "2": {"v": "aaa", 'e': null},
      "3": {'v': 'ccc', 'e': null},
      "_id": "62275a65418db3d74941d6b3",
    });
  });
  test("RecordDto", () {
    final dto = RecordDto.builder(
        id: ObjectId.fromHexString('62275a65418db3d74941d6b3'),
        metaId: ObjectId.fromHexString('62275a65418db3d74941d6b4'),
        fields: {
          // 0: Value.of('62275a65418db3d74941d6b3'), // id
          // 1: Value.of('62275a65418db3d74941d6b4'), // meta
          2: Value.of('aaa'),
          3: Value.of('ccc'),
        });

    final js = dto.toJson();
    final jsStr = json.encode(js);
    print(jsStr);
    expect(js, {
      '0': {'v': '62275a65418db3d74941d6b3', 'e': null},
      '1': {'v': '62275a65418db3d74941d6b4', 'e': null},
      '2': {'v': 'aaa', 'e': null},
      '3': {'v': 'ccc', 'e': null},
      '_id': '62275a65418db3d74941d6b3',
    });

    final js2 = json.decode(jsStr);
    final dto2 = RecordDto.fromJson(js2);
    print(dto2);
    expect(dto2.toJson(), {
      "0": {"v": "62275a65418db3d74941d6b3", "e": null},
      "1": {"v": "62275a65418db3d74941d6b4", "e": null},
      "2": {"v": "aaa", 'e': null},
      "3": {'v': 'ccc', 'e': null},
      "_id": "62275a65418db3d74941d6b3",
    });
  });
}

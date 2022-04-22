import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

final pMetaId = ObjectId.fromHexString("62314b932f929ede7dfebc8f");

main() {
  test("RecordDto mongo", () {
    final mp = {
      "_id": ObjectId.fromHexString("6232ae5d5c918fa41061f449"),
      "metaId": pMetaId,
      "0": {"v": "2", "e": null}
    };
    // fromMongoJson会修改数据, 因此同一个map只能传入1次
    RecordDto dto = RecordDto.fromMongoJson(mp);
    print(dto);
  });

  test("RecordDto builder", () {
    final dto = RecordDto.builder(metaId: pMetaId);

    print("dto: $dto");
    print("${dto.id}");
  });

  test("AttributeDto builder", () {
    // AttributeDto dto = AttributeDto.builder();
    AttributeDto dto = AttributeDto.builder(
      k: 0,
      name: "ID",
      memo: "系统生成的唯一ID",
      // calc: Expression.field(null, 0, AttrType.num),
      // expr: Expression.field(AttrType.objectId),
    );
    print("dto: $dto");
  });
  test("RecordMetaDto json", () {
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
  test("RecordDto json", () {
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
  group("RecordMetaDto Group", () {
    final list = [
      RecordMetaDto.builder(),
      RecordMetaDto.builder(methods: [
        MethodDto.builder(
            expr: ExprJsonDto(fn: "add", ag: [
          ValueJsonDto(fn: "asint", ag: ["1"]),
          ValueJsonDto(fn: "asint", ag: ["2"]),
        ])),
      ]),
    ];
    for (var dto in list) {
      test("RecordMetaDto json", () {
        final js = dto.toJson();
        print("dto: $js");
        final dto2 = RecordMetaDto.fromJson(js);
        // print("dto2: ${dto2.toJson()}");
        expect(dto, dto2);
      });
    }
  });
}

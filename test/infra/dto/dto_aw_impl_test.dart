import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/entity/entity.dart';
import 'package:mind_base/src/infra/dto/dto_aw_impl.dart';
import 'package:mind_base/src/interface/i_dto.dart';

main() {
  test('test RecordMetaDto', () {
    final meta = RecordMetaDto(
        id: 'asdf',
        name: 'name',
        memo: 'memo',
        maxKey: 3,
        attrs: [
          AttributeDto(k: 1, name: 'name', memo: 'memo', type: AttrTypeDto.num),
          AttributeDto(
              k: 1,
              name: 'name',
              memo: 'memo',
              type: const AttrTypeDto.ref('123123')),
        ],
        methods: [
          // MethodDto(k: 1, name: 'name', memo: 'memo', ),
        ]);
    final metaJson = RecordMetaDtoAppwriteX(meta).toJson();
    print("metaJson = $metaJson");
    // print("metaJson.attrs = ${metaJson['attrs'].runtimeType}");

    final meta2 = RecordMetaDtoAppwriteX.fromJson(metaJson);
    print("meta2 = $meta2");
    final meta2json = RecordMetaDtoAppwriteX(meta2).toJson();
    print("meta2json = $meta2json");
    expect(meta2json, metaJson);
  });

  test("RecordDto", () {
    final record = RecordDto(fields: {
      1: Value.of("as1dfa4sdf"),
      2: Value.of("cc3cc4cc1cc"),
      3: Value.of("xx2xx"),
    });
    final recordJs = RecordDtoAppwriteX(record).toJson();
    print("recordJs = $recordJs");

    final record2 = RecordDtoAppwriteX.fromJson(recordJs);
    print("record2 = $record2");
    final record2Js = RecordDtoAppwriteX(record2).toJson();
    print("recordXJs2 = $record2Js");
    expect(record2Js, recordJs);
  });
  test("RecordDto fromJson Appwrite", () {
    final record = RecordDto(fields: {
      1: Value.of("62870ebf5e26daf928223242"),
      2: Value.of("628711ae99b45bcef595dc5d"),
      3: Value.of("fff"),
    });
    final recordJs = RecordDtoAppwriteX(record).toJson();
    print("recordJs = $recordJs");

    // Appwrite传入的Json
    final recordXJs = {
      "1": jsonEncode(ValueJsonDtoAppwriteX(
              ValueJsonDto.fromDomain(Value.of("62870ebf5e26daf928223242")))
          .toJson()),
      "2": jsonEncode(ValueJsonDtoAppwriteX(
              ValueJsonDto.fromDomain(Value.of("628711ae99b45bcef595dc5d")))
          .toJson()),
      "3": jsonEncode(
          ValueJsonDtoAppwriteX(ValueJsonDto.fromDomain(Value.of("fff")))
              .toJson()),
      r"$id": "62870ebf5e26daf928223242",
      r"$read": "[user: 6283942f3119ac1f8c94]",
      r"$write": "[user: 6283942f3119ac1f8c94]",
      r"$collection": "28711ae99b45bcef595dc5d",
      "id": "628715d598b183607027ac2a"
    };

    final recordX = RecordDtoAppwriteX.fromJson(recordXJs);
    print("recordX = $recordX");
    final recordXJs2 = RecordDtoAppwriteX(recordX).toJson();
    print("recordXJs2 = $recordXJs2");
    expect(recordXJs2, recordJs);
  });
}

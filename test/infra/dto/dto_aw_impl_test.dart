import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/infra/dto/dto_aw_impl.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';

main() {
  test('test MetaDto', () {
    final meta = MetaDto(
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
    final metaJson = MetaDtoAppwriteX(meta).toJson();
    print("metaJson = $metaJson");
    // print("metaJson.attrs = ${metaJson['attrs'].runtimeType}");

    final meta2 = MetaDtoAppwriteX.fromJson(metaJson);
    print("meta2 = $meta2");
    final meta2json = MetaDtoAppwriteX(meta2).toJson();
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
              ValueDto.fromDomain(Value.of("62870ebf5e26daf928223242")))
          .toJson()),
      "2": jsonEncode(ValueJsonDtoAppwriteX(
              ValueDto.fromDomain(Value.of("628711ae99b45bcef595dc5d")))
          .toJson()),
      "3": jsonEncode(
          ValueJsonDtoAppwriteX(ValueDto.fromDomain(Value.of("fff")))
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

  test("IExprJsonDtoAppwriteX", () {
    final value = Value.of("1234");
    final valueDto = ValueDto.fromDomain(value);
    // print("valueDto = ${ValueJsonDtoAppwriteX(valueDto).toJson()}");
    final expr = Expression(
        fn: IFunc.findBy("add"),
        ag: [ExprValue.of(1), ExprValue.of(2)],
        type: AttrType.string);
    final exprDto = ExprNodeDto.fromDomain(expr);
    // print("exprDto = $exprDto");

    final valueJson = IExprJsonDtoAppwriteX(valueDto).toJson();
    print("valueJson = $valueJson");
    final exprJson = IExprJsonDtoAppwriteX(exprDto).toJson();
    print("exprJson = $exprJson");

    final value2 = IExprJsonDtoAppwriteX.fromJson(valueJson);
    final expr2 = IExprJsonDtoAppwriteX.fromJson(exprJson);

    final value2Json = IExprJsonDtoAppwriteX(value2).toJson();
    print("value2Json = $value2Json");
    final expr2Json = IExprJsonDtoAppwriteX(expr2).toJson();
    print("expr2Json = $expr2Json");
    expect(expr2Json, exprJson);
    expect(value2Json, valueJson);
  });
}

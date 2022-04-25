import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_arch_core/get_arch_core_interface.dart' hide test;
import 'package:mind_base/src/application/expression_parser.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mind_base/src/interface/expression_dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

///
/// 可读字符串 : 用户直接输入的字符串
/// Dto: 对字符串的包装, 需要Meta   Context, 用于映射用户输入的标识->propId
/// Domain: 表达式对象, 需要Record Context, 可以计算出表达式的结果
///
/// ┌──────────────────┐                            ┌────────┐
/// │ 中缀表达式/函数嵌套 │     函数嵌套型字符串          │        │
/// │  ReadableString  ◄──────────────────────────┐ │  Json  │
/// │                  │                          │ │        │
/// └─────────┬────────┘                          │ └───▲──┬─┘
///           │                                   │     │  │
///           │                                   │     │  │
///  ┌────────▼────────┐    ┌──────────────┐    ┌─┴─────┴──▼┐
///  │                 │    │              │    │           │
///  │                 └────►              └────►           │
///  │   ReadableDto   ◄────┐    Domain    ◄────┐  JsonDto  │
///  │                 │    │              │    │           │
///  └─────────────────┘    └──────────────┘    └───────────┘
///
main() {
  group("表达式转换", () {
    final meta = RecordMeta(
        id: ObjectId.fromHexString('6262e2d8113f6c880d5d736b'),
        name: '学生表',
        memo: '记录一个学生的信息',
        maxKey: 2,
        attrs: const [
          Attribute(k: 0, name: 'id', memo: 'memo', type: AttrType.objectId),
          Attribute(
              k: 1, name: 'metaId', memo: 'memo', type: AttrType.objectId),
          Attribute(k: 2, name: 'name', memo: '学生名称', type: AttrType.string),
          Attribute(k: 3, name: 'age', memo: '学生年龄', type: AttrType.string),
          Attribute(k: 4, name: '备注', memo: '备注信息', type: AttrType.string),
        ],
        methods: [
          Method(
              k: 0,
              name: 'getName',
              memo: 'memo2',
              expr: Expression(FuncManager.findBy("member"), [
                Value.of("a2"), // 表示attribute 0
              ])),
          Method(
              k: 1,
              name: 'sayHello',
              memo: 'memo',
              // ("'Hello every one! My name is'+this.name")
              expr: Expression(FuncManager.findBy("add"), [
                Value.of("Hello everyone! My name is "),
                Expression(FuncManager.findBy("member"), [
                  Value.of("a2"), // 填入 propId
                ]),
              ]))
        ]);
    final pRecord = Record(
      id: ObjectId.fromHexString('6262e3b0118f5894993d4533'),
      meta: meta,
      fields: {
        0: Value.of(ObjectId().toHexString()),
        1: Value.of(meta.id.toHexString()),
        2: Value.of("张三"),
        3: Value.of("20"),
        4: Value.of("asdf")
      },
    );
    final ws = WorkspaceDataHolder();
    GetIt.I.registerSingleton<WorkspaceDataHolder>(ws);
    ws.insertMeta(meta);
    ws.insertRecord(pRecord);
    final parser = ExpressionParser();

    test("可读字符->Dto", () {
      const map = {
        "'1 + 2 = ' + (1 + 2)": "('1 + 2 = '+1+2)",
        "'My age is ' + this.age": "('My age is '+this.age)",
      };
      for (final entry in map.entries) {
        final dto = ExpressionDto.of(parser, entry.key);
        final str = dto.toReadableString();
        print("exprDto = $str");
        expect(str, entry.value);
      }
    });

    const pReadable = "'My age is ' + this.age";
    // 初步转义后的
    const pReadable2 = "('My age is '+this.age)";
    // 经过上下文转义后的
    const pSavedReadable =
        'add(asString("My age is "), member(asFuncRecordMeta("6262e2d8113f6c880d5d736b"), asString("a3")))';

    final pExpr = Expression(FuncManager.findBy("add"), [
      Value.of("My age is "),
      Expression(FuncManager.findBy("member"), [
        Value.of(pRecord.meta),
        Value.of("a3"),
      ]),
    ]);
    final pExprJsonDto = ExprJsonDto(fn: "add", ag: [
      ValueJsonDto(fn: "asString", ag: ["My age is "]),
      ExprJsonDto(fn: "member", ag: [
        ValueJsonDto(fn: "asFuncRecordMeta", ag: ["6262e2d8113f6c880d5d736b"]),
        ValueJsonDto(fn: "asString", ag: ["a3"])
      ])
    ]);
    final pExprJson = {
      "fn": "add",
      "ag": [
        {
          "fn": "asString",
          "ag": ["\"My age is \""]
        },
        {
          "fn": "member",
          "ag": [
            {
              "fn": "asFuncRecordMeta",
              "ag": ["\"6262e2d8113f6c880d5d736b\""]
            },
            {
              "fn": "asString",
              "ag": ["\"a3\""]
            }
          ]
        }
      ]
    };

    test("String -> ReadableDto -> Expression (Domain)", () {
      /// Readable -> ReadableDto
      final readableDto = ExpressionDto.of(parser, pReadable);

      /// ReadableDto -> ReadableString
      final str = readableDto.toReadableString();
      print("readableDto.str = $str");
      expect(str, pReadable2);

      /// ReadableDto -> Domain
      /// 注意,传入的是 [RecordMeta]实例,但存储在内部的只有MetaId :String, 实际上通过 WorkspaceDataHolder读取
      final expr = readableDto.toDomain(pRecord.meta.id);
      // print("expr = ${expr}");
      expect(expr, pExpr);

      ///  Domain -> ReadableDto x 无需实现
    });

    test("Domain <-> JsonDto", () {
      /// Domain -> JsonDto
      final jsonDto = IExprJsonDto.fromDomain(pExpr);
      expect(jsonDto, pExprJsonDto);

      /// JsonDto -> Domain
      final domain2 = jsonDto.toDomain();
      print(domain2);
      expect(domain2, pExpr);
    });
    test("ExprJsonDto <-> Json", () {
      /// ExprJsonDto -> Json
      final dto3Json = pExprJsonDto.toJson();
      print("dto3Json = $dto3Json");
      expect(dto3Json, pExprJson);

      /// Json -> ExprJsonDto
      final jsonDto2 = IExprJsonDto.fromJson(dto3Json);
      // print("jsonDto2 = $jsonDto2");
      expect(jsonDto2, pExprJsonDto);
    });

    test("JsonDto -> ReadableString", () {
      /// JsonDto -> ReadableString
      final readableStr = pExprJsonDto.toReadableString();
      print("readableStr = $readableStr");
      expect(
        readableStr,
        pSavedReadable,
      );

      /// ReadableString -> JsonDto x 无需实现
    });

    test("重复读取ReadableString", () {
      /// 重复读取 ReadableString (因为转义后生成的表达式与原始输入的表达式不同)
      const readableL1 = pReadable;
      print("readableL1 = $readableL1");

      final exprDto = ExpressionDto.of(parser, pReadable);
      print('exprDto = $exprDto');

      final readableL2 = exprDto.toReadableString();
      print("readableL2 = $readableL2");

      final dm = exprDto.toDomain(pRecord.meta.id);
      final jsDto = IExprJsonDto.fromDomain(dm); // toDTO一切正常
      print(
          "jsDto = $jsDto"); // {fn: add, ag: [{fn: asString, ag: ["My age is "]}, {fn: member, ag: [{fn: asFuncRecordMeta, ag: ["6262e2d8113f6c880d5d736b"]}, {fn: asString, ag: ["a3"]}]}]}

      final readableL3 = jsDto.toReadableString();
      print(
          "readableL3 = $readableL3"); // add(asString(\"My age is \"), member(asFuncRecordMeta(\"6262e2d8113f6c880d5d736b\"), asString(\"a3\")))

      ///
      print("==============================================");

      final exprDtoV2 = ExpressionDto.of(parser, readableL3);
      print(
          "exprDtoV2 = $exprDtoV2"); // add(asString("My age is "), member(asFuncRecordMeta("6262e2d8113f6c880d5d736b"), asString("a3")))

      final readableL2V2 = exprDtoV2.toReadableString();
      print(
          "readableL2V2 = $readableL2V2"); // add(asString(\"My age is \"), member(asFuncRecordMeta(\"6262e2d8113f6c880d5d736b\"), asString(\"a3\")))

      final dm2 = exprDtoV2.toDomain(pRecord.meta.id); // DTO -> Domain 可能有问题
      final jsDto2 = IExprJsonDto.fromDomain(dm2);
      print("jsDto2 = $jsDto2");
      expect(jsDto2, jsDto);

      final readableL3V2 = jsDto2.toReadableString();
      print("readableL3V2 = $readableL3V2");
      expect(readableL3V2, readableL3);
    });

    group("debug #121", () {
      _test(origin) {
        final exprDtoV2 = ExpressionDto.of(parser, origin);
        print(
            "exprDtoV2 = $exprDtoV2"); // add(asString("My age is "), member(asFuncRecordMeta("6262e2d8113f6c880d5d736b"), asString("a3")))

        final readableL2V2 = exprDtoV2.toReadableString();
        print(
            "readableL2V2 = $readableL2V2"); // add(asString(\"My age is \"), member(asFuncRecordMeta(\"6262e2d8113f6c880d5d736b\"), asString(\"a3\")))
        ///
        final dm2 = exprDtoV2.toDomain(pRecord.meta.id);
        final jsDto2 = IExprJsonDto.fromDomain(dm2);


        print("jsDto2 = $jsDto2");

      }

      test("单个,值表达式", () {
        const readableL3 = "asString(\"My age is \")";
        _test(readableL3);
      });

      test("复合,运算-值表达式", () {
        const readableL3 = "add(asString(\"My age is \"), asString(\"a3\"))";
        _test(readableL3);
      });

      test("单个,成员表达式", () {
        const readableL3 =
            "member(asFuncRecordMeta(\"6262e2d8113f6c880d5d736b\"), asString(\"a3\"))";
        _test(readableL3);
      });

      test("复合,运算-成员表达式", () {
        const readableL3 =
            "add(asString(\"My age is \"), member(asFuncRecordMeta(\"6262e2d8113f6c880d5d736b\"), asString(\"a3\")))";
        _test(readableL3);
      });
    });
  });
}

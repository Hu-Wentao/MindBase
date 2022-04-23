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
  final meta = RecordMeta(
      id: ObjectId.fromHexString('6262e2d8113f6c880d5d736b'),
      name: '学生表',
      memo: '记录一个学生的信息',
      maxKey: 2,
      attrs: const [
        Attribute(k: 0, name: 'id', memo: 'memo', type: AttrType.objectId),
        Attribute(k: 1, name: 'metaId', memo: 'memo', type: AttrType.objectId),
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
  final rcd = Record(
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
  ws.insertRecord(rcd);
  final parser = ExpressionParser();

  test("可读字符->Dto", () {
    const map = {
      "'1 + 2 = ' + (1 + 2)": "('1 + 2 = '+1+2)",
      "'My age is ' + this.age": "('My age is '+this.age)",
    };
    for (final entry in map.entries) {
      final dto = ExpressionDto.of(parser, entry.key);
      final str = dto.toReadableString();
      print("dto = $str");
      expect(str, entry.value);
    }
  });

  IExpr? domain;
  IExprJsonDto? dto;
  test("Readable Dto->Domain -> JsonDto", () {
    /// 可读字符串 -> ReadableDto
    const readable = "'My age is ' + this.age";
    final readableDto = ExpressionDto.of(parser, readable);

    /// ReadableDto -> ReadableString
    final str = readableDto.toReadableString();
    print("readableDto.str = $str");
    expect(str, "('My age is '+this.age)");

    /// ========================================================================

    /// ReadableDto -> Domain
    /// 注意,传入的是 [RecordMeta]实例,但存储在内部的只有MetaId :String, 实际上通过 WorkspaceDataHolder读取
    domain = readableDto.toDomain(rcd.meta.id);
    // print("domain = ${domain}");
    expect(
        domain,
        Expression(FuncManager.findBy("add"), [
          Value.of("My age is "),
          Expression(FuncManager.findBy("member"), [
            Value.of(rcd.meta),
            Value.of("a3"),
          ]),
        ]));

    ///  Domain -> ReadableDto x 无需实现
    // final readable2 = domain!.toReadableString();
    /// ========================================================================

    /// Domain -> JsonDto
    final jsonDto = IExprJsonDto.fromDomain(domain!);

    /// JsonDto -> Domain
    final domain2 = jsonDto.toDomain();
    print(domain2);
    expect(domain2, domain);

    /// ========================================================================

    /// JsonDto -> Json
    final dto3Json = jsonDto.toJson();
    print("dto3Json = $dto3Json");
    expect(dto3Json, {
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
    });

    /// Json -> JsonDto
    final jsonDto2 = IExprJsonDto.fromJson(dto3Json);
    // print("jsonDto2 = $jsonDto2");
    // print("jsonDto  = $jsonDto");
    // print("== ${jsonDto2 == jsonDto}");
    expect(jsonDto2, jsonDto);

    /// ========================================================================

    /// JsonDto -> ReadableString
    final readableStr = jsonDto.toReadableString();
    // print("dto3 = $readableStr");
    expect(
      readableStr,
      'add(asString("My age is "), member(asFuncRecordMeta("6262e2d8113f6c880d5d736b"), asString("a3")))',
    );

    /// ReadableString -> JsonDto x 无需实现
  });
  // test("Domain->Dto", () {
  // final dto = IExprJsonDto.fromDomain(domain!);
  // print("dto = ${dto.toJson()}");
  // });
}

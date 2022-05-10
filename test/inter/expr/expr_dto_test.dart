import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_arch_core/get_arch_core_interface.dart' hide test;
import 'package:mind_base/src/application/expr_evaluator.dart';
import 'package:mind_base/src/application/expression_parser.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/entity/entity.dart';
import 'package:mind_base/src/domain/value/value.dart';
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
  final parser = ExpressionParser();

  final pMetaStudentId = ObjectId.fromHexString('6262e2d8113f6c880d5d736b');
  final pMetaSchoolId = ObjectId.fromHexString('626a109fd90369d16c2fbe0e');
  final pRcdHfuId = ObjectId.fromHexString("626a98b14a034567ff06f2f4");
  final pRcdZsId = ObjectId.fromHexString('6262e3b0118f5894993d4533');
  final pMetaSchool = RecordMeta(
      id: pMetaSchoolId,
      name: '学校表',
      memo: '学校信息',
      maxKey: 3,
      attrs: const [
        Attribute(k: 0, name: 'id', memo: 'memo', type: AttrType.string),
        Attribute(k: 1, name: 'metaId', memo: 'memo', type: AttrType.string),
        Attribute(k: 2, name: 'name', memo: '学校名称', type: AttrType.string),
        Attribute(k: 3, name: 'sign', memo: '学校简称', type: AttrType.string),
      ],
      methods: []);
  final pMetaStudent = RecordMeta(
      id: pMetaStudentId,
      name: '学生表',
      memo: '记录一个学生的信息',
      maxKey: 4,
      attrs: [
        const Attribute(k: 0, name: 'id', memo: '', type: AttrType.string),
        const Attribute(k: 1, name: 'metaId', memo: '', type: AttrType.string),
        const Attribute(k: 2, name: 'name', memo: '', type: AttrType.string),
        const Attribute(k: 3, name: 'age', memo: '年龄', type: AttrType.string),
        const Attribute(k: 4, name: '备注', memo: '备注', type: AttrType.string),
        Attribute(
            k: 5,
            name: '学校',
            memo: '学校引用',
            type: AttrType.ref(pMetaSchool.id.$oid)),
      ],
      methods: [
        Method(
            k: 0,
            name: 'getName',
            memo: 'memo2',
            expr: Expression(
              fn: IFunc.findBy("member"),
              ag: [
                Value.of("a2"), // 表示attribute 0
              ],
              type: AttrType.string,
            )),
        Method(
            k: 1,
            name: 'sayHello',
            memo: 'memo',
            // ("'Hello every one! My name is'+this.name")
            expr: Expression(
              fn: IFunc.findBy("add"),
              ag: [
                Value.of("Hello everyone! My name is "),
                Expression(
                  fn: IFunc.findBy("member"),
                  ag: [
                    const Value(fn: AsFuncThis(), ag: []),
                    Value.of("a2"), // 填入 propId
                  ],
                  type: AttrType.string,
                )
              ],
              type: AttrType.string,
            )),
        Method(
          k: 2,
          name: 'say学校',
          memo: 'memo',
          // ("'Hello every one! My name is'+this.name")
          expr: IExprJsonDto.fromJson({
            'fn': 'member',
            'ag': [
              {
                'fn': 'member',
                'ag': [
                  {'fn': 'asThis', 'ag': []},
                  {
                    'fn': 'asString',
                    'ag': ['"a5"']
                  }
                ],
                'type': 'ref_626a109fd90369d16c2fbe0e'
              },
              {
                'fn': 'asString',
                'ag': ['"a3"']
              }
            ],
            'type': 'string'
          }).toDomain(),
          // expr: ExpressionDto.of(parser, '"我的学校是: "+ this.学校.name').toDomain(),
        )
        // expr: Expression(FuncManager.findBy("add"), [
        //   Value.of("我就读的学校是: "),
        //   Expression(FuncManager.memberFunc, [
        //     Expression(FuncManager.memberFunc, [
        //       Value(
        //           fn: AsFuncThis(AttrType.ref(pMetaStudentId.$oid)),
        //           ag: []),
        //       // Value.of("a5"),
        //       Value(
        //           fn: AsFuncRef(AttrType.ref(pMetaStudentId.$oid)),
        //           ag: ["a5"]),
        //     ]),
        //     Value.of("a2"), // 填入 propId
        //   ]),
        // ]))
      ]);
  final pRcdHfu = Record(id: pRcdHfuId, meta: pMetaSchool, fields: {
    0: Value.of(pRcdHfuId.$oid),
    1: Value.of(pMetaStudent.id.$oid),
    2: Value.of("合肥学院"),
    3: Value.of("HFU"),
  });
  final pRcdZs = Record(
    id: pRcdZsId,
    meta: pMetaStudent,
    fields: {
      0: Value.of(pRcdHfuId.toHexString()),
      1: Value.of(pMetaStudent.id.toHexString()),
      2: Value.of("张三"),
      3: Value.of("20"),
      4: Value.of("备注...123"),
      5: Value.of(pRcdHfu.id.$oid)
    },
  );
  final ws = WorkspaceDataHolder();
  GetIt.I.registerSingleton<WorkspaceDataHolder>(ws);
  ws.insertMeta(pMetaStudent);
  ws.insertMeta(pMetaSchool);
  ws.insertRecord(pRcdZs);
  ws.insertRecord(pRcdHfu);
  group("表达式转换", () {
    test("可读字符->Dto", () {
      const testMap = {
        "'1 + 2 = ' + (1 + 2)": "('1 + 2 = '+1+2)",
        "'My age is ' + this.age": "('My age is '+this.age)",
      };
      for (final entry in testMap.entries) {
        final dto = ExpressionDto.of(parser, entry.key);
        final str = dto.toReadableString();
        print("exprDto = $str");
        expect(str, entry.value);
      }
    });

    const pReadableL1 = "'My age is ' + this.age";
    // 初步解析后的
    const pReadableL2 = "('My age is '+this.age)";
    // 经过上下文转义后的
    const pReadableL3 =
        'add(asString("My age is "), member(asThis(), asString("a3")))';

    final pExpr = Expression(
        fn: IFunc.findBy("add"),
        ag: [
          Value.of("My age is "),
          Expression(
            fn: IFunc.findBy("member"),
            ag: [
              Value(fn: IFunc.asThisFunc, ag: []),
              Value.of("a3"),
            ],
            type: AttrType.string,
          )
        ],
        type: AttrType.string);
    final pExprJsonDto = ExprJsonDto(
      fn: "add",
      ag: [
        ValueJsonDto(fn: "asString", ag: ["My age is "]),
        ExprJsonDto(
          fn: IFunc.memberFunc.name,
          ag: [
            ValueJsonDto(fn: IFunc.asThisFunc.name, ag: []),
            ValueJsonDto(fn: "asString", ag: ["a3"])
          ],
          type: AttrType.string,
        )
      ],
      type: AttrType.string,
    );
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
            {"fn": IFunc.asThisFunc.name, "ag": []},
            {
              "fn": "asString",
              "ag": ["\"a3\""]
            }
          ],
          'type': 'string'
        }
      ],
      'type': 'string'
    };
    test("String -> ReadableDto -> Expression (Domain)", () {
      /// Readable -> ReadableDto
      final readableDto = ExpressionDto.of(parser, pReadableL1);

      /// ReadableDto -> ReadableString
      final str = readableDto.toReadableString();
      print("readableDto.str = $str");
      expect(str, pReadableL2);

      /// ReadableDto -> Domain
      /// 注意,传入的是 [RecordMeta]实例,但存储在内部的只有MetaId :String, 实际上通过 WorkspaceDataHolder读取
      /// expr12 尝试直接传入 [RecordMeta]实例, 避免使用 sl
      final expr = readableDto.toDomain(pRcdZs.meta);
      // print("expr = ${expr}");
      expect(expr, pExpr); // 值是一样的, 可能 ==与hashCode 出问题了

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
    test("Domain -> 求值", () {
      final r = pRcdZs.getValueBy(pMetaStudent.methodMap[2] as Property);
      print("r = $r");
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
        pReadableL3,
      );

      /// ReadableString -> JsonDto x 无需实现
    });
    test("重复读取ReadableString", () {
      /// 重复读取 ReadableString (因为转义后生成的表达式与原始输入的表达式不同)
      print("pReadableL1 = $pReadableL1");

      final exprDto = ExpressionDto.of(parser, pReadableL1);
      print('exprDto = $exprDto');

      final readableL2 = exprDto.toReadableString();
      print("readableL2 = $readableL2");

      final dm = exprDto.toDomain(pRcdZs.meta);
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

      final dm2 = exprDtoV2.toDomain(pRcdZs.meta); // DTO -> Domain 可能有问题
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
        final dm2 = exprDtoV2.toDomain(pRcdZs.meta);
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
  group("#135 能够访问子实体属性", () {
    test("访问子实体字段", () {
      /// Readable -> ReadableDto
      final readableDto = ExpressionDto.of(parser, "this.学校.sign");

      /// ReadableDto -> ReadableString
      final str = readableDto.toReadableString();
      print("readableDto.str = $str");
      // expect(str, pReadableL2);

      /// ReadableDto -> Domain
      /// 注意,传入的是 [RecordMeta]实例,但存储在内部的只有MetaId :String, 实际上通过 WorkspaceDataHolder读取
      final expr = readableDto.toDomain(pRcdZs.meta);
      print("expr = $expr");
      // expect(expr, pExpr);

      final dto = ExprJsonDto.fromDomain(expr);
      print("dto = $dto");

      final expr2 = dto.toDomain();
      print("expr2 = $expr2");
      //todo 两个Expr相等吗? 丢失Ref的情况下,可以求值吗?
      final dto2 = ExprJsonDto.fromDomain(expr2);
      // print("dto2 = $dto2");
      expect(dto2, dto);

      final r = exprEvaluator.eval(expr, {AsFuncThis.ctxSign: pRcdZs});
      print("r = $r");
    });
  });
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/workspace/application/service/expr/expression_parser.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/workspace/domain/entity/entity.dart';
import 'package:mind_base/src/workspace/infra/dto/dto_aw_impl.dart';
import 'package:mind_base/src/workspace/inter/dto/expr_token_dto.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';

/// 测试 Domain 与 TokenString 之间的转换
/// Domain -> Token
/// Token -> Domain

/// ===========================

/// 数据 =====================
// id

const pMetaStudentId = ('6262e2d8113f6c880d5d736b');
const pMetaSchoolId = ('626a109fd90369d16c2fbe0e');
const pRcdSchoolHfuId = ("626a98b14a034567ff06f2f4");
const pRcdStudentZsId = ('6262e3b0118f5894993d4533');

// Meta 2个
/// 学校meta
final pMetaSchool = RecordMeta(
    id: pMetaSchoolId,
    name: '学校表',
    memo: '学校信息',
    maxKey: 3,
    attrs: const [
      Attribute(k: 0, name: 'id', memo: 'memo', type: AttrType.string),
      Attribute(k: 1, name: 'metaId', memo: 'memo', type: AttrType.string),
      Attribute(k: 2, name: 'name', memo: '学校的中文名称', type: AttrType.string),
      Attribute(k: 3, name: 'sign', memo: '学校的英文简称', type: AttrType.string),
    ],
    methods: []);

/// 学校对应的记录 (HFUU)
final pRcdHfu = Record(id: pRcdSchoolHfuId, meta: pMetaSchool, fields: {
  0: Value.of(pRcdSchoolHfuId),
  1: Value.of(pMetaSchool.id),
  2: Value.of("合肥学院"),
  3: Value.of("HFUU"),
});

/// 学生表
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
          type: AttrType.ref(pMetaSchool.id, (_) => pMetaSchool)),
    ],
    methods: [
      Method(
          k: 0,
          name: 'getName',
          memo: 'memo2',
          expr: Expression(
            fn: IFunc.findBy("member"),
            ag: [
              ExprValue.of("a2"), // 表示attribute 0
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
              ExprValue.of("Hello everyone! My name is "),
              Expression(
                fn: IFunc.findBy("member"),
                ag: [
                  // fixme  `const Value(fn: AsFuncThis(), ag: [])`表达this
                  ExprValue.of(''),
                  ExprValue.of("a2"),
                  // 填入 propId
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
        expr: IExprJsonDtoAppwriteX.fromJson({
          'fn': 'member',
          'type': 'string',
          'ag': jsonEncode([
            {
              'type': 'ref_626a109fd90369d16c2fbe0e',
              'ag': jsonEncode([]),
            },
            {
              'type': 'string',
              'ag': jsonEncode(['"a3"']),
            }
          ]),
        }).toDomain((_) => throw "none getMeta fun"),
        // expr: ExpressionDto.of(parser, '"我的学校是: "+ this.学校.name').toDomain(),
      )
    ]);

// // ([{fn: member, ag: [{"type":"ref_629393f8ff13cb4dbbf5a09a","ag":"[]"},{"type":"any","ag":"[\"a3\"]"}], type: any}, {type: string, ag: ["~~",null]}])
// final expr = Expression(fn: IFunc.findBy("+"), type: AttrType.any, ag: [
//   Expression(fn: IFunc.memberFunc, type: AttrType.any, ag: [
//     ExprValue.build(
//         type: AttrType.ref(pMetaSchool.id, (metaId) => pMetaSchool), ag: []),
//     const ExprValue.build(type: AttrType.any, ag: ["a3"]),
//   ]),
//   const ExprValue.build(type: AttrType.string, ag: ["~~", null])
// ]);
final pWs = Workspace(
  id: 'wsId',
  name: 'wsName',
  metas: [pMetaSchool, pMetaStudent],
);

main() {
  test("测试Token", () {
    // 学生表方法
    const pStuSayToken = "this.学校.name";
    // final pStuSay = ExpressionDto.of(parser, pStuSayToken).toDomain((_) =>
    //     throw "none getMeta fun");
    final tokenDto = IExprNodeDto.fromDomain(
        ExprTokenDto.of(exprParser, pStuSayToken).toDomain(
      pMetaStudentId,
      pWs.queryMeta,
    ));
    print("tokenDto: $tokenDto");
    // exprToDomain.convert(expr, ctx  );
    // domainToToken.convert(expr, ctx);
  });
}

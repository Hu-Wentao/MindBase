import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/user/application/model/model.dart';
import 'package:mind_base/src/workspace/application/model/model.dart';
import 'package:mind_base/src/workspace/application/service/expr/expr_evaluator.dart';
import 'package:mind_base/src/workspace/domain/entity/entity.dart';
import 'package:mind_base/src/workspace/infra/dto/dto_aw_impl.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';

main() {
  /// 求值器
  const evaluator = exprEvaluator;
  test("纯函数求值", () {
    final expr = Expression(
      fn: IFunc.findBy('add'),
      ag: [
        ExprValue.of(3),
        ExprValue.of(4),
      ],
      type: AttrType.num,
    );
    final r = evaluator.eval(expr, {}).value;
    print("#r = $r");
    expect(r, 7);
  });

  ///
  final us = UserModel(null);
  final tm = TeamModel(Team($id: 'id', name: "name", $createdAt: 123, total: 1, $updatedAt: 1233), us);
  final space = WorkspaceModel(WorkspaceDto.builder(), tm);
  const pMetaStudentId = ('6262e2d8113f6c880d5d736b');
  const pMetaSchoolId = ('626a109fd90369d16c2fbe0e');
  const pRcdHfuId = ("626a98b14a034567ff06f2f4");
  const pRcdZsId = ('6262e3b0118f5894993d4533');
  final pMetaSchool = MetaModel(RecordMetaDto(
      id: pMetaSchoolId,
      name: '学校表',
      memo: '学校信息',
      maxKey: 3,
      attrs: [
        AttributeDto.builder(k: 0, name: 'id', memo: 'memo', type: AttrTypeDto.string),
        AttributeDto.builder(k: 1, name: 'metaId', memo: 'memo', type: AttrTypeDto.string),
        AttributeDto.builder(k: 2, name: 'name', memo: '学校名称', type: AttrTypeDto.string),
        AttributeDto.builder(k: 3, name: 'sign', memo: '学校简称', type: AttrTypeDto.string),
      ],
      methods: []), space);
  final pRcdHfu = RecordDto.builder(id: pRcdHfuId, metaId: pMetaSchool.id, fields: {
    0: Value.of(pRcdHfuId),
    1: Value.of(pMetaSchool.id),
    2: Value.of("合肥学院"),
    3: Value.of("HFU"),
  });
  // ([{fn: member, ag: [{"type":"ref_629393f8ff13cb4dbbf5a09a","ag":"[]"},{"type":"any","ag":"[\"a3\"]"}], type: any}, {type: string, ag: ["~~",null]}])
  final expr = Expression(fn: IFunc.findBy("+"), type: AttrType.any, ag: [
    Expression(fn: IFunc.memberFunc, type: AttrType.any, ag: [
      ExprValue.build(
          type: AttrType.ref(pMetaSchool.id, (metaId) => pMetaSchool), ag: []),
      const ExprValue.build(type: AttrType.any, ag: ["a3"]),
    ]),
    const ExprValue.build(type: AttrType.string, ag: ["~~", null])
  ]);
  test("简单表达式求值", () {
    final r = evaluator.eval(expr, {
      AsFuncThis.ctxSign: pRcdHfu,
    });
    print("#r = $r");
  });
  test("简单表达式序列化", () {
    final dto = IExprNodeDto.fromDomain(expr);
    print("dto = $dto");
    final js = IExprJsonDtoAppwriteX(dto).toJson();
    print("js = $js");
    final dto2 = IExprJsonDtoAppwriteX.fromJson(js);
    print("dto2 = $dto2");
  });
}

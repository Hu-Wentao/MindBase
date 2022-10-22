import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/space/application/service/expr/domain_to_token.dart';
import 'package:mind_base/src/space/application/service/expr/expression_parser.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/inter/dto/expr_token_dto.dart';

import 'expr_test.dart';

main() {
  const pStuSayToken = "this.学校.name";
  final pStuSayExpr = Expression(
      fn: IFunc.memberFunc,
      ag: [
        Expression(
            fn: IFunc.memberFunc,
            ag: [
              ExprValue.build(
                  type: AttrType.ref("6262e2d8113f6c880d5d736b", pWs.queryMeta),
                  ag: []),
              ExprValue.build(
                  type: AttrType.ref("626a109fd90369d16c2fbe0e", pWs.queryMeta),
                  ag: ['a5']),
            ],
            type: AttrType.ref('626a109fd90369d16c2fbe0e', pWs.queryMeta)),
        const ExprValue.build(type: AttrType.string, ag: ['a2'])
      ],
      type: AttrType.string);

  test("Token->Domain", () {
    final tokenDto = ExprTokenDto.of(exprParser, pStuSayToken);
    print("tokenDto: ${tokenDto.toReadableString()}");

    final expr = tokenDto.toDomain(
      pMetaStudent.id,
      pWs.queryMeta,
    );
    print("expr: ${expr}");
  });

  test("Domain->Token", () {
    final token = domainToToken.convert(pStuSayExpr, {});

    print("token: ${token}");
  });
}

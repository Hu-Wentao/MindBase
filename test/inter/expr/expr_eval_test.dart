import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/workspace/application/service/expr_evaluator.dart';
import 'package:mind_base/src/workspace/domain/entity/entity.dart';

main() {
  /// 求值器
  const evaluator = exprEvaluator;
  test("纯函数求值", () {
    final expr = Expression(
      fn: IFunc.findBy('add'),
      ag: [
        Value.of(3),
        Value.of(4),
      ],
      type: AttrType.num,
    );
    final r = evaluator.eval(expr, {});
    print("#r = $r");
    expect(r, 7);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/application/expr_evaluator.dart';
import 'package:mind_base/src/domain/entity/func.dart';

main() {
  /// 求值器
  const evaluator = exprEvaluator;
  test("纯函数求值", () {
    final expr = Expression(FuncManager.findBy('add'), [
      Value.of(3),
      Value.of(4),
    ]);
    final r = evaluator.eval(expr, {});
    print("#r = $r");
    expect(r, 7);
  });
}

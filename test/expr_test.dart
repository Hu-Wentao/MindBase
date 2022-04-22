import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/application/expression_evaluator.dart';
import 'package:mind_base/src/application/expression_parser.dart';
import 'package:mind_base/src/interface/expression_dto.dart';

main() {
  test("expr", () {
    ExpressionParser parser = ExpressionParser();
    const evaluator = ExpressionEvaluator(memberAccessors: [
      MemberAccessor.mapAccessor, // 可以直接访问Map对象
    ]);

    ExpressionDto expr = ExpressionDto.of(
        parser, "this.sayHi() + ' My name is ' + this.name + '!'");
    final r = evaluator.eval(
      expr,
      {
        "this": {
          "name": "Tom",
          "sayHi": () => "Hello~",
        },
      },
    );
    print(r);
    expect(r, "Hello~ My name is Tom!");
  });
}

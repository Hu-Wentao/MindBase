import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mongo_dart/mongo_dart.dart';

main() {
  // test("Value toJson", () {
  //   Value value = Value.of(
  //     "asdf",
  //     "error",
  //   );
  //   print(value.toJson());
  //   print(value.toJsonWithType());
  //
  //   expect(value.toJsonWithType(), {
  //     "type": "Value",
  //     "real": {"v": "asdf", "e": "error"}
  //   });
  // });

  test("Expression2", () {
    final exp = Expression(
      FuncManager.findBy("+"),
      [
        Value.of(1),
        Value.of(2),
      ],
    );
    final r = exp.invoke();
    print("$r");
    expect(r, Value.of(3));
  });
  test("Expression2#嵌套2", () {
    final exp = Expression(
      FuncManager.findBy("+"),
      [
        Expression(FuncManager.findBy("*"), [
          Value.of(4),
          Value.of(2),
        ]),
        Value.of(2),
      ],
    );
    final r = exp.invoke();
    print("$r");
    expect(r, Value.of(10));
  });
  test("Expression2#嵌套3", () {
    final exp = Expression(
      FuncManager.findBy("+"),
      [
        Expression(FuncManager.findBy("*"), [
          Value.of(4),
          Expression(FuncManager.findBy("/"), [
            Value.of(6),
            Value.of(2),
          ])
        ]),
        Expression(FuncManager.findBy("-"), [
          Value.of(2),
          Value.of(4),
        ]),
      ],
    );
    final r = exp.invoke();
    print("$r");
    expect(r, Value.of("10.0"));
  });

  // test("Expression", () {
  //   Expression expression = Expression.field(ObjectId(), 0, AttrType.objectId);
  //   final js = expression.toJson();
  //   print("expression: $js");
  //   expect(js, {
  //     'pKeys': [],
  //     "calls": [
  //       {
  //         "type": "Func",
  //         "real": {"name": 'self'}
  //       }
  //     ],
  //     'rType': 'objectId'
  //   });
  //
  //   final jsStr = jsonEncode(js);
  //   print("jsStr: $jsStr");
  //   final exp2 = Expression.fromJson(jsonDecode(jsStr));
  //   expect(exp2, expression);
  // });
  // test("Expression.fromJson", () {
  //   Expression expression = Expression.field(ObjectId(), 0, AttrType.string);
  //   final js = expression.toJson();
  //   print("expression: $js");
  //
  //   // expect(js, {
  //   //   "pTypes": [],
  //   //   "calls": [
  //   //     {
  //   //       "type": "Func",
  //   //       "real": {"name": 'none'}
  //   //     }
  //   //   ],
  //   //   'rType': 'objectId'
  //   // });
  //
  //   // / fromJson
  //   expect(Expression.fromJson(js), expression);
  // });
}

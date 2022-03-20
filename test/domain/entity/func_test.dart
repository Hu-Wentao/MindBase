import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';

main() {
  test("Value toJson", () {
    Value value = Value.of(
      "asdf",
      "error",
    );
    print(value.toJson());
    print(value.toJsonWithType());

    expect(value.toJsonWithType(), {
      "type": "Value",
      "real": {"v": "asdf", "e": "error"}
    });
  });

  test("Expression", () {
    Expression expression = Expression.field(AttrType.objectId);
    final js = expression.toJson();
    print("expression: $js");
    expect(js, {
      'pKeys': [],
      "calls": [
        {
          "type": "Func",
          "real": {"name": 'self'}
        }
      ],
      'rType': 'objectId'
    });

    final jsStr = jsonEncode(js);
    print("jsStr: $jsStr");
    final exp2 = Expression.fromJson(jsonDecode(jsStr));
    expect(exp2, expression);
  });
  test("Expression.fromJson", () {
    Expression expression = Expression.field(AttrType.string);
    final js = expression.toJson();
    print("expression: $js");

    // expect(js, {
    //   "pTypes": [],
    //   "calls": [
    //     {
    //       "type": "Func",
    //       "real": {"name": 'none'}
    //     }
    //   ],
    //   'rType': 'objectId'
    // });

    // / fromJson
    expect(Expression.fromJson(js), expression);
  });
}

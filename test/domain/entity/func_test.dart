import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/entity/functor.dart';
import 'package:mind_base/src/domain/value.dart';

main() {
  test("Expression2", () {
    final exp = Expression(
        fn: IFunc.findBy("+"),
        ag: [
          Value.of(1),
          Value.of(2),
        ],
        type: AttrType.num);
    final r = exp.value;
    print("$r");
    expect(r, Value.of(3).value);
  });
  test("Expression2#嵌套2", () {
    final exp = Expression(
        fn: IFunc.findBy("+"),
        ag: [
          Expression(
              fn: IFunc.findBy("*"),
              ag: [
                Value.of(4),
                Value.of(2),
              ],
              type: AttrType.num),
          Value.of(2),
        ],
        type: AttrType.num);
    final r = exp.value;
    print("$r");
    expect(r, Value.of(10).value);
  });
  test("Expression2#嵌套3", () {
    final exp = Expression(
        fn: IFunc.findBy("+"),
        ag: [
          Expression(
              fn: IFunc.findBy("*"),
              ag: [
                Value.of(4),
                Expression(
                    fn: IFunc.findBy("/"),
                    ag: [
                      Value.of(6),
                      Value.of(2),
                    ],
                    type: AttrType.num)
              ],
              type: AttrType.num),
          Expression(
              fn: IFunc.findBy("-"),
              ag: [
                Value.of(2),
                Value.of(4),
              ],
              type: AttrType.num),
        ],
        type: AttrType.num);
    final r = exp.value;
    print("$r");
    expect(r, Value.of(10.0).value);
  });
  test("Expression2#嵌套3", () {
    final exp = Expression(
        fn: IFunc.findBy("+"),
        ag: [
          Expression(
              fn: IFunc.findBy("*"),
              ag: [
                Value.of(4),
                Expression(
                    fn: IFunc.findBy("/"),
                    ag: [
                      Value.of(6),
                      Value.of(2),
                    ],
                    type: AttrType.num)
              ],
              type: AttrType.num),
          Expression(
              fn: IFunc.findBy("-"),
              ag: [
                Value.of(2),
                Value.of(4),
              ],
              type: AttrType.num),
        ],
        type: AttrType.num);
    final r = exp.value;
    print("$r");
    expect(r, Value.of(10.0).value);
  });

  /// Attr_v6 移除
  // test("fMap", () {
  //   final r = Value.of("2").fMap(Func(
  //     name: 'test',
  //     pTypes: [AttrType.string],
  //     rType: AttrType.num,
  //     logic: (v) {
  //       return Expression(FuncManager.findBy("+"), [v[0] as Value, Value.of("3")])
  //           .value as Value;
  //     },
  //   ));
  //   print("#r $r");
  // });
  //
  // test("fMap2", () {
  //   final r = Value.of("2").fMap(Func(
  //     name: 'test',
  //     pTypes: [AttrType.string],
  //     rType: AttrType.num,
  //     logic: (v) {
  //       return Expression(FuncManager.findBy("+"), [v[0] as Value, Value.of("3")])
  //           .value as Value;
  //     },
  //   ));
  //   print("#r $r");
  // });

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

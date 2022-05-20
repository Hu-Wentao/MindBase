import 'package:flutter_test/flutter_test.dart';

class Person {
  final String name;
  final int age;

  const Person(this.name, this.age);
}

class Bag {
  final Map<String, String> main;

  Bag({Map<String,String>? main}):main = main ?? {};
}

main() {
  test("const constructor", () {
    const zs = Person('zs', 18);
    const zs2 = Person('zs', 18);
    const zs3 = Person('zs', 18);
    const r1 = identical(zs, zs2);
    print("$r1");
    const r2 = identical(zs, zs3);
    print("$r2");
    expect(r1, true);
    expect(r2, true);
  });
  test("multi empty map", () {
    final bag1 = Bag();
    final bag2 = Bag();
    bag1.main.addAll({"other": "qsaf"});
    bag2.main.addAll({"other": "qsaf123", "ooo": "qqq"});
    print("bag1:${bag1.main}");
    print("bag2:${bag2.main}");
  });
}

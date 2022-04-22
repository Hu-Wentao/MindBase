import 'package:flutter_test/flutter_test.dart';

class Person {
  final String name;
  final int age;

  const Person(this.name, this.age);
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
}

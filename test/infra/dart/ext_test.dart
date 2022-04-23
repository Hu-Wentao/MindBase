import 'package:flutter_test/flutter_test.dart';

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  test() {
    return StudentX(this).say();
  }
}

extension PersonX on Person {
  String say() => 'Person: $name is $age years old';
}

extension StudentX on Person {
  String say() => 'Student: $name is $age years old';
}

main() {
  test("ext", () {
    final p = Person('John', 20);
    // StudentX(p).say();
    // print(p.test());
    expect(StudentX(p).say(), 'Student: John is 20 years old');
    expect(PersonX(p).say(), 'Person: John is 20 years old');
  });
}

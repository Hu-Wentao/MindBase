import 'package:flutter_test/flutter_test.dart';

class Animal {}

class Human extends Animal {}

class Student extends Human {}

main() {
  test('test', () {
    var student = Student();
    switch (student.runtimeType) {
      case Human:
        print('Human');
        expect(false, true);
        break;
      case Student:
        print('Student');
        expect(true, true);
        break;
      default:
        expect(false, true);
        print('default');
    }
  });
}

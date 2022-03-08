import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_dart/mongo_dart.dart';

main() {
  test('description', () {
    for (var i = 0; i < 10; i++) {
      var id = ObjectId();
      print(id);
    }
  });
}

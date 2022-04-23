import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_dart/mongo_dart.dart';

main() {
  test('generate 10', () {
    for (var i = 0; i < 10; i++) {
      var id = ObjectId();
      print(id);
    }
  });
  test("parse",(){
    var id = ObjectId.parse("6263e7f954e9180e6b21b592");
    print(id);

  });
}

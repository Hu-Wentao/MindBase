import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/space/domain/value/value.dart';

main() {
  group("table view", () {
    test("update index", () {
      final ts = [
        TableView.builder(vId: 1),
        TableView.builder(vId: 2),
        TableView.builder(vId: 4),
      ];
      final t = TableView.builder(type: ViewType.sheet, cols: []);
      final t2 = t.updateIndex(ts);
      expect(t2.vId, 5);
    });
  });
}

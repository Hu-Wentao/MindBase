import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/workspace/domain/value/value.dart';

main() {
  group("table view", () {
    test("update index", () {
      final ts = [
        TableView.builder(index: 1),
        TableView.builder(index: 2),
        TableView.builder(index: 4),
      ];
      final t = TableView.builder(type: ViewType.sheet, cols: []);
      final t2 = t.updateIndex(ts);
      expect(t2.index, 5);
    });
  });
}

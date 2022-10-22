import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/space/infra/dao/realtime_hub.dart';

main() {
  test("test SubChannel", () {
    final set1 = {
      SubChannel.collection('123'),
      SubChannel.collection('123'),
      SubChannel.collection('1223'),
    };
    final set2 = {
      SubChannel.collection('123'),
      SubChannel.collection('123'),
      SubChannel.collection('1223'),
    };
    final set3 = {
      SubChannel.collection('123'),
      SubChannel.collection('1223'),
      SubChannel.collection('123'),
    };
    // expect(set1 == set2, false, reason: "两个集合==不可以比较");
    // expect(set1.difference(set2), false, reason: "两个集合==不可以比较");
    // expect(set1.difference(set2), false, reason: "两个集合==不可以比较");
    final set4 = {
      SubChannel.collection('1223'),
      SubChannel.collection('123'),
    };
    final set5 = {
      SubChannel.collection('123'),
      SubChannel.collection('1223'),
    };
    final set6 = {
      SubChannel.collection('123a'),
      SubChannel.collection('1223'),
    };
    final set7 = {
      SubChannel.collection('123'),
      SubChannel.collection('123a'),
      SubChannel.collection('1223'),
    };
    print(set1.difference(set4));
    print(set4.difference(set1));
    // expect(set1==set4 , )

    expect(_judgeDiff(set1, set2), true);
    expect(_judgeDiff(set1, set3), true);
    expect(_judgeDiff(set1, set4), true);
    expect(_judgeDiff(set1, set5), true);
    expect(_judgeDiff(set1, set6), false);
    expect(_judgeDiff(set1, set7), false);
  });
}

_judgeDiff<T>(Set<T> set1, Set<T> set2) {
  return set1.union(set2).length == set1.length;
}

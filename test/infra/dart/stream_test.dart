import 'package:flutter_test/flutter_test.dart';

main() async {
  test("stream", () {
    var stream = Stream<int>.fromIterable([1, 2, 3]);

    stream
        .asyncExpand<String>((x) => Stream<String>.fromIterable([
              for (var i = 0; i < x; i++) "x# $x - $i",
            ]))
        .listen(print);
  });
  await Future.delayed(const Duration(seconds: 1));
  print("done");
}

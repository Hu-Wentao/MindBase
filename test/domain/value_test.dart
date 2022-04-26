import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/value.dart';

main() {
  group("AttrType", () {
    const pTypeStr = AttrType.string;
    const pTypeTpRef = "62675acbd53ccfe2d07ceb63";
    const pTypeTpName = "type_$pTypeTpRef";
    const pTypeType = AttrType.ref(pTypeTpRef);

    test("name", () {
      expect(pTypeStr.name, "string");
      expect(pTypeType.name, pTypeTpName);
    });

    test("tpName", () {
      expect(pTypeStr.tpName, "string");
      expect(pTypeType.tpName, "type");
    });

    test("by", () {
      expect(AttrType.by(pTypeTpName), pTypeType);
      expect(AttrType.by("string"), pTypeStr);
    });
  });
}

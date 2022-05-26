import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/inter/i_dto.dart';

main() {
  group("AttrType", () {
    const pTypeStr = AttrTypeDto.string;
    const pTypeTpRef = "62675acbd53ccfe2d07ceb63";
    const pTypeTpName = "type_$pTypeTpRef";
    const pTypeType = AttrTypeDto.ref(pTypeTpRef);

    test("name", () {
      expect(pTypeStr.name, "string");
      expect(pTypeType.name, pTypeTpName);
    });

    test("tpName", () {
      expect(pTypeStr.tpName, "string");
      expect(pTypeType.tpName, "type");
    });

    test("by", () {
      expect(AttrTypeDto.by(pTypeTpName), pTypeType);
      expect(AttrTypeDto.by("string"), pTypeStr);
    });
  });
}

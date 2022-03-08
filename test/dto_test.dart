import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

main() {
  test("RecordDto", () {
    final dto = RecordDto(
        ObjectId.fromHexString('62275a65418db3d74941d6b3').toHexString(),
        ObjectId.fromHexString('62275a65418db3d74941d6b4').toHexString(), [
      Field.of(1, '123'),
      Field.of(2, 'aaa'),
      Field.of(3, 'ccc'),
    ]);

    final js = dto.toJson();

    print(js);
    expect(js, {
      "id": "62275a65418db3d74941d6b3",
      "metaId": "62275a65418db3d74941d6b4",
      "1": {"v": "123", "e": null},
      "2": {"v": "aaa", 'e': null},
      "3": {'v': 'ccc', 'e': null}
    });

    final dto2 = RecordDto.fromJson(js);
    print(dto2);
    expect(dto2.toJson(), {
      "id": "62275a65418db3d74941d6b3",
      "metaId": "62275a65418db3d74941d6b4",
      "1": {"v": "123", "e": null},
      "2": {"v": "aaa", 'e': null},
      "3": {'v': 'ccc', 'e': null}
    });
  });
}

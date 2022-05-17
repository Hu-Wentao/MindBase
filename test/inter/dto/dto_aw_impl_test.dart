import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/infra/dto/dto_aw_impl.dart';
import 'package:mind_base/src/interface/i_dto.dart';

main() {
  test('test RecordMetaDto', () {
    final meta =
        RecordMetaDto(id: 'asdf', name: 'name', memo: 'memo', maxKey: 3,
        attrs: [
          AttributeDto(k: 1, name: 'name', memo: 'memo', type: AttrTypeDto.num),
          AttributeDto(k: 1, name: 'name', memo: 'memo', type: const AttrTypeDto.ref('123123')),
        ],
        methods: [
          // MethodDto(k: 1, name: 'name', memo: 'memo', ),
        ]);
    final metaJson = RecordMetaDtoAppwriteX(meta).toJson();
    print("metaJson = $metaJson");
    // print("metaJson.attrs = ${metaJson['attrs'].runtimeType}");

    final meta2 = RecordMetaDtoAppwriteX.fromJson(metaJson);
    print("meta2 = $meta2");
    final meta2json = RecordMetaDtoAppwriteX(meta2).toJson();
    print("meta2json = $meta2json");
    expect(meta2json, metaJson);
  });
}

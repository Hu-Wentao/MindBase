import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base/src/application/expression_parser.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart' hide Expression;
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/expression_dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

main() {
  test("expr", () {
    final ws = WorkspaceDataHolder();
    ws.setMeta(RecordMeta(
        id: ObjectId(),
        name: '学生表',
        memo: '记录一个学生的信息',
        maxKey: 2,
        attrs: const [
          Attribute(k: 0, name: 'id', memo: 'memo', type: AttrType.objectId),
          Attribute(
              k: 1, name: 'metaId', memo: 'memo', type: AttrType.objectId),
          Attribute(k: 2, name: 'name', memo: '学生名称', type: AttrType.string),
          Attribute(k: 3, name: 'age', memo: '学生年龄', type: AttrType.string),
        ],
        methods: const [
          Method(k: 0, name: 'getName', memo: 'memo', expr: "this.name"),
          // expr: Expression(FuncManager.findBy('self'), [Value('1', null)]))
        ]));

    ExpressionParser parser = ExpressionParser();

    ExpressionDto dto =
        ExpressionDto.of(parser, "'My name is'+ person.name +'!'");
    print(dto.toReadableString());
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:get_arch_core/get_arch_core_interface.dart' hide test;
import 'package:mind_base/src/application/expression_evaluator.dart';
import 'package:mind_base/src/application/expression_parser.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart' hide Expression;
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/expression_dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

main() {
  test("expr", () {
    final meta = RecordMeta(
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
          Method(k: 0, name: 'say', memo: 'memo', expr: "'stu say: ' +'2'"),
          // expr: Expression(FuncManager.findBy('self'), [Value('1', null)]))
        ]);
    final rcd = Record(
      id: ObjectId(),
      meta: meta,
      fields: {
        0: Value.of(ObjectId().toHexString()),
        1: Value.of(meta.id.toHexString()),
        2: Value.of("张三"),
        3: Value.of("20")
      },
      methods: meta.methodMap,
    );
    final ws = WorkspaceDataHolder();
    GetIt.I.registerSingleton<WorkspaceDataHolder>(ws);
    ws.setMeta(meta);

    ws.setRecord(rcd);

    ExpressionParser parser = ExpressionParser();
    final evaluator = ExpressionEvaluator(memberAccessors: [
      RecordMemberAccessor(ws),
    ]);

    ExpressionDto dto = ExpressionDto.of(parser,
        "'My name is'+ person.say() +'!'"); // fixme 访问方法失败,可能是say()的返回值类型是Value导致的
    // ExpressionDto.of(parser, "'My name is'+ person.name +'!'");
    // print(dto.toReadableString());
    print(evaluator.eval(dto, {"person": rcd}));
  });
}

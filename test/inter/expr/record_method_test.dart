// import 'package:flutter_test/flutter_test.dart';
// import 'package:get_arch_core/get_arch_core.dart' hide test;
// import 'package:mind_base/src/domain/aggregate/aggregate.dart';
// import 'package:mind_base/src/domain/entity/entity.dart';
// import 'package:mind_base/src/domain/value/value.dart';
//
// main() {
//   test("测试方法访问属性", () {
//     final meta = RecordMeta(
//         id: ObjectIdX.createHex,
//         name: '学生表',
//         memo: '记录一个学生的信息',
//         maxKey: 2,
//         attrs: const [
//           Attribute(k: 0, name: 'id', memo: 'memo', type: AttrType.string),
//           Attribute(k: 1, name: 'metaId', memo: 'memo', type: AttrType.string),
//           Attribute(k: 2, name: 'name', memo: '学生名称', type: AttrType.string),
//           Attribute(k: 3, name: 'age', memo: '学生年龄', type: AttrType.string),
//           Attribute(k: 4, name: '备注', memo: '备注信息', type: AttrType.string),
//         ],
//         methods: [
//           Method(
//               k: 0,
//               name: 'getName',
//               memo: 'memo2',
//               expr: Expression(
//                   fn: IFunc.findBy("member"),
//                   ag: [
//                     Value.of("a2"), // 表示attribute 0
//                   ],
//                   type: AttrType.string)),
//           Method(
//               k: 1,
//               name: 'sayHello',
//               memo: 'memo',
//               // ("'Hello every one! My name is'+this.name")
//               expr: Expression(
//                   fn: IFunc.findBy("add"),
//                   ag: [
//                     Value.of("Hello everyone! My name is "),
//                     Expression(
//                         fn: IFunc.findBy("member"),
//                         ag: [
//                           Value.of("a2"), // 填入 propId
//                         ],
//                         type: AttrType.string),
//                   ],
//                   type: AttrType.string)),
//         ]);
//     final rcd = Record(
//       id: ObjectIdX.createHex,
//       meta: meta,
//       fields: {
//         0: Value.of(ObjectIdX.createHex),
//         1: Value.of(meta.id),
//         2: Value.of("张三"),
//         3: Value.of("20"),
//         4: Value.of("asdf")
//       },
//     );
//     final ws = WorkspaceDataHolder();
//     GetIt.I.registerSingleton<WorkspaceDataHolder>(ws);
//     ws.updateMeta(meta);
//
//     ws.insertRecord(rcd);
//
//     print("methods ${rcd.methods}");
//     final mth1 = rcd.methods.firstWhere((element) => element.k == 1);
//     print("methods#1 # $mth1");
//
//     final r = rcd.getValueBy(rcd.methods.first);
//     print('r: ${r.value}');
//     expect(r.value, "张三");
//
//     final r2 = rcd.getValueBy(mth1);
//     print('r: ${r2.value}');
//     expect(r2.value, "Hello everyone! My name is 张三");
//   });
// }

// import 'dart:convert';
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mind_base/src/domain/entity/entity.dart';
// import 'package:mind_base/src/inter/i_dto.dart';
//
// main() {
//   group("RecordDto", () {
//     const pMetaId = ("62314b932f929ede7dfebc8f");
//     const pRecordId = ("6232ae5d5c918fa41061f449");
//     final pRcdMgJs = {
//       "_id": pRecordId,
//       "metaId": pMetaId,
//       "0": {
//         "fn": "asString",
//         "ag": [jsonEncode(pRecordId)]
//       },
//       "1": {
//         "fn": "asString",
//         "ag": [jsonEncode(pMetaId)]
//       },
//       "2": {
//         "fn": "asString",
//         "ag": [jsonEncode("asdf")]
//       },
//     };
//     final pRcdDto = RecordDto(fields: {
//       0: Value.of(pRecordId),
//       1: Value.of(pMetaId),
//       2: Value.of("asdf"),
//     });
//
//     final pRcdJs = {
//       "_id": pRecordId,
//       "metaId": pMetaId,
//       "0": {
//         "fn": "asString",
//         "ag": [jsonEncode(pRecordId)]
//       },
//       "1": {
//         "fn": "asString",
//         "ag": [jsonEncode(pMetaId)]
//       },
//       "2": {
//         "fn": "asString",
//         "ag": [jsonEncode("asdf")]
//       },
//     };
//     test("RecordDto fromMongoJson", () {
//       // fromMongoJson会修改数据, 因此同一个map只能传入1次
//       final dto = RecordDto.fromMongoJson(pRcdMgJs);
//       print(dto);
//       expect(dto, pRcdDto);
//     });
//
//     test("RecordDto toMongoJson", () {
//       final mgJs = pRcdDto.toMongoJson();
//       // print("mgJs: $mgJs");
//       // print("pRcdMgJs: $pRcdMgJs");
//       expect(mgJs, pRcdMgJs);
//     });
//     test("RecordDto fromJson", () {
//       final dto2 = RecordDto.fromJson(pRcdJs);
//       print(dto2);
//       expect(dto2.toJson(), pRcdJs);
//     });
//     test("RecordDto toJson", () {
//       final js = pRcdDto.toJson();
//       final jsStr = json.encode(js);
//       print(jsStr);
//       expect(js, pRcdJs);
//     });
//     test("RecordDto builder", () {
//       final dto = RecordDto.builder(metaId: pMetaId);
//       print("dto: $dto");
//       print("${dto.id}");
//     });
//   });
//
//   test("AttributeDto builder", () {
//     AttributeDto dto = AttributeDto.builder(
//       k: 0,
//       name: "ID",
//       memo: "系统生成的唯一ID",
//       // calc: Expression.field(null, 0, AttrType.num),
//       // expr: Expression.field(AttrType.objectId),
//     );
//     print("dto: $dto");
//   });
//   test("MetaDto json", () {
//     // todo test
//     final dto = MetaDto.builder(
//       // id: ('62275a65418db3d74941d6b3'),
//       id: "62275a65418db3d74941d6b3",
//       // metaId: ('62275a65418db3d74941d6b4'),
//       attributes: [],
//       // {
//       //   // 0: Value.of('62275a65418db3d74941d6b3'), // id
//       //   // 1: Value.of('62275a65418db3d74941d6b4'), // meta
//       //   2: Value.of('aaa'),
//       //   3: Value.of('ccc'),
//       // }
//     );
//
//     final js = dto.toJson();
//     final jsStr = json.encode(js);
//     print(jsStr);
//     expect(js, {
//       '0': {'v': '62275a65418db3d74941d6b3', 'e': null},
//       '1': {'v': '62275a65418db3d74941d6b4', 'e': null},
//       '2': {'v': 'aaa', 'e': null},
//       '3': {'v': 'ccc', 'e': null},
//       '_id': '62275a65418db3d74941d6b3',
//     });
//
//     final js2 = json.decode(jsStr);
//     final dto2 = RecordDto.fromJson(js2);
//     print(dto2);
//     expect(dto2.toJson(), {
//       "0": {"v": "62275a65418db3d74941d6b3", "e": null},
//       "1": {"v": "62275a65418db3d74941d6b4", "e": null},
//       "2": {"v": "aaa", 'e': null},
//       "3": {'v': 'ccc', 'e': null},
//       "_id": "62275a65418db3d74941d6b3",
//     });
//   });
//
//   group("MetaDto Group", () {
//     final list = [
//       MetaDto.builder(),
//       MetaDto.builder(methods: [
//         MethodDto.builder(
//             expr: ExprJsonDto(
//           fn: "add",
//           ag: [
//             ValueJsonDto(fn: "asint", ag: ["1"]),
//             ValueJsonDto(fn: "asint", ag: ["2"]),
//           ],
//           type: AttrTypeDto.num,
//         )),
//       ]),
//     ];
//     for (var dto in list) {
//       test("MetaDto json", () {
//         final js = dto.toJson();
//         print("dto: $js");
//         final dto2 = MetaDto.fromJson(js);
//         // print("dto2: ${dto2.toJson()}");
//         expect(dto, dto2);
//       });
//     }
//   });
// }

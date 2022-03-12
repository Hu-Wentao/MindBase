// // repo 是对与聚合根而言的
//
// import 'package:get_arch_core/get_arch_core.dart';
// import 'package:mind_base/src/infra/mongo_storage.dart';
// import 'package:mind_base/src/interface/dto.dart';
// import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
// import 'package:mongo_dart/mongo_dart.dart' as mg;
//
// import 'aggregate.dart';
//
// ///
// /// 简单的Repo实现, 只能读取, 无法save聚合根
// class RecordRepo {
//   final IMongoStorage mongoStorage;
//
//   RecordRepo(this.mongoStorage);
//
//   Future<Record> find(ObjectId id) async =>
//       await mongoStorage.withSyncAsync((sync) async {
//         RecordDto rcdDto = (await RecordAccessor(sync).findById(id))!;
//         RecordMetaDto metaDto = (await RecordMetaAccessor(sync).findById(id))!;
//         return rcdDto.toDomain(metaDto.toDomain(
//           metaDto.attributes
//               .map((e) => e.toDomain(
//                     input: e.inputFuncId,
//                     check: e.checkFuncId,
//                     output: e.outputFuncId,
//                   ))
//               .toList(),
//         ));
//       });
// }

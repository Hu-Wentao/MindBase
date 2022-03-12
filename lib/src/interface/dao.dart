import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId, where, Db;

abstract class IMongoAccessor<T extends IMongoEntityDto> {
  String get collectionName;

  Future<T?> findById(ObjectId id);
}

class RecordAccessor extends IMongoAccessor<RecordDto> {
  RecordAccessor(this.db);

  @override
  String get collectionName => 'record';
  final Db db;

  @override
  Future<RecordDto?> findById(ObjectId id) => db
      .collection(collectionName)
      .findOne(where.id(id))
      .then((value) => value == null ? null : RecordDto.fromMongoJson(value));

  Future<List<RecordDto>> findAllByMetaId(ObjectId metaId) => db
      .collection(collectionName)
      .find(where.eq('metaId', metaId))
      .map((event) => RecordDto.fromMongoJson(event))
      .toList();

  Stream<RecordDto> watchAllByMetaId(ObjectId metaId) => db
      .collection(collectionName)
      .watch(where.eq('metaId', metaId))
      .map((event) => RecordDto.fromMongoJson(event));
}

/// 即Schema
class RecordMetaAccessor extends IMongoAccessor<RecordMetaDto> {
  RecordMetaAccessor(this.db);

  @override
  String get collectionName => 'record_meta';
  final Db db;

  @override
  Future<RecordMetaDto?> findById(ObjectId id) =>
      db.collection(collectionName).findOne(where.id(id)).then(
          (value) => value == null ? null : RecordMetaDto.fromMongoJson(value));

  Stream<RecordMetaDto> watchById(ObjectId id) => db
      .collection(collectionName)
      .watch(where.id(id))
      .where((event) => event != null)
      .map((value) => RecordMetaDto.fromMongoJson(value));
}

// class BaseFuncAccessor extends IMongoAccessor<FuncWrap> {
//   BaseFuncAccessor(this.db);
//
//   @override
//   String get collectionName => 'func';
//   final Db db;
//
//   @override
//   Future<FuncWrap?> findById(ObjectId id) => db
//       .collection(collectionName)
//       .findOne(where.id(id))
//       .then((value) => value == null ? null : FuncWrap.fromMongoJson(value));
// }

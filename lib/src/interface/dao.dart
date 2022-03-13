import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart'
    show ObjectId, where, Db, WriteResult;

abstract class IMongoAccessor<T extends IMongoEntityDto> {
  Db get db;

  String get collectionName;

  Future<T?> findById(ObjectId id);

  /// 当ObjectId已存在时,更新无效
  Future<WriteResult> insert(T dto) async =>
      await db.collection(collectionName).insertOne(dto.toMongoDto());

  // Future<WriteResult> replace(T dto);
  Future<WriteResult> replace(T dto) async => await db
      .collection(collectionName)
      .replaceOne(where.id(dto.id), dto.toMongoDto());
// Future<T> replace(T dto);
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

// @override
// Future<void> insert(RecordDto dto) async =>
//     await db.collection(collectionName).insertOne(dto.toMongoDto());

// @override
// Future<WriteResult> replace(RecordDto dto) async => await db
//     .collection(collectionName)
//     .replaceOne(where.id(dto.id), dto.toMongoDto());
// .then((value) =>
//     RecordDto.fromMongoJson(value.document as Map<String, dynamic>));
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

// @override
// Future<void> insert(RecordMetaDto dto) async =>
//     await db.collection(collectionName).insertOne(dto.toMongoDto());

// @override
// Future<WriteResult> replace(RecordMetaDto dto) async => await db
//     .collection(collectionName)
//     .replaceOne(where.id(dto.id), dto.toMongoDto());
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

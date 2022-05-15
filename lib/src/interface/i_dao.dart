import 'package:appwrite/models.dart';
import 'package:mind_base/src/interface/i_dto.dart';

enum WatchEventType {
  insert, // 元素插入
  delete, // 某个元素被移除 - 只返回id
  replace, // 某个元素被替换 - 返回新的完整对象
  update, // 某个元素被更新
  drop,
  rename,
  dropDatabase,
  invalidate,
}

// watchEventOf<T extends IEntityDto>(
//   RealtimeMessage _changeEvent,
//   T? Function(Map<String, Object?>? mgJson) mongoJsonToDtoOr,
// ) =>
//     WatchEvent<T>(
//       WatchEventType.values.asNameMap()[_changeEvent.operationType]!,
//       (_changeEvent.serverResponse['documentKey']
//           as Map<String, dynamic>)['_id'] as ObjectId,
//       mongoJsonToDtoOr(_changeEvent.fullDocument),
//     );

abstract class IAccessor<T extends IEntityDto> {
  String get collectionId;

  T jsonToDto(Map<String, dynamic> mgJson);

  T? jsonToDtoOr(Map<String, Object?>? mgJson);

  Future<T?> findById(String id);

  Stream<T> findAll();

  // Stream<WatchEvent<T>> watchById(String id);

  Future<Document> insert(T dto);

  Future<Document> replace(T dto);

  /// 删除记录
  Future deleteBy(String id);

// /// 删除表
// Future<bool> drop();
}

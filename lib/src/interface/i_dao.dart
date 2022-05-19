import 'package:get_arch_core/get_arch_core.dart';

// enum WatchEventType {
//   insert, // 元素插入
//   delete, // 某个元素被移除 - 只返回id
//   replace, // 某个元素被替换 - 返回新的完整对象
//   update, // 某个元素被更新
//   drop,
//   rename,
//   dropDatabase,
//   invalidate,
// }

abstract class IAccessor<T extends IDto> {
  T jsonToDto(Map<String, dynamic> mgJson);

  T? jsonToDtoOr(Map<String, Object?>? mgJson);

  Map<String, dynamic> dtoToJson(T dto);

  Future<T?> findById(String id);

  Stream<T> findAll();

  // Stream<WatchEvent<T>> watchById(String id);

  Future insert(T dto);

  Future update(T dto);

  Future replace(T dto);

  /// 删除记录
  Future deleteBy(String id);

  /// 删除表
  Future<bool> drop();
}

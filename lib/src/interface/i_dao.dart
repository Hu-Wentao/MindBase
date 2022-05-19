import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/value/event.dart';


enum DatabaseEventTp {
  insert, // 元素插入
  delete, // 某个元素被移除 - 只返回id
  replace, // 某个元素被替换 - 返回新的完整对象
  update, // 某个元素被更新
  // drop, // 所监听的集合被删除
}

class DatabaseEvent implements Event {
  final DatabaseEventTp type;
  final String ettId;
  final String collectionId;

  final Map<String, dynamic> data;

  const DatabaseEvent(
      this.type,
      this.ettId,
      this.collectionId,
      this.data,
      );

  DatabaseEvent.insert(this.ettId, this.collectionId, this.data)
      : type = DatabaseEventTp.insert;

  DatabaseEvent.delete(this.ettId, this.collectionId, this.data)
      : type = DatabaseEventTp.delete;

  DatabaseEvent.replace(this.ettId, this.collectionId, this.data)
      : type = DatabaseEventTp.replace;

  DatabaseEvent.update(this.ettId, this.collectionId, this.data)
      : type = DatabaseEventTp.update;
}


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

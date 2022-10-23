import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/space/domain/value/event.dart';

enum AccessorEvtTp {
  insert, // 元素插入
  delete, // 某个元素被移除 - 只返回id
  replace, // 某个元素被替换 - 返回新的完整对象
  update, // 某个元素被更新
  // drop, // 所监听的集合被删除
}

class AccessorEvt<T> implements Event {
  final AccessorEvtTp type;
  final String ettId;
  final String collectionId;

  final T? dto; // 删除事件可以为null

  const AccessorEvt(
    this.type,
    this.ettId,
    this.collectionId,
    this.dto,
  );

  AccessorEvt.insert(this.ettId, this.collectionId, this.dto)
      : type = AccessorEvtTp.insert;

  AccessorEvt.delete(this.ettId, this.collectionId, this.dto)
      : type = AccessorEvtTp.delete;

  AccessorEvt.replace(this.ettId, this.collectionId, this.dto)
      : type = AccessorEvtTp.replace;

  AccessorEvt.update(this.ettId, this.collectionId, this.dto)
      : type = AccessorEvtTp.update;

  @override
  String toString() => 'AccessorEvt{[$T] type: $type, ettId: $ettId, collectionId: $collectionId, dto: $dto}';
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

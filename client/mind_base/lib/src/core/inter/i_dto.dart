import 'package:dart_appwrite/models.dart' as md;
import 'package:get_arch_core/get_arch_core.dart';

/// 实体类对应的Dto需要实现本类, 并添加`_id`字段/get方法
abstract class IEntityDto extends IDto {
  const IEntityDto();

  String get id;

  // 避免IDto的toString调用toDto导致报错
  @override
  String toString() => "IDto[$runtimeType]toString";

  @override
  Map<String, dynamic> toMap() => toJson();

  toJson();
}

typedef Collection = md.Collection;
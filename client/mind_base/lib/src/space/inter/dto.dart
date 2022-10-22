import 'package:get_arch_core/get_arch_core_interface.dart';

class SpaceDto extends IDto {
  @override
  String id;
  String name;
  String teamId;
  @Deprecated("meta列表不存在这里，而是通过查询得到，考虑改为关联meta的数量")
  List<String> metas;

  SpaceDto({
    required this.id,
    required this.teamId,
    required this.name,
    required this.metas,
  });

  SpaceDto.builder({
    this.id = '',
    this.teamId = '',
    this.name = '',
    this.metas = const [],
  });


  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError("使用[$runtimeType]相关Extension的方法");
  }
}

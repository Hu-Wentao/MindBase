// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'i_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SpaceDto _$$_SpaceDtoFromJson(Map<String, dynamic> json) => _$_SpaceDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      teamId: json['teamId'] as String? ?? '',
      metas:
          (json['metas'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$_SpaceDtoToJson(_$_SpaceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'teamId': instance.teamId,
      'metas': instance.metas,
    };

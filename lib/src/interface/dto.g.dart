// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordMetaDto _$RecordMetaDtoFromJson(Map<String, dynamic> json) =>
    RecordMetaDto(
      json['id'] as String,
      json['name'] as String,
      json['memo'] as String,
      json['maxKey'] as int,
      (json['attributes'] as List<dynamic>)
          .map((e) => AttributeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecordMetaDtoToJson(RecordMetaDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'memo': instance.memo,
      'maxKey': instance.maxKey,
      'attributes': instance.attributes,
    };

AttributeDto _$AttributeDtoFromJson(Map<String, dynamic> json) => AttributeDto(
      json['k'] as int,
      json['name'] as String,
      json['memo'] as String,
      $enumDecode(_$AttrTypeEnumMap, json['type']),
      json['inputFuncId'] as String,
      json['checkFuncId'] as String,
      json['outputFuncId'] as String,
    );

Map<String, dynamic> _$AttributeDtoToJson(AttributeDto instance) =>
    <String, dynamic>{
      'k': instance.k,
      'name': instance.name,
      'memo': instance.memo,
      'type': _$AttrTypeEnumMap[instance.type],
      'inputFuncId': instance.inputFuncId,
      'checkFuncId': instance.checkFuncId,
      'outputFuncId': instance.outputFuncId,
    };

const _$AttrTypeEnumMap = {
  AttrType.any: 'any',
  AttrType.string: 'string',
  AttrType.number: 'number',
  AttrType.bool: 'bool',
  AttrType.date: 'date',
};

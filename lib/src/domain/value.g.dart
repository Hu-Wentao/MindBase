// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Field _$FieldFromJson(Map<String, dynamic> json) => Field(
      json['k'] as int,
      json['v'] as String,
      json['e'] as String?,
    );

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'k': instance.k,
      'v': instance.v,
      'e': instance.e,
    };

Range _$RangeFromJson(Map<String, dynamic> json) => Range(
      json['min'] as int,
      json['max'] as int,
    );

Map<String, dynamic> _$RangeToJson(Range instance) => <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };

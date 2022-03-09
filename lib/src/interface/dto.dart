import 'package:get_arch_core/get_arch_core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

part 'dto.g.dart';

// extension ObjectIdDto on ObjectId {
//   Map<String, dynamic> toJson() => {r"$oid": toHexString()};
// }

class RecordDto implements IDto {
// @JsonKey(name: "_id")
  final ObjectId id;
  final ObjectId metaId;
  final Map<int, Field> fields;

  RecordDto(this.id, this.metaId, this.fields);

  factory RecordDto.fromDomain(
    ObjectId id,
    ObjectId metaId,
    Map<int, Field> fields,
  ) =>
      RecordDto(id, metaId, fields);

// {id: 6227568dda2194cb3589f5d4, metaId: 6227568dda2194cb3589f5d5, 1: {v: 123, e: null}, 2: {v: aaa, e: null}}
  factory RecordDto.fromJson(Map<String, dynamic> json) => RecordDto(
          ObjectId.fromHexString(json.remove('_id')),
          ObjectId.fromHexString(json.remove('metaId')), json.map((key, value) {
        final js2 = (value as Map<String, dynamic>); // 动态字段
        return MapEntry(
            int.parse(key),
            Field(
              js2['v'] as String,
              js2['e'] as String?,
            ));
      }));

  @override
  Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
        "metaId": metaId.toJson(),
      }..addEntries(fields.entries
          .map((e) => MapEntry(e.key.toString(), e.value.toJson())));

  @override
  String toString() => toJson().toString();
}

/// 表头属性
@JsonSerializable()
class RecordMetaDto {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  @JsonKey()
  final String memo;
  @JsonKey()
  final int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
  @JsonKey()
  final List<AttributeDto> attributes;

  RecordMetaDto(this.id, this.name, this.memo, this.maxKey, this.attributes);

  factory RecordMetaDto.fromDomain(
    ObjectId id,
    String name,
    String memo,
    int maxKey,
    List<AttributeDto> attributes,
  ) =>
      RecordMetaDto(id.toString(), name, memo, maxKey, attributes);

  factory RecordMetaDto.fromJson(Map<String, dynamic> json) =>
      _$RecordMetaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RecordMetaDtoToJson(this);
}

/// 表头/属性: 关系/表的一列叫属性
@JsonSerializable()
class AttributeDto {
  @JsonKey()
  final int k; // 表头key,对应Field:k,需要从所在的TableMeat中获取
  @JsonKey()
  final String name; // 表头名称
  @JsonKey()
  final String memo; // 表头备注
  @JsonKey()
  final AttrType type;

  @JsonKey()
  final String inputFuncId;
  @JsonKey()
  final String checkFuncId;
  @JsonKey()
  final String outputFuncId;

  AttributeDto(this.k, this.name, this.memo, this.type, this.inputFuncId,
      this.checkFuncId, this.outputFuncId);

  factory AttributeDto.fromJson(Map<String, dynamic> json) =>
      _$AttributeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeDtoToJson(this);
}

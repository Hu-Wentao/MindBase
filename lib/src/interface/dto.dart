import 'package:json_annotation/json_annotation.dart';
import 'package:mind_base/src/domain/domain.dart';

part 'dto.g.dart';

@JsonSerializable()
class TupleDto {
  @JsonKey() // todo 检查是否覆盖了默认的 _id 属性
  final String id;
  @JsonKey()
  final String metaId;
  @JsonKey()
  final List<Field> fields;

  TupleDto(this.id, this.metaId, this.fields);

  factory TupleDto.fromJson(Map<String, dynamic> json) =>
      _$TupleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TupleDtoToJson(this);
}

/// 表头属性
@JsonSerializable()
class TupleMetaDto {
  @JsonKey()
  final String id;
  @JsonKey()
  final String name;
  @JsonKey()
  final String memo;
  @JsonKey()
  final int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
  @JsonKey()
  final List<AttributeDto> attributes;

  TupleMetaDto(
      this.id, this.name, this.memo, this.maxKey, this.attributes); // 表头
  factory TupleMetaDto.fromJson(Map<String, dynamic> json) =>
      _$TupleMetaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TupleMetaDtoToJson(this);
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

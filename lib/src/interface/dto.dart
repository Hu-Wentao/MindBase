import 'package:get_arch_core/get_arch_core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

// extension ObjectIdDto on ObjectId {
//   Map<String, dynamic> toJson() => {r"$oid": toHexString()};
// }
/// 实体类对应的Dto需要实现本类, 并添加`_id`字段/get方法
abstract class IMongoEntityDto implements IMongoDto {
  ObjectId get _id;
}

/// 普通的携带有ObjectId字段的Dto需要实现本类
abstract class IMongoDto implements IDto {
  // 返回的结果与json的Map相似,但 id是 ObjectId类型,而不是String
  Map<String, dynamic> toMongoDto();
}

class RecordDto implements IDto, IMongoEntityDto {
  @override
  ObjectId get _id => id;
  final ObjectId id;
  final ObjectId metaId;
  final Map<int, Field> fields;

  RecordDto(this.id, this.metaId, this.fields);

  factory RecordDto.fromDomain(Record record) =>
      RecordDto(record.id, record.meta.id, record.fields);

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
        "_id": _id.toJson(),
        "metaId": metaId.toJson(),
      }..addEntries(fields.entries
          .map((e) => MapEntry(e.key.toString(), e.value.toJson())));

  factory RecordDto.fromMongoJson(Map<String, dynamic> json) => RecordDto(
          (json.remove('_id') as ObjectId), (json.remove('metaId') as ObjectId),
          json.map((key, value) {
        final js2 = (value as Map<String, dynamic>); // 动态字段
        return MapEntry(
            int.parse(key),
            Field(
              js2['v'] as String,
              js2['e'] as String?,
            ));
      }));

  // 适配 MongoDart的ObjectId
  @override
  Map<String, dynamic> toMongoDto() => toJson()
    ..['_id'] = _id
    ..['metaId'] = metaId;

  @override
  String toString() => toJson().toString();

  Record toDomain(RecordMeta m) => Record(
        id: id,
        meta: m,
        fields: fields,
      );
}

/// 表头属性
class RecordMetaDto with IMongoEntityDto {
  @override
  ObjectId get _id => id;
  final ObjectId id;
  final String name;
  final String memo;
  final int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
  final List<AttributeDto> attributes;

  RecordMetaDto({
    required this.id,
    required this.name,
    required this.memo,
    required this.maxKey,
    required this.attributes,
  });

  factory RecordMetaDto.fromDomain(RecordMeta meta) => RecordMetaDto(
      id: meta.id,
      name: meta.name,
      memo: meta.memo,
      maxKey: meta.maxKey,
      attributes: meta.attributes.map((e) => e.toDto()).toList());

  factory RecordMetaDto.fromJson(Map<String, dynamic> json) => RecordMetaDto(
        id: ObjectId.fromHexString(json['_id'] as String),
        name: json['name'] as String,
        memo: json['memo'] as String,
        maxKey: json['maxKey'] as int,
        attributes: (json['attributes'] as List<dynamic>)
            .map((e) => AttributeDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  Map<String, dynamic> toJson() => {
        '_id': _id.toHexString(),
        'name': name,
        'memo': memo,
        'maxKey': maxKey,
        'attributes': attributes.map((e) => e.toJson()).toList(),
      };

  RecordMetaDto.fromMongoJson(Map<String, dynamic> mJs)
      : this(
          id: mJs['_id'] as ObjectId,
          name: mJs['name'] as String,
          memo: mJs['memo'] as String,
          maxKey: mJs['maxKey'] as int,
          attributes: (mJs['attributes'] as List<dynamic>)
              .map((e) => AttributeDto.fromMongoJson(e as Map<String, dynamic>))
              .toList(),
        );

  @override
  Map<String, dynamic> toMongoDto() => toJson()..['_id'] = _id;

  RecordMeta toDomain(List<Attribute> attrs) => RecordMeta(
        id: id,
        name: name,
        memo: memo,
        maxKey: maxKey,
        attributes: attrs,
      );
}

/// 表头/属性: 关系/表的一列叫属性
@JsonSerializable()
class AttributeDto extends IMongoDto {
  final int k; // 表头key,对应Field:k,需要从所在的TableMeat中获取
  final String name; // 表头名称
  final String memo; // 表头备注
  final AttrType type;

  final ObjectId inputFuncId;
  final ObjectId checkFuncId;
  final ObjectId outputFuncId;

  AttributeDto.ofDomain(Attribute attr)
      : this(
            k: attr.k,
            name: attr.name,
            memo: attr.memo,
            type: attr.type,
            inputFuncId: attr.inputFunc.id,
            checkFuncId: attr.checkFunc.id,
            outputFuncId: attr.outputFunc.id);

  AttributeDto({
    required this.k,
    required this.name,
    required this.memo,
    required this.type,
    required this.inputFuncId,
    required this.checkFuncId,
    required this.outputFuncId,
  });

  AttributeDto.fromJson(Map<String, dynamic> json)
      : this(
          k: json['k'] as int,
          name: json['name'] as String,
          memo: json['memo'] as String,
          type: AttrType.values.asNameMap()['type']!,
          inputFuncId: ObjectId.fromHexString(json['inputFuncId'] as String),
          checkFuncId: ObjectId.fromHexString(json['checkFuncId'] as String),
          outputFuncId: ObjectId.fromHexString(json['outputFuncId'] as String),
        );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'k': k,
        'name': name,
        'memo': memo,
        'type': type.name,
        'inputFuncId': inputFuncId,
        'checkFuncId': checkFuncId,
        'outputFuncId': outputFuncId,
      };

  AttributeDto.fromMongoJson(Map<String, dynamic> mJs)
      : this(
          k: mJs['k'] as int,
          name: mJs['name'] as String,
          memo: mJs['memo'] as String,
          type: AttrType.values.asNameMap()['type']!,
          inputFuncId: mJs['inputFuncId'] as ObjectId,
          checkFuncId: mJs['checkFuncId'] as ObjectId,
          outputFuncId: mJs['outputFuncId'] as ObjectId,
        );

  @override
  Map<String, dynamic> toMongoDto() => toJson()
    ..['inputFuncId'] = inputFuncId
    ..['checkFuncId'] = checkFuncId
    ..['outputFuncId'] = outputFuncId;

  Attribute toDomain(
    IFunc input,
    IFunc check,
    IFunc output,
  ) =>
      Attribute(
        k: k,
        name: name,
        memo: memo,
        type: type,
        inputFunc: input,
        checkFunc: check,
        outputFunc: output,
      );
}

class FuncDto extends IMongoDto implements IFunc {
  @override
  final ObjectId id;
  @override
  final String name;
  @override
  final FunType type;
  @override
  final Range pRange;
  @override
  final AttrType pType;
  @override
  final AttrType rType;

  FuncDto(this.id, this.name, this.type, this.pRange, this.pType, this.rType);

  @override
  Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
        "name": name,
        "type": type.name,
        "pRange": pRange.toJson(),
        "pType": pType.name,
        "rType": rType.name,
      };

  @override
  Map<String, dynamic> toMongoDto() => toJson()..["_id"] = id;
}

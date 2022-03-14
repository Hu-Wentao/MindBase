import 'dart:math' as math;

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

/// 实体类对应的Dto需要实现本类, 并添加`_id`字段/get方法
abstract class IMongoEntityDto implements IMongoDto {
  ObjectId get id;
}

/// 普通的携带有ObjectId字段的Dto需要实现本类
abstract class IMongoDto implements IDto {
  // 返回的结果与json的Map相似,但 id是 ObjectId类型,而不是String
  Map<String, dynamic> toMongoDto();
}

class RecordDto implements IDto, IMongoEntityDto {
  @override
  final ObjectId id;
  final ObjectId metaId;
  final Map<int, Value> fields;

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
            Value(
              js2['v'] as String,
              js2['e'] as String?,
            ));
      }));

  @override
  Map<String, dynamic> toJson() => toMongoDto()
    ..['_id'] = id
    ..['metaId'] = metaId;

  factory RecordDto.fromMongoJson(Map<String, dynamic> json) => RecordDto(
          (json.remove('_id') as ObjectId), (json.remove('metaId') as ObjectId),
          json.map((key, value) {
        final js2 = (value as Map<String, dynamic>); // 动态字段
        return MapEntry(
            int.parse(key),
            Value(
              js2['v'] as String,
              js2['e'] as String?,
            ));
      }));

  // 适配 MongoDart的ObjectId
  @override
  Map<String, dynamic> toMongoDto() => {
        "_id": id,
        "metaId": metaId,
      }..addEntries(fields.entries
          .map((e) => MapEntry(e.key.toString(), e.value.toJson())));

  @override
  String toString() => toJson().toString();

  Record toDm(RecordMeta Function(ObjectId metaId) getMeta) =>
      toDomain(getMeta(metaId));

  Record toDomain(RecordMeta m) => Record(
        id: id,
        meta: m,
        fields: fields,
      );
}

/// 表头属性
class RecordMetaDto with IMongoEntityDto {
  @override
  ObjectId id;
  String name;
  String memo;
  int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
  List<AttributeDto> attributes;

  RecordMetaDto({
    required this.id,
    required this.name,
    required this.memo,
    required this.maxKey,
    required this.attributes,
  });

  // 用于给Form提供初始值
  RecordMetaDto.builder({
    String? id,
    String name = "",
    String memo = "",
    int maxKey = 0,
    List<AttributeDto> attributes = const [],
  }) : this(
          id: id == null ? ObjectId() : ObjectId.fromHexString(id),
          name: name,
          memo: memo,
          maxKey: maxKey,
          attributes: attributes,
        );

  // 从Form中获取的Map
  RecordMetaDto build(Map<String, String> map, List<AttributeDto> attributes) =>
      RecordMetaDto(
        id: ObjectId.fromHexString(map['id']!),
        name: map['name']!,
        memo: map['memo']!,
        maxKey: int.parse(map['maxKey']!),
        attributes: attributes,
      );

  factory RecordMetaDto.fromForm(
          Map<String, dynamic> map, List<AttributeDto> attrs) =>
      RecordMetaDto(
        // form中是'id', 而不是'_id'
        id: ObjectId.fromHexString(map['id'] as String),
        name: map['name'] as String,
        memo: map['memo'] as String,
        // todo 后期考虑将k移动到form中
        maxKey: attrs.map((e) => e.k).reduce(math.max),
        attributes: attrs,
      );

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
  Map<String, dynamic> toJson() => toMongoDto()..['_id'] = id.toHexString();

  RecordMetaDto.fromMongoJson(Map<String, dynamic> mJs)
      : this(
          id: mJs['_id'] as ObjectId,
          name: mJs['name'] as String,
          memo: mJs['memo'] as String,
          maxKey: mJs['maxKey'] as int,
          attributes: (mJs['attributes'] as List<dynamic>)
              .map((e) => AttributeDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

  @override
  Map<String, dynamic> toMongoDto() => {
        '_id': id,
        'name': name,
        'memo': memo,
        'maxKey': maxKey,
        'attributes': attributes.map((e) => e.toJson()).toList(),
      };

  RecordMeta toDm(
    Attribute Function(AttributeDto dto) attrToDm,
  ) =>
      toDomain(attributes.map(attrToDm).toList());

  RecordMeta toDomain(List<Attribute> attrs) => RecordMeta(
        id: id,
        name: name,
        memo: memo,
        maxKey: maxKey,
        attributes: attrs,
      );
}

/// 表头/属性: 关系/表的一列叫属性
class AttributeDto implements IDto {
  final int k;
  final String name;
  final String memo;
  final AttrType type;
  final String checkFuncName;

  /// 供Form初始化
  AttributeDto.builder({
    int k = 0,
    String name = "",
    String memo = "",
    AttrType type = AttrType.string,
    String checkFuncName = "",
  }) : this(
          k: k,
          name: name,
          memo: memo,
          type: type,
          checkFuncName: checkFuncName,
        );

  AttributeDto build(Map<String, String> map) => AttributeDto.fromJson(map);

  factory AttributeDto.fromFrom(Map<String, dynamic> attrMap) => AttributeDto(
        k: int.parse(attrMap['k'] as String),
        name: attrMap['name'] as String,
        memo: attrMap['memo'] as String,
        type: AttrType.values.asNameMap()[attrMap['type'] as String]!,
        checkFuncName: attrMap['checkFuncName'] as String,
      );

  AttributeDto.ofDomain(Attribute attr)
      : this(
          k: attr.k,
          name: attr.name,
          memo: attr.memo,
          type: attr.type,
          checkFuncName: attr.check.name,
        );

  AttributeDto({
    required this.k,
    required this.name,
    required this.memo,
    required this.type,
    required this.checkFuncName,
  });

  AttributeDto.fromJson(Map<String, dynamic> json)
      : this(
          k: json['k'] as int,
          name: json['name'] as String,
          memo: json['memo'] as String,
          type: AttrType.values.asNameMap()[json['type'] as String]!,
          checkFuncName: json['checkFuncName'] as String,
        );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'k': k,
        'name': name,
        'memo': memo,
        'type': type.name,
        'checkFuncName': checkFuncName,
      };

  Attribute toDm(
    Func Function(String funName) getCheck,
  ) =>
      toDomain(getCheck(checkFuncName));

  Attribute toDomain(
    Func check,
  ) =>
      Attribute(
        k: k,
        name: name,
        memo: memo,
        type: type,
        check: check,
      );

  @override
  String toString() => toJson().toString();
}

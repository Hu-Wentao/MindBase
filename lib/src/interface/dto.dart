import 'dart:math' as math;

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dto.freezed.dart';

part 'dto.g.dart';

/// 实体类对应的Dto需要实现本类, 并添加`_id`字段/get方法
abstract class IMongoEntityDto extends IMongoDto {
  const IMongoEntityDto();

  ObjectId get id;

  @override
  String toString() => toMongoJson().toString();
}

/// 普通的携带有ObjectId字段的Dto需要实现本类
abstract class IMongoDto extends Equatable with IMongoDtoMx {
  const IMongoDto();

  @override
  bool? get stringify => true;
}

mixin IMongoDtoMx implements IDto {
  // 返回的结果与json的Map相似,但 id是 ObjectId类型,而不是String
  // todo 可以在这里实现保存 int， bool， 等原始类型的需求
  dynamic toMongoJson({AttrType type = AttrType.string});

  @override
  String toString() => toMongoJson().toString();
}

///
/// fields[0] 表示ID : ObjectId
/// fields[1] 表示MetaID ObjectId
class RecordDto extends IMongoEntityDto {
  @override
  ObjectId get id => ObjectId.fromHexString(idHex);

  ObjectId get metaId => ObjectId.fromHexString(metaIdHex);

  String get idHex => fields[0]!.v;

  String get metaIdHex => fields[1]!.v;

  final Map<int, Value> fields;

  const RecordDto({required this.fields});

  @override
  List<Object?> get props => [fields];

  factory RecordDto.builder({
    ObjectId? id,
    required ObjectId metaId,
    Map<int, Value> fields = const {},
  }) =>
      RecordDto(
        fields: {
          //      填入默认值
          0: Value.of((id ?? ObjectId()).toHexString()),
          1: Value.of(metaId.toHexString()),
        }..addAll(fields),
      );

  factory RecordDto.fromDomain(Record record) => RecordDto(
        fields: record.fields,
      );

  factory RecordDto.fromJson(Map<String, dynamic> json) => RecordDto(
        fields: Map.fromEntries(
          json.entries
              .where((element) => element.value is Map<String, dynamic>)
              .map((e) => MapEntry(int.parse(e.key), Value.fromJson(e.value))),
        ),
      );

  @override
  Map<String, dynamic> toJson() => toMongoJson()..['_id'] = idHex;

  /// 从表单输入
  factory RecordDto.fromForm(RecordMeta meta, Map<String, dynamic> formMap) {
    return RecordDto(
      fields: Map.fromEntries(meta.attributes.map((attr) {
        final value = formMap["${attr.k}"];
        return MapEntry(attr.k, Value.of(value));
      })),
    );
  }

  /// 注意, 本方法会修改json内容, 如果传入的json被再次解析,将会导致解析出错
  ///   (例如,将同一个json连续两次调用本方法)
  factory RecordDto.fromMongoJson(Map<String, dynamic> json) => RecordDto(
          fields: Map.fromEntries(
        json.entries
            .where((element) => element.value is Map<String, dynamic>)
            .map((e) => MapEntry(
                  int.parse(e.key),
                  Value.fromJson(e.value),
                )),
      ));

  /// 适配 MongoDart的ObjectId
  /// 这里直接使用json,无需将value转换为String
  @override
  Map<String, dynamic> toMongoJson({AttrType type = AttrType.string}) =>
      fields.map((key, value) => MapEntry("$key", value.toMongoJson()))
        ..['_id'] = id;

  Record toDm(RecordMeta Function(ObjectId metaId) getMeta) =>
      toDomain(getMeta(metaId));

  Record toDomain(RecordMeta m) => Record(
        id: id,
        meta: m,
        fields: fields,
      );

  Record? toDomainOr(RecordMeta? m) => m == null ? null : toDomain(m);

  /// 向Table提供Map <metaKey值,Filed Value>
  @Deprecated("考虑新增更内聚的方法")
  Map<String, Value> toGridKeyValueMap() =>
      fields.map((key, value) => MapEntry("$key", value));

  @Deprecated("考虑新增更内聚的方法")
  static RecordDto fromGridKeyValueMap(
    RecordDto oldEntity,
    Map<String, Value> nGridMap,
  ) =>
      RecordDto(
        fields: nGridMap.map((k, v) => MapEntry(int.tryParse(k) ?? -1, v)),
      );
}

/// 表头属性
/// attributes固定 0:表示Record的ID, 1:表示Record的metaId
class RecordMetaDto extends IMongoEntityDto {
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

  @override
  List<Object?> get props => [
        id,
        name,
        memo,
        maxKey,
        attributes,
      ];

  AttributeDto findAttr(int k) =>
      attributes.firstWhere((element) => element.k == k);

  int nextKey() => maxKey + 1;

  // 用于给Form提供初始值
  factory RecordMetaDto.builder({
    String? id,
    String name = "",
    String memo = "",
    List<AttributeDto>? attributes,
  }) {
    final metaId = id == null ? ObjectId() : ObjectId.fromHexString(id);
    final attrs = attributes ??
        [
          AttributeDto.builder(
            metaId: metaId,
            k: 0,
            name: "ID",
            memo: "系统生成的唯一ID",
            // expr: Expression.field(metaId, 0, AttrType.objectId),
          ),
          AttributeDto.builder(
            metaId: metaId,
            k: 1,
            name: "metaId",
            memo: "元数据ID",
            // expr: Expression.field(metaId, 1, AttrType.objectId),
          ),
        ];
    return RecordMetaDto(
      id: metaId,
      name: name,
      memo: memo,
      maxKey: attrs.length,
      attributes: attrs,
    );
  }

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
  Map<String, dynamic> toJson() => toMongoJson()..['_id'] = id.toHexString();

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
  Map<String, dynamic> toMongoJson({AttrType type = AttrType.string}) => {
        '_id': id, // 必须要有 '_id'
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

  // key序列, <字段key,UI展示名>/<字段key,Header名>, 例如 <"0":"ID">, <"2","年龄">等
  @Deprecated("考虑新增更内聚的方法")
  Map<String, String> toGridKeyNameMap() =>
      Map.fromEntries(attributes.map((e) => MapEntry("${e.k}", e.name)));

  AttributeDto getAttrByKey(int key) =>
      attributes.firstWhere((element) => element.k == key);

  AttributeDto? getAttrByKeyOr(int? key) =>
      key == null ? null : getAttrByKey(key);
}

/// 表头/属性: 关系/表的一列叫属性
class AttributeDto with IMongoDtoMx, EquatableMixin {
  final int k;
  final String name;
  final String memo;
  final Expression calc;
  final String checkFuncName;

  /// 供Form初始化
  AttributeDto.builder({
    ObjectId? metaId,
    int k = 0,
    String name = "",
    String memo = "",
    Expression? calc,
    String checkFuncName = FuncManager.noneFuncName,
  }) : this(
          k: k,
          name: name,
          memo: memo,
          calc: calc ?? Expression(
          ),
          checkFuncName: checkFuncName,
        );

  AttributeDto build(Map<String, String> map) => AttributeDto.fromJson(map);

  factory AttributeDto.fromFrom(Map<String, dynamic> attrMap) => AttributeDto(
        k: int.parse(attrMap['k'] as String),
        name: attrMap['name'] as String,
        memo: attrMap['memo'] as String,
        calc: BaseInvokableDto.fromTypedJson(
                attrMap['calc'] as Map<String, dynamic>)
            .toDomain() as Expression,
        checkFuncName: attrMap['checkFuncName'] as String,
      );

  AttributeDto.ofDomain(Attribute attr)
      : this(
          k: attr.k,
          name: attr.name,
          memo: attr.memo,
          calc: attr.calc,
          checkFuncName: attr.check.name,
        );

  const AttributeDto({
    required this.k,
    required this.name,
    required this.memo,
    required this.calc,
    required this.checkFuncName,
  });

  @override
  List<Object?> get props => [
        k,
        name,
        memo,
        calc,
        checkFuncName,
      ];

  AttributeDto copyWith({
    k,
    name,
    memo,
    expr,
    checkFuncName,
  }) =>
      AttributeDto(
        k: k ?? this.k,
        name: name ?? this.name,
        memo: memo ?? this.memo,
        calc: expr ?? this.calc,
        checkFuncName: checkFuncName ?? this.checkFuncName,
      );

  AttributeDto.fromJson(Map<String, dynamic> json)
      : this(
          k: json['k'] as int,
          name: json['name'] as String,
          memo: json['memo'] as String,
          calc: BaseInvokableDto.fromTypedJson(
                  json['calc'] as Map<String, dynamic>)
              .toDomain() as Expression,
          checkFuncName: json['checkFuncName'] as String,
        );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'k': k,
        'name': name,
        'memo': memo,
        'calc': ExpressionDto.fromDomain(calc),
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
        calc: calc,
        check: check,
      );

  @override
  String toString() => toJson().toString();

  @override
  toMongoJson({AttrType type = AttrType.string}) => toJson();
}

mixin BaseInvokableDto on IMongoDtoMx {
  static BaseInvokableDto fromDomain(Invokable entity) {
    if (entity is Expression) {
      return ExpressionDto.fromDomain(entity);
    } else if (entity is Value) {
      return ValueDto.fromDomain(entity);
    } else {
      throw Exception("不支持的Invokable类型");
    }
  }

  static BaseInvokableDto fromTypedJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final real = json['real'] as Map<String, dynamic>;
    switch (type) {
      case "Value":
        return ValueDto.fromJson(real);
      case 'Expression':
        return ExpressionDto.fromJson(real);
      default:
        throw Exception('BaseCallable::fromTypedJson# Unknown type: $type');
    }
  }

  Map<String, dynamic> toJsonWithType() => {
        'type': "$runtimeType",
        'real': toJson(),
      };

  @override
  toMongoJson({AttrType type = AttrType.string}) => toJsonWithType();

  Invokable toDomain() {
    switch (runtimeType) {
      case ValueDto:
        final dto = this as ValueDto;
        return Value(dto.v ?? '', dto.e);
      case ExpressionDto:
        final dto = (this as ExpressionDto);
        return Expression(
          FuncManager.findBy(dto.func),
          dto.args.map((e) => e.toDomain()).toList(),
        );
      default:
        throw "未知的类型 [$runtimeType]";
    }
  }
}

@freezed
class ValueDto with _$ValueDto, IMongoDtoMx, BaseInvokableDto {
  const ValueDto._();

  const factory ValueDto(
    String? v, // 字段存储值
    String? e, // 字段错误信息
  ) = _ValueDto;

  factory ValueDto.fromJson(Map<String, dynamic> json) =>
      _$ValueDtoFromJson(json);

  @override
  toMongoJson({AttrType type = AttrType.string}) => toJson();

  static ValueDto fromDomain(Value entity) => ValueDto(entity.v, entity.e);
}

class ExpressionDto with IMongoDtoMx, BaseInvokableDto {
  //内嵌函数的名
  String func;
  List<BaseInvokableDto> args;

  ExpressionDto({
    required this.func,
    required this.args,
  });

  static ExpressionDto fromJson(Map<String, dynamic> real) => ExpressionDto(
      func: real['func'] as String,
      args: (real['args'] as List<dynamic>)
          .map((e) => BaseInvokableDto.fromTypedJson(e as Map<String, dynamic>))
          .toList());

  @override
  Map<String, dynamic> toJson() => {
        'func': func,
        'args': args.map((e) => e.toJsonWithType()).toList(),
      };

  static fromDomain(Expression expr) => ExpressionDto(
        func: expr.func.name,
        args: expr.args.map(BaseInvokableDto.fromDomain).toList(),
      );
}

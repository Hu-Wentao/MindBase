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
      fields: Map.fromEntries(meta.properties.map((attr) {
        final value = formMap[attr.propId];
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
        methods: m.methodMap,
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

/// attributes固定 0:表示Record的ID, 1:表示Record的metaId
class RecordMetaDto extends IMongoEntityDto {
  @override
  ObjectId id;
  String name;
  String memo;
  int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
  List<AttributeDto> attrs;
  List<MethodDto> methods;

  RecordMetaDto({
    required this.id,
    required this.name,
    required this.memo,
    required this.maxKey,
    required this.attrs,
    required this.methods,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        memo,
        maxKey,
        attrs,
      ];

  AttributeDto findAttr(int k) => attrs.firstWhere((element) => element.k == k);

  // 方法和属性公用 k值，在创建表单时，会对同一个实例多次调用，因此这里用`+=`
  int nextKey() => maxKey += 1;

  // 用于给Form提供初始值
  factory RecordMetaDto.builder({
    String? id,
    String name = "",
    String memo = "",
    List<AttributeDto>? attributes,
    List<MethodDto> methods = const [],
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
      attrs: attrs,
      methods: methods,
    );
  }

  // 从Form中获取的Map
  RecordMetaDto build(Map<String, String> map, List<AttributeDto> attributes,
          List<MethodDto> methods) =>
      RecordMetaDto(
        id: ObjectId.fromHexString(map['id']!),
        name: map['name']!,
        memo: map['memo']!,
        maxKey: int.parse(map['maxKey']!),
        attrs: attributes,
        methods: methods,
      );

  factory RecordMetaDto.fromForm(
    Map<String, dynamic> map,
    List<AttributeDto> attrs,
    List<MethodDto> methods,
  ) =>
      RecordMetaDto(
        // form中是'id', 而不是'_id'
        id: ObjectId.fromHexString(map['id'] as String),
        name: map['name'] as String,
        memo: map['memo'] as String,
        // todo 后期考虑将k移动到form中
        maxKey: attrs.map((e) => e.k).reduce(math.max),
        attrs: attrs,
        methods: methods,
      );

  factory RecordMetaDto.fromDomain(RecordMeta meta) => RecordMetaDto(
        id: meta.id,
        name: meta.name,
        memo: meta.memo,
        maxKey: meta.maxKey,
        attrs: meta.attrs.map((e) => e.toDto()).toList(),
        methods: meta.methods.map((e) => e.toDto()).toList(),
      );

  factory RecordMetaDto.fromJson(Map<String, dynamic> json) => RecordMetaDto(
        id: ObjectId.fromHexString(json['_id'] as String),
        name: json['name'] as String,
        memo: json['memo'] as String,
        maxKey: json['maxKey'] as int,
        attrs: (json['attrs'] as List<dynamic>)
            .map((e) => AttributeDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        methods: (json['methods'] as List<dynamic>)
            .map((e) => MethodDto.fromJson(e as Map<String, dynamic>))
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
          attrs: (mJs['attrs'] as List<dynamic>)
              .map((e) => AttributeDto.fromJson(e as Map<String, dynamic>))
              .toList(),
          methods: (mJs['methods'] as List<dynamic>)
              .map((e) => MethodDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

  @override
  Map<String, dynamic> toMongoJson({AttrType type = AttrType.string}) => {
        '_id': id, // 必须要有 '_id'
        'name': name,
        'memo': memo,
        'maxKey': maxKey,
        'attrs': attrs.map((e) => e.toJson()).toList(),
        'methods': methods.map((e) => e.toJson()).toList(),
      };

  RecordMeta toDm(
    Attribute Function(AttributeDto dto) attrToDm,
  ) =>
      toDomain(
        attrs.map(attrToDm).toList(),
        methods.map((e) => e.toDomain()).toList(),
      );

  RecordMeta toDomain(List<Attribute> attrs, List<Method> methods) =>
      RecordMeta(
        id: id,
        name: name,
        memo: memo,
        maxKey: maxKey,
        attrs: attrs,
        methods: methods,
      );

  // key序列, <字段key,UI展示名>/<字段key,Header名>, 例如 <"0":"ID">, <"2","年龄">等
  @Deprecated("考虑新增更内聚的方法")
  Map<String, String> toGridKeyNameMap() =>
      Map.fromEntries(attrs.map((e) => MapEntry("${e.k}", e.name)));

  AttributeDto getAttrByKey(int key) =>
      attrs.firstWhere((element) => element.k == key);

  AttributeDto? getAttrByKeyOr(int? key) =>
      key == null ? null : getAttrByKey(key);
}

class MethodDto with IMongoDtoMx, EquatableMixin {
  final int k;
  final String name;
  final String memo;
  final String expr;

  // final ExpressionDto expr;

  /// 供Form初始化
  MethodDto.builder({
    ObjectId? metaId,
    int k = 0,
    String name = "",
    String memo = "",
    String expr = "",
    // ExpressionDto? expr,
  }) : this(
          k: k,
          name: name,
          memo: memo,
          expr: expr,
          // expr: expr ?? ExpressionDto.builder(),
        );

  MethodDto build(Map<String, String> map) => MethodDto.fromJson(map);

  factory MethodDto.fromFrom(Map<String, dynamic> attrMap) => MethodDto(
        k: int.parse(attrMap['k'] as String),
        name: attrMap['name'] as String,
        memo: attrMap['memo'] as String,
        expr: attrMap['expr'] as String,
        // expr: ExpressionDto.fromJson(attrMap['expr'] as Map<String, dynamic>),
      );

  MethodDto.ofDomain(Method method)
      : this(
          k: method.k,
          name: method.name,
          memo: method.memo,
          expr: method.expr,
          // expr: ExpressionDto(
          //   func: method.expr.func.name,
          //   args: method.expr.args
          //       .map((e) => BaseInvokableDto.fromDomain(e))
          //       .toList(),
          // ),
        );

  const MethodDto({
    required this.k,
    required this.name,
    required this.memo,
    required this.expr,
  });

  @override
  List<Object?> get props => [
        k,
        name,
        memo,
        expr,
      ];

  MethodDto copyWith({
    k,
    name,
    memo,
    expr,
  }) =>
      MethodDto(
        k: k ?? this.k,
        name: name ?? this.name,
        memo: memo ?? this.memo,
        expr: expr ?? this.expr,
      );

  MethodDto.fromJson(Map<String, dynamic> json)
      : this(
          k: json['k'] as int,
          name: json['name'] as String,
          memo: json['memo'] as String,
          expr: json['expr'] as String,
          // expr: ExpressionDto.fromJson(json['expr'] as Map<String, dynamic>),
        );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'k': k,
        'name': name,
        'memo': memo,
        'expr': expr,
        // 'expr': expr.toJson(),
      };

  Method toDomain() => Method(
        k: k,
        name: name,
        memo: memo,
        expr: expr,
        // expr: expr.toDomain() as Expression,
      );

  @override
  String toString() => toJson().toString();

  @override
  toMongoJson({AttrType type = AttrType.string}) => toJson();
}

/// 表头/属性: 关系/表的一列叫属性
class AttributeDto with IMongoDtoMx, EquatableMixin {
  final int k;
  final String name;
  final String memo;
  final AttrType type;

  /// 供Form初始化
  AttributeDto.builder({
    ObjectId? metaId,
    int k = 0,
    String name = "",
    String memo = "",
    AttrType type = AttrType.any,
  }) : this(
          k: k,
          name: name,
          memo: memo,
          type: type,
        );

  AttributeDto build(Map<String, String> map) => AttributeDto.fromJson(map);

  factory AttributeDto.fromFrom(Map<String, dynamic> attrMap) => AttributeDto(
        k: int.parse(attrMap['k'] as String),
        name: attrMap['name'] as String,
        memo: attrMap['memo'] as String,
        type: AttrType.values.byName(attrMap['type'] as String),
      );

  AttributeDto.ofDomain(Attribute attr)
      : this(
          k: attr.k,
          name: attr.name,
          memo: attr.memo,
          type: attr.type,
        );

  const AttributeDto({
    required this.k,
    required this.name,
    required this.memo,
    required this.type,
  });

  @override
  List<Object?> get props => [
        k,
        name,
        memo,
      ];

  AttributeDto copyWith({
    k,
    name,
    memo,
    type,
  }) =>
      AttributeDto(
        k: k ?? this.k,
        name: name ?? this.name,
        memo: memo ?? this.memo,
        type: type ?? this.type,
      );

  AttributeDto.fromJson(Map<String, dynamic> json)
      : this(
          k: json['k'] as int,
          name: json['name'] as String,
          memo: json['memo'] as String,
          type: AttrType.values.byName(json['type'] as String),
        );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'k': k,
        'name': name,
        'memo': memo,
        'type': type.name,
      };

  Attribute toDm() => toDomain();

  Attribute toDomain() => Attribute(
        k: k,
        name: name,
        memo: memo,
        type: type,
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
    final type = json['sign'] as String;
    final real = json['real'] as Map<String, dynamic>;
    switch (type) {
      case 'Exp':
        return ExpressionDto.fromJson(real);
      case "Val":
        return ValueDto.fromJson(real);
      default:
        throw Exception('BaseCallable::fromTypedJson# Unknown type: $type');
    }
  }

  String get subTypeToSign => this is ExpressionDto ? 'Exp' : 'Val';

  Map<String, dynamic> toJsonWithType() {
    return {
      'sign': subTypeToSign,
      'real': toJson(),
    };
  }

  /// 可视化的表达式字符串， 例如 foo('1', '2')
  String toEditString();

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
          FuncManager.findBy(dto.func!),
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

  // fixme ValueDto没有`类型`信息，无法在这里展示类型， 考虑Form的入参直接使用Domain对象
  // fixme 或许不需要，因为ValueDto代表的就是某个字段的值，而方法中操作的一般是某个字段(Attr)
  @override
  String toEditString() => "$v";
// 如果v是原始类型，则应当使用下面的代码
// String toEditString() => json.encode(v);
}

class ExpressionDto with IMongoDtoMx, BaseInvokableDto {
  //内嵌函数的名
  String? func;
  List<BaseInvokableDto> args;

  ExpressionDto({
    this.func,
    this.args = const [],
  });

  ExpressionDto.builder({
    this.func,
    this.args = const [],
  });

  static ExpressionDto fromJson(Map<String, dynamic> real) => ExpressionDto(
      func: real['func'] as String,
      args: (real['args'] as List<dynamic>)
          .map((e) => BaseInvokableDto.fromTypedJson(e as Map<String, dynamic>))
          .toList());

  /// 可视化的函数表达式字符串
  @override
  String toEditString() =>
      "$func(${args.map((e) => e.toEditString()).join(', ')})";

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

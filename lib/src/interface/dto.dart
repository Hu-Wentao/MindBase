import 'dart:convert';
import 'dart:math' as math;

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:quiver/core.dart' as quiver;

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

  String get idHex => fields[0]!.value;

  String get metaIdHex => fields[1]!.value;

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
              .map((e) => MapEntry(
                    int.parse(e.key),
                    ValueJsonDto.fromJson(e.value).toDomain() as Value,
                  )),
        ),
      );

  @override
  Map<String, dynamic> toJson() => toMongoJson()
    ..['metaId'] = metaIdHex
    ..['_id'] = idHex;

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
                  ValueJsonDto.fromJson(e.value).toDomain() as Value,
                )),
      ));

  /// 适配 MongoDart的ObjectId
  /// 这里直接使用json,无需将value转换为String
  @override
  Map<String, dynamic> toMongoJson({AttrType type = AttrType.string}) =>
      fields.map((key, value) =>
          MapEntry("$key", ValueJsonDto.fromDomain(value).toMongoJson()))
        ..['metaId'] = metaId
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
  final IExprJsonDto expr;

  /// 供Form初始化
  MethodDto.builder({
    ObjectId? metaId,
    int k = 0,
    String name = "",
    String memo = "",
    IExprJsonDto? expr,
  }) : this(
          k: k,
          name: name,
          memo: memo,
          expr: expr ?? ExprJsonDto.builder(),
        );

  MethodDto build(Map<String, String> map) => MethodDto.fromJson(map);

  factory MethodDto.fromFrom(Map<String, dynamic> attrMap) => MethodDto(
        k: int.parse(attrMap['k'] as String),
        name: attrMap['name'] as String,
        memo: attrMap['memo'] as String,
        expr: IExprJsonDto.fromJson(attrMap['expr'] as Map<String, dynamic>),
      );

  MethodDto.ofDomain(Method method)
      : this(
          k: method.k,
          name: method.name,
          memo: method.memo,
          expr: IExprJsonDto.fromDomain(method.expr),
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
          expr: IExprJsonDto.fromJson(json['expr'] as Map<String, dynamic>),
        );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'k': k,
        'name': name,
        'memo': memo,
        'expr': expr.toJson(),
      };

  Method toDomain() => Method(
        k: k,
        name: name,
        memo: memo,
        expr: expr.toDomain(),
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
        type: AttrType.by(attrMap['type'] as String),
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
          type: AttrType.by(json['type'] as String),
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

abstract class IExprJsonDto implements IMongoDtoMx {
  String? get fn;

  List<dynamic> get ag;

  static IExprJsonDto fromDomain(dynamic expr) {
    if (expr is Value) {
      return ValueJsonDto(
        fn: expr.fn.name,
        ag: expr.ag,
      );
    }
    if (expr is Expression) {
      return ExprJsonDto(
        fn: expr.fn.name,
        ag: expr.ag.map(IExprJsonDto.fromDomain).toList(),
        type: expr.type,
      );
    }
    throw Exception("不支持的IExpr类型[${expr.runtimeType}]");
  }

  static IExprJsonDto fromJson(Map<String, dynamic> json) {
    final fnName = json['fn'] as String;
    if (FuncManager.isAsFunc(fnName)) {
      return ValueJsonDto.fromJson(json);
    } else {
      return ExprJsonDto.fromJson(json);
    }
  }

  /// 可视化的表达式字符串， 例如 foo('1', '2')
  String toReadableString();

  @override
  toMongoJson({AttrType type = AttrType.string}) => toJson();

  IExpr toDomain() {
    switch (runtimeType) {
      case ValueJsonDto:
        final dto = this as ValueJsonDto;
        final fn = FuncManager.findAsFunc(dto.fn!);
        var ag = dto.ag;
        if ((fn is AsFuncRecord || fn is AsFuncRecordMeta) &&
            ag[0] is! ObjectId) {
          ag[0] = ObjectId.fromHexString(ag[0] as String);
        }
        return Value(fn: fn, ag: dto.ag);
      case ExprJsonDto:
        final dto = (this as ExprJsonDto);
        return Expression(
          fn: FuncManager.findBy(dto.fn!),
          ag: dto.ag.map((e) => e.toDomain()).toList(),
          type: dto.type!,
        );
      default:
        throw "IExpr::toDomain 未知的类型 [$runtimeType]";
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExprJsonDto &&
          runtimeType == other.runtimeType &&
          fn == other.fn &&
          // fixme 低性能
          toString() == other.toString();

  @override
  int get hashCode => fn.hashCode ^ quiver.hashObjects(ag);
}

class ExprJsonDto extends IExprJsonDto with IMongoDtoMx {
  //内嵌函数的名
  @override
  String? fn;
  @override
  List<IExprJsonDto> ag;

  AttrType? type;

  ExprJsonDto({
    required this.fn,
    this.ag = const [],
    required this.type,
  });

  ExprJsonDto.builder({
    this.fn,
    this.ag = const [],
    this.type,
  });

  factory ExprJsonDto.fromDomain(IExpr expr) => ExprJsonDto(
        fn: expr.fn.name,
        ag: expr.ag.map(IExprJsonDto.fromDomain).toList(),
        type: expr.type,
      );

  factory ExprJsonDto.fromJson(Map<String, dynamic> json) => ExprJsonDto(
        fn: json['fn'] as String,
        ag: (json['ag'] as List<dynamic>)
            .map((e) => IExprJsonDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        type: AttrType.by(json['type'] as String),
      );

  /// 可视化的函数表达式字符串
  @override
  String toReadableString() =>
      "$fn(${ag.map((e) => e.toReadableString()).join(', ')})";

  @override
  Map<String, dynamic> toJson() => {
        'fn': fn,
        'ag': ag.map((e) => e.toJson()).toList(),
        'type': type?.name,
      };
}

/// 不同点在于, ValueDto 的ag是 List<dynamic>
class ValueJsonDto extends IExprJsonDto with IMongoDtoMx {
  //内嵌函数的名
  @override
  String? fn;
  @override
  List<dynamic> ag;

  ValueJsonDto({
    this.fn,
    this.ag = const [],
  });

  ValueJsonDto.builder({
    this.fn,
    this.ag = const [],
  });

  factory ValueJsonDto.fromDomain(IExpr expr) => ValueJsonDto(
        fn: expr.fn.name,
        ag: expr.ag,
        // ag: expr.ag.map((e) => jsonEncode(e)).toList(),
      );

  static ValueJsonDto fromJson(Map<String, dynamic> json) => ValueJsonDto(
      fn: json['fn'] as String,
      ag: (json['ag'] as List<dynamic>).map((e) => jsonDecode(e)).toList());

  /// 可视化的函数表达式字符串
  @override
  String toReadableString() => "$fn(${ag.map(_resolveTypeToJson).join(', ')})";

  @override
  Map<String, dynamic> toJson() => {
        'fn': fn,
        'ag': ag.map(_resolveTypeToJson).toList(),
      };

  _resolveTypeToJson(dynamic e) {
    switch (e.runtimeType) {
      case IExprJsonDto:
        return e.toJson();
      case Record:
        return jsonEncode((e as Record).id.toHexString());
      case RecordMeta:
        return jsonEncode((e as RecordMeta).id.toHexString());
      default:
        try {
          return jsonEncode(e);
        } catch (e) {
          print("_resolveTypeToJson#error#e = $e");
          return "error";
        }
    }
  }
}

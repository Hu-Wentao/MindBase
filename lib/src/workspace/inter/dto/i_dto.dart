import 'dart:convert';
import 'dart:math' as math;
import 'package:get_arch_core/get_arch_core.dart';
import 'package:json_editor/json_editor.dart';
import 'package:mind_base/src/core/infra/dto/dto_json_impl.dart';
import 'package:mind_base/src/core/inter/i_dto.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/workspace/domain/entity/entity.dart';
import 'package:mind_base/src/workspace/domain/value/value.dart';
import 'package:quiver/core.dart';

part 'expr_node_dto.dart';

extension RecordX on Record {
  RecordDto toDto() => RecordDto.fromDomain(this);
}

///
/// fields[0] 表示ID : String
/// fields[1] 表示MetaID String
class RecordDto extends IEntityDto {
  @override
  String get id => idHex;

  String get metaId => metaIdHex;

  String get idHex => fields[0]!.value;

  String get metaIdHex => fields[1]!.value;

  final Map<int, Value> fields;

  const RecordDto({this.fields = const {}});

  factory RecordDto.fromDomain(Record record) => RecordDto(
        fields: record.fields,
      );

  factory RecordDto.builder({
    String? id,
    String? metaId,
    Map<int, Value> fields = const {},
  }) =>
      RecordDto(
          fields: {
        //      填入默认值
        0: Value.of(id ??= ObjectIdX.createHex),
        1: Value.of(metaId),
      }..addAll(fields));

  /// 从表单输入
  factory RecordDto.fromForm(RecordMeta meta, Map<String, dynamic> formMap) {
    return RecordDto(
      fields: Map.fromEntries(meta.properties.map((attr) {
        final value = formMap[attr.propId];
        return MapEntry(attr.k, Value.of(value));
      })),
    );
  }

  Record toDm(RecordMeta Function(String metaId) getMeta) =>
      toDomain(getMeta(metaId));

  Record toDomain(RecordMeta m) => Record(
        id: idHex,
        meta: m,
        fields: fields,
      );

  Record? toDomainOr(RecordMeta? m) => m == null ? null : toDomain(m);

  @override
  Map<String, dynamic> toJson() =>
      throw UnimplementedError("使用[$runtimeType]相关Extension的方法");

  @override
  String toString() => 'RecordDto{fields: $fields}';
}

extension RecordMetaX on RecordMeta {
  RecordMetaDto toDto() => RecordMetaDto.fromDomain(this);
}

/// attributes固定 0:表示Record的ID, 1:表示Record的metaId
class RecordMetaDto extends IEntityDto {
  @override
  String id;
  String name;
  String memo;
  int maxKey; // 等于Table中出现过key的数量, 用于新增Attr/Method,只能增加
  List<AttributeDto> attrs;
  List<MethodDto> methods;

  RecordMetaDto({
    required this.id,
    required this.name,
    required this.memo,
    required this.maxKey,
    this.attrs = const [],
    this.methods = const [],
  });

  AttributeDto findAttr(int k) => attrs.firstWhere((element) => element.k == k);

  AttributeDto? findAttrByName(String name) {
    for (final a in attrs) {
      if (a.name == name) {
        return a;
      }
    }
    return null;
  }

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
    final metaId = id ??= ObjectIdX.createHex;
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
        id: (map['id']!),
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
        id: (map['id'] as String),
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

  @override
  Map<String, dynamic> toJson() =>
      throw UnimplementedError("使用[$runtimeType]相关Extension的方法");

  RecordMeta toDm(QueryMetaFn toMeta) => toDomain(
        attrs.map((a) => a.toDomain(toMeta)).toList(),
        methods.map((e) => e.toDomain(toMeta)).toList(),
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

  @override
  String toString() {
    return 'RecordMetaDto{id: $id, name: $name, memo: $memo, maxKey: $maxKey, attrs: $attrs, methods: $methods}';
  }
}

extension MethodX on Method {
  MethodDto toDto() => MethodDto.ofDomain(this);
}

class MethodDto extends IDto {
  int k;
  String name;
  String memo;
  IExprNodeDto expr;

  MethodDto({
    required this.k,
    required this.name,
    required this.memo,
    required this.expr,
  });

  /// 供Form初始化
  MethodDto.builder({
    String? metaId,
    int k = 0,
    String name = "",
    String memo = "",
    IExprNodeDto? expr,
  }) : this(
          k: k,
          name: name,
          memo: memo,
          expr: expr ?? ExprNodeDto.builder(),
        );

  factory MethodDto.fromFrom(Map<String, dynamic> attrMap) => MethodDto(
        k: int.parse(attrMap['k'] as String),
        name: attrMap['name'] as String,
        memo: attrMap['memo'] as String,
        expr:
            IExprJsonDtoJsonX.fromJson(attrMap['expr'] as Map<String, dynamic>),
      );

  MethodDto.ofDomain(Method method)
      : this(
          k: method.k,
          name: method.name,
          memo: method.memo,
          expr: IExprNodeDto.fromDomain(method.expr),
        );

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

  Method toDomain(QueryMetaFn toMeta) => Method(
        k: k,
        name: name,
        memo: memo,
        expr: expr.toDomain(toMeta),
      );

  @override
  String toString() =>
      'MethodDto{k: $k, name: $name, memo: $memo, expr: $expr}';

  @override
  Map<String, dynamic> toJson() =>
      throw UnimplementedError("使用[$runtimeType]相关Extension的方法");
}

extension AttrbuteX on Attribute {
  AttributeDto toDto() => AttributeDto.ofDomain(this);
}

/// 表头/属性: 关系/表的一列叫属性
class AttributeDto extends IDto {
  int k;
  String name;
  String memo;
  AttrTypeDto type;

  AttributeDto({
    required this.k,
    required this.name,
    required this.memo,
    required this.type,
  });

  String get propId => PropertyX.getPropId(true, k);

  /// 供Form初始化
  AttributeDto.builder({
    @Deprecated("无意义参数") String? metaId,
    int k = 0,
    String name = "",
    String memo = "",
    AttrTypeDto type = AttrTypeDto.any,
  }) : this(
          k: k,
          name: name,
          memo: memo,
          type: type,
        );

  factory AttributeDto.fromFrom(Map<String, dynamic> attrMap) => AttributeDto(
        k: int.parse(attrMap['k'] as String),
        name: attrMap['name'] as String,
        memo: attrMap['memo'] as String,
        type: AttrTypeDto.by(attrMap['type'] as String, attrMap['ref']),
      );

  AttributeDto.ofDomain(Attribute attr)
      : this(
          k: attr.k,
          name: attr.name,
          memo: attr.memo,
          type: attr.type.toDto(),
        );

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

  Attribute toDm(QueryMetaFn toMeta) => toDomain(toMeta);

  Attribute toDomain(QueryMetaFn toMeta) => Attribute(
        k: k,
        name: name,
        memo: memo,
        type: type.toDomain(toMeta),
      );

  @override
  String toString() {
    return 'AttributeDto{k: $k, name: $name, memo: $memo, type: $type}';
  }

  @override
  Map<String, dynamic> toJson() =>
      throw UnimplementedError("使用[$runtimeType]相关Extension的方法");
}

class WorkspaceDto extends IEntityDto {
  @override
  String id;
  String name;
  String teamId;
  List<String> metas;

  WorkspaceDto({
    required this.id,
    required this.teamId,
    required this.name,
    required this.metas,
  });

  WorkspaceDto.builder({
    this.id = '',
    this.teamId = '',
    this.name = '',
    this.metas = const [],
  });

  Workspace toDomain(RecordMeta Function(String metaId) toMeta) => Workspace(
      id: id, name: name, metas: metas.map((e) => toMeta(e)).toList());

  @override
  toJson() => throw UnimplementedError("使用[$runtimeType]相关Extension的方法");
}

extension AttrTypeX on AttrType {
  AttrTypeDto toDto() => AttrTypeDto(tp, meta?.id);
}

/// 如果[tp]为[AttrTp.ref],则[r]不能为空
class AttrTypeDto {
  final AttrTp tp;

  final String? r;

  static const AttrTypeDto any = AttrTypeDto(AttrTp.any, null);
  static const AttrTypeDto num = AttrTypeDto(AttrTp.num, null);
  static const AttrTypeDto string = AttrTypeDto(AttrTp.string, null);
  static const AttrTypeDto boolean = AttrTypeDto(AttrTp.bool, null);

  const AttrTypeDto.ref(String r) : this(AttrTp.ref, r);

  const AttrTypeDto(this.tp, this.r);

  /// [name]可以仅为 AttrTp.name, 也可以是 type_$ref
  factory AttrTypeDto.by(String name, [String? ref]) =>
      (name.startsWith(refPrefix))
          ? AttrTypeDto.ref(name.substring(refPrefix.length))
          : AttrTypeDto(AttrTp.values.byName(name), ref);

  static Iterable<AttrTp> get values => AttrTp.values;

  /// [AttrTp.ref]类型的[r]前缀
  static final refPrefix = "${AttrTp.ref.name}_";

  String get tpName => tp.name;

  String get name => tp == AttrTp.ref ? "$refPrefix$r" : tpName;

  bool get isRef => tp == AttrTp.ref;

  AttrType toDomain(QueryMetaFn toMeta) => AttrType(
        tp,
        r,
        toMeta,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttrTypeDto &&
          runtimeType == other.runtimeType &&
          tp == other.tp &&
          r == other.r;

  @override
  int get hashCode => tp.hashCode ^ r.hashCode;

  @override
  String toString() => 'AttrType{tp: $tp, ref: $r}';

  /// 通过value的类型创建对应的[AttrTypeDto]
  static AttrTypeDto ofJsonType(JsonElementValueType? value) {
    if (value == null) return AttrTypeDto.string;

    switch (value) {
      case JsonElementValueType.numeric:
        return AttrTypeDto.num;
      case JsonElementValueType.bool:
        return AttrTypeDto.boolean;
      case JsonElementValueType.string:
      // 其他类型直接按照String处理
      case JsonElementValueType.array:
      case JsonElementValueType.map:
        return AttrTypeDto.string;
    }
  }
}

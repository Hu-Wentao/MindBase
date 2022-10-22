import 'dart:convert';
import 'dart:math' as math;
import 'package:appwrite/appwrite.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:json_editor/json_editor.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/core/infra/dto/dto_json_impl.dart';
import 'package:mind_base/src/core/inter/i_dto.dart';
import 'package:mind_base/src/user/inter/dto.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/domain/value/value.dart';
import 'package:mind_base/src/space/infra/ap_adapter.dart';
import 'package:quiver/core.dart';

import '../../../app/application/model.dart';

part 'expr_node_dto.dart';

part 'i_dto.freezed.dart';

part 'i_dto.g.dart';

@Deprecated('ValueDto')
typedef Value = ValueDto;

class ValueDto {
  dynamic v;

  get value => v;

  ValueDto.of(this.v);

  ValueDto.builder({this.v = ''});

  @Deprecated('无效')
  static fromDomain(Value value) => ValueDto.builder(v: value.v);

  @Deprecated('无效')
  Value toDomain() {
    // print("RcdValueDto.toDomain: $v, type: ${v.runtimeType}");
    return Value.of(v);
  }

  @override
  String toString() => 'ValueDto{v: $v}';
}

extension RecordX on RecordModel {
  RecordDto toDto() => data;
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

  final Map<int, ValueDto> fields;

  const RecordDto({this.fields = const {}});

  factory RecordDto.builder({
    String? id,
    String? metaId,
    Map<int, ValueDto> fields = const {},
  }) =>
      RecordDto(
          fields: {
        //      填入默认值
        0: ValueDto.of(id ??= ObjectIdX.createHex),
        1: ValueDto.of(metaId),
      }..addAll(fields));

  /// 从表单输入
  factory RecordDto.fromForm(MetaModel meta, Map<String, dynamic> formMap) {
    return RecordDto(
      fields: Map.fromEntries(meta.properties.map((attr) {
        final value = formMap[attr.propId];
        return MapEntry(attr.k, ValueDto.of(value));
      })),
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      throw UnimplementedError("使用[$runtimeType]相关Extension的方法");

  @override
  String toString() => 'RecordDto{fields: $fields}';
}

extension MetaModelX on MetaModel {
  MetaDto toDto() => data;
// MetaDto.fromDomain(this);
}

/// 权限类型
enum PermsType {
  owner, // 创建者可读写, 成员可读
  member, // 成员可读写
  openRead, // 成员可读写, 外部人员可读
  openWrite, // 所有人可读写
  unknown, // 其他自定义配置项
}

extension CollectionX on CollectionDto {
  updateBy(PermsType type, String teamId) {
    switch (type) {
      case PermsType.owner:
        reads
          ..clear()
          ..addAll(_member(teamId));
        writes
          ..clear()
          ..addAll(_owner(teamId));
        break;
      case PermsType.member:
        final m = _member(teamId);
        reads
          ..clear()
          ..addAll(m);
        writes
          ..clear()
          ..addAll(m);
        break;
      case PermsType.openRead:
        reads
          ..clear()
          ..addAll(Permissions.all.value);
        writes
          ..clear()
          ..addAll(_member(teamId));
        break;
      case PermsType.openWrite:
        reads
          ..clear()
          ..addAll(Permissions.all.value);
        writes
          ..clear()
          ..addAll(Permissions.all.value);
        break;
      case PermsType.unknown:
      default:
        return this;
    }
  }

  PermsType getType(String teamId) {
    if (writes.equals(_owner(teamId))) {
      return PermsType.owner;
    } else {
      final member = _member(teamId);
      if (writes.equals(member)) {
        if (reads.equals(member)) {
          return PermsType.member;
        } else if (reads.equals(Permissions.all.value)) {
          return PermsType.openRead;
        }
      } else if (writes.equals(Permissions.all.value)) {
        if (reads.equals(Permissions.all.value)) {
          return PermsType.openWrite;
        }
      }
    }
    return PermsType.unknown;
  }

  static _owner(String teamId) => Permissions.team(
        teamId: teamId,
        roles: [RoleX.owner(teamId)],
      ).value;

  static _member(String teamId) => Permissions.team(teamId: teamId).value;
}

///
/// 表信息, 控制读写权限与逻辑删除
/// 参见 https://appwrite.io/docs/permissions
class CollectionDto extends IDto {
  // 表级别权限控制
  static const levelCollection = 'collection';

  // 记录级别权限控制
  static const levelDocument = 'document';

  final List<String> reads;
  final List<String> writes;
  final bool? enabled;

  CollectionDto({
    required this.reads,
    required this.writes,
    this.enabled,
  });

  /// Record表 权限信息, 存放于Meta记录中
  CollectionDto.builder({Permissions? reads, Permissions? writes})
      : this(
          reads: reads?.value ?? const [],
          writes: writes?.value ?? const [],
        );

  // 适配新版本格式
  List<String> get permissions => ApAdapter.toPermissions(this);

  /// add
  CollectionDto add({Permissions? reads, Permissions? writes}) => this
    ..reads.addAll(reads?.value ?? const [])
    ..writes.addAll(writes?.value ?? const []);

  //
  @override
  Map<String, dynamic> toJson() => {
        'reads': reads,
        'writes': writes,
        'enabled': enabled,
      };

  static from(Collection? collection) {
    if (collection == null) return null;
    return CollectionDto(
      //  权限管理替换
      reads: ApAdapter.parsePermitToRead(collection),
      writes: ApAdapter.parsePermitToWrite(collection),
      enabled: collection.enabled,
    );
  }

  static fromForm(Map<String, dynamic> value) => CollectionDto(
        reads: (value['reads'] as String).split(','),
        writes: (value['writes'] as String).split(','),
        enabled: value['enabled'] as bool?,
      );

  @override
  Map<String, dynamic> toMap() => toJson();
}

///
/// [attrs]固定 0:表示Record的ID
class MetaDto extends IEntityDto {
  @override
  String id;
  String name;
  String memo;
  int maxKey; // 等于Table中出现过key的数量, 用于新增Attr/Method,只能增加
  List<AttributeDto> attrs;
  List<MethodDto> methods;
  List<TableView> views;

  MetaDto({
    required this.id,
    required this.name,
    required this.memo,
    required this.maxKey,
    List<AttributeDto>? attrs,
    List<MethodDto>? methods,
    List<TableView>? views,
  })  : // const [] 会导致 .add 方法报错
        attrs = attrs ?? [],
        methods = methods ?? [],
        views = views ?? [];

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
  factory MetaDto.builder({
    String? id,
    String name = "",
    String memo = "",
    List<AttributeDto>? attributes,
    List<MethodDto>? methods,
    List<TableView>? views,
  }) {
    final metaId = id ??= ObjectIdX.createHex;
    final attrs = attributes ??
        [
          AttributeDto.builder(
            k: 0,
            name: "ID",
            memo: "系统生成的唯一ID",
            // expr: Expression.field(metaId, 0, AttrType.objectId),
          ),
          AttributeDto.builder(
            k: 1,
            name: "metaId",
            memo: "元数据ID",
            // expr: Expression.field(metaId, 1, AttrType.objectId),
          ),
        ];
    return MetaDto(
      id: metaId,
      name: name,
      memo: memo,
      maxKey: attrs.length,
      attrs: attrs,
      methods: methods,
      views: views,
    );
  }

  // 从Form中获取的Map
  MetaDto build(
    Map<String, String> map,
    List<AttributeDto> attributes,
    List<MethodDto> methods,
    List<TableView>? views,
  ) =>
      MetaDto(
        id: (map['id']!),
        name: map['name']!,
        memo: map['memo']!,
        maxKey: int.parse(map['maxKey']!),
        attrs: attributes,
        methods: methods,
        views: views,
      );

  factory MetaDto.fromForm(
    Map<String, dynamic> map,
    List<AttributeDto> attrs,
    List<MethodDto> methods,
  ) =>
      MetaDto(
        // form中是'id', 而不是'_id'
        id: (map['id'] as String),
        name: map['name'] as String,
        memo: map['memo'] as String,
        // todo 后期考虑将k移动到form中
        maxKey: attrs.map((e) => e.k).reduce(math.max),
        attrs: attrs,
        methods: methods,
      );

  @override
  Map<String, dynamic> toJson() =>
      throw UnimplementedError("使用[$runtimeType]相关Extension的方法");

  @override
  String toString() {
    return 'MetaDto{id: $id, name: $name, memo: $memo, maxKey: $maxKey, attrs: $attrs, methods: $methods, views: $views}';
  }

  MetaDto updateView(TableView view) {
    // 保留meta中存在的props (view中有,但meta中已被移除的列Info 将被删除)
    view.cols.retainWhere((ele) =>
        attrs.any((at) => at.propId == ele.propId) ||
        methods.any((mt) => mt.propId == ele.propId));

    final vId = view.vId;
    if (vId != -1) {
      // k (view)已存在, 更新view(只涉及Meta)
      final idx = views.indexWhere((v) => v.vId == vId);
      views.replaceRange(idx, idx + 1, [view]);
    } else {
      // k (view)不存在, 新增view
      final v = view.updateIndex(views);
      views.add(v);
    }
    return this;
  }
}

abstract class PropertyDto extends IDto {
  int k; // 表头key,对应Field:k,需要从所在的TableMeta中获取
  String name; // 表头名称
  String memo; // 表头备注
  AttrTypeDto get type; // 最终返回值类型
  PropertyDto({
    required this.k,
    required this.name,
    required this.memo,
  });

  String get propId => '$k';
}

extension MethodX on Method {
  MethodDto toDto() => MethodDto.ofDomain(this);
}

class MethodDto extends PropertyDto {
  IExprNodeDto expr;

  @override
  AttrTypeDto get type => expr.type!;

  MethodDto({
    required super.k,
    required super.name,
    required super.memo,
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

  String get propId => PropertyX.getPropId(false, k);

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

  Map<String, dynamic> toMap() => toJson();

  @override
  Map<String, dynamic> toJson() =>
      throw UnimplementedError("使用[$runtimeType]相关Extension的方法");
}

extension AttrbuteX on Attribute {
  AttributeDto toDto() => AttributeDto.ofDomain(this);
}

extension AttrTypeDtoX on AttrTypeDto {
  // 请确保type是ref类型,否则报错
  MetaModel fetchMeta(SpaceModel space) => space.queryMeta(r!);
}

/// 表头/属性: 关系/表的一列叫属性
class AttributeDto extends PropertyDto {
  @override
  AttrTypeDto type;

  AttributeDto({
    required super.k,
    required super.name,
    required super.memo,
    required this.type,
  });

  @override
  String get propId => PropertyX.getPropId(true, k);

  /// 供Form初始化
  AttributeDto.builder({
    @Deprecated("无意义参数") String? metaId,
    int k = 0,
    String name = "",
    String memo = "",
    AttrTypeDto type = AttrTypeDto.string,
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

  Map<String, dynamic> toMap() => toJson();

  @override
  Map<String, dynamic> toJson() =>
      throw UnimplementedError("使用[$runtimeType]相关Extension的方法");
}

@freezed
class SpaceDto with _$SpaceDto implements IEntityDto {
  const SpaceDto._();

  const factory SpaceDto({
    @Default('') String id,
    @Default('') String name,
    @Default('') String teamId,
    @Default([]) List<String> metas,
  }) = _SpaceDto;

  factory SpaceDto.fromJson(Map<String, dynamic> json) =>
      _$SpaceDtoFromJson(json);

  @override
  Map<String, dynamic> toMap() => toJson();
}

extension AttrTypeX on AttrType {
  AttrTypeDto toDto() => AttrTypeDto(tp, meta?.id);

  // 请确保type是ref类型,否则报错
  MetaModel fetchMeta(SpaceModel space) => space.queryMeta(r!);
}

/// 如果[tp]为[AttrTp.ref],则[r]不能为空
class AttrTypeDto {
  final AttrTp tp;

  final String? r;

  @Deprecated("考虑移除any类型, 默认用string")
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

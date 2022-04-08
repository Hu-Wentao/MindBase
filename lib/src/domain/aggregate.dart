import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' hide Type;

import 'entity/func.dart';

/// 表 =========================================================================

/// 记录
/// 必须通过DTO转换 [RecordDto]
/// fields[0] 始终为 [id]
class Record extends Equatable implements IEtt<ObjectId> {
  @override
  final ObjectId id;
  final RecordMeta meta; // Aggregate组装得到,实际只存储Id
  final Map<int, Value> fields;
  final Map<int, Method> methods;

  const Record({
    required this.id,
    required this.meta,
    required this.fields,
    required this.methods,
  });

  @override
  get props => [id, meta, fields];

  factory Record.of({
    ObjectId? id,
    required RecordMeta meta,
    required Map<int, Value> fields,
  }) {
    final recordId = id ?? ObjectId();
    return Record(
      id: recordId,
      meta: meta,
      fields: {
        0: Value.of(recordId.toHexString()),
        1: Value.of(meta.id.toHexString()),
      }..addAll(fields),
      methods: meta.methodMap,
    );
  }

  RecordDto toDto() => RecordDto.fromDomain(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Record &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          meta == other.meta &&
          fields == other.fields;

  @override
  int get hashCode => id.hashCode ^ meta.hashCode ^ fields.hashCode;

  @override
  String toString() => toDto().toString();

  /// Value不存在时返回一个空Value
  Value getFieldByColumn(String name) =>
      tryGetFieldByColumn(name, orElse: (_) => Value.of(''))!;

  Value? tryGetFieldByColumn(String name, {Value Function(int k)? orElse}) {
    final propId = Property.parsePropId(name);
    return tryGetFieldBy(propId.value2, orElse: orElse);
  }

  Value getFieldBy(int attrKey, {Value Function(int k)? orElse}) =>
      tryGetFieldBy(attrKey) ??
      orElse?.call(attrKey) ??
      (throw "找不到属性: [$attrKey] 对应的字段");

  Value? tryGetFieldBy(int attrKey, {Value Function(int k)? orElse}) =>
      fields[attrKey] ?? orElse?.call(attrKey);

  Method? tryGetMethodBy(int methodKey, {Method Function(int k)? orElse}) =>
      methods[methodKey] ?? orElse?.call(methodKey);

  /// 根据属性名称获取属性值(同时调用表达式进行计算)
  Value getValueBy(Property prop) {
    final propId = Property.parsePropId(prop.propId);
    if (prop is Method) {
      final method = tryGetMethodBy(propId.value2)!;
      return method.expr.invoke() as Value; // todo 目前只有 0参数的方法, 尚不支持传参的方法
    }
    return getFieldBy(prop.k);
  }

  @Deprecated("只能更新字段值")
  Record updateWith({required String propId, required Value value}) {
    return Record(
      id: id,
      meta: meta,
      fields: fields..[Property.parsePropId(propId).value2] = value,
      methods: methods,
    );
  }
}

/// Meta信息
/// 必须通过DTO转换 [RecordMetaDto]
class RecordMeta extends Equatable implements IEtt<ObjectId> {
  @override
  final ObjectId id;
  final String name;
  final String memo;
  final int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
  final List<Attribute> attrs; // 字段表
  final List<Method> methods; // 方法表

  Map<int, Method> get methodMap =>
      Map.fromEntries(methods.map((e) => MapEntry(e.k, e)).toList());

  // 表头
  List<Property> get properties => [...attrs, ...methods];

  const RecordMeta({
    required this.id,
    required this.name,
    required this.memo,
    required this.maxKey,
    required this.attrs,
    required this.methods,
  });

  @override
  List<Object?> get props => [id, name, memo, maxKey, properties];

  int nextKey() => maxKey + 1;

  // table新增Attr
  RecordMeta addAttr(Attribute attr) {
    if (attr.k != nextKey()) {
      throw "逻辑异常! 新增的Attr::k[${attr.k}] 不等于table[$name]的maxKey[$maxKey]+1";
    }
    return RecordMeta(
      id: id,
      name: name,
      memo: memo,
      maxKey: nextKey(),
      attrs: attrs..add(attr),
      methods: methods,
      // properties: properties..add(attr),
    );
  }

  RecordMetaDto toDto() => RecordMetaDto.fromDomain(this);

  @override
  String toString() => toDto().toString();
}

/// 是 [Attribute]和[Method]的父类
abstract class Property extends Equatable {
  final int k; // 表头key,对应Field:k,需要从所在的TableMeta中获取
  final String name; // 表头名称
  final String memo; // 表头备注
  AttrType get type; // 最终返回值类型

  /// 字段或属性在一个Meta中的唯一标识
  /// 在字符串开头使用 m标识[Methods], 使用 a标识[Attribute]
  String get propId => '${(this is Attribute) ? 'a' : 'm'}$k';

  static Tuple2<String, int> parsePropId(String propId) => Tuple2(
        propId.substring(0, 1),
        int.parse(propId.substring(1)),
      );

  const Property(this.k, this.name, this.memo);

  static const subTypeMap = {
    Method: 'm',
    Attribute: 'a',
  };

  String get toSubTypeSign => subTypeMap[runtimeType]!;

  Type getSubTypeBySign(String sign) {
    final subType = subTypeMap.entries
        .firstWhere((e) => e.value == sign,
            orElse: () => throw "找不到类型标识: [$sign]")
        .key;
    return subType;
  }

  @override
  List<Object> get props => [k, name, memo, type];
}

class Method extends Property {
  // 方法体
  final Expression expr;

  const Method({
    required int k,
    required String name,
    required String memo,
    required this.expr,
  }) : super(k, name, memo);

  @override
  List<Object> get props => super.props..addAll([expr]);

  MethodDto toDto() => MethodDto.ofDomain(this);

  @override
  AttrType get type => expr.type;
}

class Attribute extends Property {
  @override
  final AttrType type; // 类型
  final RecordMeta? meta; //如果type是"ref", 该值不为空,存储被引用的MetaId

  const Attribute({
    required int k,
    required String name,
    required String memo,
    required this.type,
    this.meta,
  }) : super(k, name, memo);

  @override
  List<Object> get props => super.props..addAll([if (meta != null) meta!]);

  AttributeDto toDto() => AttributeDto.ofDomain(this);

  @override
  String toString() => toDto().toString();
}

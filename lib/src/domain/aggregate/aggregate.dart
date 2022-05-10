import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/expression_parser.dart';
import 'package:mind_base/src/domain/entity/entity.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' hide Type;

/// 表 =========================================================================

/// 记录
/// 必须通过DTO转换 [RecordDto]
/// fields[0] 始终为 [id]
class Record implements IEtt<ObjectId> {
  @override
  final ObjectId id;
  final RecordMeta meta; // Aggregate组装得到,实际只存储Id
  Map<int, Value> fields;

  List<Method> get methods => meta.methods; // method自带k值

  Record({
    required this.id,
    required this.meta,
    required this.fields,
  });

  factory Record.of({
    ObjectId? id,
    required RecordMeta meta,
    required Map<int, Value> fields,
  }) {
    final recordId = id ?? ObjectId(clientMode: true);
    return Record(
      id: recordId,
      meta: meta,
      fields: {
        0: Value.of(recordId.toHexString()),
        1: Value.of(meta.id.toHexString()),
      }..addAll(fields),
    );
  }

  RecordDto toDto() => RecordDto.fromDomain(this);

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
      (throw "找不到attrKey: [$attrKey] 对应的Field");

  Value? tryGetFieldBy(int attrKey, {Value Function(int k)? orElse}) =>
      fields[attrKey] ?? orElse?.call(attrKey);

  Method? tryGetMethodBy(int methodKey, {Method Function(int k)? orElse}) =>
      methods.firstWhere((mth) => mth.k == methodKey,
          orElse: () =>
              orElse?.call(methodKey) ??
              (throw "找不到attrKey: [$methods] 对应的Method"));

  static ExpressionParser parser = ExpressionParser();

  /// 根据属性名称获取属性值(同时调用表达式进行计算)
  Value getValueBy(Property prop) {
    if (prop is Method) {
      final method = prop;
      return Value.of(method.eval(this));
    } else {
      return getFieldBy(prop.k, orElse: (_) => Value.of(null)); // 填充一个null默认值
    }
  }

  // // fixme 待完善
  // getPropBy(String propId) {
  //   print("debug # getPropBy# propId: $propId");
  //   final parsedPropId = Property.parsePropId(propId);
  //   if (parsedPropId.value1 == 'm') {
  //     return tryGetMethodBy(parsedPropId.value2);
  //   } else {
  //     return tryGetFieldBy(parsedPropId.value2);
  //   }
  // }

  // 更新属性值
  void update(Record record) {
    assert(id == record.id, "Record::update,当前ID[$id]与更新ID[${record.id}]不一致!");
    fields = record.fields;
  }

  @Deprecated("只能更新字段值")
  Record updateWith({required String propId, required Value value}) {
    return Record(
      id: id,
      meta: meta,
      fields: fields..[Property.parsePropId(propId).value2] = value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Record &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          meta == other.meta &&
          fields == other.fields &&
          methods == other.methods;

  @override
  int get hashCode =>
      id.hashCode ^ meta.hashCode ^ fields.hashCode ^ methods.hashCode;
}

/// Meta信息
/// 必须通过DTO转换 [RecordMetaDto]
class RecordMeta implements IEtt<ObjectId> {
  @override
  final ObjectId id;
  String name;
  String memo;
  int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
  List<Attribute> attrs; // 字段表
  List<Method> methods; // 方法表

  Map<int, Method> get methodMap =>
      Map.fromEntries(methods.map((e) => MapEntry(e.k, e)).toList());

  // 表头
  List<Property> get properties => [...attrs, ...methods];

  RecordMeta({
    required this.id,
    required this.name,
    required this.memo,
    required this.maxKey,
    required this.attrs,
    required this.methods,
  });

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

  Method? tryGetMethodBy(String member) {
    for (final method in methods) {
      if (method.name == member) return method;
    }
    return null;
  }

  Property getPropBy(String propId) =>
      properties.firstWhere((prop) => prop.propId == propId);

  bool hasPropBy(String propId) =>
      properties.any((prop) => prop.propId == propId);

  RecordMetaDto toDto() => RecordMetaDto.fromDomain(this);

  @override
  String toString() => "RecordMeta#${toDto()}";

  void update(RecordMeta meta) {
    assert(id == meta.id, "Meta::update,当前ID[$id]与更新ID[${meta.id}]不一致!");
    name = meta.name;
    memo = meta.memo;
    maxKey = meta.maxKey;
    attrs = meta.attrs;
    methods = meta.methods;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordMeta &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          memo == other.memo &&
          maxKey == other.maxKey &&
          attrs == other.attrs &&
          methods == other.methods;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      memo.hashCode ^
      maxKey.hashCode ^
      attrs.hashCode ^
      methods.hashCode;
}


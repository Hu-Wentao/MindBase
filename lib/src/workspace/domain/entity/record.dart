part of '../aggregate/aggregate.dart';

/// 表 =========================================================================

/// 记录
/// 必须通过DTO转换 [RecordDto]
/// fields[0] 始终为 [id]
class Record implements IEtt<String> {
  @override
  final String id;
  final RecordMeta meta; // Aggregate组装得到,实际只存储Id
  Map<int, Value> fields;

  List<Method> get methods => meta.methods; // method自带k值

  Record({
    required this.id,
    required this.meta,
    required this.fields,
  });

  factory Record.of({
    String? id,
    required RecordMeta meta,
    required Map<int, Value> fields,
  }) =>
      Record(
        id: id ??= ObjectIdX.createHex,
        meta: meta,
        fields: {
          0: Value.of(id),
          1: Value.of(meta.id),
        }..addAll(fields),
      );

  /// Value不存在时返回一个空Value
  @Deprecated("使用 getField")
  Value getFieldByColumn(String name) =>
      tryGetFieldByColumn(name, orElse: (_) => Value.of(''))!;

  @Deprecated("使用 getField")
  Value? tryGetFieldByColumn(String name, {Value Function(int k)? orElse}) {
    final propId = Property.parsePropId(name);
    return tryGetFieldBy(propId.value2, orElse: orElse);
  }

  @Deprecated("使用 getField")
  Value getFieldBy(int attrKey, {Value Function(int k)? orElse}) =>
      tryGetFieldBy(attrKey) ??
      orElse?.call(attrKey) ??
      (throw "找不到attrKey: [$attrKey] 对应的Field");

  @Deprecated("使用 getField")
  Value? tryGetFieldBy(int attrKey, {Value Function(int k)? orElse}) =>
      fields[attrKey] ?? orElse?.call(attrKey);

  ExprValue getFieldByAttrName(String name) => getField(name.parsePropK);

  ExprValue getField(int attrKey) {
    final prop = meta.attrs.firstWhere((attr) => attr.k == attrKey);
    final value = tryGetFieldBy(attrKey);
    return ExprValue.build(
        type: prop.type, ag: value?.ag ?? ['', "Error#找不到Value值"]);
  }

  Method? tryGetMethodBy(int methodKey, {Method Function(int k)? orElse}) =>
      methods.firstWhere((mth) => mth.k == methodKey,
          orElse: () =>
              orElse?.call(methodKey) ??
              (throw "找不到attrKey: [$methods] 对应的Method"));

  static ExpressionParser parser = ExpressionParser();

  /// 根据属性名称获取属性值(同时调用表达式进行计算)
  Value getValueBy(Property prop, FindRecordFn find) {
    if (prop is Method) {
      final method = prop;
      return Value.of(method.eval(this, find));
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

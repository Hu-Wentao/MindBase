import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

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

  const Record({
    required this.id,
    required this.meta,
    required this.fields,
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

  Value? tryGetFieldByColumn(String name, {Value Function(int k)? orElse}) =>
      tryGetFieldBy(int.parse(name), orElse: orElse);

  Value getFieldBy(int attrKey, {Value Function(int k)? orElse}) =>
      tryGetFieldBy(attrKey) ??
      orElse?.call(attrKey) ??
      (throw "找不到属性: [$attrKey] 对应的字段");

  Value? tryGetFieldBy(int attrKey, {Value Function(int k)? orElse}) =>
      fields[attrKey] ?? orElse?.call(attrKey);

  /// 根据属性名称获取属性值(同时调用表达式进行计算)
  Value getValueWithCalc(Attribute attr) {
    // fixme 或许 invoke() 的返回值应当限定为Value, 否则可能会造成循环引用...
    // fixme 如何处理 "self"类型的表达式?? invoke() 是否应该传入参数,包括但不限于"Value所属Attr","Value所属Record"?
    return attr.calc.invoke() as Value;
  }

  Record updateWith({required int attrKey, required Value value}) => Record(
        id: id,
        meta: meta,
        fields: fields..[attrKey] = value,
      );
}

/// Meta信息
/// 必须通过DTO转换 [RecordMetaDto]
class RecordMeta extends Equatable implements IEtt<ObjectId> {
  @override
  final ObjectId id;
  final String name;
  final String memo;
  final int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
  final List<Attribute> attributes; // 表头
  const RecordMeta({
    required this.id,
    required this.name,
    required this.memo,
    required this.maxKey,
    required this.attributes,
  });

  @override
  List<Object?> get props => [id, name, memo, maxKey, attributes];

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
      attributes: attributes..add(attr),
    );
  }

  RecordMetaDto toDto() => RecordMetaDto.fromDomain(this);

  @override
  String toString() => toDto().toString();
}

class Attribute extends Equatable {
  final int k; // 表头key,对应Field:k,需要从所在的TableMeat中获取
  final String name; // 表头名称
  final String memo; // 表头备注
  final Expression calc; // 计算表达式
  AttrType get type => calc.type;

  // todo 读写权限等..

  // Func的默认值应当为 NoneFunc
  @Deprecated('可能是不必要的')
  final Func check; // 校验函数, 如果出错则会将错误信息记录到e字段中

  const Attribute({
    required this.k,
    required this.name,
    required this.memo,
    required this.calc,
    required this.check,
  });

  @override
  List<Object?> get props => [k, name, memo, calc, check];

  // // 检查当前函数值是否合法
  // @protected
  // Field onCheck(Field f) => checkFunc.run([f]);
  //
  // // 用户输入值
  // Field onSet(String value) {
  //   return onInput(Field.of(value));
  // }
  //
  // // 先检查后输入
  // // Filed f 一般来自其他列,因此这里使用自带的 ::k
  // Field onInput(Field f) {
  //   final r = onCheck(f);
  //   return inputFunc.run([r]);
  // }
  //
  // // 先输出后检查
  // // 输出当前函数值(进行一些转换),最后进行检查
  // Field onOutput(Field f) {
  //   final r = outputFunc.run([f]);
  //   return onCheck(r);
  // }

  AttributeDto toDto() => AttributeDto.ofDomain(this);

  @override
  String toString() => toDto().toString();
}

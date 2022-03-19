import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'entity/func.dart';

/// 表 ============================================ =============================

/// 记录
/// 必须通过DTO转换 [RecordDto]
/// fields[0] 始终为 [id]
class Record implements IEtt<ObjectId> {
  @override
  final ObjectId id;
  final RecordMeta meta; // Aggregate组装得到,实际只存储Id
  final Map<int, Value> fields;

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
    final recordId = id ?? ObjectId();
    return Record(
      id: recordId,
      meta: meta,
      fields: fields..[0] = Value.of(recordId.toHexString()),
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
}

/// Meta信息
/// 必须通过DTO转换 [RecordMetaDto]
class RecordMeta implements IEtt<ObjectId> {
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


  /// fixme 没什么用, 可能导致Bug, 考虑移除
  @Deprecated("移除")
  factory RecordMeta.of({
    ObjectId? id,
    required String name,
    String memo = "",
    List<AttrInMetaBuilder> attributes = const [],
  }) {
    if (name.isEmpty) {
      throw ArgumentError("name cannot be empty");
    }
    return RecordMeta(
        id: id ?? ObjectId(),
        name: name,
        memo: memo,
        maxKey: attributes.length,
        attributes: attributes
            .asMap()
            .entries
            .map((e) => e.value.build(e.key))
            .toList());
  }

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordMeta &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          memo == other.memo &&
          maxKey == other.maxKey &&
          attributes == other.attributes;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      memo.hashCode ^
      maxKey.hashCode ^
      attributes.hashCode;

  @override
  String toString() => toDto().toString();
}

/// fixme 合并到DTO[AttributeDto]中
class AttrInMetaBuilder {
  final String name; // 表头名称
  final String memo; // 表头备注
  final AttrType type; // 字段类型
  final String checkFuncName;

  AttrInMetaBuilder(this.name, this.memo, this.type, this.checkFuncName);

  Attribute build(int key) => AttributeDto(
        k: key,
        name: name,
        memo: memo,
        type: type,
        checkFuncName: checkFuncName,
      ).toDm((funName) => FuncManager.findBy(funName));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttrInMetaBuilder &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          memo == other.memo &&
          type == other.type &&
          checkFuncName == other.checkFuncName;

  @override
  int get hashCode =>
      name.hashCode ^ memo.hashCode ^ type.hashCode ^ checkFuncName.hashCode;
}

class Attribute {
  final int k; // 表头key,对应Field:k,需要从所在的TableMeat中获取
  final String name; // 表头名称
  final String memo; // 表头备注
  final AttrType type; // 字段类型
  // todo 读写权限等..

  // Func的默认值应当为 NoneFunc
  final Func check; // 校验函数, 如果出错则会将错误信息记录到e字段中

  Attribute({
    required this.k,
    required this.name,
    required this.memo,
    required this.type,
    required this.check,
  });

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attribute &&
          runtimeType == other.runtimeType &&
          k == other.k &&
          name == other.name &&
          memo == other.memo &&
          type == other.type &&
          check == other.check;

  @override
  int get hashCode =>
      k.hashCode ^
      name.hashCode ^
      memo.hashCode ^
      type.hashCode ^
      check.hashCode;
}

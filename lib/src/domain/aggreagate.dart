import 'package:flutter/foundation.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

import 'entity.dart';

/// 表 =========================================================================

/// 记录
/// 必须通过DTO转换 [RecordDto]
class Record {
  final ObjectId id;
  final RecordMeta meta; // Aggregate组装得到,实际只存储Id
  final List<Field> fields;

  Record(this.id, this.meta, this.fields);

  RecordDto toDto() => RecordDto.fromDomain(id, meta.id, fields);
}

/// Meta信心
/// 必须通过DTO转换 [RecordMetaDto]
class RecordMeta {
  final ObjectId id;
  final String name;
  final String memo;
  final int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
  final List<Attribute> attributes; // 表头
  const RecordMeta(this.id, this.name, this.memo, this.maxKey, this.attributes);

  int nextKey() => maxKey + 1;

  // table新增Attr
  RecordMeta addAttr(Attribute attr) {
    if (attr.k != nextKey()) {
      throw "逻辑异常! 新增的Attr::k[${attr.k}] 不等于table[$name]的maxKey[$maxKey]+1";
    }
    return RecordMeta(id, name, memo, nextKey(), attributes..add(attr));
  }

  RecordMetaDto toDto() => RecordMetaDto.fromDomain(
      id, name, memo, maxKey, attributes.map((a) => a.toDto()).toList());
}

class Attribute {
  final int k; // 表头key,对应Field:k,需要从所在的TableMeat中获取
  final String name; // 表头名称
  final String memo; // 表头备注
  final AttrType type; // 字段类型
  // todo 读写权限等..

  // Func的默认值应当为 NoneFunc
  final BaseFunc _inputFunc; // 预处理函数,可以用于设置默认值
  final BaseFunc _checkFunc; // 校验函数, 如果出错则会将错误信息记录到e字段中
  final BaseFunc _outputFunc; // 输出函数,

  Attribute(this.k, this.name, this.memo, this.type, this._inputFunc,
      this._checkFunc, this._outputFunc);

  // 检查当前函数值是否合法
  @protected
  Field onCheck(Field f) => _checkFunc.run(k, [f]);

  // 用户输入值
  Field onSet(String value) {
    return onInput(Field.of(k, value));
  }

  // 先检查后输入
  // Filed f 一般来自其他列,因此这里使用自带的 ::k
  Field onInput(Field f) {
    final r = onCheck(f);
    return _inputFunc.run(k, [r]);
  }

  // 先输出后检查
  // 输出当前函数值(进行一些转换),最后进行检查
  Field onOutput(Field f) {
    final r = _outputFunc.run(k, [f]);
    return onCheck(r);
  }

  AttributeDto toDto() => AttributeDto(
      k, name, memo, type, _inputFunc.id, _checkFunc.id, _outputFunc.id);
}

import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' hide Field;

import 'entity/func.dart';

/// 表 =========================================================================

/// 记录
/// 必须通过DTO转换 [RecordDto]
class Record {
  final ObjectId id;
  final RecordMeta meta; // Aggregate组装得到,实际只存储Id
  final Map<int, Value> fields;

  Record({
    required this.id,
    required this.meta,
    required this.fields,
  });

  RecordDto toDto() => RecordDto.fromDomain(this);
}

/// Meta信心
/// 必须通过DTO转换 [RecordMetaDto]
class RecordMeta {
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
}

class Attribute {
  final int k; // 表头key,对应Field:k,需要从所在的TableMeat中获取
  final String name; // 表头名称
  final String memo; // 表头备注
  final AttrType type; // 字段类型
  // todo 读写权限等..

  // Func的默认值应当为 NoneFunc
  final Func inputFunc; // 预处理函数,可以用于设置默认值
  final Func checkFunc; // 校验函数, 如果出错则会将错误信息记录到e字段中
  final Func outputFunc; // 输出函数,

  Attribute({
    required this.k,
    required this.name,
    required this.memo,
    required this.type,
    required this.inputFunc,
    required this.checkFunc,
    required this.outputFunc,
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
}

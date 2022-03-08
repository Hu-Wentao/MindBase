import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// 字段  =======================================================================

/// 分量/字段/属性: 元组的某个属性值叫做分量.(一行记录叫元组Tuple)
class Field {
   final int k; // 分量的id,(不代表分量在UI中的位置)
  final String v; // 字段存储值
  String? e; // 字段错误信息

  Field(this.k, this.v, this.e);

  Field.of(this.k, this.v, [this.e]);

  Field.err(this.k, this.e) : v = "";
}

/// 表头/属性: 关系/表的一列叫属性
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
}

enum AttrType {
  any, // 任意类型
  string,
  number,
  boolean,
  date,
}

/// 函数 ========================================================================

// 多数BaseFunc只存于程序中, 只允许被实现, 不需要被持久化;例如 加减乘除等
// 某些带有属性的Func除外,如regex转换Func,自身存储了regex表达式
// todo 方案A: 部分持久化: 考虑分为 calc函数和trans函数,calc都是实现类,不能持久化;trans是regex转换,都需要持久化
// todo 方案B: 全局持久化: 不同的实现类都持久化为不同的文档,对于calc同一个类的不同实例,其id含义为"不同版本的函数标识"
// todo feat A: 为Func添加 tag属性,便于用户自己查询使用,提供默认的sys函数tag,用户自己也可以创建私有函数tag;可能需要单独建立tag表,用于保存对应关系
abstract class BaseFunc {
  final ObjectId id; // id是有必要的,因为用户自己会定义函数,使得::name重复
  final String name;
  final Set<FuncScope> scopes; // 函数适用范围
  final Range argsLenRange; // 函数参数个数, -1表示无限制
  final AttrType inType; // 输入类型
  final AttrType outType; // 输出类型

  const BaseFunc(
    this.id,
    this.name,
    this.scopes,
    this.argsLenRange,
    this.inType,
    this.outType,
  );

  // 对输入参数进行检查
  Field run(int k, List<Field> inputs) {
    if (argsLenRange.inBound(inputs.length)) {
      return Field.err(k,
          "函数[$runtimeType]输入参数数量[${inputs.length}]过多,最多只能输入[$argsLenRange]个参数");
    }
    return onRun(inputs);
  }

  @protected
  Field onRun(List<Field> inputs);
}

class Range {
  final int min;
  final int max;

  const Range(this.min, this.max);

  const Range.equal(int n)
      : min = n,
        max = n;

  bool inBound(int v) => v >= min && v <= max;
}

enum FuncScope {
  input, // 输入处理, 将输入的值转换为`存储值`
  check, // 字段检查, input完成后被调用,检查字段值是否符合要求,不符合则将错误信息添加到e中
  output, // 输出处理, 将`存储值`转换为需要数据.如 func为 "数值*2", 则存储"A1",输出为 A1*2的值
}

// Func实现-无处理
class NoneFunc extends BaseFunc {
  NoneFunc()
      : super(
          ObjectId.fromHexString("6226adf527b60ea31165e4e3"),
          'None',
          {FuncScope.input, FuncScope.check, FuncScope.output},
          const Range.equal(1),
          AttrType.any,
          AttrType.any,
        );

  @override
  Field onRun(List<Field> inputs) => inputs[0];
}

/// 表 =========================================================================

class TableMeta {
  final ObjectId id;
  final String name;
  final String memo;
  final int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
  final List<Attribute> attributes; // 表头
  const TableMeta(this.id, this.name, this.memo, this.maxKey, this.attributes);

  int nextKey() => maxKey + 1;

  // table新增Attr
  TableMeta addAttr(Attribute attr) =>
      TableMeta(id, name, memo, nextKey(), attributes..add(attr));
}

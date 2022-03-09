import 'package:flutter/foundation.dart';
import 'package:mind_base/src/domain/value.dart';

/// 函数 ========================================================================

// 多数BaseFunc只存于程序中, 只允许被实现, 不需要被持久化;例如 加减乘除等
// 某些带有属性的Func除外,如regex转换Func,自身存储了regex表达式
// todo 方案A: 部分持久化: 考虑分为 calc函数和trans函数,calc都是实现类,不能持久化;trans是regex转换,都需要持久化
// todo 方案B: 全局持久化: 不同的实现类都持久化为不同的文档,对于calc同一个类的不同实例,其id含义为"不同版本的函数标识"
// todo feat A: 为Func添加 tag属性,便于用户自己查询使用,提供默认的sys函数tag,用户自己也可以创建私有函数tag;可能需要单独建立tag表,用于保存对应关系
abstract class BaseFunc {
  final String id; // id是有必要的,因为用户自己会定义函数,使得::name重复
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
      return Field.err(
          "函数[$runtimeType]输入参数数量[${inputs.length}]过多,最多只能输入[$argsLenRange]个参数");
    }
    return onRun(inputs);
  }

  @protected
  Field onRun(List<Field> inputs);
}

// Func实现-无处理-单例
class NoneFunc extends BaseFunc {
  NoneFunc()
      : super(
          "6226adf527b60ea31165e4e3",
          'None',
          {FuncScope.input, FuncScope.check, FuncScope.output},
          const Range.equal(1),
          AttrType.any,
          AttrType.any,
        );

  @override
  Field onRun(List<Field> inputs) => inputs[0];
}

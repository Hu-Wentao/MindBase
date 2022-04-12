import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/value.dart';
import 'dart:math' as math;

part 'func_manager.dart';

/// 函数 ========================================================================
@Deprecated("使用IFunctor取代Invokable; invoke就是 get value")
mixin Invokable on IFunctor, EquatableMixin {
  Invokable invoke();

// Invokable invoke([List<Invokable> params]);
}

/// 表达式[Expression]由多个[Func]构成
/// 表达式是有状态的,存储了参数的来源,返回值类型等等; 而Func是无状态,只有name
/// 如果是Value，则pTypes为空， expr为表达式的内容， rType为返回值类型
class Expression extends IFunctor with EquatableMixin, Invokable {
  final Func func;
  final List<Invokable> args;

  const Expression(this.func, this.args);

  AttrType get type => func.rType;

  @override
  Invokable invoke() {
    // Invokable invoke([List<Invokable> params = const []]) {
    // todo 出入参数量,类型检查
    // invoke 最终的结果必然是Value类型
    final List<Value> values =
        args.map((arg) => arg.invoke() as Value).toList();
    return func.onInvoke(values);
  }

  @override
  List<Object?> get props => [func, args];

  // @override
  // IFunctor fMap(Func fn) {
  //   // TODO: implement fMap
  //   throw UnimplementedError();
  // }

  @override
  Value get value => invoke() as Value;
}

/// Func 的实例相当于 Dart的external函数
class Func with EquatableMixin {
  final String name; // 全局唯一
  final List<AttrType> pTypes;

  // todo 新增一个动态获取 rType的方法，针对Any类型的返回值，可以通过方法得到实际的返回类型，而不是Any
  final AttrType rType;

  // run 只有运算, 在调用之前,需要先检查Attr的类型匹配问题
  final dynamic Function(List p) logic;

  IFunctor apply(List<IFunctor> p) {
    try {
      // fixme 未作细节处理，如保留原值等
      return logic(p);
    } catch (e) {
      return Value('', e.toString());
    }
  }

  @Deprecated("message attr-v5后不可用")
  Invokable onInvoke(List<Value> p) {
    try {
      // fixme 未作细节处理，如保留原值等
      return logic(p) as Invokable;
    } catch (e) {
      return Value('', e.toString());
    }
  }

  const Func({
    required this.name,
    required this.pTypes,
    required this.rType,
    required this.logic,
  });

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
      };

  @override
  toMongoJson({AttrType type = AttrType.string}) => toJson();

  static Func fromJson(Map<String, dynamic> json) =>
      FuncManager.findBy(json['name'] as String);
}

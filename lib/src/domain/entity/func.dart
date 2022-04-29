import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/value.dart';
import 'dart:math' as math;

import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

part 'func_manager.dart';

abstract class IExpr with IFunctor {
  const IExpr();

  /// 不常用, 如果是 [ExpressionDto]转换成 [IExpr], 则需要使用 [ExprDtoToDomain],结合ctx上下文做转换
  factory IExpr.of(Func fn, List<dynamic> ag, AttrType type) {
    if (fn is AsFunc) {
      return Value(fn: fn, ag: ag);
    } else if (ag is List<IExpr>) {
      return Expression(fn: fn, ag: ag, type: type);
    } else {
      throw "IExpr.of构造失败#fn名称与类型: [${fn.name}][${fn.runtimeType}] #ag参数# ${ag.join(", ")}";
    }
  }

  Func get fn;

  /// 调用后即为 [value]
  callee();

  // 返回值类型
  AttrType get type;

  List<dynamic> get ag;
}

/// 表达式[Expression]由多个[Func]构成
/// 表达式是有状态的,存储了参数的来源,返回值类型等等; 而Func是无状态,只有name
/// 如果是Value，则pTypes为空， expr为表达式的内容， rType为返回值类型
/// 如果Expression作为方法体, 则 ag[0]应当为`this`
class Expression extends IExpr with IFunctor, EquatableMixin {
  @override
  final Func fn;
  @override
  final List<IExpr> ag;

  // expr-v12.1 表达式需要显式确定返回值类型
  @override
  final AttrType type;

  // const Expression(this.fn, this.type, [this.ag = const []]);
  const Expression({required this.fn, this.ag = const [], required this.type});

  // const Expression(this.fn, [this.ag = const [], this.type = AttrType.any]);

  @override
  callee() => fn.invoke(ag.map((a) => a.callee()).toList());

// todo 出入参数量,类型检查 等等
  @override
  get value => callee();

  @override
  List<Object?> get props => [fn, ag];

// @override
// IFunctor fMap(Func fn) {
//   // TODO: implement fMap
//   throw UnimplementedError();
// }

}

mixin IFunctor {
  dynamic get value;

// IFunctor fMap(Func fn);
}

/// Expr-v11.2 方案 直接存储dynamic类型,通过 fn映射为具体的类型
/// 一般来说 List [ag], ag[0]用于存储 v, 表示当前的值;考虑用ag[1]存储 e
/// 需要注意的是, ag[0]可以是dynamic类型,在计算时,会自动as为String类型
class Value extends IExpr with IFunctor, EquatableMixin {
  @override
  final AsFunc fn; // 对于Value, fn对象始终是 [AsFunc]类及其子类
  @override
  final List<dynamic> ag; // ag[0]为实际值, ag[1]为错误值
  @override
  callee() => fn.logic.call(ag);

  // expr-v12.1
  @override
  AttrType get type => fn.rType;

  @override
  dynamic get value => callee();

  dynamic get v => ag[0];

  String get e => ag[1];

  @override
  List<Object?> get props => [fn, ...ag];

  @protected
  const Value({
    required this.fn,
    required this.ag,
  });

  factory Value.of(dynamic v, [dynamic e]) {
    AsFunc fn;
    dynamic value = v ?? "";
    switch (v.runtimeType) {
      case String:
        fn = const AsFunc<String>();
        break;
      case double:
        fn = const AsFunc<double>();
        break;
      case int:
        fn = const AsFunc<int>();
        break;
      case num:
        fn = const AsFunc<num>();
        break;
      case bool:
        fn = const AsFunc<bool>();
        break;
      case RecordMeta:
        return Value.ofMetaId(v.id);
      case Record:
        fn = const AsFuncRecord();
        value = v.id;
        break;
      case IExpr:
        return v;
      case Value: // 无法被IExpr取代, 原因未知
        return v;
      case Expression: // 无法被IExpr取代, 原因未知
        return v;
      default:
        fn = const AsFuncDynamic();
      // throw "暂不支持的包装类型[${v.runtimeType}]";
    }
    return Value(
      fn: fn,
      ag: [value, if (e != null) e],
    );
  }

  /// 特殊处理 对于[RecordMeta], 直接存储 metaId:[ObjectId]
  Value.ofMetaId(ObjectId metaId)
      : this(fn: const AsFuncRecordMeta(), ag: [metaId]);

  factory Value.err(String? e) => Value.of("", e);

  @override
  String toString() => '${fn.name}($ag)';
}

/// Func 的实例相当于 Dart的external函数
abstract class Func with EquatableMixin {
  const Func();

  // 全局函数需要确保函数名全局唯一
  String get name;

  List<AttrType> get pTypes;

  /// 用于获取返回值的逻辑, 输入值可以是Type,也可以是参数
  /// 用于`求表达式返回值类型`
  @Deprecated(
      "从expr12.1开始, Func的type获取逻辑,大部分由DTO->Domain托管,如MemberFunc, 少部分如AsFunc,是直接在这里获取")
  AttrType type([List<AttrType>? argTypes]);

  //
  // // 在调用之前,需要先检查Attr的类型匹配问题
  // @protected
  // Function get logic;

  /// [ctx] 仅当函数作为方法体时才会被传入, 内容即对象的成员对象(属性和其他方法)
  invoke([List<dynamic>? ag]);

  // invoke([List<dynamic>? ag]) => logic(ag);

  IFunctor apply(List<IFunctor>? p) {
    throw UnimplementedError();
    // try {
    //   // fixme 未作细节处理，如保留原值等
    //   return Function.apply(logic, p);
    // } catch (e) {
    //   // return Value('', e.toString());
    // }
  }
}

class BaseFunc extends Func {
  @override
  final String name; // 全局唯一
  @override
  final List<AttrType> pTypes;

  // todo 新增一个动态获取 rType的方法，针对Any类型的返回值，可以通过方法得到实际的返回类型，而不是Any
  final AttrType rType;

  // 在调用之前,需要先检查Attr的类型匹配问题
  @protected
  final Function logic;

  /// [ctx] 仅当函数作为方法体时才会被传入, 内容即对象的成员对象(属性和其他方法)
  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  IFunctor apply(List<IFunctor>? p) {
    throw UnimplementedError();
    // try {
    //   // fixme 未作细节处理，如保留原值等
    //   return Function.apply(logic, p);
    // } catch (e) {
    //   // return Value('', e.toString());
    // }
  }

  const BaseFunc({
    required this.name,
    required this.pTypes,
    required this.rType,
    required this.logic,
  });

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  // 固定返回值的Func,一般直接用rType返回即可
  @override
  AttrType type([List<dynamic>? ag]) => rType;
}

class AsFunc<T> implements BaseFunc {
  const AsFunc();

  @override
  String get name => "as$T";

  @override
  List<AttrType> get pTypes => [rType];

  @override
  AttrType get rType {
    switch (T) {
      case String:
        return AttrType.string;
      case int:
      case double:
        return AttrType.num;
      case bool:
        return AttrType.boolean;
      default:
        print("debug# 未知的AsFunc返回值类型:[$T],已转换为 [${AttrType.any}]");
        return AttrType.any;
    }
    return AttrType.by("$T");
  }

  @override
  AttrType type([List<dynamic>? ag]) => rType;

  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (args) {
        final v = args[0];
        return v as T;
      };

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  bool get stringify => true;
}

class AsFuncDynamic extends AsFunc {
  const AsFuncDynamic();

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  Function get logic => (_) => _[0];

  @override
  String get name => "asDynamic";

  @override
  AttrType get rType => AttrType.any;
}

@Deprecated("请使用[AsFuncRef]")
class AsFuncRecord extends AsFunc<Record> {
  const AsFuncRecord();

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  /// 存储的是RecordId
  @override
  Function get logic => (_) {
        final recordId = _[0];
        final record = sl<WorkspaceDataHolder>().queryRecordBy(recordId);
        return record;
      };

  @override
  String get name => "asFuncRecord";

  @override
  AttrType get rType => AttrType.any;
}

@Deprecated("没有实际意义")
class AsFuncRecordMeta extends AsFunc<RecordMeta> {
  const AsFuncRecordMeta();

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  /// 存储的是MetaId
  @override
  Function get logic => (_) {
        // fixme 这里做特殊处理,
        final metaId = (_[0] is ObjectId)
            ? _[0]
            : ObjectId.fromHexString(_[0]); // ObjectId (MetaId), 注册在Workspace中
        final meta = sl<WorkspaceDataHolder>().getMetaBy(metaId);
        return meta;
      };

  @override
  String get name => "asFuncRecordMeta";

  @override
  AttrType get rType => AttrType.any;
}

class MemberFunc implements Func {
  const MemberFunc();

  @override
  final String name = "member";

  @override
  List<AttrType> get pTypes => [AttrType.any];

  @override
  AttrType type([List<dynamic>? ag]) {
    if ((ag?.length ?? 0) < 2) throw "member函数需要两个参数";
    final member = ag![1] as IExpr; // member 必须是一个表达式
    return member.type;
  }

  /// memberFunc就相当于 `.`, 必须要有两个参数!
  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (p) {
        final record = p[0];
        var propId = p[1];
        print("memberFunction#A# ${record.runtimeType} # $record");
        print("memberFunction#B# ${propId.runtimeType} # $propId");
        if (record is RecordMeta) {
          return record.getPropBy(propId).name;
        }
        return record[propId] ?? (throw "找不到 propId [$propId]");
      };

  @override
  List<Object?> get props => [name, pTypes, logic];

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  bool get stringify => true;
}

/// 访问数组对象
class IndexFunc implements BaseFunc {
  const IndexFunc();

  @override
  final String name = "index";

  /// [索引, 对象]
  @override
  List<AttrType> get pTypes => [AttrType.num, rType];

  @override
  AttrType get rType => AttrType.any;

  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (p) {
        final index = p[0];
        final list = p[1];
        return list[index] ?? (throw "list 中找不到索引 [$index]");
      };

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  bool get stringify => true;

  @override
  AttrType type([List<dynamic>? ag]) => rType;
}

/// 可以构造[rType]用于表达式返回值类型推断
/// asRef_xx<某MetaId>xx([<this所属Meta的propId,并且与`某MetaId`不同>])
/// 用于表示变量再ctx中是某个Meta下的实例, 其中,xx就代表该Meta的Id
/// todo asRef描述的是,在表达式中,value的类型,
class AsFuncRef implements AsFunc {
  @override
  final AttrType rType;

  const AsFuncRef([this.rType = AttrType.any]);

  static const funPrefix = "asRef_";

  static AsFuncRef? ofName(String funcName) {
    if (!funcName.startsWith(funPrefix)) return null;
    return AsFuncRef(AttrType.ref(funcName.substring(funPrefix.length)));
  }

  @override
  // String get name => 'asRef';
  String get name => "$funPrefix${rType.r}";

  @override
  AttrType type([List<dynamic>? ag]) => rType;

  @override
  IFunctor apply(List<IFunctor>? p) {
    throw UnimplementedError();
  }

  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (p) => p[0];

  @override
  List<AttrType> get pTypes => throw UnimplementedError();

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  @override
  bool get stringify => true;
}

///
/// [AsFuncThis] 是一个标记性的函数,没有固定Args,返回值从ctx中获取
/// [AsFuncThis]与[AsFuncRef]
/// asThis,用于表示当前类型的对象, 描述了一种"相对的位置",具体的ref值是从ctx中获取;
/// asRef,是绝对位置,ref指定MetaId将会被持久化到数据库中
class AsFuncThis implements AsFunc {
  /// 指定返回值类型, 可以帮助表达式确认Meta, 用于多层MemberFunc的转换
  /// 因此,[AsFuncThis]应当在convert或eval时,
  /// 从ctx中取[ctxTypeSign]作为[rType](是Meta的Id, 因为AttrType只能存储MetaId,暂时不能存储Meta)
  /// 从ctx中取[ctxSign]作为ag:[0]的值(是Record)
  @override
  final AttrType rType;

  const AsFuncThis([this.rType = AttrType.any]);

  @override
  AttrType type([List<dynamic>? ag]) => rType;

  // 如果上下文中存在`this`,则为其key值
  static const ctxSign = 'this';

  /// 如果上下文没有`this`,但是有`this`的类型(Meta),(如表达式convert场景)则为其key值
  /// 对应的value,应该是[RecordMeta]类型
  static const ctxTypeSign = 'thisType';
  @override
  final String name = 'asThis';

  @override
  IFunctor apply(List<IFunctor>? p) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  invoke([List<dynamic>? ag]) => logic(ag);

  @override
  Function get logic => (p) => p[0];

  @override
  List<AttrType> get pTypes => throw UnimplementedError();

  @override
  List<Object?> get props => [name, pTypes, rType, logic];

  @override
  bool get stringify => true;
}

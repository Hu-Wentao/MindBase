import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/workspace/domain/entity/entity.dart';
import 'package:mind_base/src/workspace/inter/expression_dto.dart';

const exprEvaluator = ExprEvaluator(memberAccessors: [RecordMemberAccessor()]);

/// 表达式(Domain)求值器
class ExprEvaluator {
  final List<MemberAccessor> memberAccessors;

  const ExprEvaluator({this.memberAccessors = const []});

  /// todo IExpr_v20B 返回值应当为 [IExpr], 最终返回值类型应当为 [ExprValue]
  dynamic eval(IExpr expr, Map<String, dynamic> ctx) {
    print("eval: $expr");
    final fn = expr.fn;
    // print("fn runtimeType = ${fn.runtimeType}");

    if (fn is AsFunc) {
      // 由于 AsFunc带有<>泛型,无法case匹配,因此在这里提前处理
      return evalAsFunc(expr, ctx);
    }
    switch (fn.runtimeType) {
      // case AsFunc:
      case MemberFunc:
        return evalMemberFunc(expr, ctx);
      case IndexFunc:
        return evalIndexFunc(expr, ctx);
      case BaseFunc: // 普通函数,无需上下文
        return evalBaseFunc(expr, ctx);
    }
  }

  // As都是Value类型
  evalAsFunc(IExpr expr, ctx) {
    // print("evalAsFunc# ${expr.fn}#${expr.ag}");
    assert(expr is Value);
    // todo 考虑检查一下 [expr.e]是否为null,这样可以提前检查异常
    if (expr.fn is AsFuncThis) {
      // this 应当是一个[Record]实例, 表示当前被调用方法所在的Record
      return ctx[AsFuncThis.ctxSign];
    } else if (expr.fn is AsFuncRef) {
      return expr.value;
    }
    // 直接返回v,而不是value, 后期考虑移除value等自带求值功能|或者将这里的功能移动到Func中
    return (expr as Value).v;
  }

  evalMemberFunc(IExpr expr, ctx) {
    assert(expr is Expression);
    // 读取参数
    var obj = eval(expr.ag[0], ctx);
    assert(obj != null, "找不到Member主对象,参数列表[${expr.ag}]");
    // 如果obj不是Record,而是RecordId(是一个引用对象),则需要从工作空间中查询,
    if (obj is ExprValue) {
      assert(obj.type.isRef, "只有RefExprValue才能作为FindRecordFn的参数");
      final findRecordFn = ctx[Workspace.ctxFindRecordFnSign] as FindRecordFn;
      obj = findRecordFn(obj); // MetaId(HexString) -> Meta
    }

    final member = eval(expr.ag[1], ctx);
    // print("evalMemberFunc# 表达式的ag列表${expr.ag}");
    // 选择相关的Accessor
    for (var a in memberAccessors) {
      if (a.canHandle(obj, member)) {
        return a.getMember(obj, member);
      }
    }
    throw ExpressionEvaluatorException.memberAccessNotSupported(
      obj.runtimeType,
      member,
    );
  }

  @protected
  dynamic evalValue(ValueDto valueDto, Map<String, dynamic> ctx) {
    var value = valueDto.value;
    if (value is List) return value.map((e) => eval(e, ctx)).toList();
    if (value is Map) {
      return value
          .map((key, value) => MapEntry(eval(key, ctx), eval(value, ctx)));
    }
    return value;
  }

  @protected
  dynamic evalVariable(VariableDto variable, Map<String, dynamic> ctx) {
    return ctx[variable.identifier.name];
  }

  @protected
  dynamic evalThis(ThisExpressionDto expr, Map<String, dynamic> ctx) {
    return ctx['this'];
  }

  //
  // @protected
  // dynamic evalCallExpression(CallExpressionDto expr, Map<String, dynamic> ctx) {
  //   var callee = eval(expr.callee, ctx);
  //   var arguments = expr.arguments.map((e) => eval(e, ctx)).toList();
  //   return Function.apply(callee, arguments);
  // }

  // @protected
  // dynamic evalUnaryExpression(
  //     UnaryExpressionDto expr, Map<String, dynamic> ctx) {
  //   var argument = eval(expr.argument, ctx);
  //   switch (expr.operator) {
  //     case '-':
  //       return -argument;
  //     case '+':
  //       return argument;
  //     case '!':
  //       return !argument;
  //     case '~':
  //       return ~argument;
  //   }
  //   throw ArgumentError('Unknown unary operator ${expr.operator}');
  // }

  // _right(right, ctx) => () => eval(right, ctx);
  //
  // @protected
  // dynamic evalBinaryExpression(
  //     BinaryExpressionDto expr, Map<String, dynamic> ctx) {
  //   var left = eval(expr.left, ctx);
  //   var right = _right(expr.right, ctx);
  //   switch (expr.operator) {
  //     case '||':
  //       return left || right();
  //     case '&&':
  //       return left && right();
  //     case '|':
  //       return left | right();
  //     case '^':
  //       return left ^ right();
  //     case '&':
  //       return left & right();
  //     case '==':
  //       return left == right();
  //     case '!=':
  //       return left != right();
  //     case '<=':
  //       return left <= right();
  //     case '>=':
  //       return left >= right();
  //     case '<':
  //       return left < right();
  //     case '>':
  //       return left > right();
  //     case '<<':
  //       return left << right();
  //     case '>>':
  //       return left >> right();
  //     case '+':
  //       return left + right();
  //     case '-':
  //       return left - right();
  //     case '*':
  //       return left * right();
  //     case '/': // 注意,在Dart中,这不是整除
  //       return left / right();
  //     case '~/': // 整除
  //       return left ~/ right();
  //     case '%':
  //       return left % right();
  //   }
  //   throw ArgumentError('Unknown operator ${expr.operator} in expression');
  // }

  @protected
  dynamic getMember(dynamic obj, String member) {
    for (var a in memberAccessors) {
      if (a.canHandle(obj, member)) {
        return a.getMember(obj, member);
      }
    }
    throw ExpressionEvaluatorException.memberAccessNotSupported(
        obj.runtimeType, member);
  }

  evalIndexFunc(IExpr expr, Map<String, dynamic> ctx) {
    assert(expr is Expression);
    final obj = (expr as Expression).ag[0];
    final index = (expr).ag[1];
    return eval(obj, ctx)[eval(index, ctx)];
  }

  evalBaseFunc(IExpr expr, Map<String, dynamic> ctx) {
    assert(expr is Expression);
    final fn = expr.fn;
    final args = expr.ag.map((e) => eval(e, ctx)).toList();
    return fn.invoke(args);
  }
}

class ExpressionEvaluatorException implements Exception {
  final String message;

  ExpressionEvaluatorException(this.message);

  ExpressionEvaluatorException.memberAccessNotSupported(
      Type type, String member)
      : this('`$type`类型的对象不支持成员`$member`访问,检查Evaluator中是否定义了成员访问器');

  @override
  String toString() {
    return 'ExpressionEvaluatorException: $message';
  }
}

typedef SingleMemberAccessor<T> = dynamic Function(T);
typedef AnyMemberAccessor<T> = dynamic Function(T, String member);

/// 成员访问器
abstract class MemberAccessor<T> {
  // 内置一个Map访问器,可以通过 `alice.bag`的方式访问Map中的值
  static const MemberAccessor<Map> mapAccessor =
      MemberAccessor<Map>.fallback(_getMapItem);

  static dynamic _getMapItem(Map map, String key) => map[key];

  const factory MemberAccessor(Map<String, SingleMemberAccessor<T>> accessors) =
      _MemberAccessor;

  const factory MemberAccessor.fallback(AnyMemberAccessor<T> accessor) =
      _MemberAccessorFallback;

  dynamic getMember(T object, String member);

  bool canHandle(dynamic object, String member);
}

class _MemberAccessorFallback<T> implements MemberAccessor<T> {
  final AnyMemberAccessor<T> accessor;

  const _MemberAccessorFallback(this.accessor);

  @override
  bool canHandle(object, String member) {
    if (object is! T) return false;
    return true;
  }

  @override
  dynamic getMember(T object, String member) {
    return accessor(object, member);
  }
}

class _MemberAccessor<T> implements MemberAccessor<T> {
  final Map<String, SingleMemberAccessor<T>> accessors;

  const _MemberAccessor(this.accessors);

  @override
  bool canHandle(object, String member) {
    if (object is! T) return false;
    if (accessors.containsKey(member)) return true;
    return false;
  }

  @override
  dynamic getMember(T object, String member) {
    return accessors[member]!(object);
  }
}

/// 记录值访问器
class RecordMemberAccessor implements MemberAccessor<Record> {
  // final WorkspaceDataHolder workspace;

  const RecordMemberAccessor();

  @override
  bool canHandle(object, String member) {
    return object is Record; // 不再检查是否有成员, 如果真的不存在,则交给eval去处理
    // 只允许访问Record类型
    // if (object is! Record) return false;
    // // 是否存在对应的成员
    // return object.meta.hasPropBy(member);
  }

  /// 成员可以是值, 也可是函数[Function]
  /// todo 在新增/修改变量/方法名称时,没有检查名称唯一性
  /// 考虑允许方法与变量重名,用于表达"get"方法
  /// todo IExpr_v20B 返回值改造为 IExpr, 或者(ExprValue)
  @override
  getMember(Record record, String member) {
    final method = record.meta.tryGetMethodBy(member);
    if (method != null) {
      return method.expr.callee; // 可以被调用
    }
    final field = record.getFieldByAttrName(member);
    if (field.value != null) {
      return field; // 值
    }
    throw "在Record[${record.id}]找不到名称为[$member]的成员方法或变量";
  }
}

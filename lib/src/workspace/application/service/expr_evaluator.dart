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
  /// 1. 存在问题: 如果返回值为 [ExprValue],那么计算结果为Record,也需要包装成 [ExprValue],但目前没有对应的type来表示record
  /// 2. 确实要统一返回ExprValue, 以member访问为例, 如果不用ExprValue,则Record对象将只有一个RecordId, 无法作为member函数的首个入参;
  /// 3. 问题解决: 对于 已有的 add(),等入参为原始类型的函数, 需要进行简单改造,适配为ExprValue,这样可以同时检查入参的类型;
  ExprValue eval(IExpr expr, Map<String, dynamic> ctx) {
    // print("eval: $expr");
    late dynamic r;
    if (expr is ExprValue) {
      return expr; // ExprValue就不用求值了,直接返回
    } else {
      switch (expr.fn.runtimeType) {
        // case AsFunc:
        case MemberFunc:
          r = evalMemberFunc(expr, ctx);
          break;
        case IndexFunc:
          r = evalIndexFunc(expr, ctx);
          break;
        case BaseFunc: // 普通函数,无需上下文
          final rr = evalBaseFunc(expr, ctx);
          // fixme 由于基础函数返回值都是原始类型, 在这里对原始类型进行简单包装,防止出错
          r = ExprValue.of(rr);
          break;
      }
    }
    print("eval#rst: $expr #r: $r");
    return r;
  }

  ExprValue evalMemberFunc(IExpr expr, ctx) {
    assert(expr is Expression);
    // 读取参数
    var obj = eval(expr.ag[0], ctx);
    // 如果obj不是Record,而是RecordId(是一个引用对象),则需要从工作空间中查询,
    assert(obj.type.isRef, "只有RefExprValue才能作为FindRecordFn的参数");

    late Record rcd;
    if (obj.value == null || (obj.value as String).isEmpty) {
      // 识别为 `this`表达式
      rcd = ctx[AsFuncThis.ctxSign] as Record;
    } else {
      // 识别为 Ref表达式
      final findRecordFn = ctx[Workspace.ctxFindRecordFnSign] as FindRecordFn;
      rcd = findRecordFn(obj.value); // RecordId(HexString) -> Record
    }

    final member = eval(expr.ag[1], ctx);

    late String field = member.value;
    // print("evalMemberFunc# 表达式的ag列表${expr.ag}");
    // 选择相关的Accessor
    for (var a in memberAccessors) {
      if (a.canHandle(rcd, field)) {
        return a.getMember(rcd, field);
      }
    }
    throw ExpressionEvaluatorException.memberAccessNotSupported(
      obj.runtimeType,
      field,
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
    return eval(obj, ctx).value[eval(index, ctx)];
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
      return field; // Expr值, 如果是ref,则直接返回,如果是原始类型, 则要返回value
    }
    throw "在Record[${record.id}]找不到名称为[$member]的成员方法或变量";
  }
}

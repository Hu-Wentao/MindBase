import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/inter/dto/expr_token_dto.dart';

import '../../../../app/application/model.dart';
import 'member_accessor.dart';

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
    // print("eval#rst: $expr #r: $r");
    return r;
  }

  IExpr evalMemberFunc(IExpr expr, ctx) {
    assert(expr is Expression);
    // 读取参数
    ExprValue exprV = eval(expr.ag[0], ctx);
    if(!exprV.type.isRef){
      return ExprValue.err('只有RefExprValue对象才能调用member函数');
    }
    // 如果obj不是Record,而是RecordId(是一个引用对象),则需要从工作空间中查询,

    late RecordModel rcd;
    if (exprV.value == null || (exprV.value as String).isEmpty) {
      // 识别为 `this`表达式, this是一种特殊(不指定RecordId)的RefExprValue
      rcd = ctx[AsFuncThis.ctxSign] as RecordModel;
    } else {
      // 识别为 Ref表达式
      final findRecordFn = ctx[SpaceModel.ctxFindRecordFnSign] as FindRecordFn;
      rcd = findRecordFn(exprV); // ExprValue(RefExprValue) -> Record
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
      exprV.runtimeType,
      field,
    );
  }

  @protected
  dynamic evalValue(LiteralDto valueDto, Map<String, dynamic> ctx) {
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
  dynamic evalThis(ThisExprTokenDto expr, Map<String, dynamic> ctx) {
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

  IExpr getMember(T object, String member);

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
  IExpr getMember(T object, String member) {
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
  IExpr getMember(T object, String member) {
    return accessors[member]!(object);
  }
}



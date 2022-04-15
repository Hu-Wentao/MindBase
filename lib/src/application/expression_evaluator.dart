import 'package:flutter/foundation.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/interface/expression_dto.dart';

/// 表达式求值器
class ExpressionEvaluator {
  final List<MemberAccessor> memberAccessors;

  const ExpressionEvaluator({this.memberAccessors = const []});

  dynamic eval(ExpressionDto expr, Map<String, dynamic> ctx) {
    switch (expr.runtimeType) {
      case ValueDto:
        return evalValue(expr as ValueDto, ctx);
      case VariableDto:
        return evalVariable(expr as VariableDto, ctx);
      case ThisExpressionDto:
        return evalThis(expr as ThisExpressionDto, ctx);
      case MemberExpressionDto:
        return evalMemberExpression(expr as MemberExpressionDto, ctx);
      case IndexExpressionDto:
        return evalIndexExpression(expr as IndexExpressionDto, ctx);
      case CallExpressionDto:
        return evalCallExpression(expr as CallExpressionDto, ctx);
      case UnaryExpressionDto:
        return evalUnaryExpression(expr as UnaryExpressionDto, ctx);
      case BinaryExpressionDto:
        return evalBinaryExpression(expr as BinaryExpressionDto, ctx);
      default:
        throw ArgumentError("未知的表达式类型 '${expr.runtimeType}'");
    }
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

  @protected
  dynamic evalMemberExpression(
      MemberExpressionDto expr, Map<String, dynamic> ctx) {
    var obj = eval(expr.object, ctx);

    return getMember(obj, expr.property.name);
  }

  @protected
  dynamic evalIndexExpression(
      IndexExpressionDto expr, Map<String, dynamic> ctx) {
    return eval(expr.object, ctx)[eval(expr.index, ctx)];
  }

  @protected
  dynamic evalCallExpression(CallExpressionDto expr, Map<String, dynamic> ctx) {
    var callee = eval(expr.callee, ctx);
    var arguments = expr.arguments.map((e) => eval(e, ctx)).toList();
    return Function.apply(callee, arguments);
  }

  @protected
  dynamic evalUnaryExpression(
      UnaryExpressionDto expr, Map<String, dynamic> ctx) {
    var argument = eval(expr.argument, ctx);
    switch (expr.operator) {
      case '-':
        return -argument;
      case '+':
        return argument;
      case '!':
        return !argument;
      case '~':
        return ~argument;
    }
    throw ArgumentError('Unknown unary operator ${expr.operator}');
  }

  _right(right, ctx) => () => eval(right, ctx);

  @protected
  dynamic evalBinaryExpression(
      BinaryExpressionDto expr, Map<String, dynamic> ctx) {
    var left = eval(expr.left, ctx);
    var right = _right(expr.right, ctx);
    switch (expr.operator) {
      case '||':
        return left || right();
      case '&&':
        return left && right();
      case '|':
        return left | right();
      case '^':
        return left ^ right();
      case '&':
        return left & right();
      case '==':
        return left == right();
      case '!=':
        return left != right();
      case '<=':
        return left <= right();
      case '>=':
        return left >= right();
      case '<':
        return left < right();
      case '>':
        return left > right();
      case '<<':
        return left << right();
      case '>>':
        return left >> right();
      case '+':
        return left + right();
      case '-':
        return left - right();
      case '*':
        return left * right();
      case '/': // 注意,在Dart中,这不是整除
        return left / right();
      case '~/': // 整除
        return left ~/ right();
      case '%':
        return left % right();
    }
    throw ArgumentError('Unknown operator ${expr.operator} in expression');
  }

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
  final WorkspaceDataHolder workspace;

  RecordMemberAccessor(this.workspace);

  @override
  bool canHandle(object, String member) {
    // 只允许访问Record类型
    if (object is! Record) return false;
    // 是否存在对应的成员
    return object.meta.properties.any((element) => element.name == member);

    // 因为传入的类型是Record, 无论是否存在于workspace中,都可以访问其成员
    // final meta = object.meta;
    // // 检查meta是否存在
    // return workspace.hasMetaId(meta.id);
  }

  @override
  getMember(Record object, String member) {
    // fixme 虽然可以访问method,但无法正常获取返回结果
    return object
        .getValueBy(object.meta.properties
            .firstWhere((element) => element.name == member))
        .v;
  }
}

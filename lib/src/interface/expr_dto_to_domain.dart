import 'package:flutter/foundation.dart';
import 'package:mind_base/src/application/expression_evaluator.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/interface/expression_dto.dart';

const exprToDomain = ExprDtoToDomain(
  memberAccessors: [MetaMemberAccessor()],
);

/// 可读表达式 -> Domain
/// 注意[ctx]与Eval不同, 传入的是[RecordMeta],而不是[Record]
class ExprDtoToDomain {
  final List<MemberAccessor> memberAccessors;

  const ExprDtoToDomain({this.memberAccessors = const []});

  IExpr convert(ExpressionDto expr, Map<String, dynamic> ctx) {
    switch (expr.runtimeType) {
      case ValueDto:
        return convertValue(expr as ValueDto, ctx);
      case VariableDto:
        return convertVariable(expr as VariableDto, ctx);
      case ThisExpressionDto:
        return convertThis(expr as ThisExpressionDto, ctx);
      case MemberExpressionDto:
        return convertMemberExpression(expr as MemberExpressionDto, ctx);
      case IndexExpressionDto:
        return convertIndexExpression(expr as IndexExpressionDto, ctx);
      case CallExpressionDto:
        return convertCallExpression(expr as CallExpressionDto, ctx);
      case UnaryExpressionDto:
        return convertUnaryExpression(expr as UnaryExpressionDto, ctx);
      case BinaryExpressionDto:
        return convertBinaryExpression(expr as BinaryExpressionDto, ctx);
      default:
        throw ArgumentError("未知的表达式类型 '${expr.runtimeType}'");
    }
  }

  @protected
  Value convertValue(ValueDto valueDto, Map<String, dynamic> ctx) {
    var value = valueDto.value;
    if (value is List) {
      return Value.of(value.map((e) => convert(e, ctx)).toList());
    }
    if (value is Map) {
      return Value.of(value.map(
          (key, value) => MapEntry(convert(key, ctx), convert(value, ctx))));
    }
    return Value.of(value);
  }

  @protected
  Value convertVariable(VariableDto variable, Map<String, dynamic> ctx) =>
      Value.of(
        ctx[variable.identifier.name] ??
            (throw "在ctx中找不到变量[${variable.identifier.name}]"),
      );

  @protected
  Value convertThis(ThisExpressionDto expr, Map<String, dynamic> ctx) =>
      Value.of(ctx['this']);

  // Expression(
  //   FuncManager.memberFunc,
  //   [
  //     Value.of(ctx),
  //     Value.of(ctx['this']),
  //   ]
  // );

  @protected
  IExpr convertMemberExpression(
    MemberExpressionDto expr,
    Map<String, dynamic> ctx,
  ) {
    // 用 `this`从ctx中获取到 MetaId, 而Value本身可以从 Workspace中得到Meta
    final metaValue = convert(expr.object, ctx);
    final propValue = Value.of(getMember(metaValue, expr.property.name));
    // final obj
    return Expression(FuncManager.memberFunc, [metaValue, propValue]);
  }

  @protected
  IExpr convertIndexExpression(
          IndexExpressionDto expr, Map<String, dynamic> ctx) =>
      Expression(FuncManager.indexFunc, [
        convert(expr.object, ctx),
        convert(expr.index, ctx),
      ]);

  /// 将表达式Call 转换成 Domain
  ///
  @protected
  IExpr convertCallExpression(
      CallExpressionDto expr, Map<String, dynamic> ctx) {
    var callee = convert(expr.callee, ctx).value; // value才是Ctx中存储的Func实例
    var arguments = expr.arguments.map((e) {

      return convert(e, ctx).value;
    }).toList();
    // var arguments = expr.arguments.map((e) => e.toDomain()).toList();
    print("convertCallExpression# [$callee], [$arguments]");
    return IExpr.of(callee, arguments);
  }

  /// [-], [~], [!], [+]
  @protected
  IExpr convertUnaryExpression(
      UnaryExpressionDto expr, Map<String, dynamic> ctx) {
    var argument = convert(expr.argument, ctx);
    return Expression(
      FuncManager.findBy(expr.operator),
      [argument],
    );
  }

  _right(right, ctx) => () => convert(right, ctx);

  @protected
  IExpr convertBinaryExpression(
      BinaryExpressionDto expr, Map<String, dynamic> ctx) {
    var left = convert(expr.left, ctx);
    dynamic right;
    if (FuncManager.isShortCircuit(expr.operator)) {
      right = _right(expr.right, ctx);
    } else {
      right = _right(expr.right, ctx).call();
    }
    return Expression(FuncManager.findBy(expr.operator), [
      left,
      right,
    ]);
  }

  // 传入的时被Value包装过的对象,需要拆包使用
  @protected
  dynamic getMember(IExpr value, String member) {
    final obj = value.value;
    // final obj = value;
    for (var a in memberAccessors) {
      if (a.canHandle(obj, member)) {
        return a.getMember(obj, member);
      }
    }
    throw ExpressionConvertException.memberAccessNotSupported(
        obj.runtimeType, member);
  }
}

class ExpressionConvertException implements Exception {
  final String message;

  ExpressionConvertException(this.message);

  ExpressionConvertException.memberAccessNotSupported(Type type, String member)
      : this('`$type`类型的对象不支持成员`$member`访问,检查Evaluator中是否定义了成员访问器');
}

/// 将对象名改成转换成 propId, 以便持久化
class MetaMemberAccessor implements MemberAccessor<RecordMeta> {
  const MetaMemberAccessor();

  // final WorkspaceDataHolder workspace;
  // RecordMemberAccessor(this.workspace);

  @override
  bool canHandle(meta, String member) {
    // 只允许访问Record类型
    if (meta is! RecordMeta) return false;
    // 是否存在对应的成员
    return meta.properties.any((element) => element.name == member);
  }

  /// 成员可以是值, 也可是函数[Function]
  /// 将成员名称-> 成员propId
  @override
  getMember(RecordMeta meta, String member) => meta.properties
      .firstWhere(
        (element) => element.name == member,
        orElse: () => throw "在Record[${meta.id}]找不到名称为[$member]的成员方法或变量",
      )
      .propId;
}

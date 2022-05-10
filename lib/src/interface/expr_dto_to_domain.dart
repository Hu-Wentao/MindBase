import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/expr_evaluator.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/entity/functor.dart';
import 'package:mind_base/src/domain/value/value.dart';
import 'package:mind_base/src/interface/expression_dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

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

  // 这里是DTO转换, 传入ctx['this']作为ag,仅仅是为了下一步求值中,可以访问其member,以便保存propId
  @protected
  Value convertThis(ThisExpressionDto expr, Map<String, dynamic> ctx) => Value(
      fn: AsFuncThis(
          AttrType.ref((ctx[AsFuncThis.ctxTypeSign] as RecordMeta).id.$oid)),
      ag: const []);

  /// 转换Member表达式:
  ///   1. 通过 expr.object, 从ctx中查询到`对象`,
  ///   如: object为`this`,即从ctx中查询this对应的Meta
  ///   2. 通过 expr.property.name, 借助 getMember方法, 从`对象`中查询到property对应的propId
  ///   如: property.name为`name`,则查询 Meta中,名称为 `name`的property, 返回propId
  /// <备注>
  /// 如果要从MemberExpr转换成Dto, 或者转换成 ReadableString,也是同理,
  ///   1. 通过propId,查询到Meta中的prop的name, 直接展示name值
  ///   2. 通过object(即MetaId),
  @protected
  IExpr convertMemberExpression(
    MemberExpressionDto expr,
    Map<String, dynamic> ctx,
  ) {
    // `expr.object`将被识别为`VariableDto`, `this`从ctx中获取到 MetaId, 而Value本身可以从 Workspace中得到Meta
    // expr-v12 单独
    final objectV = convert(expr.object, ctx); // 这是This表达式
    final objectType = objectV.type; // todo 类型推断关键点: 通过type方法,IExpr自行返回表达式的结果类型
    // 下面是作类型推断
    if (objectType.tp != AttrTp.ref) {
      throw "MemberExpressionDto.object# Member表达式的类型为[$objectType],其tp与[${AttrTp.ref}]不符";
    }
    final meta = sl<WorkspaceDataHolder>()
        .getMetaBy(ObjectId.fromHexString(objectType.r!))!;

    /// expr12.1 手动处理 prop的value与type问题, 可以考虑移除 asThis的Type
    final prop = getMember(meta, expr.property.name) as Property;
    final propValue = Value.of(prop.propId);

    return Expression(
      fn: IFunc.memberFunc,
      ag: [objectV, propValue],
      type: prop.type, // 表达式的返回值类型即对应prop的类型
    );
  }

  @protected
  IExpr convertIndexExpression(
    IndexExpressionDto expr,
    Map<String, dynamic> ctx,
  ) {
    final obj = convert(expr.object, ctx);
    return Expression(
      fn: IFunc.indexFunc,
      ag: [
        obj,
        convert(expr.index, ctx),
      ],
      type: obj.type,
    );
  }

  /// 将表达式Call 转换成 Domain
  /// 1. 读取DTO的callee, 从ctx中查询到callee对应的Func实例(Value.of(Func))
  /// 2. 读取DTO的arguments, 从ctx中查询 arguments分别对应的Value/Expression实例
  /// 3. 将 callee与 arguments 组装成 Expression,并返回
  @protected
  IExpr convertCallExpression(
    CallExpressionDto expr,
    Map<String, dynamic> ctx,
  ) {
    final callee = convert(expr.callee, ctx).value; // .value才是Ctx中存储的Func实例
    // AsFunc表示该IExpr是Value
    if (callee is AsFunc) {
      return Value(
          fn: callee,
          ag: expr.arguments.map((e) => (e as ValueDto).value).toList());
    }
    // 对于非 AsFunc, type类型的获取逻辑暂时先放在 DTO->Domain中(此处)进行处理
    // todo 某些func可能需要特殊处理
    final args = expr.arguments.map((e) => convert(e, ctx)).toList();
    var exprType = (callee as Func).type(args);
    return Expression(
      fn: callee,
      ag: args,
      type: exprType,
    );
  }

  /// [-], [~], [!], [+]
  @protected
  IExpr convertUnaryExpression(
    UnaryExpressionDto expr,
    Map<String, dynamic> ctx,
  ) {
    var argument = convert(expr.argument, ctx);
    return Expression(
      fn: IFunc.findBy(expr.operator),
      ag: [argument],
      type: argument.type,
    );
  }

  _right(right, ctx) => () => convert(right, ctx);

  @protected
  IExpr convertBinaryExpression(
    BinaryExpressionDto expr,
    Map<String, dynamic> ctx,
  ) {
    var left = convert(expr.left, ctx);
    dynamic right;
    if (IFunc.isShortCircuit(expr.operator)) {
      right = _right(expr.right, ctx);
    } else {
      right = _right(expr.right, ctx).call();
    }
    return Expression(
      fn: IFunc.findBy(expr.operator),
      ag: [
        left,
        right,
      ],
      type: left.type,
    );
  }

  // 传入的时被Value包装过的对象,需要拆包使用
  /// 从 [value]种获取成员变量[member]
  /// DTO>Domain的 getMember应该返回什么?
  /// 应该返回Meta中的prop,而不是propId,因为还涉及到类型推断逻辑
  @protected
  dynamic getMember(dynamic obj, String member) {
    // dynamic getMember(IExpr value, String member) {
    //   final obj = value.value;
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

/// 传入 (Meta, propName), 返回 Prop
/// 将对象名改成转换成 prop, 以便持久化和类型推断
class MetaMemberAccessor implements MemberAccessor<RecordMeta> {
  const MetaMemberAccessor();

  @override
  bool canHandle(meta, String member) {
    // 只允许访问Record类型
    if (meta is! RecordMeta) return false;
    // 是否存在对应的成员
    return meta.properties.any((element) => element.name == member);
  }

  /// 将成员名称-> 成员prop
  @override
  getMember(RecordMeta meta, String member) {
    final prop = meta.properties.firstWhere(
      (element) => element.name == member,
      orElse: () => throw "在Record[${meta.id}]找不到名称为[$member]的成员方法或变量",
    );
    return prop;
    // if (prop.type.tp == AttrTp.ref) {
    //   // 引用类型, 同时返回类型信息, 以便推断表达式返回值类型
    //   return Value(
    //       fn: AsFuncRef(prop.type),
    //       ag: [prop.propId]); // 返回一个Value,同时通过 asRef将string转换成Meta
    //   // return Expression(const AsFuncRecordMeta(), [prop.type, prop.propId]); // 返回一个Expr, 通过AsFuncMeta 将 prop转换为Meta, 此时就与propId无关了,
    // } else {
    //   // 原始类型, 同时返回类型信息, 以便推断表达式返回值类型
    //   return Value.of(prop.propId);
    // }
  }
}

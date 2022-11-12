part of 'i_dto.dart';

/// 将表达式转换为json保存
abstract class IExprNodeDto extends IDto {
  AttrTypeDto? get type;

  List<dynamic> get ag;

  @Deprecated("ExprValue没有fn")
  String? get fn;

  static IExprNodeDto fromDomain(dynamic expr) {
    if (expr is ExprValue) {
      return ExprValueNodeDto(
        type: expr.type.toDto(),
        ag: expr.ag,
      );
    }
    if (expr is Expression) {
      return ExprNodeDto(
        fn: expr.fn.name,
        ag: expr.ag.map(IExprNodeDto.fromDomain).toList(),
        type: expr.type.toDto(),
      );
    }
    throw Exception("不支持的IExpr类型[${expr.runtimeType}]");
  }

  /// 可视化的表达式字符串， 例如 foo('1', '2')
  @Deprecated("使用 IExprJsonDtoTokenX.toTokenString")
  String toReadableString();

  IExpr toDomain(QueryMetaFn? toMeta) {
    switch (runtimeType) {
      case ExprValueNodeDto:
        final dto = this as ExprValueNodeDto;
        return ExprValue.build(type: dto.type.toDomain(toMeta!), ag: dto.ag);
      case ExprNodeDto:
        final dto = (this as ExprNodeDto);
        return Expression(
          fn: IFunc.findBy(dto.fn!),
          ag: dto.ag.map((e) => e.toDomain(toMeta)).toList(),
          type: dto.type!.toDomain(toMeta!),
        );
      default:
        throw "IExpr::toDomain 未知的类型 [$runtimeType]";
    }
  }

  @override
  String toString() =>
      'IExprJsonDto{fn: ${this is ExprValueNodeDto ? (this as ExprValueNodeDto).type : fn}, ag: $ag}';

  @override
  Map<String, dynamic> toJson() =>
      throw UnimplementedError("使用[$runtimeType]相关Extension的方法");

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExprNodeDto &&
          runtimeType == other.runtimeType &&
          fn == other.fn &&
          // fixme 低性能
          toString() == other.toString();

  @override
  int get hashCode => fn.hashCode ^ hashObjects(ag);
}

class ExprNodeDto extends IExprNodeDto {
  //内嵌函数的名
  @override
  String? fn;
  @override
  List<IExprNodeDto> ag;

  @override
  AttrTypeDto? type;

  ExprNodeDto({
    required this.fn,
    this.ag = const [],
    required this.type,
  });

  ExprNodeDto.builder({
    this.fn,
    this.ag = const [],
    this.type,
  });

  factory ExprNodeDto.fromDomain(IExpr expr) => ExprNodeDto(
        fn: expr.fn.name,
        ag: expr.ag.map(IExprNodeDto.fromDomain).toList(),
        type: expr.type.toDto(),
      );

  /// 可视化的函数表达式字符串
  @override
  String toReadableString() =>
      "$fn(${ag.map((e) => e.toReadableString()).join(', ')})";

  @override
  Map<String, dynamic> toMap() => toJson();
}

/// 不同点在于, ValueDto 的ag是 List<dynamic>
@Deprecated("将在IExpr_20B2C移除")
class ValueJsonDto extends IExprNodeDto {
  //内嵌函数的名
  @override
  String? fn;
  @override
  List<dynamic> ag;

  ValueJsonDto({
    this.fn,
    this.ag = const [],
  });

  ValueJsonDto.builder({
    this.fn,
    this.ag = const [],
  });

  factory ValueJsonDto.fromDomain(IExpr expr) => ValueJsonDto(
        fn: expr.fn.name,
        ag: expr.ag,
      );

  /// 可视化的函数表达式字符串
  @override
  String toReadableString() => "$fn(${ag.map(_resolveTypeToJson).join(', ')})";

  _resolveTypeToJson(dynamic e) {
    switch (e.runtimeType) {
      case IExprNodeDto:
        return e.toJson();
      case RecordModel:
        return jsonEncode((e as RecordModel).id);
      case MetaModel:
        return jsonEncode((e as MetaModel).id);
      default:
        try {
          return jsonEncode(e);
        } catch (e) {
          print("_resolveTypeToJson#error#e = $e");
          return "error";
        }
    }
  }

  @override
  // TODO: implement type
  AttrTypeDto? get type => throw UnimplementedError();

  @override
  Map<String, dynamic> toMap() => toJson();
}

/// 对应[ExprValue]
class ExprValueNodeDto extends IExprNodeDto {
  //内嵌函数的名
  AttrTypeDto type;
  @override
  List<dynamic> ag;

  ExprValueNodeDto({
    required this.type,
    this.ag = const [],
  });

  ExprValueNodeDto.builder({
    this.type = AttrTypeDto.any,
    this.ag = const [],
  });

  factory ExprValueNodeDto.fromDomain(IExpr expr) => ExprValueNodeDto(
        type: expr.type.toDto(),
        ag: expr.ag,
      );

  /// 可视化的函数表达式字符串
  /// 涉及反序列化, 请勿随意更改
  @override
  String toReadableString() => "(${ag.map(_resolveTypeToJson).join(', ')})";

  _resolveTypeToJson(dynamic e) {
    switch (e.runtimeType) {
      case IExprNodeDto:
        return e.toJson();
      case RecordModel:
        return jsonEncode((e as RecordModel).id);
      case MetaModel:
        return jsonEncode((e as MetaModel).id);
      default:
        try {
          return jsonEncode(e);
        } catch (e) {
          print("_resolveTypeToJson#error#e = $e");
          return "error";
        }
    }
  }

  @override
  String? get fn => throw UnimplementedError("ExprValueJsonDto不需要::fn");
  @override
  Map<String, dynamic> toMap() => toJson();
}

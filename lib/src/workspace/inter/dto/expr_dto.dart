part of 'i_dto.dart';

/// 将表达式转换为json保存
/// todo 重命名为IExprNodeDto,避免Json歧义
abstract class IExprJsonDto extends IDto {
  String? get fn;

  List<dynamic> get ag;

  static IExprJsonDto fromDomain(dynamic expr) {
    if (expr is ExprValue) {
      return ExprValueJsonDto(
        type: expr.type.toDto(),
        ag: expr.ag,
      );
    }
    if (expr is Expression) {
      return ExprJsonDto(
        fn: expr.fn.name,
        ag: expr.ag.map(IExprJsonDto.fromDomain).toList(),
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
      case ValueJsonDto:
        final dto = this as ValueJsonDto;
        final fn = IFunc.findAsFunc(dto.fn!);
        // var ag = dto.ag;
        // if ((fn is AsFuncRecord || fn is AsFuncRecordMeta) &&
        //     ag[0] is! String) {
        //   ag[0] = String.fromHexString(ag[0] as String);
        // }
        return Value(fn: fn, ag: dto.ag);
      case ExprValueJsonDto:
        final dto = this as ExprValueJsonDto;
        return ExprValue.build(type: dto.type.toDomain(toMeta!), ag: dto.ag);
      case ExprJsonDto:
        final dto = (this as ExprJsonDto);
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
      'IExprJsonDto{fn: ${this is ExprValueJsonDto ? (this as ExprValueJsonDto).type : fn}, ag: $ag}';

  @override
  Map<String, dynamic> toJson() =>
      throw UnimplementedError("使用[$runtimeType]相关Extension的方法");

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExprJsonDto &&
          runtimeType == other.runtimeType &&
          fn == other.fn &&
          // fixme 低性能
          toString() == other.toString();

  @override
  int get hashCode => fn.hashCode ^ hashObjects(ag);
}

class ExprJsonDto extends IExprJsonDto {
  //内嵌函数的名
  @override
  String? fn;
  @override
  List<IExprJsonDto> ag;

  AttrTypeDto? type;

  ExprJsonDto({
    required this.fn,
    this.ag = const [],
    required this.type,
  });

  ExprJsonDto.builder({
    this.fn,
    this.ag = const [],
    this.type,
  });

  factory ExprJsonDto.fromDomain(IExpr expr) => ExprJsonDto(
        fn: expr.fn.name,
        ag: expr.ag.map(IExprJsonDto.fromDomain).toList(),
        type: expr.type.toDto(),
      );

  /// 可视化的函数表达式字符串
  @override
  String toReadableString() =>
      "$fn(${ag.map((e) => e.toReadableString()).join(', ')})";
}

/// 不同点在于, ValueDto 的ag是 List<dynamic>
@Deprecated("将在IExpr_20B2C移除")
class ValueJsonDto extends IExprJsonDto {
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
      case IExprJsonDto:
        return e.toJson();
      case Record:
        return jsonEncode((e as Record).id);
      case RecordMeta:
        return jsonEncode((e as RecordMeta).id);
      default:
        try {
          return jsonEncode(e);
        } catch (e) {
          print("_resolveTypeToJson#error#e = $e");
          return "error";
        }
    }
  }
}

/// 对应[ExprValue]
class ExprValueJsonDto extends IExprJsonDto {
  //内嵌函数的名
  AttrTypeDto type;
  @override
  List<dynamic> ag;

  ExprValueJsonDto({
    required this.type,
    this.ag = const [],
  });

  ExprValueJsonDto.builder({
    this.type = AttrTypeDto.any,
    this.ag = const [],
  });

  factory ExprValueJsonDto.fromDomain(IExpr expr) => ExprValueJsonDto(
        type: expr.type.toDto(),
        ag: expr.ag,
      );

  /// 可视化的函数表达式字符串
  /// 涉及反序列化, 请勿随意更改
  @override
  String toReadableString() => "(${ag.map(_resolveTypeToJson).join(', ')})";

  _resolveTypeToJson(dynamic e) {
    switch (e.runtimeType) {
      case IExprJsonDto:
        return e.toJson();
      case Record:
        return jsonEncode((e as Record).id);
      case RecordMeta:
        return jsonEncode((e as RecordMeta).id);
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
}

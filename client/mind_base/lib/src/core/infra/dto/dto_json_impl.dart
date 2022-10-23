import 'dart:convert';

import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';

/// Json实现

extension RecordDtoJsonX on RecordDto {
  static RecordDto fromJson(Map<String, dynamic> json, QueryMetaFn toMeta) =>
      RecordDto(
          fields: Map.fromEntries(json.entries
              .where((element) => element.value is Map<String, dynamic>)
              .map((e) => MapEntry(
                    int.parse(e.key),
                    RcdValueDtoJsonX.fromJson(e.value).toDomain(),
                  ))));

  Map<String, dynamic> toJson() => fields.map(
      (key, value) => MapEntry("$key", ValueDto.fromDomain(value).toJson()));
}

extension MetaDtoJsonX on MetaDto {
  static MetaDto fromJson(Map<String, dynamic> json) => MetaDto(
        id: (json['id'] as String),
        name: json['name'] as String,
        memo: json['memo'] as String,
        maxKey: json['maxKey'] as int,
        attrs: (json['attrs'] as List<dynamic>)
            .map((e) => AttributeDtoJsonX.fromJson(e as Map<String, dynamic>))
            .toList(),
        methods: (json['methods'] as List<dynamic>)
            .map((e) => MethodDtoJsonX.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  toJson() => {
        'id': id,
        'name': name,
        'memo': memo,
        'maxKey': maxKey,
        'attrs': attrs.map((e) => e.toJson()).toList(),
        'methods': methods.map((e) => e.toJson()).toList(),
      };
}

extension MethodDtoJsonX on MethodDto {
  static MethodDto fromJson(Map<String, dynamic> json) => MethodDto(
        k: json['k'] as int,
        name: json['name'] as String,
        memo: json['memo'] as String,
        expr: IExprJsonDtoJsonX.fromJson(json['expr'] as Map<String, dynamic>),
      );

  toJson() => {
        'k': k.toString(),
        'name': name,
        'memo': memo,
        'expr': expr.toJson(),
      };
}

extension AttributeDtoJsonX on AttributeDto {
  static AttributeDto fromJson(Map<String, dynamic> json) => AttributeDto(
        k: json['k'] as int,
        name: json['name'] as String,
        memo: json['memo'] as String,
        type: AttrTypeDto.by(json['type'] as String),
      );

  toJson() => {
        'k': k,
        'name': name,
        'memo': memo,
        'type': type.toString(),
      };
}

extension IExprJsonDtoJsonX on IExprNodeDto {
  static IExprNodeDto fromJson(Map<String, dynamic> json) {
    final fnName = json['fn'] as String;
    if (IFunc.isAsFunc(fnName)) {
      return ValueJsonDtoJsonX.fromJson(json);
    } else {
      return ExprJsonDtoJsonX.fromJson(json);
    }
  }
}

extension ExprJsonDtoJsonX on ExprNodeDto {
  static fromJson(Map<String, dynamic> json) => ExprNodeDto(
        fn: json['fn'] as String,
        ag: (json['ag'] as List<dynamic>)
            .map((e) => IExprJsonDtoJsonX.fromJson(e as Map<String, dynamic>))
            .toList(),
        type: AttrTypeDto.by(json['type'] as String),
      );

  toJson() => {
        'fn': fn,
        'ag': ag.map((e) => e.toJson()).toList(),
        'type': type.toString(),
      };
}

extension RcdValueDtoJsonX on ValueDto {
  static ValueDto fromJson(Map<String, dynamic> json) {
    if (json['v'] != null) {
      // IExpr_20B2C 不使用其他包装，只存储`v`
      return ValueDto.builder(v: json['v']);
    } else {
      return _adapt_0_21_0(json);
    }
  }

  // 适配早期版本
  static _adapt_0_21_0(Map<String, dynamic> json) {
    print("debug adapt 0.21.0 # json = $json");
    return ValueDto.builder(
        v: (json['ag'] as List<dynamic>)
            .map((e) => jsonDecode(e))
            .toList()
            .first);
  }

  Map<String, dynamic> toJson() => {
        'v': v,
      };
}

@Deprecated("将在IExpr_20B2C移除")
extension ValueJsonDtoJsonX on ValueJsonDto {
  static ValueJsonDto fromJson(Map<String, dynamic> json) {
    return ValueJsonDto.builder(
        fn: json['fn'] as String,
        ag: (json['ag'] as List<dynamic>).map((e) => jsonDecode(e)).toList());
  }

  Map<String, dynamic> toJson() => {
        'fn': fn,
        'ag': ag,
      };
}

extension SpaceModelDtoJsonX on SpaceDto {
  static SpaceDto fromJson(Map<String, dynamic> json) => SpaceDto(
        id: json['id'] as String,
        name: json['name'] as String,
        metas:
            (json['metas'] as List<dynamic>).map((e) => e as String).toList(),
        teamId: json['teamId'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'metas': metas,
      };
}

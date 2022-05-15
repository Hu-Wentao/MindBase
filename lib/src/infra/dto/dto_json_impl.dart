import 'dart:convert';

import 'package:mind_base/src/domain/entity/entity.dart';
import 'package:mind_base/src/domain/value/value.dart';
import 'package:mind_base/src/interface/i_dto.dart';

/// Json实现

extension RecordDtoJsonX on RecordDto {
  static RecordDto fromJson(Map<String, dynamic> json) => RecordDto(
      fields: Map.fromEntries(json.entries
          .where((element) => element.value is Map<String, dynamic>)
          .map((e) => MapEntry(
                int.parse(e.key),
                ValueJsonDtoJsonX.fromJson(e.value).toDomain() as Value,
              ))));

  Map<String, dynamic> toJson() => fields.map((key, value) =>
      MapEntry("$key", ValueJsonDto.fromDomain(value).toJson()));
}

extension RecordMetaDtoJsonX on RecordMetaDto {
  static RecordMetaDto fromJson(Map<String, dynamic> json) => RecordMetaDto(
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
        type: AttrType.by(json['type'] as String),
      );

  toJson() => {
        'k': k,
        'name': name,
        'memo': memo,
        'type': type.toString(),
      };
}

extension IExprJsonDtoJsonX on IExprJsonDto {
  static IExprJsonDto fromJson(Map<String, dynamic> json) {
    final fnName = json['fn'] as String;
    if (IFunc.isAsFunc(fnName)) {
      return ValueJsonDtoJsonX.fromJson(json);
    } else {
      return ExprJsonDtoJsonX.fromJson(json);
    }
  }
}

extension ExprJsonDtoJsonX on ExprJsonDto {
  static fromJson(Map<String, dynamic> json) => ExprJsonDto(
        fn: json['fn'] as String,
        ag: (json['ag'] as List<dynamic>)
            .map((e) => IExprJsonDtoJsonX.fromJson(e as Map<String, dynamic>))
            .toList(),
        type: AttrType.by(json['type'] as String),
      );

  toJson() => {
        'fn': fn,
        'ag': ag.map((e) => e.toJson()).toList(),
        'type': type.toString(),
      };
}

extension ValueJsonDtoJsonX on ValueJsonDto {
  static ValueJsonDto fromJson(Map<String, dynamic> json) => ValueJsonDto(
      fn: json['fn'] as String,
      ag: (json['ag'] as List<dynamic>).map((e) => jsonDecode(e)).toList());

  Map<String, dynamic> toJson() => {
        'fn': fn,
        'ag': ag,
      };
}

extension WorkspaceDtoJsonX on WorkspaceDto {
  static WorkspaceDto fromJson(Map<String, dynamic> json) => WorkspaceDto(
        id: json['id'] as String,
        name: json['name'] as String,
        metas:
            (json['metas'] as List<dynamic>).map((e) => e as String).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'metas': metas,
      };
}

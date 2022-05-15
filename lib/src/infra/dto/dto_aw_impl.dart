/// Appwrite实现

import 'dart:convert';

import 'package:appwrite/models.dart';
import 'package:mind_base/src/domain/entity/entity.dart';
import 'package:mind_base/src/domain/value/value.dart';
import 'package:mind_base/src/interface/i_dto.dart';

extension ValueJsonDtoAppwriteX on ValueJsonDto {
  // 需要将 ag:List 转换为 ag:String
  Map<String, dynamic> toJson() => {'ag': jsonEncode(ag)};

  static ValueJsonDto fromJson(dynamic json) => ValueJsonDto(
        fn: json['fn'] as String? ?? 'asString', // 存储时已擦除`fn`,该值应当为空
        ag: jsonDecode(json['ag'] as String),
      );
}

extension ExprJsonDtoAppwriteX on ExprJsonDto {
  Map<String, dynamic> toJson() => {
        'fn': fn,
        'ag': jsonEncode(ag.map((e) => e.toJson())),
        'type': '$type',
      };

  static fromJson(Map<String, dynamic> json) => ExprJsonDto(
        fn: json['fn'] as String,
        ag: (json['ag'] as List<dynamic>)
            .map((e) =>
                IExprJsonDtoAppwriteX.fromJson(e as Map<String, dynamic>))
            .toList(),
        type: AttrType.by(json['type'] as String),
      );
}

extension IExprJsonDtoAppwriteX on IExprJsonDto {
  static IExprJsonDto fromDocument(Document doc) => fromJson(doc.data);

  static IExprJsonDto fromJson(Map<String, dynamic> json) {
    // 只有表达式才有::type属性
    final type = json['type'] as String?;
    if (type == null || type.isEmpty) {
      return ValueJsonDtoAppwriteX.fromJson(json);
    } else {
      return ExprJsonDtoAppwriteX.fromJson(json);
    }
  }
}

// todo 重点单元测试
extension RecordDtoAppwriteX on RecordDto {
  Map<String, dynamic> toJson() => fields.map((key, value) => MapEntry(
        jsonEncode(key),
        ValueJsonDto.fromDomain(value).toJson(),
      ));

  static RecordDto fromDocument(Document doc) => fromJson(doc.data);

  static RecordDto fromJson(Map<String, dynamic> json) => RecordDto(
          fields: Map.fromEntries(
        json.entries
            .where((element) => element.value is Map<String, dynamic>)
            .map(
              (e) => MapEntry(
                int.parse(e.key),
                ValueJsonDtoAppwriteX.fromJson(e.value).toDomain() as Value,
              ),
            ),
      ));
}

extension RecordMetaDtoAppwriteX on RecordMetaDto {
  toJson() => {
        'id': id,
        'name': name,
        'memo': memo,
        'maxKey': maxKey,
        'attrs': jsonEncode(attrs.map((e) => e.toJson())),
        'methods': jsonEncode(methods.map((e) => e.toJson())),
      };

  static RecordMetaDto fromDocument(Document doc) => fromJson(doc.data);

  static RecordMetaDto fromJson(Map<String, dynamic> json) => RecordMetaDto(
        id: (json['id'] as String),
        name: json['name'] as String,
        memo: json['memo'] as String,
        maxKey: json['maxKey'] as int,
        attrs: (jsonEncode(json['attrs'] as String) as List<dynamic>)
            .map((e) =>
                AttributeDtoAppwriteX.fromJson(e as Map<String, dynamic>))
            .toList(),
        methods: (jsonEncode(json['methods'] as String) as List<dynamic>)
            .map((e) => MethodDtoAppwriteX.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

extension MethodDtoAppwriteX on MethodDto {
  toJson() => {
        'k': jsonEncode(k),
        'name': name,
        'memo': memo,
        'expr': jsonEncode(expr.toJson()),
      };

  static MethodDto fromJson(Map<String, dynamic> json) => MethodDto(
        k: jsonDecode(json['k']),
        name: json['name'] as String,
        memo: json['memo'] as String,
        expr: IExprJsonDtoAppwriteX.fromJson(
            (jsonDecode(json['expr'] as String)) as Map<String, dynamic>),
      );
}

extension AttributeDtoAppwriteX on AttributeDto {
  toJson() => {
        'k': jsonEncode(k),
        'name': name,
        'memo': memo,
        'type': type.toString(),
      };

  static AttributeDto fromJson(Map<String, dynamic> json) => AttributeDto(
        k: jsonDecode(json['k']),
        name: json['name'] as String,
        memo: json['memo'] as String,
        type: AttrType.by(json['type'] as String),
      );
}

extension WorkspaceDtoAppwriteX on WorkspaceDto {
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'metas': jsonEncode(metas),
      };

  static WorkspaceDto fromJson(Map<String, dynamic> json) => WorkspaceDto(
        id: json['id'] as String,
        name: json['name'] as String,
        metas: ((jsonDecode(json['metas'] as String)) as List<dynamic>)
            .map((metaId) => metaId as String)
            .toList(),
      );
}

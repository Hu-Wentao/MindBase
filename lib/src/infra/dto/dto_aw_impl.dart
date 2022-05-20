/// Appwrite实现

import 'dart:convert';

import 'package:appwrite/models.dart';
import 'package:mind_base/src/domain/entity/entity.dart';
import 'package:mind_base/src/domain/value/value.dart';
import 'package:mind_base/src/infra/dao/dao_aw_impl.dart';
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
        'type': '${type?.name}',
      };

  static fromJson(Map<String, dynamic> json) {
    final ag = json['ag'] as String? ?? '';
    return ExprJsonDto(
      fn: json['fn'] as String,
      ag: ag.isEmpty
          ? []
          : (jsonDecode(ag) as List<dynamic>)
              .map((e) =>
                  IExprJsonDtoAppwriteX.fromJson(e as Map<String, dynamic>))
              .toList(),
      type: AttrTypeDto.by(json['type'] as String),
    );
  }
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
        PropertyX.getPropId(true, key), // 使用propId, 因为纯数值的属性名触发Appwrite的bug
        jsonEncode(
            ValueJsonDtoAppwriteX(ValueJsonDto.fromDomain(value)).toJson()),
      ));

  static RecordDto fromDocument(Document doc) => fromJson(doc.data);

  static RecordDto fromJson(Map<String, dynamic> json) => RecordDto(
          fields: Map.fromEntries(
        json.entries
            // 过滤掉Appwrite附加的 $id,$collection等字段;
            .where((entry) => PropertyX.isPropId(true, entry.key))
            .map(
              (e) => MapEntry(
                e.key.parsePropK,
                // fixme #324 考虑移除Value包装;
                ValueJsonDtoAppwriteX.fromJson(jsonDecode(e.value))
                    .toDomain(null) as Value,
              ),
            ),
      ));
}

extension RecordMetaDtoAppwriteX on RecordMetaDto {
  toJson() => {
        // 'id': id, // 存储时已擦除`id`,该值应当为空
        'name': name,
        'memo': memo,
        'maxKey': maxKey,
        'attrs': jsonEncode(
          attrs.map((e) => AttributeDtoAppwriteX(e).toJson()).toList(),
        ),
        'methods': jsonEncode(
          methods.map((e) => MethodDtoAppwriteX(e).toJson()).toList(),
        ),
      };

  static RecordMetaDto fromDocument(Document doc) => fromJson(doc.toFullJson());

  static RecordMetaDto fromJson(Map<String, dynamic> json) {
    final a = json['attrs'] as String? ?? '';
    final m = json['methods'] as String? ?? '';
    return RecordMetaDto(
      id: (json['id'] as String?) ?? '请注入id或使用toFullJson',
      name: json['name'] as String,
      memo: json['memo'] as String? ?? '',
      maxKey: json['maxKey'] as int,
      attrs: a.isEmpty
          ? []
          : (jsonDecode(a) as List<dynamic>)
              .map((e) =>
                  AttributeDtoAppwriteX.fromJson(e as Map<String, dynamic>))
              .toList(),
      methods: m.isEmpty
          ? []
          : (jsonDecode(m) as List<dynamic>)
              .map(
                  (e) => MethodDtoAppwriteX.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
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

extension AttrTypeDtoAppwriteX on AttrTypeDto {
  toJson() => {
        'tp': tp.name,
        'r': r,
      };

  static AttrTypeDto fromJson(Map<String, dynamic> json) => AttrTypeDto(
        AttrTp.values.byName(json['tp'] as String),
        json['r'] as String?,
      );

  String toJsonStr() => jsonEncode(toJson());

  static AttrTypeDto fromJsonStr(String json) => fromJson(jsonDecode(json));
}

extension AttributeDtoAppwriteX on AttributeDto {
  toJson() => {
        'k': jsonEncode(k),
        'name': name,
        'memo': memo,
        'type': AttrTypeDtoAppwriteX(type).toJsonStr(),
      };

  static AttributeDto fromJson(Map<String, dynamic> json) => AttributeDto(
        k: jsonDecode(json['k']) as int,
        name: json['name'] as String,
        memo: json['memo'] as String,
        type: AttrTypeDtoAppwriteX.fromJsonStr(json['type'] as String),
      );
}

extension WorkspaceDtoAppwriteX on WorkspaceDto {
  Map<String, dynamic> toJson() => {
        // 'id': id, // 没有id属性
        'teamId': teamId,
        'name': name,
        'metas': jsonEncode(metas),
      };

  static WorkspaceDto fromJson(Map<String, dynamic> json) => WorkspaceDto(
        // 因为Appwrite.data 没有id属性, 不过新增 `toFullJson`方法,再次注入了id属性
        id: (json['id'] as String?) ?? '请注入ID或使用toFullJson',
        name: json['name'] as String,
        metas: ((jsonDecode(json['metas'] as String)) as List<dynamic>)
            .map((metaId) => metaId as String)
            .toList(),
        teamId: json['teamId'] as String,
      );
}

/// Appwrite实现

import 'dart:convert';

import 'package:appwrite/models.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/domain/value/value.dart';
import 'package:mind_base/src/space/infra/dao/dao_aw_impl.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';

/// 对应[Value]
extension RcdValueDtoAppwriteX on ValueDto {
// 修复 ::fn 字段丢失导致表达式无法正常解析的bug
  Map<String, dynamic> toJson() => {'v': jsonEncode(v)};

  static ValueDto fromJson(Map<String, dynamic> js) {
    if (js['v'] != null) {
      return ValueDto.builder(v: jsonDecode(js['v']));
    } else {
      return _adapt_0_21_0(js);
    }
  }

  static _adapt_0_21_0(Map<String, dynamic> js) {
    final jsMap = jsonDecode(js['ag'] as String);
    if (jsMap is List) {
// 仅用于适配 0.12.0 之前的版本, 之前版本所录入的asThis表达式都无法正常执行
      return ValueDto.builder(
        v: jsonDecode(js['ag'] as String)[0],
      );
    } else {
      return ValueDto.builder(
        v: jsonDecode(jsMap['ag'] as String)[0],
      );
    }
  }
}

@Deprecated('Use ExprValueJsonDtoAppwriteX')
extension ValueJsonDtoAppwriteX on ValueJsonDto {
// 修复 ::fn 字段丢失导致表达式无法正常解析的bug
  Map<String, dynamic> toJson() => {
        'ag': jsonEncode({
          'fn': fn,
          'ag': jsonEncode(ag),
        }),
      };

  static ValueJsonDto fromJson(Map<String, dynamic> js) {
    final jsMap = jsonDecode(js['ag'] as String);
    if (jsMap is List) {
// 仅用于适配 0.12.0 之前的版本, 之前版本所录入的asThis表达式都无法正常执行
      return ValueJsonDto(
        fn: js['fn'] as String? ?? 'asString', // 存储时已擦除`fn`,该值应当为空
        ag: jsonDecode(js['ag'] as String),
      );
    } else {
      return ValueJsonDto(
        fn: jsMap['fn'] as String? ?? 'asString',
        ag: jsonDecode(jsMap['ag'] as String),
      );
    }
  }
}

///
/// [ExprValue]
/// @since >0.14.0
/// 取代IExpr中的[Value], 属于不兼容变更
extension ExprValueJsonDtoAppwriteX on ExprValueNodeDto {
  // 修复 ::fn 字段丢失导致表达式无法正常解析的bug
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'ag': jsonEncode(ag),
      };

  static ExprValueNodeDto fromJson(Map<String, dynamic> js) => ExprValueNodeDto(
        type: AttrTypeDto.by(js['type'] as String),
        ag: jsonDecode(js['ag'] as String),
      );
}

/// 对应 [Expression]
extension ExprJsonDtoAppwriteX on ExprNodeDto {
  Map<String, dynamic> toJson() => {
        'fn': fn,
        'ag': jsonEncode(
            ag.map((e) => IExprJsonDtoAppwriteX(e).toJson()).toList()),
        'type': '${type?.name}',
      };

  static fromJson(Map<String, dynamic> json) {
    final ag = json['ag'] as String? ?? '';
    return ExprNodeDto(
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

extension IExprJsonDtoAppwriteX on IExprNodeDto {
  static IExprNodeDto fromDocument(Document doc) => fromJson(doc.data);

  static IExprNodeDto fromJson(Map<String, dynamic> json) {
    // 只有表达式才有::fn属性
    final fn = json['fn'] as String?;
    if (fn == null || fn.isEmpty) {
      return ExprValueJsonDtoAppwriteX.fromJson(json);
    } else {
      return ExprJsonDtoAppwriteX.fromJson(json);
    }
  }

  Map<String, dynamic> toJson() => (this is ExprValueNodeDto)
      ? (ExprValueJsonDtoAppwriteX((this as ExprValueNodeDto)).toJson())
      : (this is ExprNodeDto)
          ? ExprJsonDtoAppwriteX(this as ExprNodeDto).toJson()
          : throw Exception(
              'IExprJsonDtoAppwriteX::toJson#未处理的类型[$runtimeType]');
}

extension RecordDtoAppwriteX on RecordDto {
  Map<String, dynamic> toJson() => fields.map((key, value) => MapEntry(
        PropertyX.getPropId(true, key), // 使用propId, 因为纯数值的属性名触发Appwrite的bug
        jsonEncode(RcdValueDtoAppwriteX(ValueDto.fromDomain(value)).toJson()),
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
                e.value == null
                    ? Value.of('')
                    : RcdValueDtoAppwriteX.fromJson(jsonDecode(e.value))
                        .toDomain(),
                //       ..fn = "asString")
                //     .toDomain(null) as RcdValue)
              ),
            ),
      ));
}

extension MetaDtoAppwriteX on MetaDto {
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
        "views": jsonEncode(
            views.map((e) => TableViewAppwriteX(e).toJson()).toList()),
      };

  static MetaDto fromDocument(Document doc) => fromJson(doc.toFullJson());

  static MetaDto fromJson(Map<String, dynamic> json) {
    if (json['views'] != null) {
      final a = json['attrs'] as String? ?? '';
      final m = json['methods'] as String? ?? '';
      final v = json['views'] as String? ?? '';
      return MetaDto(
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
                .map((e) =>
                    MethodDtoAppwriteX.fromJson(e as Map<String, dynamic>))
                .toList(),
        views: v.isEmpty
            ? []
            : (jsonDecode(v) as List<dynamic>)
                .map((e) =>
                    TableViewAppwriteX.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else {
      return _fromJson_1_0_0(json);
    }
  }

  // 兼容 1.0.0版本，（实际上是兼容1.1之前的版本）
  static MetaDto _fromJson_1_0_0(Map<String, dynamic> json) {
    final a = json['attrs'] as String? ?? '';
    final m = json['methods'] as String? ?? '';
    return MetaDto(
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

extension ColViewInfoAppwriteX on ColViewInfo {
  toJson() => {
        "propId": propId,
        "width": width,
        "visible": visible,
      };

  static ColViewInfo fromJson(Map<String, dynamic> json) {
    try {
      return ColViewInfo(
        json['propId'] as String,
        json['width'] as double,
        json['visible'] as bool? ?? false,
      );
    } catch (e) {
      if ("$e" == "type 'int' is not a subtype of type 'double' in type cast") {
        return ColViewInfo(
          json['propId'] as String,
          (json['width'] as int).toDouble(),
          json['visible'] as bool? ?? false,
        );
      }
      rethrow;
    }
  }
}

extension TableViewAppwriteX on TableView {
  toJson() => {
        "vId": vId,
        "type": type.name,
        "name": name,
        "cols": jsonEncode(cols.map((e) => e.toJson()).toList()),
      };

  static TableView fromDocument(Document doc) => fromJson(doc.data);

  static TableView fromJson(Map<String, dynamic> json) => TableView.builder(
        vId: json['vId'] as int,
        type: ViewType.values.byName(json['type'] as String),
        name: json['name'] as String,
        cols: (jsonDecode(json['cols'] as String) as List)
            .map(
              (e) => ColViewInfoAppwriteX.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
}

extension MethodDtoAppwriteX on MethodDto {
  toJson() => {
        'k': jsonEncode(k),
        'name': name,
        'memo': memo,
        'expr': jsonEncode(IExprJsonDtoAppwriteX(expr).toJson()),
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

extension SpaceModelDtoAppwriteX on SpaceDto {
  Map<String, dynamic> toJson() => {
        // 'id': id, // 没有id属性
        'teamId': teamId,
        'name': name,
        'metas': jsonEncode(metas),
      };

  static SpaceDto fromJson(Map<String, dynamic> json) => SpaceDto(
        // 因为Appwrite.data 没有id属性, 不过新增 `toFullJson`方法,再次注入了id属性
        id: (json['id'] as String?) ?? '请注入ID或使用toFullJson',
        name: json['name'] as String,
        metas: ((jsonDecode(json['metas'] as String)) as List<dynamic>)
            .map((metaId) => metaId as String)
            .toList(),
        teamId: json['teamId'] as String,
      );
}

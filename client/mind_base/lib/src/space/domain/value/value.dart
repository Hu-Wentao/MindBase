import 'dart:math' as math;

import 'package:appwrite/appwrite.dart';
import 'package:bson/bson.dart';
import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:json_annotation/json_annotation.dart';

part 'value.g.dart';

// 异常
class TypeCastException extends BaseException {
  TypeCastException(String msg) : super(msg);
}

/// 字段  =======================================================================

/// 分量/字段/属性: 元组的某个属性值叫做分量.(一行记录叫元组Tuple)
// @JsonSerializable()
// class Field {
//   @JsonKey()
//   final String v; // 字段存储值
//   @JsonKey()
//   String? e; // 字段错误信息
//
//   Field(this.v, this.e);
//
//   Field.of(this.v, [this.e]);
//
//   Field.err(this.e) : v = "";
//
//   factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);
//
//   Map<String, dynamic> toJson() => _$FieldToJson(this);
//
//   @override
//   String toString() => toJson().toString();
// }

class Error {
  final String m; // 异常信息
  final String? s; // stace trace

  const Error(this.m, [this.s]);

  Error.fromJson(Map<String, dynamic> json)
      : this(
          json['m'] as String,
          json['s'] as String?,
        );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'm': m,
        's': s,
      };
}

/// === TableView （表视图）相关值对象 ===

enum ViewType {
  sheet, // 列前缀 vs
  form, // 列前缀  vf
}

/// 列 视图信息
/// 包含列propId和宽度
class ColViewInfo {
  final String propId;
  final double width;
  final bool visible; // 不能合并到width
  double get minWidth => 60;

  const ColViewInfo(this.propId, this.width, this.visible);

  const ColViewInfo.build({
    required this.propId,
    this.visible = true,
    this.width = 100,
  });

  ColViewInfo copyWith({
    String? propId,
    double? width,
    bool? visible,
  }) =>
      ColViewInfo(
        propId ?? this.propId,
        width ?? this.width,
        visible ?? this.visible,
      );

  @override
  String toString() =>
      'ColViewInfo{propId: $propId, width: $width, visible: $visible}';
}

///
/// TableView 实例的排序即List<TableView>的元素顺序
class TableView {
  final int vId; // ==-1 表示新增的View
  final String name; // 视图名称
  final ViewType type; // 列类型
  final List<ColViewInfo> cols; // 列排序与可见性

  const TableView(this.vId, this.name, this.type, this.cols);

  // -1 表示在实际插入时，应当被修正为最后一个
  TableView.builder({
    this.vId = -1,
    this.name = '新增表格视图',
    this.type = ViewType.sheet,
    this.cols = const [],
  });

  @Deprecated("copyWith")
  get update => copyWith;

  TableView copyWith({
    int? vId,
    ViewType? type,
    String? name,
    List<ColViewInfo>? cols,
  }) =>
      TableView.builder(
        vId: vId ?? this.vId,
        name: name ?? this.name,
        type: type ?? this.type,
        cols: cols ?? this.cols,
      );

  /// 将 ::index ==-1  的View更新为 [views]中最大的index
  TableView updateIndex(List<TableView> views) {
    if (this.vId != -1) return this;
    final vId =
        views.isEmpty ? 1 : views.map((e) => e.vId).reduce(math.max) + 1;
    return copyWith(vId: vId);
  }

  @override
  String toString() =>
      'TableView{vId: $vId, name: $name, type: $type, cols: $cols}';
}

class Permissions {
  final List<String> value;

  bool get isEmpty => value.isEmpty;

  const Permissions(this.value);

  Permissions.init({List<String>? origin}) : this(origin ?? []);

  Permissions add(Permissions value) => value.isEmpty ? this : this
    ..value.addAll(value.value);

  /// 以 全局角色 为单位授权权限
  // 给予任意角色权限
  static const all = Permissions(['role:all']);

  // 给予未登录用户权限
  static const onlyGuest = Permissions(['role:guest']);

  // 给予已登录用户权限
  static const onlyMember = Permissions(['role:member']);

  /// 以 用户 为单位授权权限
  /// 给予特定用户[userId]权限
  Permissions.user({required String userId}) : this(['user:$userId']);

  /// 以 团队 为单位授权权限
  /// 给予特定团队[teamId]内指定角色[role]成员权限;
  /// [role] 为empty表示 团队内全部成员
  Permissions.team({required String teamId, List<String> roles = const []})
      : this(roles.isEmpty ? [Role.team(teamId)] : roles);

  /// 以 成员 为单位授权权限
  /// 给予特定团队成员[memberId]权限
  /// 这样可以控制用户在离开团队后自动失去权限
  Permissions.member({required String memberId}) : this(['member:$memberId']);
}

/// === AttrType （属性类型）相关值对象 ===

enum AttrTp {
  @Deprecated("考虑移除, 但需要先处理MongoJs相关转换问题")
  objectId, // 特殊处理的String类型, todo 考虑移除,直接用 String/ref/type表示; 但可能存在ObjectId相关转换的问题,需要谨慎处理
  any, // 任意类型
  string,
  num,
  bool,
  ref, // 引用类型
  // func, // 函数类型 相当于Dart的Function,Excel的函数 暂不实现
}

/// 与 [AttrTypeDto] 对应
mixin ITypeMx {
  String get asString;

  num get asNum;

  bool get asBool;

  DateTime get asDate;
}

@JsonSerializable()
class Range {
  static const one = Range.equal(1);
  static const two = Range.equal(2);

  @JsonKey()
  final int min;
  @JsonKey()
  final int max;

  const Range(this.min, this.max);

  const Range.equal(int n)
      : min = n,
        max = n;

  bool inBound(int v) => v >= min && v <= max;

  factory Range.fromJson(Map<String, dynamic> json) => _$RangeFromJson(json);

  Map<String, dynamic> toJson() => _$RangeToJson(this);
}

@deprecated
enum FuncScope {
  input, // 输入处理, 将输入的值转换为`存储值`
  check, // 字段检查, input完成后被调用,检查字段值是否符合要求,不符合则将错误信息添加到e中
  output, // 输出处理, 将`存储值`转换为需要数据.如 func为 "数值*2", 则存储"A1",输出为 A1*2的值
}

typedef PropId = Tuple2<String, int>;

extension PropIdX on PropId {
  bool get isField => head == 'a';

  bool get isMethod => head == 'm';
}

extension PropertyX on String {
  /// 在字符串开头使用 m标识[Methods], 使用 a标识[Attribute]
  static String getPropId(bool isAttribute, int k) =>
      isAttribute ? 'a$k' : 'm$k';

  String get parsePropType => substring(0, 1);

  int get parsePropK => int.parse(substring(1));

  PropId parsePropId() => Tuple2(
        parsePropType,
        parsePropK,
      );

  static isPropId(bool? assignAttribute, String propId) =>
      assignAttribute == null
          ? isPropId(true, propId) || isPropId(false, propId)
          : assignAttribute
              ? propId.startsWith('a')
              : propId.startsWith('m');
}

abstract class ObjectIdX {
  static ObjectId get create => ObjectId(clientMode: true);

  static String get createHex => create.toHexString();
}

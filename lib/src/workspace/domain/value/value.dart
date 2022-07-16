import 'dart:math' as math;

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

enum ColWidthType {
  auto,
  hide,
  value,
}

/// 列 视图信息
/// 包含列propId和宽度
class ColViewInfo {
  final String propId;
  final int width;

  const ColViewInfo(this.propId, this.width);

  // 自动宽度
  const ColViewInfo.auto(this.propId) : width = 0;

  // 隐藏列
  // 如果没有特定列的propId，也表示隐藏改列
  const ColViewInfo.hide(this.propId) : width = -1;

  ColWidthType get colWidthType => width > 0
      ? ColWidthType.value
      : (width == 0 ? ColWidthType.auto : ColWidthType.hide);

  @override
  String toString() => 'ColViewInfo{propId: $propId, width: $width}';
}

class TableView {
  final int index; // ==-1 表示新增的View
  final String name; // 视图名称
  final ViewType type; // 列类型
  final List<ColViewInfo> cols; // 列排序与可见性

  const TableView(this.index, this.name, this.type, this.cols);

  // -1 表示在实际插入时，应当被修正为最后一个
  TableView.builder({
    this.index = -1,
    this.name = '新增表格视图',
    this.type = ViewType.sheet,
    this.cols = const [],
  });

  TableView update({
    int? index,
    ViewType? type,
    String? name,
    List<ColViewInfo>? cols,
  }) =>
      TableView.builder(
        index: index ?? this.index,
        name: name ?? this.name,
        type: type ?? this.type,
        cols: cols ?? this.cols,
      );

  /// 将 ::index ==-1  的View更新为 [views]中最大的index
  TableView updateIndex(List<TableView> views) {
    if (this.index != -1) return this;
    final index =
        views.isEmpty ? 1 : views.map((e) => e.index).reduce(math.max) + 1;
    return update(index: index);
  }

  @override
  String toString() =>
      'TableView{index: $index, name: $name, type: $type, cols: $cols}';
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

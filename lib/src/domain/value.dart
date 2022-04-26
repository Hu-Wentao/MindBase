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

enum AttrTp {
  @Deprecated("考虑移除, 但需要先处理MongoJs相关转换问题")
  objectId, // 特殊处理的String类型, todo 考虑移除,直接用 String/ref/type表示; 但可能存在ObjectId相关转换的问题,需要谨慎处理
  any, // 任意类型
  string,
  num,
  bool,
  // ref, // 对应 AsFuncRecord, 是ObjectId() String 的别名类型; 只有在引用其他字段时,才标识为ref, 如果标识当前记录的_id,则应该使用 string
  type, // 对应 AsFuncRecordMeta, 是ObjectId() String 的别名类型
  // func, // 函数类型 相当于Dart的Function,Excel的函数 暂不实现
}

/// 如果[tp]为[AttrTp.type],则[ref]不能为空
class AttrType {
  final AttrTp tp;
  final String? ref;

  static const AttrType any = AttrType(AttrTp.any, null);
  static const AttrType num = AttrType(AttrTp.num, null);
  static const AttrType string = AttrType(AttrTp.string, null);
  static const AttrType bool = AttrType(AttrTp.bool, null);

  const AttrType.type(String ref) : this(AttrTp.type, ref);

  const AttrType(this.tp, this.ref);

  /// [name]可以仅为 AttrTp.name, 也可以是 type_$ref
  factory AttrType.by(String name, [String? ref]) => (name.startsWith("type_"))
      ? AttrType.type(name.substring(5))
      : AttrType(AttrTp.values.byName(name), ref);

  static Iterable<AttrTp> get values => AttrTp.values;

  String get name => tp == AttrTp.type ? "type_$ref" : tp.name;

  @override
  String toString() => 'AttrType{tp: $tp, ref: $ref}';
}

/// 与 [AttrType] 对应
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

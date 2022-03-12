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

// /// 无类型(String)方案
class Value with ITypeMx {
  final String v; // 字段存储值
  String? e; // 字段错误信息

  Value(this.v, this.e);

  Value.of(dynamic v, [this.e]):v = "$v";

  Value.err(String? e) : this.of("", e);

  Value.fromJson(Map<String, dynamic> json)
      : this.of(
          json['v'] as String,
          json['e'] as String?,
        );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'v': v,
        'e': e,
      };

  @override
  String toString() => toJson().toString();

  @override
  bool get asBool =>
      const <String, bool>{
        "true": true,
        "false": false,
      }[v] ??
      (throw TypeCastException("[$v] is not bool"));

  @override
  DateTime get asDate =>
      DateTime.tryParse(v) ?? (throw TypeCastException("[$v] is not DateTime"));

  @override
  num get asNum =>
      num.tryParse(v) ?? (throw TypeCastException("[$v] is not num"));

  @override
  String get asString => v;

  bool equals(Value input) => v == input.v;
}

/// dynamic方案
/// Attr中类型变更后,需要同时转换数据库中存储的Value的类型!
// class Value with ITypeMx {
//   final dynamic v; // 字段存储值
//   String? e; // 字段错误信息
//
//   Value(this.v, this.e);
//
//   Value.of(this.v, [this.e]);
//
//   Value.fromJson(Map<String, dynamic> json)
//       : this.of(
//           json['v'] as dynamic,
//           json['e'] as String?,
//         );
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'v': v,
//         'e': e,
//       };
//
//   @override
//   String toString() => toJson().toString();
//
//   /// 这不是类型转换!  如果真实类型与as类型不同,将会报错!
//   @override
//   String get asString => "$v";
//
//   @override
//   num get asNum => v as num;
//
//   @override
//   bool get asBool => v as bool;
//
//   @override
//   DateTime get asDateTime => v as DateTime;
// }

/// 带类型的方案, 后期再引入
/// 如果是带类型的方法,则从输入到输出都要固定值类型
// class Value<T> { // with ITypeMx
//   final T v; // 字段存储值
//   Error? e; // 字段错误信息
//
//   Value(this.v, this.e);
//
//   Value.of(this.v, [this.e]);
//
//   Value.fromJson(Map<String, dynamic> json)
//       : this.of(
//           json['v'] as T,
//           json['e'] != null
//               ? Error.fromJson(json['e'] as Map<String, dynamic>)
//               : null,
//         );
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'v': v,
//         'e': e,
//       };
//
//   @override
//   String toString() => toJson().toString();
// }

enum AttrType {
  any, // 任意类型
  string,
  num,
  bool,
  date,
  // todo 引用类型; 可能不必要，考虑使用 Func去获取外部关系
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

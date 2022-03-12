import 'package:json_annotation/json_annotation.dart';

part 'value.g.dart';

/// 字段  =======================================================================

/// 分量/字段/属性: 元组的某个属性值叫做分量.(一行记录叫元组Tuple)
@JsonSerializable()
class Field {
  @JsonKey()
  final String v; // 字段存储值
  @JsonKey()
  String? e; // 字段错误信息

  Field(this.v, this.e);

  Field.of(this.v, [this.e]);

  Field.err(this.e) : v = "";

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  Map<String, dynamic> toJson() => _$FieldToJson(this);

  @override
  String toString() => toJson().toString();
}

enum AttrType {
  any, // 任意类型
  string,
  number,
  bool,
  date,
  // todo 引用类型; 可能不必要，考虑使用 Func去获取外部关系
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

enum FuncScope {
  input, // 输入处理, 将输入的值转换为`存储值`
  check, // 字段检查, input完成后被调用,检查字段值是否符合要求,不符合则将错误信息添加到e中
  output, // 输出处理, 将`存储值`转换为需要数据.如 func为 "数值*2", 则存储"A1",输出为 A1*2的值
}

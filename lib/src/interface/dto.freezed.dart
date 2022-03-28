// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ValueDto _$ValueDtoFromJson(Map<String, dynamic> json) {
  return _ValueDto.fromJson(json);
}

/// @nodoc
class _$ValueDtoTearOff {
  const _$ValueDtoTearOff();

  _ValueDto call(String? v, String? e) {
    return _ValueDto(
      v,
      e,
    );
  }

  ValueDto fromJson(Map<String, Object?> json) {
    return ValueDto.fromJson(json);
  }
}

/// @nodoc
const $ValueDto = _$ValueDtoTearOff();

/// @nodoc
mixin _$ValueDto {
  String? get v => throw _privateConstructorUsedError; // 字段存储值
  String? get e => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ValueDtoCopyWith<ValueDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValueDtoCopyWith<$Res> {
  factory $ValueDtoCopyWith(ValueDto value, $Res Function(ValueDto) then) =
      _$ValueDtoCopyWithImpl<$Res>;
  $Res call({String? v, String? e});
}

/// @nodoc
class _$ValueDtoCopyWithImpl<$Res> implements $ValueDtoCopyWith<$Res> {
  _$ValueDtoCopyWithImpl(this._value, this._then);

  final ValueDto _value;
  // ignore: unused_field
  final $Res Function(ValueDto) _then;

  @override
  $Res call({
    Object? v = freezed,
    Object? e = freezed,
  }) {
    return _then(_value.copyWith(
      v: v == freezed
          ? _value.v
          : v // ignore: cast_nullable_to_non_nullable
              as String?,
      e: e == freezed
          ? _value.e
          : e // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$ValueDtoCopyWith<$Res> implements $ValueDtoCopyWith<$Res> {
  factory _$ValueDtoCopyWith(_ValueDto value, $Res Function(_ValueDto) then) =
      __$ValueDtoCopyWithImpl<$Res>;
  @override
  $Res call({String? v, String? e});
}

/// @nodoc
class __$ValueDtoCopyWithImpl<$Res> extends _$ValueDtoCopyWithImpl<$Res>
    implements _$ValueDtoCopyWith<$Res> {
  __$ValueDtoCopyWithImpl(_ValueDto _value, $Res Function(_ValueDto) _then)
      : super(_value, (v) => _then(v as _ValueDto));

  @override
  _ValueDto get _value => super._value as _ValueDto;

  @override
  $Res call({
    Object? v = freezed,
    Object? e = freezed,
  }) {
    return _then(_ValueDto(
      v == freezed
          ? _value.v
          : v // ignore: cast_nullable_to_non_nullable
              as String?,
      e == freezed
          ? _value.e
          : e // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ValueDto extends _ValueDto {
  const _$_ValueDto(this.v, this.e) : super._();

  factory _$_ValueDto.fromJson(Map<String, dynamic> json) =>
      _$$_ValueDtoFromJson(json);

  @override
  final String? v;
  @override // 字段存储值
  final String? e;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ValueDto &&
            const DeepCollectionEquality().equals(other.v, v) &&
            const DeepCollectionEquality().equals(other.e, e));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(v),
      const DeepCollectionEquality().hash(e));

  @JsonKey(ignore: true)
  @override
  _$ValueDtoCopyWith<_ValueDto> get copyWith =>
      __$ValueDtoCopyWithImpl<_ValueDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ValueDtoToJson(this);
  }
}

abstract class _ValueDto extends ValueDto {
  const factory _ValueDto(String? v, String? e) = _$_ValueDto;
  const _ValueDto._() : super._();

  factory _ValueDto.fromJson(Map<String, dynamic> json) = _$_ValueDto.fromJson;

  @override
  String? get v;
  @override // 字段存储值
  String? get e;
  @override
  @JsonKey(ignore: true)
  _$ValueDtoCopyWith<_ValueDto> get copyWith =>
      throw _privateConstructorUsedError;
}

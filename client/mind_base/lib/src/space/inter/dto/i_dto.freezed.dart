// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'i_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SpaceDto _$SpaceDtoFromJson(Map<String, dynamic> json) {
  return _SpaceDto.fromJson(json);
}

/// @nodoc
mixin _$SpaceDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get teamId => throw _privateConstructorUsedError;
  List<String> get metas => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpaceDtoCopyWith<SpaceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpaceDtoCopyWith<$Res> {
  factory $SpaceDtoCopyWith(SpaceDto value, $Res Function(SpaceDto) then) =
      _$SpaceDtoCopyWithImpl<$Res, SpaceDto>;
  @useResult
  $Res call({String id, String name, String teamId, List<String> metas});
}

/// @nodoc
class _$SpaceDtoCopyWithImpl<$Res, $Val extends SpaceDto>
    implements $SpaceDtoCopyWith<$Res> {
  _$SpaceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? teamId = null,
    Object? metas = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      metas: null == metas
          ? _value.metas
          : metas // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SpaceDtoCopyWith<$Res> implements $SpaceDtoCopyWith<$Res> {
  factory _$$_SpaceDtoCopyWith(
          _$_SpaceDto value, $Res Function(_$_SpaceDto) then) =
      __$$_SpaceDtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String teamId, List<String> metas});
}

/// @nodoc
class __$$_SpaceDtoCopyWithImpl<$Res>
    extends _$SpaceDtoCopyWithImpl<$Res, _$_SpaceDto>
    implements _$$_SpaceDtoCopyWith<$Res> {
  __$$_SpaceDtoCopyWithImpl(
      _$_SpaceDto _value, $Res Function(_$_SpaceDto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? teamId = null,
    Object? metas = null,
  }) {
    return _then(_$_SpaceDto(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      metas: null == metas
          ? _value._metas
          : metas // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SpaceDto extends _SpaceDto {
  const _$_SpaceDto(
      {this.id = '',
      this.name = '',
      this.teamId = '',
      final List<String> metas = const []})
      : _metas = metas,
        super._();

  factory _$_SpaceDto.fromJson(Map<String, dynamic> json) =>
      _$$_SpaceDtoFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String teamId;
  final List<String> _metas;
  @override
  @JsonKey()
  List<String> get metas {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_metas);
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SpaceDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            const DeepCollectionEquality().equals(other._metas, _metas));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, teamId,
      const DeepCollectionEquality().hash(_metas));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SpaceDtoCopyWith<_$_SpaceDto> get copyWith =>
      __$$_SpaceDtoCopyWithImpl<_$_SpaceDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SpaceDtoToJson(
      this,
    );
  }
}

abstract class _SpaceDto extends SpaceDto {
  const factory _SpaceDto(
      {final String id,
      final String name,
      final String teamId,
      final List<String> metas}) = _$_SpaceDto;
  const _SpaceDto._() : super._();

  factory _SpaceDto.fromJson(Map<String, dynamic> json) = _$_SpaceDto.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get teamId;
  @override
  List<String> get metas;
  @override
  @JsonKey(ignore: true)
  _$$_SpaceDtoCopyWith<_$_SpaceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

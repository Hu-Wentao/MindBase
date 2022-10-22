// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SpaceAct {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(SpaceDto data) updateModel,
    required TResult Function(CollectionDto data) updateTableDetail,
    required TResult Function(MetaDto data) insertMeta,
    required TResult Function(String metaId) deleteMeta,
    required TResult Function(TableDto dto) updateByTable,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(SpaceDto data)? updateModel,
    TResult? Function(CollectionDto data)? updateTableDetail,
    TResult? Function(MetaDto data)? insertMeta,
    TResult? Function(String metaId)? deleteMeta,
    TResult? Function(TableDto dto)? updateByTable,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(SpaceDto data)? updateModel,
    TResult Function(CollectionDto data)? updateTableDetail,
    TResult Function(MetaDto data)? insertMeta,
    TResult Function(String metaId)? deleteMeta,
    TResult Function(TableDto dto)? updateByTable,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpaceActInitModel value) initModel,
    required TResult Function(SpaceActUpdateModel value) updateModel,
    required TResult Function(SpaceActUpdateTableDetail value)
        updateTableDetail,
    required TResult Function(SpaceActInsertMeta value) insertMeta,
    required TResult Function(SpaceActDeleteMeta value) deleteMeta,
    required TResult Function(SpaceActUpdateByTable value) updateByTable,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpaceActInitModel value)? initModel,
    TResult? Function(SpaceActUpdateModel value)? updateModel,
    TResult? Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult? Function(SpaceActInsertMeta value)? insertMeta,
    TResult? Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult? Function(SpaceActUpdateByTable value)? updateByTable,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceActInitModel value)? initModel,
    TResult Function(SpaceActUpdateModel value)? updateModel,
    TResult Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult Function(SpaceActInsertMeta value)? insertMeta,
    TResult Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult Function(SpaceActUpdateByTable value)? updateByTable,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpaceActCopyWith<$Res> {
  factory $SpaceActCopyWith(SpaceAct value, $Res Function(SpaceAct) then) =
      _$SpaceActCopyWithImpl<$Res, SpaceAct>;
}

/// @nodoc
class _$SpaceActCopyWithImpl<$Res, $Val extends SpaceAct>
    implements $SpaceActCopyWith<$Res> {
  _$SpaceActCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SpaceActInitModelCopyWith<$Res> {
  factory _$$SpaceActInitModelCopyWith(
          _$SpaceActInitModel value, $Res Function(_$SpaceActInitModel) then) =
      __$$SpaceActInitModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SpaceActInitModelCopyWithImpl<$Res>
    extends _$SpaceActCopyWithImpl<$Res, _$SpaceActInitModel>
    implements _$$SpaceActInitModelCopyWith<$Res> {
  __$$SpaceActInitModelCopyWithImpl(
      _$SpaceActInitModel _value, $Res Function(_$SpaceActInitModel) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SpaceActInitModel implements SpaceActInitModel {
  const _$SpaceActInitModel();

  @override
  String toString() {
    return 'SpaceAct.initModel()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SpaceActInitModel);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(SpaceDto data) updateModel,
    required TResult Function(CollectionDto data) updateTableDetail,
    required TResult Function(MetaDto data) insertMeta,
    required TResult Function(String metaId) deleteMeta,
    required TResult Function(TableDto dto) updateByTable,
  }) {
    return initModel();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(SpaceDto data)? updateModel,
    TResult? Function(CollectionDto data)? updateTableDetail,
    TResult? Function(MetaDto data)? insertMeta,
    TResult? Function(String metaId)? deleteMeta,
    TResult? Function(TableDto dto)? updateByTable,
  }) {
    return initModel?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(SpaceDto data)? updateModel,
    TResult Function(CollectionDto data)? updateTableDetail,
    TResult Function(MetaDto data)? insertMeta,
    TResult Function(String metaId)? deleteMeta,
    TResult Function(TableDto dto)? updateByTable,
    required TResult orElse(),
  }) {
    if (initModel != null) {
      return initModel();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpaceActInitModel value) initModel,
    required TResult Function(SpaceActUpdateModel value) updateModel,
    required TResult Function(SpaceActUpdateTableDetail value)
        updateTableDetail,
    required TResult Function(SpaceActInsertMeta value) insertMeta,
    required TResult Function(SpaceActDeleteMeta value) deleteMeta,
    required TResult Function(SpaceActUpdateByTable value) updateByTable,
  }) {
    return initModel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpaceActInitModel value)? initModel,
    TResult? Function(SpaceActUpdateModel value)? updateModel,
    TResult? Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult? Function(SpaceActInsertMeta value)? insertMeta,
    TResult? Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult? Function(SpaceActUpdateByTable value)? updateByTable,
  }) {
    return initModel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceActInitModel value)? initModel,
    TResult Function(SpaceActUpdateModel value)? updateModel,
    TResult Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult Function(SpaceActInsertMeta value)? insertMeta,
    TResult Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult Function(SpaceActUpdateByTable value)? updateByTable,
    required TResult orElse(),
  }) {
    if (initModel != null) {
      return initModel(this);
    }
    return orElse();
  }
}

abstract class SpaceActInitModel implements SpaceAct {
  const factory SpaceActInitModel() = _$SpaceActInitModel;
}

/// @nodoc
abstract class _$$SpaceActUpdateModelCopyWith<$Res> {
  factory _$$SpaceActUpdateModelCopyWith(_$SpaceActUpdateModel value,
          $Res Function(_$SpaceActUpdateModel) then) =
      __$$SpaceActUpdateModelCopyWithImpl<$Res>;
  @useResult
  $Res call({SpaceDto data});
}

/// @nodoc
class __$$SpaceActUpdateModelCopyWithImpl<$Res>
    extends _$SpaceActCopyWithImpl<$Res, _$SpaceActUpdateModel>
    implements _$$SpaceActUpdateModelCopyWith<$Res> {
  __$$SpaceActUpdateModelCopyWithImpl(
      _$SpaceActUpdateModel _value, $Res Function(_$SpaceActUpdateModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SpaceActUpdateModel(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SpaceDto,
    ));
  }
}

/// @nodoc

class _$SpaceActUpdateModel implements SpaceActUpdateModel {
  const _$SpaceActUpdateModel(this.data);

  @override
  final SpaceDto data;

  @override
  String toString() {
    return 'SpaceAct.updateModel(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpaceActUpdateModel &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpaceActUpdateModelCopyWith<_$SpaceActUpdateModel> get copyWith =>
      __$$SpaceActUpdateModelCopyWithImpl<_$SpaceActUpdateModel>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(SpaceDto data) updateModel,
    required TResult Function(CollectionDto data) updateTableDetail,
    required TResult Function(MetaDto data) insertMeta,
    required TResult Function(String metaId) deleteMeta,
    required TResult Function(TableDto dto) updateByTable,
  }) {
    return updateModel(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(SpaceDto data)? updateModel,
    TResult? Function(CollectionDto data)? updateTableDetail,
    TResult? Function(MetaDto data)? insertMeta,
    TResult? Function(String metaId)? deleteMeta,
    TResult? Function(TableDto dto)? updateByTable,
  }) {
    return updateModel?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(SpaceDto data)? updateModel,
    TResult Function(CollectionDto data)? updateTableDetail,
    TResult Function(MetaDto data)? insertMeta,
    TResult Function(String metaId)? deleteMeta,
    TResult Function(TableDto dto)? updateByTable,
    required TResult orElse(),
  }) {
    if (updateModel != null) {
      return updateModel(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpaceActInitModel value) initModel,
    required TResult Function(SpaceActUpdateModel value) updateModel,
    required TResult Function(SpaceActUpdateTableDetail value)
        updateTableDetail,
    required TResult Function(SpaceActInsertMeta value) insertMeta,
    required TResult Function(SpaceActDeleteMeta value) deleteMeta,
    required TResult Function(SpaceActUpdateByTable value) updateByTable,
  }) {
    return updateModel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpaceActInitModel value)? initModel,
    TResult? Function(SpaceActUpdateModel value)? updateModel,
    TResult? Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult? Function(SpaceActInsertMeta value)? insertMeta,
    TResult? Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult? Function(SpaceActUpdateByTable value)? updateByTable,
  }) {
    return updateModel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceActInitModel value)? initModel,
    TResult Function(SpaceActUpdateModel value)? updateModel,
    TResult Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult Function(SpaceActInsertMeta value)? insertMeta,
    TResult Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult Function(SpaceActUpdateByTable value)? updateByTable,
    required TResult orElse(),
  }) {
    if (updateModel != null) {
      return updateModel(this);
    }
    return orElse();
  }
}

abstract class SpaceActUpdateModel implements SpaceAct {
  const factory SpaceActUpdateModel(final SpaceDto data) =
      _$SpaceActUpdateModel;

  SpaceDto get data;
  @JsonKey(ignore: true)
  _$$SpaceActUpdateModelCopyWith<_$SpaceActUpdateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SpaceActUpdateTableDetailCopyWith<$Res> {
  factory _$$SpaceActUpdateTableDetailCopyWith(
          _$SpaceActUpdateTableDetail value,
          $Res Function(_$SpaceActUpdateTableDetail) then) =
      __$$SpaceActUpdateTableDetailCopyWithImpl<$Res>;
  @useResult
  $Res call({CollectionDto data});
}

/// @nodoc
class __$$SpaceActUpdateTableDetailCopyWithImpl<$Res>
    extends _$SpaceActCopyWithImpl<$Res, _$SpaceActUpdateTableDetail>
    implements _$$SpaceActUpdateTableDetailCopyWith<$Res> {
  __$$SpaceActUpdateTableDetailCopyWithImpl(_$SpaceActUpdateTableDetail _value,
      $Res Function(_$SpaceActUpdateTableDetail) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SpaceActUpdateTableDetail(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as CollectionDto,
    ));
  }
}

/// @nodoc

class _$SpaceActUpdateTableDetail implements SpaceActUpdateTableDetail {
  const _$SpaceActUpdateTableDetail(this.data);

  @override
  final CollectionDto data;

  @override
  String toString() {
    return 'SpaceAct.updateTableDetail(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpaceActUpdateTableDetail &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpaceActUpdateTableDetailCopyWith<_$SpaceActUpdateTableDetail>
      get copyWith => __$$SpaceActUpdateTableDetailCopyWithImpl<
          _$SpaceActUpdateTableDetail>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(SpaceDto data) updateModel,
    required TResult Function(CollectionDto data) updateTableDetail,
    required TResult Function(MetaDto data) insertMeta,
    required TResult Function(String metaId) deleteMeta,
    required TResult Function(TableDto dto) updateByTable,
  }) {
    return updateTableDetail(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(SpaceDto data)? updateModel,
    TResult? Function(CollectionDto data)? updateTableDetail,
    TResult? Function(MetaDto data)? insertMeta,
    TResult? Function(String metaId)? deleteMeta,
    TResult? Function(TableDto dto)? updateByTable,
  }) {
    return updateTableDetail?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(SpaceDto data)? updateModel,
    TResult Function(CollectionDto data)? updateTableDetail,
    TResult Function(MetaDto data)? insertMeta,
    TResult Function(String metaId)? deleteMeta,
    TResult Function(TableDto dto)? updateByTable,
    required TResult orElse(),
  }) {
    if (updateTableDetail != null) {
      return updateTableDetail(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpaceActInitModel value) initModel,
    required TResult Function(SpaceActUpdateModel value) updateModel,
    required TResult Function(SpaceActUpdateTableDetail value)
        updateTableDetail,
    required TResult Function(SpaceActInsertMeta value) insertMeta,
    required TResult Function(SpaceActDeleteMeta value) deleteMeta,
    required TResult Function(SpaceActUpdateByTable value) updateByTable,
  }) {
    return updateTableDetail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpaceActInitModel value)? initModel,
    TResult? Function(SpaceActUpdateModel value)? updateModel,
    TResult? Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult? Function(SpaceActInsertMeta value)? insertMeta,
    TResult? Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult? Function(SpaceActUpdateByTable value)? updateByTable,
  }) {
    return updateTableDetail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceActInitModel value)? initModel,
    TResult Function(SpaceActUpdateModel value)? updateModel,
    TResult Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult Function(SpaceActInsertMeta value)? insertMeta,
    TResult Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult Function(SpaceActUpdateByTable value)? updateByTable,
    required TResult orElse(),
  }) {
    if (updateTableDetail != null) {
      return updateTableDetail(this);
    }
    return orElse();
  }
}

abstract class SpaceActUpdateTableDetail implements SpaceAct {
  const factory SpaceActUpdateTableDetail(final CollectionDto data) =
      _$SpaceActUpdateTableDetail;

  CollectionDto get data;
  @JsonKey(ignore: true)
  _$$SpaceActUpdateTableDetailCopyWith<_$SpaceActUpdateTableDetail>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SpaceActInsertMetaCopyWith<$Res> {
  factory _$$SpaceActInsertMetaCopyWith(_$SpaceActInsertMeta value,
          $Res Function(_$SpaceActInsertMeta) then) =
      __$$SpaceActInsertMetaCopyWithImpl<$Res>;
  @useResult
  $Res call({MetaDto data});
}

/// @nodoc
class __$$SpaceActInsertMetaCopyWithImpl<$Res>
    extends _$SpaceActCopyWithImpl<$Res, _$SpaceActInsertMeta>
    implements _$$SpaceActInsertMetaCopyWith<$Res> {
  __$$SpaceActInsertMetaCopyWithImpl(
      _$SpaceActInsertMeta _value, $Res Function(_$SpaceActInsertMeta) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SpaceActInsertMeta(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as MetaDto,
    ));
  }
}

/// @nodoc

class _$SpaceActInsertMeta implements SpaceActInsertMeta {
  const _$SpaceActInsertMeta(this.data);

  @override
  final MetaDto data;

  @override
  String toString() {
    return 'SpaceAct.insertMeta(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpaceActInsertMeta &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpaceActInsertMetaCopyWith<_$SpaceActInsertMeta> get copyWith =>
      __$$SpaceActInsertMetaCopyWithImpl<_$SpaceActInsertMeta>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(SpaceDto data) updateModel,
    required TResult Function(CollectionDto data) updateTableDetail,
    required TResult Function(MetaDto data) insertMeta,
    required TResult Function(String metaId) deleteMeta,
    required TResult Function(TableDto dto) updateByTable,
  }) {
    return insertMeta(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(SpaceDto data)? updateModel,
    TResult? Function(CollectionDto data)? updateTableDetail,
    TResult? Function(MetaDto data)? insertMeta,
    TResult? Function(String metaId)? deleteMeta,
    TResult? Function(TableDto dto)? updateByTable,
  }) {
    return insertMeta?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(SpaceDto data)? updateModel,
    TResult Function(CollectionDto data)? updateTableDetail,
    TResult Function(MetaDto data)? insertMeta,
    TResult Function(String metaId)? deleteMeta,
    TResult Function(TableDto dto)? updateByTable,
    required TResult orElse(),
  }) {
    if (insertMeta != null) {
      return insertMeta(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpaceActInitModel value) initModel,
    required TResult Function(SpaceActUpdateModel value) updateModel,
    required TResult Function(SpaceActUpdateTableDetail value)
        updateTableDetail,
    required TResult Function(SpaceActInsertMeta value) insertMeta,
    required TResult Function(SpaceActDeleteMeta value) deleteMeta,
    required TResult Function(SpaceActUpdateByTable value) updateByTable,
  }) {
    return insertMeta(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpaceActInitModel value)? initModel,
    TResult? Function(SpaceActUpdateModel value)? updateModel,
    TResult? Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult? Function(SpaceActInsertMeta value)? insertMeta,
    TResult? Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult? Function(SpaceActUpdateByTable value)? updateByTable,
  }) {
    return insertMeta?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceActInitModel value)? initModel,
    TResult Function(SpaceActUpdateModel value)? updateModel,
    TResult Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult Function(SpaceActInsertMeta value)? insertMeta,
    TResult Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult Function(SpaceActUpdateByTable value)? updateByTable,
    required TResult orElse(),
  }) {
    if (insertMeta != null) {
      return insertMeta(this);
    }
    return orElse();
  }
}

abstract class SpaceActInsertMeta implements SpaceAct {
  const factory SpaceActInsertMeta(final MetaDto data) = _$SpaceActInsertMeta;

  MetaDto get data;
  @JsonKey(ignore: true)
  _$$SpaceActInsertMetaCopyWith<_$SpaceActInsertMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SpaceActDeleteMetaCopyWith<$Res> {
  factory _$$SpaceActDeleteMetaCopyWith(_$SpaceActDeleteMeta value,
          $Res Function(_$SpaceActDeleteMeta) then) =
      __$$SpaceActDeleteMetaCopyWithImpl<$Res>;
  @useResult
  $Res call({String metaId});
}

/// @nodoc
class __$$SpaceActDeleteMetaCopyWithImpl<$Res>
    extends _$SpaceActCopyWithImpl<$Res, _$SpaceActDeleteMeta>
    implements _$$SpaceActDeleteMetaCopyWith<$Res> {
  __$$SpaceActDeleteMetaCopyWithImpl(
      _$SpaceActDeleteMeta _value, $Res Function(_$SpaceActDeleteMeta) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metaId = null,
  }) {
    return _then(_$SpaceActDeleteMeta(
      null == metaId
          ? _value.metaId
          : metaId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SpaceActDeleteMeta implements SpaceActDeleteMeta {
  const _$SpaceActDeleteMeta(this.metaId);

  @override
  final String metaId;

  @override
  String toString() {
    return 'SpaceAct.deleteMeta(metaId: $metaId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpaceActDeleteMeta &&
            (identical(other.metaId, metaId) || other.metaId == metaId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, metaId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpaceActDeleteMetaCopyWith<_$SpaceActDeleteMeta> get copyWith =>
      __$$SpaceActDeleteMetaCopyWithImpl<_$SpaceActDeleteMeta>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(SpaceDto data) updateModel,
    required TResult Function(CollectionDto data) updateTableDetail,
    required TResult Function(MetaDto data) insertMeta,
    required TResult Function(String metaId) deleteMeta,
    required TResult Function(TableDto dto) updateByTable,
  }) {
    return deleteMeta(metaId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(SpaceDto data)? updateModel,
    TResult? Function(CollectionDto data)? updateTableDetail,
    TResult? Function(MetaDto data)? insertMeta,
    TResult? Function(String metaId)? deleteMeta,
    TResult? Function(TableDto dto)? updateByTable,
  }) {
    return deleteMeta?.call(metaId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(SpaceDto data)? updateModel,
    TResult Function(CollectionDto data)? updateTableDetail,
    TResult Function(MetaDto data)? insertMeta,
    TResult Function(String metaId)? deleteMeta,
    TResult Function(TableDto dto)? updateByTable,
    required TResult orElse(),
  }) {
    if (deleteMeta != null) {
      return deleteMeta(metaId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpaceActInitModel value) initModel,
    required TResult Function(SpaceActUpdateModel value) updateModel,
    required TResult Function(SpaceActUpdateTableDetail value)
        updateTableDetail,
    required TResult Function(SpaceActInsertMeta value) insertMeta,
    required TResult Function(SpaceActDeleteMeta value) deleteMeta,
    required TResult Function(SpaceActUpdateByTable value) updateByTable,
  }) {
    return deleteMeta(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpaceActInitModel value)? initModel,
    TResult? Function(SpaceActUpdateModel value)? updateModel,
    TResult? Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult? Function(SpaceActInsertMeta value)? insertMeta,
    TResult? Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult? Function(SpaceActUpdateByTable value)? updateByTable,
  }) {
    return deleteMeta?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceActInitModel value)? initModel,
    TResult Function(SpaceActUpdateModel value)? updateModel,
    TResult Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult Function(SpaceActInsertMeta value)? insertMeta,
    TResult Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult Function(SpaceActUpdateByTable value)? updateByTable,
    required TResult orElse(),
  }) {
    if (deleteMeta != null) {
      return deleteMeta(this);
    }
    return orElse();
  }
}

abstract class SpaceActDeleteMeta implements SpaceAct {
  const factory SpaceActDeleteMeta(final String metaId) = _$SpaceActDeleteMeta;

  String get metaId;
  @JsonKey(ignore: true)
  _$$SpaceActDeleteMetaCopyWith<_$SpaceActDeleteMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SpaceActUpdateByTableCopyWith<$Res> {
  factory _$$SpaceActUpdateByTableCopyWith(_$SpaceActUpdateByTable value,
          $Res Function(_$SpaceActUpdateByTable) then) =
      __$$SpaceActUpdateByTableCopyWithImpl<$Res>;
  @useResult
  $Res call({TableDto dto});
}

/// @nodoc
class __$$SpaceActUpdateByTableCopyWithImpl<$Res>
    extends _$SpaceActCopyWithImpl<$Res, _$SpaceActUpdateByTable>
    implements _$$SpaceActUpdateByTableCopyWith<$Res> {
  __$$SpaceActUpdateByTableCopyWithImpl(_$SpaceActUpdateByTable _value,
      $Res Function(_$SpaceActUpdateByTable) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dto = null,
  }) {
    return _then(_$SpaceActUpdateByTable(
      null == dto
          ? _value.dto
          : dto // ignore: cast_nullable_to_non_nullable
              as TableDto,
    ));
  }
}

/// @nodoc

class _$SpaceActUpdateByTable implements SpaceActUpdateByTable {
  const _$SpaceActUpdateByTable(this.dto);

  @override
  final TableDto dto;

  @override
  String toString() {
    return 'SpaceAct.updateByTable(dto: $dto)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpaceActUpdateByTable &&
            (identical(other.dto, dto) || other.dto == dto));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dto);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpaceActUpdateByTableCopyWith<_$SpaceActUpdateByTable> get copyWith =>
      __$$SpaceActUpdateByTableCopyWithImpl<_$SpaceActUpdateByTable>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(SpaceDto data) updateModel,
    required TResult Function(CollectionDto data) updateTableDetail,
    required TResult Function(MetaDto data) insertMeta,
    required TResult Function(String metaId) deleteMeta,
    required TResult Function(TableDto dto) updateByTable,
  }) {
    return updateByTable(dto);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(SpaceDto data)? updateModel,
    TResult? Function(CollectionDto data)? updateTableDetail,
    TResult? Function(MetaDto data)? insertMeta,
    TResult? Function(String metaId)? deleteMeta,
    TResult? Function(TableDto dto)? updateByTable,
  }) {
    return updateByTable?.call(dto);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(SpaceDto data)? updateModel,
    TResult Function(CollectionDto data)? updateTableDetail,
    TResult Function(MetaDto data)? insertMeta,
    TResult Function(String metaId)? deleteMeta,
    TResult Function(TableDto dto)? updateByTable,
    required TResult orElse(),
  }) {
    if (updateByTable != null) {
      return updateByTable(dto);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpaceActInitModel value) initModel,
    required TResult Function(SpaceActUpdateModel value) updateModel,
    required TResult Function(SpaceActUpdateTableDetail value)
        updateTableDetail,
    required TResult Function(SpaceActInsertMeta value) insertMeta,
    required TResult Function(SpaceActDeleteMeta value) deleteMeta,
    required TResult Function(SpaceActUpdateByTable value) updateByTable,
  }) {
    return updateByTable(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpaceActInitModel value)? initModel,
    TResult? Function(SpaceActUpdateModel value)? updateModel,
    TResult? Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult? Function(SpaceActInsertMeta value)? insertMeta,
    TResult? Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult? Function(SpaceActUpdateByTable value)? updateByTable,
  }) {
    return updateByTable?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceActInitModel value)? initModel,
    TResult Function(SpaceActUpdateModel value)? updateModel,
    TResult Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult Function(SpaceActInsertMeta value)? insertMeta,
    TResult Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult Function(SpaceActUpdateByTable value)? updateByTable,
    required TResult orElse(),
  }) {
    if (updateByTable != null) {
      return updateByTable(this);
    }
    return orElse();
  }
}

abstract class SpaceActUpdateByTable implements SpaceAct {
  const factory SpaceActUpdateByTable(final TableDto dto) =
      _$SpaceActUpdateByTable;

  TableDto get dto;
  @JsonKey(ignore: true)
  _$$SpaceActUpdateByTableCopyWith<_$SpaceActUpdateByTable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SpaceState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(
            da.Collection metaTableDetail, List<MetaModel> metas)
        done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(da.Collection metaTableDetail, List<MetaModel> metas)?
        done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(da.Collection metaTableDetail, List<MetaModel> metas)?
        done,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpaceStateInit value) init,
    required TResult Function(SpaceStateDone value) done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpaceStateInit value)? init,
    TResult? Function(SpaceStateDone value)? done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceStateInit value)? init,
    TResult Function(SpaceStateDone value)? done,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpaceStateCopyWith<$Res> {
  factory $SpaceStateCopyWith(
          SpaceState value, $Res Function(SpaceState) then) =
      _$SpaceStateCopyWithImpl<$Res, SpaceState>;
}

/// @nodoc
class _$SpaceStateCopyWithImpl<$Res, $Val extends SpaceState>
    implements $SpaceStateCopyWith<$Res> {
  _$SpaceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SpaceStateInitCopyWith<$Res> {
  factory _$$SpaceStateInitCopyWith(
          _$SpaceStateInit value, $Res Function(_$SpaceStateInit) then) =
      __$$SpaceStateInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SpaceStateInitCopyWithImpl<$Res>
    extends _$SpaceStateCopyWithImpl<$Res, _$SpaceStateInit>
    implements _$$SpaceStateInitCopyWith<$Res> {
  __$$SpaceStateInitCopyWithImpl(
      _$SpaceStateInit _value, $Res Function(_$SpaceStateInit) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SpaceStateInit implements SpaceStateInit {
  const _$SpaceStateInit();

  @override
  String toString() {
    return 'SpaceState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SpaceStateInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(
            da.Collection metaTableDetail, List<MetaModel> metas)
        done,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(da.Collection metaTableDetail, List<MetaModel> metas)?
        done,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(da.Collection metaTableDetail, List<MetaModel> metas)?
        done,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpaceStateInit value) init,
    required TResult Function(SpaceStateDone value) done,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpaceStateInit value)? init,
    TResult? Function(SpaceStateDone value)? done,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceStateInit value)? init,
    TResult Function(SpaceStateDone value)? done,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class SpaceStateInit implements SpaceState {
  const factory SpaceStateInit() = _$SpaceStateInit;
}

/// @nodoc
abstract class _$$SpaceStateDoneCopyWith<$Res> {
  factory _$$SpaceStateDoneCopyWith(
          _$SpaceStateDone value, $Res Function(_$SpaceStateDone) then) =
      __$$SpaceStateDoneCopyWithImpl<$Res>;
  @useResult
  $Res call({da.Collection metaTableDetail, List<MetaModel> metas});
}

/// @nodoc
class __$$SpaceStateDoneCopyWithImpl<$Res>
    extends _$SpaceStateCopyWithImpl<$Res, _$SpaceStateDone>
    implements _$$SpaceStateDoneCopyWith<$Res> {
  __$$SpaceStateDoneCopyWithImpl(
      _$SpaceStateDone _value, $Res Function(_$SpaceStateDone) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metaTableDetail = null,
    Object? metas = null,
  }) {
    return _then(_$SpaceStateDone(
      null == metaTableDetail
          ? _value.metaTableDetail
          : metaTableDetail // ignore: cast_nullable_to_non_nullable
              as da.Collection,
      null == metas
          ? _value.metas
          : metas // ignore: cast_nullable_to_non_nullable
              as List<MetaModel>,
    ));
  }
}

/// @nodoc

class _$SpaceStateDone implements SpaceStateDone {
  const _$SpaceStateDone(this.metaTableDetail, this.metas);

  @override
  final da.Collection metaTableDetail;
  @override
  final List<MetaModel> metas;

  @override
  String toString() {
    return 'SpaceState.done(metaTableDetail: $metaTableDetail, metas: $metas)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpaceStateDone &&
            (identical(other.metaTableDetail, metaTableDetail) ||
                other.metaTableDetail == metaTableDetail) &&
            const DeepCollectionEquality().equals(other.metas, metas));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, metaTableDetail, const DeepCollectionEquality().hash(metas));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpaceStateDoneCopyWith<_$SpaceStateDone> get copyWith =>
      __$$SpaceStateDoneCopyWithImpl<_$SpaceStateDone>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(
            da.Collection metaTableDetail, List<MetaModel> metas)
        done,
  }) {
    return done(metaTableDetail, metas);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(da.Collection metaTableDetail, List<MetaModel> metas)?
        done,
  }) {
    return done?.call(metaTableDetail, metas);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(da.Collection metaTableDetail, List<MetaModel> metas)?
        done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(metaTableDetail, metas);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpaceStateInit value) init,
    required TResult Function(SpaceStateDone value) done,
  }) {
    return done(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpaceStateInit value)? init,
    TResult? Function(SpaceStateDone value)? done,
  }) {
    return done?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceStateInit value)? init,
    TResult Function(SpaceStateDone value)? done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(this);
    }
    return orElse();
  }
}

abstract class SpaceStateDone implements SpaceState {
  const factory SpaceStateDone(
          final da.Collection metaTableDetail, final List<MetaModel> metas) =
      _$SpaceStateDone;

  da.Collection get metaTableDetail;
  List<MetaModel> get metas;
  @JsonKey(ignore: true)
  _$$SpaceStateDoneCopyWith<_$SpaceStateDone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TeamAct {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(aw.Team team) updateTeam,
    required TResult Function(String name) renameTeam,
    required TResult Function() updateSpaces,
    required TResult Function(String name) createSpace,
    required TResult Function(String spaceId) deleteSpace,
    required TResult Function() updateMembers,
    required TResult Function(String userEmail) inviteMember,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(aw.Team team)? updateTeam,
    TResult? Function(String name)? renameTeam,
    TResult? Function()? updateSpaces,
    TResult? Function(String name)? createSpace,
    TResult? Function(String spaceId)? deleteSpace,
    TResult? Function()? updateMembers,
    TResult? Function(String userEmail)? inviteMember,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(aw.Team team)? updateTeam,
    TResult Function(String name)? renameTeam,
    TResult Function()? updateSpaces,
    TResult Function(String name)? createSpace,
    TResult Function(String spaceId)? deleteSpace,
    TResult Function()? updateMembers,
    TResult Function(String userEmail)? inviteMember,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamActInitModel value) initModel,
    required TResult Function(TeamActUpdateTeam value) updateTeam,
    required TResult Function(TeamActRenameTeam value) renameTeam,
    required TResult Function(TeamActUpdateSpaces value) updateSpaces,
    required TResult Function(TeamActCreateSpace value) createSpace,
    required TResult Function(TeamActDeleteSpace value) deleteSpace,
    required TResult Function(TeamActUpdateMembers value) updateMembers,
    required TResult Function(TeamActInviteMember value) inviteMember,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamActInitModel value)? initModel,
    TResult? Function(TeamActUpdateTeam value)? updateTeam,
    TResult? Function(TeamActRenameTeam value)? renameTeam,
    TResult? Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult? Function(TeamActCreateSpace value)? createSpace,
    TResult? Function(TeamActDeleteSpace value)? deleteSpace,
    TResult? Function(TeamActUpdateMembers value)? updateMembers,
    TResult? Function(TeamActInviteMember value)? inviteMember,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamActInitModel value)? initModel,
    TResult Function(TeamActUpdateTeam value)? updateTeam,
    TResult Function(TeamActRenameTeam value)? renameTeam,
    TResult Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult Function(TeamActCreateSpace value)? createSpace,
    TResult Function(TeamActDeleteSpace value)? deleteSpace,
    TResult Function(TeamActUpdateMembers value)? updateMembers,
    TResult Function(TeamActInviteMember value)? inviteMember,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamActCopyWith<$Res> {
  factory $TeamActCopyWith(TeamAct value, $Res Function(TeamAct) then) =
      _$TeamActCopyWithImpl<$Res, TeamAct>;
}

/// @nodoc
class _$TeamActCopyWithImpl<$Res, $Val extends TeamAct>
    implements $TeamActCopyWith<$Res> {
  _$TeamActCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$TeamActInitModelCopyWith<$Res> {
  factory _$$TeamActInitModelCopyWith(
          _$TeamActInitModel value, $Res Function(_$TeamActInitModel) then) =
      __$$TeamActInitModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TeamActInitModelCopyWithImpl<$Res>
    extends _$TeamActCopyWithImpl<$Res, _$TeamActInitModel>
    implements _$$TeamActInitModelCopyWith<$Res> {
  __$$TeamActInitModelCopyWithImpl(
      _$TeamActInitModel _value, $Res Function(_$TeamActInitModel) _then)
      : super(_value, _then);
}

/// @nodoc

class _$TeamActInitModel implements TeamActInitModel {
  const _$TeamActInitModel();

  @override
  String toString() {
    return 'TeamAct.initModel()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TeamActInitModel);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(aw.Team team) updateTeam,
    required TResult Function(String name) renameTeam,
    required TResult Function() updateSpaces,
    required TResult Function(String name) createSpace,
    required TResult Function(String spaceId) deleteSpace,
    required TResult Function() updateMembers,
    required TResult Function(String userEmail) inviteMember,
  }) {
    return initModel();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(aw.Team team)? updateTeam,
    TResult? Function(String name)? renameTeam,
    TResult? Function()? updateSpaces,
    TResult? Function(String name)? createSpace,
    TResult? Function(String spaceId)? deleteSpace,
    TResult? Function()? updateMembers,
    TResult? Function(String userEmail)? inviteMember,
  }) {
    return initModel?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(aw.Team team)? updateTeam,
    TResult Function(String name)? renameTeam,
    TResult Function()? updateSpaces,
    TResult Function(String name)? createSpace,
    TResult Function(String spaceId)? deleteSpace,
    TResult Function()? updateMembers,
    TResult Function(String userEmail)? inviteMember,
    required TResult orElse(),
  }) {
    if (initModel != null) {
      return initModel();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamActInitModel value) initModel,
    required TResult Function(TeamActUpdateTeam value) updateTeam,
    required TResult Function(TeamActRenameTeam value) renameTeam,
    required TResult Function(TeamActUpdateSpaces value) updateSpaces,
    required TResult Function(TeamActCreateSpace value) createSpace,
    required TResult Function(TeamActDeleteSpace value) deleteSpace,
    required TResult Function(TeamActUpdateMembers value) updateMembers,
    required TResult Function(TeamActInviteMember value) inviteMember,
  }) {
    return initModel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamActInitModel value)? initModel,
    TResult? Function(TeamActUpdateTeam value)? updateTeam,
    TResult? Function(TeamActRenameTeam value)? renameTeam,
    TResult? Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult? Function(TeamActCreateSpace value)? createSpace,
    TResult? Function(TeamActDeleteSpace value)? deleteSpace,
    TResult? Function(TeamActUpdateMembers value)? updateMembers,
    TResult? Function(TeamActInviteMember value)? inviteMember,
  }) {
    return initModel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamActInitModel value)? initModel,
    TResult Function(TeamActUpdateTeam value)? updateTeam,
    TResult Function(TeamActRenameTeam value)? renameTeam,
    TResult Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult Function(TeamActCreateSpace value)? createSpace,
    TResult Function(TeamActDeleteSpace value)? deleteSpace,
    TResult Function(TeamActUpdateMembers value)? updateMembers,
    TResult Function(TeamActInviteMember value)? inviteMember,
    required TResult orElse(),
  }) {
    if (initModel != null) {
      return initModel(this);
    }
    return orElse();
  }
}

abstract class TeamActInitModel implements TeamAct {
  const factory TeamActInitModel() = _$TeamActInitModel;
}

/// @nodoc
abstract class _$$TeamActUpdateTeamCopyWith<$Res> {
  factory _$$TeamActUpdateTeamCopyWith(
          _$TeamActUpdateTeam value, $Res Function(_$TeamActUpdateTeam) then) =
      __$$TeamActUpdateTeamCopyWithImpl<$Res>;
  @useResult
  $Res call({aw.Team team});
}

/// @nodoc
class __$$TeamActUpdateTeamCopyWithImpl<$Res>
    extends _$TeamActCopyWithImpl<$Res, _$TeamActUpdateTeam>
    implements _$$TeamActUpdateTeamCopyWith<$Res> {
  __$$TeamActUpdateTeamCopyWithImpl(
      _$TeamActUpdateTeam _value, $Res Function(_$TeamActUpdateTeam) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? team = null,
  }) {
    return _then(_$TeamActUpdateTeam(
      null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as aw.Team,
    ));
  }
}

/// @nodoc

class _$TeamActUpdateTeam implements TeamActUpdateTeam {
  const _$TeamActUpdateTeam(this.team);

  @override
  final aw.Team team;

  @override
  String toString() {
    return 'TeamAct.updateTeam(team: $team)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamActUpdateTeam &&
            (identical(other.team, team) || other.team == team));
  }

  @override
  int get hashCode => Object.hash(runtimeType, team);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamActUpdateTeamCopyWith<_$TeamActUpdateTeam> get copyWith =>
      __$$TeamActUpdateTeamCopyWithImpl<_$TeamActUpdateTeam>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(aw.Team team) updateTeam,
    required TResult Function(String name) renameTeam,
    required TResult Function() updateSpaces,
    required TResult Function(String name) createSpace,
    required TResult Function(String spaceId) deleteSpace,
    required TResult Function() updateMembers,
    required TResult Function(String userEmail) inviteMember,
  }) {
    return updateTeam(team);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(aw.Team team)? updateTeam,
    TResult? Function(String name)? renameTeam,
    TResult? Function()? updateSpaces,
    TResult? Function(String name)? createSpace,
    TResult? Function(String spaceId)? deleteSpace,
    TResult? Function()? updateMembers,
    TResult? Function(String userEmail)? inviteMember,
  }) {
    return updateTeam?.call(team);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(aw.Team team)? updateTeam,
    TResult Function(String name)? renameTeam,
    TResult Function()? updateSpaces,
    TResult Function(String name)? createSpace,
    TResult Function(String spaceId)? deleteSpace,
    TResult Function()? updateMembers,
    TResult Function(String userEmail)? inviteMember,
    required TResult orElse(),
  }) {
    if (updateTeam != null) {
      return updateTeam(team);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamActInitModel value) initModel,
    required TResult Function(TeamActUpdateTeam value) updateTeam,
    required TResult Function(TeamActRenameTeam value) renameTeam,
    required TResult Function(TeamActUpdateSpaces value) updateSpaces,
    required TResult Function(TeamActCreateSpace value) createSpace,
    required TResult Function(TeamActDeleteSpace value) deleteSpace,
    required TResult Function(TeamActUpdateMembers value) updateMembers,
    required TResult Function(TeamActInviteMember value) inviteMember,
  }) {
    return updateTeam(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamActInitModel value)? initModel,
    TResult? Function(TeamActUpdateTeam value)? updateTeam,
    TResult? Function(TeamActRenameTeam value)? renameTeam,
    TResult? Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult? Function(TeamActCreateSpace value)? createSpace,
    TResult? Function(TeamActDeleteSpace value)? deleteSpace,
    TResult? Function(TeamActUpdateMembers value)? updateMembers,
    TResult? Function(TeamActInviteMember value)? inviteMember,
  }) {
    return updateTeam?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamActInitModel value)? initModel,
    TResult Function(TeamActUpdateTeam value)? updateTeam,
    TResult Function(TeamActRenameTeam value)? renameTeam,
    TResult Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult Function(TeamActCreateSpace value)? createSpace,
    TResult Function(TeamActDeleteSpace value)? deleteSpace,
    TResult Function(TeamActUpdateMembers value)? updateMembers,
    TResult Function(TeamActInviteMember value)? inviteMember,
    required TResult orElse(),
  }) {
    if (updateTeam != null) {
      return updateTeam(this);
    }
    return orElse();
  }
}

abstract class TeamActUpdateTeam implements TeamAct {
  const factory TeamActUpdateTeam(final aw.Team team) = _$TeamActUpdateTeam;

  aw.Team get team;
  @JsonKey(ignore: true)
  _$$TeamActUpdateTeamCopyWith<_$TeamActUpdateTeam> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TeamActRenameTeamCopyWith<$Res> {
  factory _$$TeamActRenameTeamCopyWith(
          _$TeamActRenameTeam value, $Res Function(_$TeamActRenameTeam) then) =
      __$$TeamActRenameTeamCopyWithImpl<$Res>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$TeamActRenameTeamCopyWithImpl<$Res>
    extends _$TeamActCopyWithImpl<$Res, _$TeamActRenameTeam>
    implements _$$TeamActRenameTeamCopyWith<$Res> {
  __$$TeamActRenameTeamCopyWithImpl(
      _$TeamActRenameTeam _value, $Res Function(_$TeamActRenameTeam) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$TeamActRenameTeam(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TeamActRenameTeam implements TeamActRenameTeam {
  const _$TeamActRenameTeam(this.name);

  @override
  final String name;

  @override
  String toString() {
    return 'TeamAct.renameTeam(name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamActRenameTeam &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamActRenameTeamCopyWith<_$TeamActRenameTeam> get copyWith =>
      __$$TeamActRenameTeamCopyWithImpl<_$TeamActRenameTeam>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(aw.Team team) updateTeam,
    required TResult Function(String name) renameTeam,
    required TResult Function() updateSpaces,
    required TResult Function(String name) createSpace,
    required TResult Function(String spaceId) deleteSpace,
    required TResult Function() updateMembers,
    required TResult Function(String userEmail) inviteMember,
  }) {
    return renameTeam(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(aw.Team team)? updateTeam,
    TResult? Function(String name)? renameTeam,
    TResult? Function()? updateSpaces,
    TResult? Function(String name)? createSpace,
    TResult? Function(String spaceId)? deleteSpace,
    TResult? Function()? updateMembers,
    TResult? Function(String userEmail)? inviteMember,
  }) {
    return renameTeam?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(aw.Team team)? updateTeam,
    TResult Function(String name)? renameTeam,
    TResult Function()? updateSpaces,
    TResult Function(String name)? createSpace,
    TResult Function(String spaceId)? deleteSpace,
    TResult Function()? updateMembers,
    TResult Function(String userEmail)? inviteMember,
    required TResult orElse(),
  }) {
    if (renameTeam != null) {
      return renameTeam(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamActInitModel value) initModel,
    required TResult Function(TeamActUpdateTeam value) updateTeam,
    required TResult Function(TeamActRenameTeam value) renameTeam,
    required TResult Function(TeamActUpdateSpaces value) updateSpaces,
    required TResult Function(TeamActCreateSpace value) createSpace,
    required TResult Function(TeamActDeleteSpace value) deleteSpace,
    required TResult Function(TeamActUpdateMembers value) updateMembers,
    required TResult Function(TeamActInviteMember value) inviteMember,
  }) {
    return renameTeam(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamActInitModel value)? initModel,
    TResult? Function(TeamActUpdateTeam value)? updateTeam,
    TResult? Function(TeamActRenameTeam value)? renameTeam,
    TResult? Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult? Function(TeamActCreateSpace value)? createSpace,
    TResult? Function(TeamActDeleteSpace value)? deleteSpace,
    TResult? Function(TeamActUpdateMembers value)? updateMembers,
    TResult? Function(TeamActInviteMember value)? inviteMember,
  }) {
    return renameTeam?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamActInitModel value)? initModel,
    TResult Function(TeamActUpdateTeam value)? updateTeam,
    TResult Function(TeamActRenameTeam value)? renameTeam,
    TResult Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult Function(TeamActCreateSpace value)? createSpace,
    TResult Function(TeamActDeleteSpace value)? deleteSpace,
    TResult Function(TeamActUpdateMembers value)? updateMembers,
    TResult Function(TeamActInviteMember value)? inviteMember,
    required TResult orElse(),
  }) {
    if (renameTeam != null) {
      return renameTeam(this);
    }
    return orElse();
  }
}

abstract class TeamActRenameTeam implements TeamAct {
  const factory TeamActRenameTeam(final String name) = _$TeamActRenameTeam;

  String get name;
  @JsonKey(ignore: true)
  _$$TeamActRenameTeamCopyWith<_$TeamActRenameTeam> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TeamActUpdateSpacesCopyWith<$Res> {
  factory _$$TeamActUpdateSpacesCopyWith(_$TeamActUpdateSpaces value,
          $Res Function(_$TeamActUpdateSpaces) then) =
      __$$TeamActUpdateSpacesCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TeamActUpdateSpacesCopyWithImpl<$Res>
    extends _$TeamActCopyWithImpl<$Res, _$TeamActUpdateSpaces>
    implements _$$TeamActUpdateSpacesCopyWith<$Res> {
  __$$TeamActUpdateSpacesCopyWithImpl(
      _$TeamActUpdateSpaces _value, $Res Function(_$TeamActUpdateSpaces) _then)
      : super(_value, _then);
}

/// @nodoc

class _$TeamActUpdateSpaces implements TeamActUpdateSpaces {
  const _$TeamActUpdateSpaces();

  @override
  String toString() {
    return 'TeamAct.updateSpaces()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TeamActUpdateSpaces);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(aw.Team team) updateTeam,
    required TResult Function(String name) renameTeam,
    required TResult Function() updateSpaces,
    required TResult Function(String name) createSpace,
    required TResult Function(String spaceId) deleteSpace,
    required TResult Function() updateMembers,
    required TResult Function(String userEmail) inviteMember,
  }) {
    return updateSpaces();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(aw.Team team)? updateTeam,
    TResult? Function(String name)? renameTeam,
    TResult? Function()? updateSpaces,
    TResult? Function(String name)? createSpace,
    TResult? Function(String spaceId)? deleteSpace,
    TResult? Function()? updateMembers,
    TResult? Function(String userEmail)? inviteMember,
  }) {
    return updateSpaces?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(aw.Team team)? updateTeam,
    TResult Function(String name)? renameTeam,
    TResult Function()? updateSpaces,
    TResult Function(String name)? createSpace,
    TResult Function(String spaceId)? deleteSpace,
    TResult Function()? updateMembers,
    TResult Function(String userEmail)? inviteMember,
    required TResult orElse(),
  }) {
    if (updateSpaces != null) {
      return updateSpaces();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamActInitModel value) initModel,
    required TResult Function(TeamActUpdateTeam value) updateTeam,
    required TResult Function(TeamActRenameTeam value) renameTeam,
    required TResult Function(TeamActUpdateSpaces value) updateSpaces,
    required TResult Function(TeamActCreateSpace value) createSpace,
    required TResult Function(TeamActDeleteSpace value) deleteSpace,
    required TResult Function(TeamActUpdateMembers value) updateMembers,
    required TResult Function(TeamActInviteMember value) inviteMember,
  }) {
    return updateSpaces(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamActInitModel value)? initModel,
    TResult? Function(TeamActUpdateTeam value)? updateTeam,
    TResult? Function(TeamActRenameTeam value)? renameTeam,
    TResult? Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult? Function(TeamActCreateSpace value)? createSpace,
    TResult? Function(TeamActDeleteSpace value)? deleteSpace,
    TResult? Function(TeamActUpdateMembers value)? updateMembers,
    TResult? Function(TeamActInviteMember value)? inviteMember,
  }) {
    return updateSpaces?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamActInitModel value)? initModel,
    TResult Function(TeamActUpdateTeam value)? updateTeam,
    TResult Function(TeamActRenameTeam value)? renameTeam,
    TResult Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult Function(TeamActCreateSpace value)? createSpace,
    TResult Function(TeamActDeleteSpace value)? deleteSpace,
    TResult Function(TeamActUpdateMembers value)? updateMembers,
    TResult Function(TeamActInviteMember value)? inviteMember,
    required TResult orElse(),
  }) {
    if (updateSpaces != null) {
      return updateSpaces(this);
    }
    return orElse();
  }
}

abstract class TeamActUpdateSpaces implements TeamAct {
  const factory TeamActUpdateSpaces() = _$TeamActUpdateSpaces;
}

/// @nodoc
abstract class _$$TeamActCreateSpaceCopyWith<$Res> {
  factory _$$TeamActCreateSpaceCopyWith(_$TeamActCreateSpace value,
          $Res Function(_$TeamActCreateSpace) then) =
      __$$TeamActCreateSpaceCopyWithImpl<$Res>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$TeamActCreateSpaceCopyWithImpl<$Res>
    extends _$TeamActCopyWithImpl<$Res, _$TeamActCreateSpace>
    implements _$$TeamActCreateSpaceCopyWith<$Res> {
  __$$TeamActCreateSpaceCopyWithImpl(
      _$TeamActCreateSpace _value, $Res Function(_$TeamActCreateSpace) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$TeamActCreateSpace(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TeamActCreateSpace implements TeamActCreateSpace {
  const _$TeamActCreateSpace(this.name);

  @override
  final String name;

  @override
  String toString() {
    return 'TeamAct.createSpace(name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamActCreateSpace &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamActCreateSpaceCopyWith<_$TeamActCreateSpace> get copyWith =>
      __$$TeamActCreateSpaceCopyWithImpl<_$TeamActCreateSpace>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(aw.Team team) updateTeam,
    required TResult Function(String name) renameTeam,
    required TResult Function() updateSpaces,
    required TResult Function(String name) createSpace,
    required TResult Function(String spaceId) deleteSpace,
    required TResult Function() updateMembers,
    required TResult Function(String userEmail) inviteMember,
  }) {
    return createSpace(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(aw.Team team)? updateTeam,
    TResult? Function(String name)? renameTeam,
    TResult? Function()? updateSpaces,
    TResult? Function(String name)? createSpace,
    TResult? Function(String spaceId)? deleteSpace,
    TResult? Function()? updateMembers,
    TResult? Function(String userEmail)? inviteMember,
  }) {
    return createSpace?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(aw.Team team)? updateTeam,
    TResult Function(String name)? renameTeam,
    TResult Function()? updateSpaces,
    TResult Function(String name)? createSpace,
    TResult Function(String spaceId)? deleteSpace,
    TResult Function()? updateMembers,
    TResult Function(String userEmail)? inviteMember,
    required TResult orElse(),
  }) {
    if (createSpace != null) {
      return createSpace(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamActInitModel value) initModel,
    required TResult Function(TeamActUpdateTeam value) updateTeam,
    required TResult Function(TeamActRenameTeam value) renameTeam,
    required TResult Function(TeamActUpdateSpaces value) updateSpaces,
    required TResult Function(TeamActCreateSpace value) createSpace,
    required TResult Function(TeamActDeleteSpace value) deleteSpace,
    required TResult Function(TeamActUpdateMembers value) updateMembers,
    required TResult Function(TeamActInviteMember value) inviteMember,
  }) {
    return createSpace(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamActInitModel value)? initModel,
    TResult? Function(TeamActUpdateTeam value)? updateTeam,
    TResult? Function(TeamActRenameTeam value)? renameTeam,
    TResult? Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult? Function(TeamActCreateSpace value)? createSpace,
    TResult? Function(TeamActDeleteSpace value)? deleteSpace,
    TResult? Function(TeamActUpdateMembers value)? updateMembers,
    TResult? Function(TeamActInviteMember value)? inviteMember,
  }) {
    return createSpace?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamActInitModel value)? initModel,
    TResult Function(TeamActUpdateTeam value)? updateTeam,
    TResult Function(TeamActRenameTeam value)? renameTeam,
    TResult Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult Function(TeamActCreateSpace value)? createSpace,
    TResult Function(TeamActDeleteSpace value)? deleteSpace,
    TResult Function(TeamActUpdateMembers value)? updateMembers,
    TResult Function(TeamActInviteMember value)? inviteMember,
    required TResult orElse(),
  }) {
    if (createSpace != null) {
      return createSpace(this);
    }
    return orElse();
  }
}

abstract class TeamActCreateSpace implements TeamAct {
  const factory TeamActCreateSpace(final String name) = _$TeamActCreateSpace;

  String get name;
  @JsonKey(ignore: true)
  _$$TeamActCreateSpaceCopyWith<_$TeamActCreateSpace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TeamActDeleteSpaceCopyWith<$Res> {
  factory _$$TeamActDeleteSpaceCopyWith(_$TeamActDeleteSpace value,
          $Res Function(_$TeamActDeleteSpace) then) =
      __$$TeamActDeleteSpaceCopyWithImpl<$Res>;
  @useResult
  $Res call({String spaceId});
}

/// @nodoc
class __$$TeamActDeleteSpaceCopyWithImpl<$Res>
    extends _$TeamActCopyWithImpl<$Res, _$TeamActDeleteSpace>
    implements _$$TeamActDeleteSpaceCopyWith<$Res> {
  __$$TeamActDeleteSpaceCopyWithImpl(
      _$TeamActDeleteSpace _value, $Res Function(_$TeamActDeleteSpace) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spaceId = null,
  }) {
    return _then(_$TeamActDeleteSpace(
      null == spaceId
          ? _value.spaceId
          : spaceId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TeamActDeleteSpace implements TeamActDeleteSpace {
  const _$TeamActDeleteSpace(this.spaceId);

  @override
  final String spaceId;

  @override
  String toString() {
    return 'TeamAct.deleteSpace(spaceId: $spaceId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamActDeleteSpace &&
            (identical(other.spaceId, spaceId) || other.spaceId == spaceId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, spaceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamActDeleteSpaceCopyWith<_$TeamActDeleteSpace> get copyWith =>
      __$$TeamActDeleteSpaceCopyWithImpl<_$TeamActDeleteSpace>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(aw.Team team) updateTeam,
    required TResult Function(String name) renameTeam,
    required TResult Function() updateSpaces,
    required TResult Function(String name) createSpace,
    required TResult Function(String spaceId) deleteSpace,
    required TResult Function() updateMembers,
    required TResult Function(String userEmail) inviteMember,
  }) {
    return deleteSpace(spaceId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(aw.Team team)? updateTeam,
    TResult? Function(String name)? renameTeam,
    TResult? Function()? updateSpaces,
    TResult? Function(String name)? createSpace,
    TResult? Function(String spaceId)? deleteSpace,
    TResult? Function()? updateMembers,
    TResult? Function(String userEmail)? inviteMember,
  }) {
    return deleteSpace?.call(spaceId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(aw.Team team)? updateTeam,
    TResult Function(String name)? renameTeam,
    TResult Function()? updateSpaces,
    TResult Function(String name)? createSpace,
    TResult Function(String spaceId)? deleteSpace,
    TResult Function()? updateMembers,
    TResult Function(String userEmail)? inviteMember,
    required TResult orElse(),
  }) {
    if (deleteSpace != null) {
      return deleteSpace(spaceId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamActInitModel value) initModel,
    required TResult Function(TeamActUpdateTeam value) updateTeam,
    required TResult Function(TeamActRenameTeam value) renameTeam,
    required TResult Function(TeamActUpdateSpaces value) updateSpaces,
    required TResult Function(TeamActCreateSpace value) createSpace,
    required TResult Function(TeamActDeleteSpace value) deleteSpace,
    required TResult Function(TeamActUpdateMembers value) updateMembers,
    required TResult Function(TeamActInviteMember value) inviteMember,
  }) {
    return deleteSpace(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamActInitModel value)? initModel,
    TResult? Function(TeamActUpdateTeam value)? updateTeam,
    TResult? Function(TeamActRenameTeam value)? renameTeam,
    TResult? Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult? Function(TeamActCreateSpace value)? createSpace,
    TResult? Function(TeamActDeleteSpace value)? deleteSpace,
    TResult? Function(TeamActUpdateMembers value)? updateMembers,
    TResult? Function(TeamActInviteMember value)? inviteMember,
  }) {
    return deleteSpace?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamActInitModel value)? initModel,
    TResult Function(TeamActUpdateTeam value)? updateTeam,
    TResult Function(TeamActRenameTeam value)? renameTeam,
    TResult Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult Function(TeamActCreateSpace value)? createSpace,
    TResult Function(TeamActDeleteSpace value)? deleteSpace,
    TResult Function(TeamActUpdateMembers value)? updateMembers,
    TResult Function(TeamActInviteMember value)? inviteMember,
    required TResult orElse(),
  }) {
    if (deleteSpace != null) {
      return deleteSpace(this);
    }
    return orElse();
  }
}

abstract class TeamActDeleteSpace implements TeamAct {
  const factory TeamActDeleteSpace(final String spaceId) = _$TeamActDeleteSpace;

  String get spaceId;
  @JsonKey(ignore: true)
  _$$TeamActDeleteSpaceCopyWith<_$TeamActDeleteSpace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TeamActUpdateMembersCopyWith<$Res> {
  factory _$$TeamActUpdateMembersCopyWith(_$TeamActUpdateMembers value,
          $Res Function(_$TeamActUpdateMembers) then) =
      __$$TeamActUpdateMembersCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TeamActUpdateMembersCopyWithImpl<$Res>
    extends _$TeamActCopyWithImpl<$Res, _$TeamActUpdateMembers>
    implements _$$TeamActUpdateMembersCopyWith<$Res> {
  __$$TeamActUpdateMembersCopyWithImpl(_$TeamActUpdateMembers _value,
      $Res Function(_$TeamActUpdateMembers) _then)
      : super(_value, _then);
}

/// @nodoc

class _$TeamActUpdateMembers implements TeamActUpdateMembers {
  const _$TeamActUpdateMembers();

  @override
  String toString() {
    return 'TeamAct.updateMembers()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TeamActUpdateMembers);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(aw.Team team) updateTeam,
    required TResult Function(String name) renameTeam,
    required TResult Function() updateSpaces,
    required TResult Function(String name) createSpace,
    required TResult Function(String spaceId) deleteSpace,
    required TResult Function() updateMembers,
    required TResult Function(String userEmail) inviteMember,
  }) {
    return updateMembers();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(aw.Team team)? updateTeam,
    TResult? Function(String name)? renameTeam,
    TResult? Function()? updateSpaces,
    TResult? Function(String name)? createSpace,
    TResult? Function(String spaceId)? deleteSpace,
    TResult? Function()? updateMembers,
    TResult? Function(String userEmail)? inviteMember,
  }) {
    return updateMembers?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(aw.Team team)? updateTeam,
    TResult Function(String name)? renameTeam,
    TResult Function()? updateSpaces,
    TResult Function(String name)? createSpace,
    TResult Function(String spaceId)? deleteSpace,
    TResult Function()? updateMembers,
    TResult Function(String userEmail)? inviteMember,
    required TResult orElse(),
  }) {
    if (updateMembers != null) {
      return updateMembers();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamActInitModel value) initModel,
    required TResult Function(TeamActUpdateTeam value) updateTeam,
    required TResult Function(TeamActRenameTeam value) renameTeam,
    required TResult Function(TeamActUpdateSpaces value) updateSpaces,
    required TResult Function(TeamActCreateSpace value) createSpace,
    required TResult Function(TeamActDeleteSpace value) deleteSpace,
    required TResult Function(TeamActUpdateMembers value) updateMembers,
    required TResult Function(TeamActInviteMember value) inviteMember,
  }) {
    return updateMembers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamActInitModel value)? initModel,
    TResult? Function(TeamActUpdateTeam value)? updateTeam,
    TResult? Function(TeamActRenameTeam value)? renameTeam,
    TResult? Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult? Function(TeamActCreateSpace value)? createSpace,
    TResult? Function(TeamActDeleteSpace value)? deleteSpace,
    TResult? Function(TeamActUpdateMembers value)? updateMembers,
    TResult? Function(TeamActInviteMember value)? inviteMember,
  }) {
    return updateMembers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamActInitModel value)? initModel,
    TResult Function(TeamActUpdateTeam value)? updateTeam,
    TResult Function(TeamActRenameTeam value)? renameTeam,
    TResult Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult Function(TeamActCreateSpace value)? createSpace,
    TResult Function(TeamActDeleteSpace value)? deleteSpace,
    TResult Function(TeamActUpdateMembers value)? updateMembers,
    TResult Function(TeamActInviteMember value)? inviteMember,
    required TResult orElse(),
  }) {
    if (updateMembers != null) {
      return updateMembers(this);
    }
    return orElse();
  }
}

abstract class TeamActUpdateMembers implements TeamAct {
  const factory TeamActUpdateMembers() = _$TeamActUpdateMembers;
}

/// @nodoc
abstract class _$$TeamActInviteMemberCopyWith<$Res> {
  factory _$$TeamActInviteMemberCopyWith(_$TeamActInviteMember value,
          $Res Function(_$TeamActInviteMember) then) =
      __$$TeamActInviteMemberCopyWithImpl<$Res>;
  @useResult
  $Res call({String userEmail});
}

/// @nodoc
class __$$TeamActInviteMemberCopyWithImpl<$Res>
    extends _$TeamActCopyWithImpl<$Res, _$TeamActInviteMember>
    implements _$$TeamActInviteMemberCopyWith<$Res> {
  __$$TeamActInviteMemberCopyWithImpl(
      _$TeamActInviteMember _value, $Res Function(_$TeamActInviteMember) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userEmail = null,
  }) {
    return _then(_$TeamActInviteMember(
      null == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TeamActInviteMember implements TeamActInviteMember {
  const _$TeamActInviteMember(this.userEmail);

  @override
  final String userEmail;

  @override
  String toString() {
    return 'TeamAct.inviteMember(userEmail: $userEmail)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamActInviteMember &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userEmail);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamActInviteMemberCopyWith<_$TeamActInviteMember> get copyWith =>
      __$$TeamActInviteMemberCopyWithImpl<_$TeamActInviteMember>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(aw.Team team) updateTeam,
    required TResult Function(String name) renameTeam,
    required TResult Function() updateSpaces,
    required TResult Function(String name) createSpace,
    required TResult Function(String spaceId) deleteSpace,
    required TResult Function() updateMembers,
    required TResult Function(String userEmail) inviteMember,
  }) {
    return inviteMember(userEmail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(aw.Team team)? updateTeam,
    TResult? Function(String name)? renameTeam,
    TResult? Function()? updateSpaces,
    TResult? Function(String name)? createSpace,
    TResult? Function(String spaceId)? deleteSpace,
    TResult? Function()? updateMembers,
    TResult? Function(String userEmail)? inviteMember,
  }) {
    return inviteMember?.call(userEmail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(aw.Team team)? updateTeam,
    TResult Function(String name)? renameTeam,
    TResult Function()? updateSpaces,
    TResult Function(String name)? createSpace,
    TResult Function(String spaceId)? deleteSpace,
    TResult Function()? updateMembers,
    TResult Function(String userEmail)? inviteMember,
    required TResult orElse(),
  }) {
    if (inviteMember != null) {
      return inviteMember(userEmail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamActInitModel value) initModel,
    required TResult Function(TeamActUpdateTeam value) updateTeam,
    required TResult Function(TeamActRenameTeam value) renameTeam,
    required TResult Function(TeamActUpdateSpaces value) updateSpaces,
    required TResult Function(TeamActCreateSpace value) createSpace,
    required TResult Function(TeamActDeleteSpace value) deleteSpace,
    required TResult Function(TeamActUpdateMembers value) updateMembers,
    required TResult Function(TeamActInviteMember value) inviteMember,
  }) {
    return inviteMember(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamActInitModel value)? initModel,
    TResult? Function(TeamActUpdateTeam value)? updateTeam,
    TResult? Function(TeamActRenameTeam value)? renameTeam,
    TResult? Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult? Function(TeamActCreateSpace value)? createSpace,
    TResult? Function(TeamActDeleteSpace value)? deleteSpace,
    TResult? Function(TeamActUpdateMembers value)? updateMembers,
    TResult? Function(TeamActInviteMember value)? inviteMember,
  }) {
    return inviteMember?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamActInitModel value)? initModel,
    TResult Function(TeamActUpdateTeam value)? updateTeam,
    TResult Function(TeamActRenameTeam value)? renameTeam,
    TResult Function(TeamActUpdateSpaces value)? updateSpaces,
    TResult Function(TeamActCreateSpace value)? createSpace,
    TResult Function(TeamActDeleteSpace value)? deleteSpace,
    TResult Function(TeamActUpdateMembers value)? updateMembers,
    TResult Function(TeamActInviteMember value)? inviteMember,
    required TResult orElse(),
  }) {
    if (inviteMember != null) {
      return inviteMember(this);
    }
    return orElse();
  }
}

abstract class TeamActInviteMember implements TeamAct {
  const factory TeamActInviteMember(final String userEmail) =
      _$TeamActInviteMember;

  String get userEmail;
  @JsonKey(ignore: true)
  _$$TeamActInviteMemberCopyWith<_$TeamActInviteMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TeamState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(
            List<SpaceModel> workspaces, List<MemberModel> members)
        done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(List<SpaceModel> workspaces, List<MemberModel> members)?
        done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<SpaceModel> workspaces, List<MemberModel> members)?
        done,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamStateInit value) init,
    required TResult Function(TeamStateDone value) done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamStateInit value)? init,
    TResult? Function(TeamStateDone value)? done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamStateInit value)? init,
    TResult Function(TeamStateDone value)? done,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamStateCopyWith<$Res> {
  factory $TeamStateCopyWith(TeamState value, $Res Function(TeamState) then) =
      _$TeamStateCopyWithImpl<$Res, TeamState>;
}

/// @nodoc
class _$TeamStateCopyWithImpl<$Res, $Val extends TeamState>
    implements $TeamStateCopyWith<$Res> {
  _$TeamStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$TeamStateInitCopyWith<$Res> {
  factory _$$TeamStateInitCopyWith(
          _$TeamStateInit value, $Res Function(_$TeamStateInit) then) =
      __$$TeamStateInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TeamStateInitCopyWithImpl<$Res>
    extends _$TeamStateCopyWithImpl<$Res, _$TeamStateInit>
    implements _$$TeamStateInitCopyWith<$Res> {
  __$$TeamStateInitCopyWithImpl(
      _$TeamStateInit _value, $Res Function(_$TeamStateInit) _then)
      : super(_value, _then);
}

/// @nodoc

class _$TeamStateInit implements TeamStateInit {
  const _$TeamStateInit();

  @override
  String toString() {
    return 'TeamState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TeamStateInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(
            List<SpaceModel> workspaces, List<MemberModel> members)
        done,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(List<SpaceModel> workspaces, List<MemberModel> members)?
        done,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<SpaceModel> workspaces, List<MemberModel> members)?
        done,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamStateInit value) init,
    required TResult Function(TeamStateDone value) done,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamStateInit value)? init,
    TResult? Function(TeamStateDone value)? done,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamStateInit value)? init,
    TResult Function(TeamStateDone value)? done,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class TeamStateInit implements TeamState {
  const factory TeamStateInit() = _$TeamStateInit;
}

/// @nodoc
abstract class _$$TeamStateDoneCopyWith<$Res> {
  factory _$$TeamStateDoneCopyWith(
          _$TeamStateDone value, $Res Function(_$TeamStateDone) then) =
      __$$TeamStateDoneCopyWithImpl<$Res>;
  @useResult
  $Res call({List<SpaceModel> workspaces, List<MemberModel> members});
}

/// @nodoc
class __$$TeamStateDoneCopyWithImpl<$Res>
    extends _$TeamStateCopyWithImpl<$Res, _$TeamStateDone>
    implements _$$TeamStateDoneCopyWith<$Res> {
  __$$TeamStateDoneCopyWithImpl(
      _$TeamStateDone _value, $Res Function(_$TeamStateDone) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workspaces = null,
    Object? members = null,
  }) {
    return _then(_$TeamStateDone(
      workspaces: null == workspaces
          ? _value._workspaces
          : workspaces // ignore: cast_nullable_to_non_nullable
              as List<SpaceModel>,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberModel>,
    ));
  }
}

/// @nodoc

class _$TeamStateDone implements TeamStateDone {
  const _$TeamStateDone(
      {required final List<SpaceModel> workspaces,
      required final List<MemberModel> members})
      : _workspaces = workspaces,
        _members = members;

  final List<SpaceModel> _workspaces;
  @override
  List<SpaceModel> get workspaces {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workspaces);
  }

  final List<MemberModel> _members;
  @override
  List<MemberModel> get members {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  String toString() {
    return 'TeamState.done(workspaces: $workspaces, members: $members)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamStateDone &&
            const DeepCollectionEquality()
                .equals(other._workspaces, _workspaces) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_workspaces),
      const DeepCollectionEquality().hash(_members));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamStateDoneCopyWith<_$TeamStateDone> get copyWith =>
      __$$TeamStateDoneCopyWithImpl<_$TeamStateDone>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(
            List<SpaceModel> workspaces, List<MemberModel> members)
        done,
  }) {
    return done(workspaces, members);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(List<SpaceModel> workspaces, List<MemberModel> members)?
        done,
  }) {
    return done?.call(workspaces, members);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<SpaceModel> workspaces, List<MemberModel> members)?
        done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(workspaces, members);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamStateInit value) init,
    required TResult Function(TeamStateDone value) done,
  }) {
    return done(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamStateInit value)? init,
    TResult? Function(TeamStateDone value)? done,
  }) {
    return done?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamStateInit value)? init,
    TResult Function(TeamStateDone value)? done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(this);
    }
    return orElse();
  }
}

abstract class TeamStateDone implements TeamState {
  const factory TeamStateDone(
      {required final List<SpaceModel> workspaces,
      required final List<MemberModel> members}) = _$TeamStateDone;

  List<SpaceModel> get workspaces;
  List<MemberModel> get members;
  @JsonKey(ignore: true)
  _$$TeamStateDoneCopyWith<_$TeamStateDone> get copyWith =>
      throw _privateConstructorUsedError;
}

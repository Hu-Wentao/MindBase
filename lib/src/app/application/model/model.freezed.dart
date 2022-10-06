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
mixin _$AppAct {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        login,
    required TResult Function() loginAnonymous,
    required TResult Function() recover,
    required TResult Function() logout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppActSignupLogin value) signupLogin,
    required TResult Function(AppActLogin value) login,
    required TResult Function(AppActLoginAnonymous value) loginAnonymous,
    required TResult Function(AppActRecover value) recover,
    required TResult Function(AppActLogout value) logout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppActCopyWith<$Res> {
  factory $AppActCopyWith(AppAct value, $Res Function(AppAct) then) =
      _$AppActCopyWithImpl<$Res>;
}

/// @nodoc
class _$AppActCopyWithImpl<$Res> implements $AppActCopyWith<$Res> {
  _$AppActCopyWithImpl(this._value, this._then);

  final AppAct _value;
  // ignore: unused_field
  final $Res Function(AppAct) _then;
}

/// @nodoc
abstract class _$$AppActSignupLoginCopyWith<$Res> {
  factory _$$AppActSignupLoginCopyWith(
          _$AppActSignupLogin value, $Res Function(_$AppActSignupLogin) then) =
      __$$AppActSignupLoginCopyWithImpl<$Res>;
  $Res call({AuthVerify authVerify, String identityStr, Password password});
}

/// @nodoc
class __$$AppActSignupLoginCopyWithImpl<$Res> extends _$AppActCopyWithImpl<$Res>
    implements _$$AppActSignupLoginCopyWith<$Res> {
  __$$AppActSignupLoginCopyWithImpl(
      _$AppActSignupLogin _value, $Res Function(_$AppActSignupLogin) _then)
      : super(_value, (v) => _then(v as _$AppActSignupLogin));

  @override
  _$AppActSignupLogin get _value => super._value as _$AppActSignupLogin;

  @override
  $Res call({
    Object? authVerify = freezed,
    Object? identityStr = freezed,
    Object? password = freezed,
  }) {
    return _then(_$AppActSignupLogin(
      authVerify: authVerify == freezed
          ? _value.authVerify
          : authVerify // ignore: cast_nullable_to_non_nullable
              as AuthVerify,
      identityStr: identityStr == freezed
          ? _value.identityStr
          : identityStr // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as Password,
    ));
  }
}

/// @nodoc

class _$AppActSignupLogin implements AppActSignupLogin {
  const _$AppActSignupLogin(
      {required this.authVerify,
      required this.identityStr,
      required this.password});

  @override
  final AuthVerify authVerify;
  @override
  final String identityStr;
  @override
  final Password password;

  @override
  String toString() {
    return 'AppAct.signupLogin(authVerify: $authVerify, identityStr: $identityStr, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppActSignupLogin &&
            const DeepCollectionEquality()
                .equals(other.authVerify, authVerify) &&
            const DeepCollectionEquality()
                .equals(other.identityStr, identityStr) &&
            const DeepCollectionEquality().equals(other.password, password));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(authVerify),
      const DeepCollectionEquality().hash(identityStr),
      const DeepCollectionEquality().hash(password));

  @JsonKey(ignore: true)
  @override
  _$$AppActSignupLoginCopyWith<_$AppActSignupLogin> get copyWith =>
      __$$AppActSignupLoginCopyWithImpl<_$AppActSignupLogin>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        login,
    required TResult Function() loginAnonymous,
    required TResult Function() recover,
    required TResult Function() logout,
  }) {
    return signupLogin(authVerify, identityStr, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
  }) {
    return signupLogin?.call(authVerify, identityStr, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
    required TResult orElse(),
  }) {
    if (signupLogin != null) {
      return signupLogin(authVerify, identityStr, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppActSignupLogin value) signupLogin,
    required TResult Function(AppActLogin value) login,
    required TResult Function(AppActLoginAnonymous value) loginAnonymous,
    required TResult Function(AppActRecover value) recover,
    required TResult Function(AppActLogout value) logout,
  }) {
    return signupLogin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
  }) {
    return signupLogin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
    required TResult orElse(),
  }) {
    if (signupLogin != null) {
      return signupLogin(this);
    }
    return orElse();
  }
}

abstract class AppActSignupLogin implements AppAct {
  const factory AppActSignupLogin(
      {required final AuthVerify authVerify,
      required final String identityStr,
      required final Password password}) = _$AppActSignupLogin;

  AuthVerify get authVerify;
  String get identityStr;
  Password get password;
  @JsonKey(ignore: true)
  _$$AppActSignupLoginCopyWith<_$AppActSignupLogin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AppActLoginCopyWith<$Res> {
  factory _$$AppActLoginCopyWith(
          _$AppActLogin value, $Res Function(_$AppActLogin) then) =
      __$$AppActLoginCopyWithImpl<$Res>;
  $Res call({AuthVerify authVerify, String identityStr, Password password});
}

/// @nodoc
class __$$AppActLoginCopyWithImpl<$Res> extends _$AppActCopyWithImpl<$Res>
    implements _$$AppActLoginCopyWith<$Res> {
  __$$AppActLoginCopyWithImpl(
      _$AppActLogin _value, $Res Function(_$AppActLogin) _then)
      : super(_value, (v) => _then(v as _$AppActLogin));

  @override
  _$AppActLogin get _value => super._value as _$AppActLogin;

  @override
  $Res call({
    Object? authVerify = freezed,
    Object? identityStr = freezed,
    Object? password = freezed,
  }) {
    return _then(_$AppActLogin(
      authVerify: authVerify == freezed
          ? _value.authVerify
          : authVerify // ignore: cast_nullable_to_non_nullable
              as AuthVerify,
      identityStr: identityStr == freezed
          ? _value.identityStr
          : identityStr // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as Password,
    ));
  }
}

/// @nodoc

class _$AppActLogin implements AppActLogin {
  const _$AppActLogin(
      {required this.authVerify,
      required this.identityStr,
      required this.password});

  @override
  final AuthVerify authVerify;
  @override
  final String identityStr;
  @override
  final Password password;

  @override
  String toString() {
    return 'AppAct.login(authVerify: $authVerify, identityStr: $identityStr, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppActLogin &&
            const DeepCollectionEquality()
                .equals(other.authVerify, authVerify) &&
            const DeepCollectionEquality()
                .equals(other.identityStr, identityStr) &&
            const DeepCollectionEquality().equals(other.password, password));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(authVerify),
      const DeepCollectionEquality().hash(identityStr),
      const DeepCollectionEquality().hash(password));

  @JsonKey(ignore: true)
  @override
  _$$AppActLoginCopyWith<_$AppActLogin> get copyWith =>
      __$$AppActLoginCopyWithImpl<_$AppActLogin>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        login,
    required TResult Function() loginAnonymous,
    required TResult Function() recover,
    required TResult Function() logout,
  }) {
    return login(authVerify, identityStr, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
  }) {
    return login?.call(authVerify, identityStr, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(authVerify, identityStr, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppActSignupLogin value) signupLogin,
    required TResult Function(AppActLogin value) login,
    required TResult Function(AppActLoginAnonymous value) loginAnonymous,
    required TResult Function(AppActRecover value) recover,
    required TResult Function(AppActLogout value) logout,
  }) {
    return login(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
  }) {
    return login?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(this);
    }
    return orElse();
  }
}

abstract class AppActLogin implements AppAct {
  const factory AppActLogin(
      {required final AuthVerify authVerify,
      required final String identityStr,
      required final Password password}) = _$AppActLogin;

  AuthVerify get authVerify;
  String get identityStr;
  Password get password;
  @JsonKey(ignore: true)
  _$$AppActLoginCopyWith<_$AppActLogin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AppActLoginAnonymousCopyWith<$Res> {
  factory _$$AppActLoginAnonymousCopyWith(_$AppActLoginAnonymous value,
          $Res Function(_$AppActLoginAnonymous) then) =
      __$$AppActLoginAnonymousCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppActLoginAnonymousCopyWithImpl<$Res>
    extends _$AppActCopyWithImpl<$Res>
    implements _$$AppActLoginAnonymousCopyWith<$Res> {
  __$$AppActLoginAnonymousCopyWithImpl(_$AppActLoginAnonymous _value,
      $Res Function(_$AppActLoginAnonymous) _then)
      : super(_value, (v) => _then(v as _$AppActLoginAnonymous));

  @override
  _$AppActLoginAnonymous get _value => super._value as _$AppActLoginAnonymous;
}

/// @nodoc

class _$AppActLoginAnonymous implements AppActLoginAnonymous {
  const _$AppActLoginAnonymous();

  @override
  String toString() {
    return 'AppAct.loginAnonymous()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AppActLoginAnonymous);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        login,
    required TResult Function() loginAnonymous,
    required TResult Function() recover,
    required TResult Function() logout,
  }) {
    return loginAnonymous();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
  }) {
    return loginAnonymous?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
    required TResult orElse(),
  }) {
    if (loginAnonymous != null) {
      return loginAnonymous();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppActSignupLogin value) signupLogin,
    required TResult Function(AppActLogin value) login,
    required TResult Function(AppActLoginAnonymous value) loginAnonymous,
    required TResult Function(AppActRecover value) recover,
    required TResult Function(AppActLogout value) logout,
  }) {
    return loginAnonymous(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
  }) {
    return loginAnonymous?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
    required TResult orElse(),
  }) {
    if (loginAnonymous != null) {
      return loginAnonymous(this);
    }
    return orElse();
  }
}

abstract class AppActLoginAnonymous implements AppAct {
  const factory AppActLoginAnonymous() = _$AppActLoginAnonymous;
}

/// @nodoc
abstract class _$$AppActRecoverCopyWith<$Res> {
  factory _$$AppActRecoverCopyWith(
          _$AppActRecover value, $Res Function(_$AppActRecover) then) =
      __$$AppActRecoverCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppActRecoverCopyWithImpl<$Res> extends _$AppActCopyWithImpl<$Res>
    implements _$$AppActRecoverCopyWith<$Res> {
  __$$AppActRecoverCopyWithImpl(
      _$AppActRecover _value, $Res Function(_$AppActRecover) _then)
      : super(_value, (v) => _then(v as _$AppActRecover));

  @override
  _$AppActRecover get _value => super._value as _$AppActRecover;
}

/// @nodoc

class _$AppActRecover implements AppActRecover {
  const _$AppActRecover();

  @override
  String toString() {
    return 'AppAct.recover()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AppActRecover);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        login,
    required TResult Function() loginAnonymous,
    required TResult Function() recover,
    required TResult Function() logout,
  }) {
    return recover();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
  }) {
    return recover?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
    required TResult orElse(),
  }) {
    if (recover != null) {
      return recover();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppActSignupLogin value) signupLogin,
    required TResult Function(AppActLogin value) login,
    required TResult Function(AppActLoginAnonymous value) loginAnonymous,
    required TResult Function(AppActRecover value) recover,
    required TResult Function(AppActLogout value) logout,
  }) {
    return recover(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
  }) {
    return recover?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
    required TResult orElse(),
  }) {
    if (recover != null) {
      return recover(this);
    }
    return orElse();
  }
}

abstract class AppActRecover implements AppAct {
  const factory AppActRecover() = _$AppActRecover;
}

/// @nodoc
abstract class _$$AppActLogoutCopyWith<$Res> {
  factory _$$AppActLogoutCopyWith(
          _$AppActLogout value, $Res Function(_$AppActLogout) then) =
      __$$AppActLogoutCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppActLogoutCopyWithImpl<$Res> extends _$AppActCopyWithImpl<$Res>
    implements _$$AppActLogoutCopyWith<$Res> {
  __$$AppActLogoutCopyWithImpl(
      _$AppActLogout _value, $Res Function(_$AppActLogout) _then)
      : super(_value, (v) => _then(v as _$AppActLogout));

  @override
  _$AppActLogout get _value => super._value as _$AppActLogout;
}

/// @nodoc

class _$AppActLogout implements AppActLogout {
  const _$AppActLogout();

  @override
  String toString() {
    return 'AppAct.logout()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AppActLogout);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthVerify authVerify, String identityStr, Password password)
        login,
    required TResult Function() loginAnonymous,
    required TResult Function() recover,
    required TResult Function() logout,
  }) {
    return logout();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
  }) {
    return logout?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(
            AuthVerify authVerify, String identityStr, Password password)?
        login,
    TResult Function()? loginAnonymous,
    TResult Function()? recover,
    TResult Function()? logout,
    required TResult orElse(),
  }) {
    if (logout != null) {
      return logout();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppActSignupLogin value) signupLogin,
    required TResult Function(AppActLogin value) login,
    required TResult Function(AppActLoginAnonymous value) loginAnonymous,
    required TResult Function(AppActRecover value) recover,
    required TResult Function(AppActLogout value) logout,
  }) {
    return logout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
  }) {
    return logout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppActSignupLogin value)? signupLogin,
    TResult Function(AppActLogin value)? login,
    TResult Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult Function(AppActRecover value)? recover,
    TResult Function(AppActLogout value)? logout,
    required TResult orElse(),
  }) {
    if (logout != null) {
      return logout(this);
    }
    return orElse();
  }
}

abstract class AppActLogout implements AppAct {
  const factory AppActLogout() = _$AppActLogout;
}

/// @nodoc
mixin _$AppState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(UserModel user) logged,
    required TResult Function() unLogged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(UserModel user)? logged,
    TResult Function()? unLogged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(UserModel user)? logged,
    TResult Function()? unLogged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppStateInit value) init,
    required TResult Function(AppStateLogged value) logged,
    required TResult Function(AppStateUnLogged value) unLogged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppStateInit value)? init,
    TResult Function(AppStateLogged value)? logged,
    TResult Function(AppStateUnLogged value)? unLogged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppStateInit value)? init,
    TResult Function(AppStateLogged value)? logged,
    TResult Function(AppStateUnLogged value)? unLogged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res> implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  final AppState _value;
  // ignore: unused_field
  final $Res Function(AppState) _then;
}

/// @nodoc
abstract class _$$AppStateInitCopyWith<$Res> {
  factory _$$AppStateInitCopyWith(
          _$AppStateInit value, $Res Function(_$AppStateInit) then) =
      __$$AppStateInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppStateInitCopyWithImpl<$Res> extends _$AppStateCopyWithImpl<$Res>
    implements _$$AppStateInitCopyWith<$Res> {
  __$$AppStateInitCopyWithImpl(
      _$AppStateInit _value, $Res Function(_$AppStateInit) _then)
      : super(_value, (v) => _then(v as _$AppStateInit));

  @override
  _$AppStateInit get _value => super._value as _$AppStateInit;
}

/// @nodoc

class _$AppStateInit implements AppStateInit {
  const _$AppStateInit();

  @override
  String toString() {
    return 'AppState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AppStateInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(UserModel user) logged,
    required TResult Function() unLogged,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(UserModel user)? logged,
    TResult Function()? unLogged,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(UserModel user)? logged,
    TResult Function()? unLogged,
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
    required TResult Function(AppStateInit value) init,
    required TResult Function(AppStateLogged value) logged,
    required TResult Function(AppStateUnLogged value) unLogged,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppStateInit value)? init,
    TResult Function(AppStateLogged value)? logged,
    TResult Function(AppStateUnLogged value)? unLogged,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppStateInit value)? init,
    TResult Function(AppStateLogged value)? logged,
    TResult Function(AppStateUnLogged value)? unLogged,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class AppStateInit implements AppState {
  const factory AppStateInit() = _$AppStateInit;
}

/// @nodoc
abstract class _$$AppStateLoggedCopyWith<$Res> {
  factory _$$AppStateLoggedCopyWith(
          _$AppStateLogged value, $Res Function(_$AppStateLogged) then) =
      __$$AppStateLoggedCopyWithImpl<$Res>;
  $Res call({UserModel user});
}

/// @nodoc
class __$$AppStateLoggedCopyWithImpl<$Res> extends _$AppStateCopyWithImpl<$Res>
    implements _$$AppStateLoggedCopyWith<$Res> {
  __$$AppStateLoggedCopyWithImpl(
      _$AppStateLogged _value, $Res Function(_$AppStateLogged) _then)
      : super(_value, (v) => _then(v as _$AppStateLogged));

  @override
  _$AppStateLogged get _value => super._value as _$AppStateLogged;

  @override
  $Res call({
    Object? user = freezed,
  }) {
    return _then(_$AppStateLogged(
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ));
  }
}

/// @nodoc

class _$AppStateLogged implements AppStateLogged {
  const _$AppStateLogged({required this.user});

  @override
  final UserModel user;

  @override
  String toString() {
    return 'AppState.logged(user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppStateLogged &&
            const DeepCollectionEquality().equals(other.user, user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(user));

  @JsonKey(ignore: true)
  @override
  _$$AppStateLoggedCopyWith<_$AppStateLogged> get copyWith =>
      __$$AppStateLoggedCopyWithImpl<_$AppStateLogged>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(UserModel user) logged,
    required TResult Function() unLogged,
  }) {
    return logged(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(UserModel user)? logged,
    TResult Function()? unLogged,
  }) {
    return logged?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(UserModel user)? logged,
    TResult Function()? unLogged,
    required TResult orElse(),
  }) {
    if (logged != null) {
      return logged(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppStateInit value) init,
    required TResult Function(AppStateLogged value) logged,
    required TResult Function(AppStateUnLogged value) unLogged,
  }) {
    return logged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppStateInit value)? init,
    TResult Function(AppStateLogged value)? logged,
    TResult Function(AppStateUnLogged value)? unLogged,
  }) {
    return logged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppStateInit value)? init,
    TResult Function(AppStateLogged value)? logged,
    TResult Function(AppStateUnLogged value)? unLogged,
    required TResult orElse(),
  }) {
    if (logged != null) {
      return logged(this);
    }
    return orElse();
  }
}

abstract class AppStateLogged implements AppState {
  const factory AppStateLogged({required final UserModel user}) =
      _$AppStateLogged;

  UserModel get user;
  @JsonKey(ignore: true)
  _$$AppStateLoggedCopyWith<_$AppStateLogged> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AppStateUnLoggedCopyWith<$Res> {
  factory _$$AppStateUnLoggedCopyWith(
          _$AppStateUnLogged value, $Res Function(_$AppStateUnLogged) then) =
      __$$AppStateUnLoggedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppStateUnLoggedCopyWithImpl<$Res>
    extends _$AppStateCopyWithImpl<$Res>
    implements _$$AppStateUnLoggedCopyWith<$Res> {
  __$$AppStateUnLoggedCopyWithImpl(
      _$AppStateUnLogged _value, $Res Function(_$AppStateUnLogged) _then)
      : super(_value, (v) => _then(v as _$AppStateUnLogged));

  @override
  _$AppStateUnLogged get _value => super._value as _$AppStateUnLogged;
}

/// @nodoc

class _$AppStateUnLogged implements AppStateUnLogged {
  const _$AppStateUnLogged();

  @override
  String toString() {
    return 'AppState.unLogged()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AppStateUnLogged);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(UserModel user) logged,
    required TResult Function() unLogged,
  }) {
    return unLogged();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(UserModel user)? logged,
    TResult Function()? unLogged,
  }) {
    return unLogged?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(UserModel user)? logged,
    TResult Function()? unLogged,
    required TResult orElse(),
  }) {
    if (unLogged != null) {
      return unLogged();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppStateInit value) init,
    required TResult Function(AppStateLogged value) logged,
    required TResult Function(AppStateUnLogged value) unLogged,
  }) {
    return unLogged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppStateInit value)? init,
    TResult Function(AppStateLogged value)? logged,
    TResult Function(AppStateUnLogged value)? unLogged,
  }) {
    return unLogged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppStateInit value)? init,
    TResult Function(AppStateLogged value)? logged,
    TResult Function(AppStateUnLogged value)? unLogged,
    required TResult orElse(),
  }) {
    if (unLogged != null) {
      return unLogged(this);
    }
    return orElse();
  }
}

abstract class AppStateUnLogged implements AppState {
  const factory AppStateUnLogged() = _$AppStateUnLogged;
}

/// @nodoc
mixin _$AppEvt {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String msg) msg,
    required TResult Function() recovering,
    required TResult Function(String? errMsg) recoverDone,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppEvtMsg value) msg,
    required TResult Function(AppEvtRecovering value) recovering,
    required TResult Function(AppEvtRecoverDone value) recoverDone,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppEvtCopyWith<$Res> {
  factory $AppEvtCopyWith(AppEvt value, $Res Function(AppEvt) then) =
      _$AppEvtCopyWithImpl<$Res>;
}

/// @nodoc
class _$AppEvtCopyWithImpl<$Res> implements $AppEvtCopyWith<$Res> {
  _$AppEvtCopyWithImpl(this._value, this._then);

  final AppEvt _value;
  // ignore: unused_field
  final $Res Function(AppEvt) _then;
}

/// @nodoc
abstract class _$$AppEvtMsgCopyWith<$Res> {
  factory _$$AppEvtMsgCopyWith(
          _$AppEvtMsg value, $Res Function(_$AppEvtMsg) then) =
      __$$AppEvtMsgCopyWithImpl<$Res>;
  $Res call({String msg});
}

/// @nodoc
class __$$AppEvtMsgCopyWithImpl<$Res> extends _$AppEvtCopyWithImpl<$Res>
    implements _$$AppEvtMsgCopyWith<$Res> {
  __$$AppEvtMsgCopyWithImpl(
      _$AppEvtMsg _value, $Res Function(_$AppEvtMsg) _then)
      : super(_value, (v) => _then(v as _$AppEvtMsg));

  @override
  _$AppEvtMsg get _value => super._value as _$AppEvtMsg;

  @override
  $Res call({
    Object? msg = freezed,
  }) {
    return _then(_$AppEvtMsg(
      msg == freezed
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AppEvtMsg implements AppEvtMsg {
  const _$AppEvtMsg(this.msg);

  @override
  final String msg;

  @override
  String toString() {
    return 'AppEvt.msg(msg: $msg)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppEvtMsg &&
            const DeepCollectionEquality().equals(other.msg, msg));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(msg));

  @JsonKey(ignore: true)
  @override
  _$$AppEvtMsgCopyWith<_$AppEvtMsg> get copyWith =>
      __$$AppEvtMsgCopyWithImpl<_$AppEvtMsg>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String msg) msg,
    required TResult Function() recovering,
    required TResult Function(String? errMsg) recoverDone,
  }) {
    return msg(this.msg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
  }) {
    return msg?.call(this.msg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
    required TResult orElse(),
  }) {
    if (msg != null) {
      return msg(this.msg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppEvtMsg value) msg,
    required TResult Function(AppEvtRecovering value) recovering,
    required TResult Function(AppEvtRecoverDone value) recoverDone,
  }) {
    return msg(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
  }) {
    return msg?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
    required TResult orElse(),
  }) {
    if (msg != null) {
      return msg(this);
    }
    return orElse();
  }
}

abstract class AppEvtMsg implements AppEvt {
  const factory AppEvtMsg(final String msg) = _$AppEvtMsg;

  String get msg;
  @JsonKey(ignore: true)
  _$$AppEvtMsgCopyWith<_$AppEvtMsg> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AppEvtRecoveringCopyWith<$Res> {
  factory _$$AppEvtRecoveringCopyWith(
          _$AppEvtRecovering value, $Res Function(_$AppEvtRecovering) then) =
      __$$AppEvtRecoveringCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppEvtRecoveringCopyWithImpl<$Res> extends _$AppEvtCopyWithImpl<$Res>
    implements _$$AppEvtRecoveringCopyWith<$Res> {
  __$$AppEvtRecoveringCopyWithImpl(
      _$AppEvtRecovering _value, $Res Function(_$AppEvtRecovering) _then)
      : super(_value, (v) => _then(v as _$AppEvtRecovering));

  @override
  _$AppEvtRecovering get _value => super._value as _$AppEvtRecovering;
}

/// @nodoc

class _$AppEvtRecovering implements AppEvtRecovering {
  const _$AppEvtRecovering();

  @override
  String toString() {
    return 'AppEvt.recovering()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AppEvtRecovering);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String msg) msg,
    required TResult Function() recovering,
    required TResult Function(String? errMsg) recoverDone,
  }) {
    return recovering();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
  }) {
    return recovering?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
    required TResult orElse(),
  }) {
    if (recovering != null) {
      return recovering();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppEvtMsg value) msg,
    required TResult Function(AppEvtRecovering value) recovering,
    required TResult Function(AppEvtRecoverDone value) recoverDone,
  }) {
    return recovering(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
  }) {
    return recovering?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
    required TResult orElse(),
  }) {
    if (recovering != null) {
      return recovering(this);
    }
    return orElse();
  }
}

abstract class AppEvtRecovering implements AppEvt {
  const factory AppEvtRecovering() = _$AppEvtRecovering;
}

/// @nodoc
abstract class _$$AppEvtRecoverDoneCopyWith<$Res> {
  factory _$$AppEvtRecoverDoneCopyWith(
          _$AppEvtRecoverDone value, $Res Function(_$AppEvtRecoverDone) then) =
      __$$AppEvtRecoverDoneCopyWithImpl<$Res>;
  $Res call({String? errMsg});
}

/// @nodoc
class __$$AppEvtRecoverDoneCopyWithImpl<$Res> extends _$AppEvtCopyWithImpl<$Res>
    implements _$$AppEvtRecoverDoneCopyWith<$Res> {
  __$$AppEvtRecoverDoneCopyWithImpl(
      _$AppEvtRecoverDone _value, $Res Function(_$AppEvtRecoverDone) _then)
      : super(_value, (v) => _then(v as _$AppEvtRecoverDone));

  @override
  _$AppEvtRecoverDone get _value => super._value as _$AppEvtRecoverDone;

  @override
  $Res call({
    Object? errMsg = freezed,
  }) {
    return _then(_$AppEvtRecoverDone(
      errMsg == freezed
          ? _value.errMsg
          : errMsg // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AppEvtRecoverDone implements AppEvtRecoverDone {
  const _$AppEvtRecoverDone(this.errMsg);

  @override
  final String? errMsg;

  @override
  String toString() {
    return 'AppEvt.recoverDone(errMsg: $errMsg)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppEvtRecoverDone &&
            const DeepCollectionEquality().equals(other.errMsg, errMsg));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(errMsg));

  @JsonKey(ignore: true)
  @override
  _$$AppEvtRecoverDoneCopyWith<_$AppEvtRecoverDone> get copyWith =>
      __$$AppEvtRecoverDoneCopyWithImpl<_$AppEvtRecoverDone>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String msg) msg,
    required TResult Function() recovering,
    required TResult Function(String? errMsg) recoverDone,
  }) {
    return recoverDone(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
  }) {
    return recoverDone?.call(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
    required TResult orElse(),
  }) {
    if (recoverDone != null) {
      return recoverDone(errMsg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppEvtMsg value) msg,
    required TResult Function(AppEvtRecovering value) recovering,
    required TResult Function(AppEvtRecoverDone value) recoverDone,
  }) {
    return recoverDone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
  }) {
    return recoverDone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
    required TResult orElse(),
  }) {
    if (recoverDone != null) {
      return recoverDone(this);
    }
    return orElse();
  }
}

abstract class AppEvtRecoverDone implements AppEvt {
  const factory AppEvtRecoverDone(final String? errMsg) = _$AppEvtRecoverDone;

  String? get errMsg;
  @JsonKey(ignore: true)
  _$$AppEvtRecoverDoneCopyWith<_$AppEvtRecoverDone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserAct {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function() updateTeams,
    required TResult Function(String name) createTeam,
    required TResult Function(String teamId) deleteTeam,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function()? updateTeams,
    TResult Function(String name)? createTeam,
    TResult Function(String teamId)? deleteTeam,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function()? updateTeams,
    TResult Function(String name)? createTeam,
    TResult Function(String teamId)? deleteTeam,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserActInitModel value) initModel,
    required TResult Function(UserActUpdateTeams value) updateTeams,
    required TResult Function(UserActCreateTeam value) createTeam,
    required TResult Function(UserActDeleteTeam value) deleteTeam,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
    TResult Function(UserActUpdateTeams value)? updateTeams,
    TResult Function(UserActCreateTeam value)? createTeam,
    TResult Function(UserActDeleteTeam value)? deleteTeam,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
    TResult Function(UserActUpdateTeams value)? updateTeams,
    TResult Function(UserActCreateTeam value)? createTeam,
    TResult Function(UserActDeleteTeam value)? deleteTeam,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserActCopyWith<$Res> {
  factory $UserActCopyWith(UserAct value, $Res Function(UserAct) then) =
      _$UserActCopyWithImpl<$Res>;
}

/// @nodoc
class _$UserActCopyWithImpl<$Res> implements $UserActCopyWith<$Res> {
  _$UserActCopyWithImpl(this._value, this._then);

  final UserAct _value;
  // ignore: unused_field
  final $Res Function(UserAct) _then;
}

/// @nodoc
abstract class _$$UserActInitModelCopyWith<$Res> {
  factory _$$UserActInitModelCopyWith(
          _$UserActInitModel value, $Res Function(_$UserActInitModel) then) =
      __$$UserActInitModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserActInitModelCopyWithImpl<$Res> extends _$UserActCopyWithImpl<$Res>
    implements _$$UserActInitModelCopyWith<$Res> {
  __$$UserActInitModelCopyWithImpl(
      _$UserActInitModel _value, $Res Function(_$UserActInitModel) _then)
      : super(_value, (v) => _then(v as _$UserActInitModel));

  @override
  _$UserActInitModel get _value => super._value as _$UserActInitModel;
}

/// @nodoc

class _$UserActInitModel implements UserActInitModel {
  const _$UserActInitModel();

  @override
  String toString() {
    return 'UserAct.initModel()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserActInitModel);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function() updateTeams,
    required TResult Function(String name) createTeam,
    required TResult Function(String teamId) deleteTeam,
  }) {
    return initModel();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function()? updateTeams,
    TResult Function(String name)? createTeam,
    TResult Function(String teamId)? deleteTeam,
  }) {
    return initModel?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function()? updateTeams,
    TResult Function(String name)? createTeam,
    TResult Function(String teamId)? deleteTeam,
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
    required TResult Function(UserActInitModel value) initModel,
    required TResult Function(UserActUpdateTeams value) updateTeams,
    required TResult Function(UserActCreateTeam value) createTeam,
    required TResult Function(UserActDeleteTeam value) deleteTeam,
  }) {
    return initModel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
    TResult Function(UserActUpdateTeams value)? updateTeams,
    TResult Function(UserActCreateTeam value)? createTeam,
    TResult Function(UserActDeleteTeam value)? deleteTeam,
  }) {
    return initModel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
    TResult Function(UserActUpdateTeams value)? updateTeams,
    TResult Function(UserActCreateTeam value)? createTeam,
    TResult Function(UserActDeleteTeam value)? deleteTeam,
    required TResult orElse(),
  }) {
    if (initModel != null) {
      return initModel(this);
    }
    return orElse();
  }
}

abstract class UserActInitModel implements UserAct {
  const factory UserActInitModel() = _$UserActInitModel;
}

/// @nodoc
abstract class _$$UserActUpdateTeamsCopyWith<$Res> {
  factory _$$UserActUpdateTeamsCopyWith(_$UserActUpdateTeams value,
          $Res Function(_$UserActUpdateTeams) then) =
      __$$UserActUpdateTeamsCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserActUpdateTeamsCopyWithImpl<$Res>
    extends _$UserActCopyWithImpl<$Res>
    implements _$$UserActUpdateTeamsCopyWith<$Res> {
  __$$UserActUpdateTeamsCopyWithImpl(
      _$UserActUpdateTeams _value, $Res Function(_$UserActUpdateTeams) _then)
      : super(_value, (v) => _then(v as _$UserActUpdateTeams));

  @override
  _$UserActUpdateTeams get _value => super._value as _$UserActUpdateTeams;
}

/// @nodoc

class _$UserActUpdateTeams implements UserActUpdateTeams {
  const _$UserActUpdateTeams();

  @override
  String toString() {
    return 'UserAct.updateTeams()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserActUpdateTeams);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function() updateTeams,
    required TResult Function(String name) createTeam,
    required TResult Function(String teamId) deleteTeam,
  }) {
    return updateTeams();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function()? updateTeams,
    TResult Function(String name)? createTeam,
    TResult Function(String teamId)? deleteTeam,
  }) {
    return updateTeams?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function()? updateTeams,
    TResult Function(String name)? createTeam,
    TResult Function(String teamId)? deleteTeam,
    required TResult orElse(),
  }) {
    if (updateTeams != null) {
      return updateTeams();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserActInitModel value) initModel,
    required TResult Function(UserActUpdateTeams value) updateTeams,
    required TResult Function(UserActCreateTeam value) createTeam,
    required TResult Function(UserActDeleteTeam value) deleteTeam,
  }) {
    return updateTeams(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
    TResult Function(UserActUpdateTeams value)? updateTeams,
    TResult Function(UserActCreateTeam value)? createTeam,
    TResult Function(UserActDeleteTeam value)? deleteTeam,
  }) {
    return updateTeams?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
    TResult Function(UserActUpdateTeams value)? updateTeams,
    TResult Function(UserActCreateTeam value)? createTeam,
    TResult Function(UserActDeleteTeam value)? deleteTeam,
    required TResult orElse(),
  }) {
    if (updateTeams != null) {
      return updateTeams(this);
    }
    return orElse();
  }
}

abstract class UserActUpdateTeams implements UserAct {
  const factory UserActUpdateTeams() = _$UserActUpdateTeams;
}

/// @nodoc
abstract class _$$UserActCreateTeamCopyWith<$Res> {
  factory _$$UserActCreateTeamCopyWith(
          _$UserActCreateTeam value, $Res Function(_$UserActCreateTeam) then) =
      __$$UserActCreateTeamCopyWithImpl<$Res>;
  $Res call({String name});
}

/// @nodoc
class __$$UserActCreateTeamCopyWithImpl<$Res>
    extends _$UserActCopyWithImpl<$Res>
    implements _$$UserActCreateTeamCopyWith<$Res> {
  __$$UserActCreateTeamCopyWithImpl(
      _$UserActCreateTeam _value, $Res Function(_$UserActCreateTeam) _then)
      : super(_value, (v) => _then(v as _$UserActCreateTeam));

  @override
  _$UserActCreateTeam get _value => super._value as _$UserActCreateTeam;

  @override
  $Res call({
    Object? name = freezed,
  }) {
    return _then(_$UserActCreateTeam(
      name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UserActCreateTeam implements UserActCreateTeam {
  const _$UserActCreateTeam(this.name);

  @override
  final String name;

  @override
  String toString() {
    return 'UserAct.createTeam(name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserActCreateTeam &&
            const DeepCollectionEquality().equals(other.name, name));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(name));

  @JsonKey(ignore: true)
  @override
  _$$UserActCreateTeamCopyWith<_$UserActCreateTeam> get copyWith =>
      __$$UserActCreateTeamCopyWithImpl<_$UserActCreateTeam>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function() updateTeams,
    required TResult Function(String name) createTeam,
    required TResult Function(String teamId) deleteTeam,
  }) {
    return createTeam(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function()? updateTeams,
    TResult Function(String name)? createTeam,
    TResult Function(String teamId)? deleteTeam,
  }) {
    return createTeam?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function()? updateTeams,
    TResult Function(String name)? createTeam,
    TResult Function(String teamId)? deleteTeam,
    required TResult orElse(),
  }) {
    if (createTeam != null) {
      return createTeam(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserActInitModel value) initModel,
    required TResult Function(UserActUpdateTeams value) updateTeams,
    required TResult Function(UserActCreateTeam value) createTeam,
    required TResult Function(UserActDeleteTeam value) deleteTeam,
  }) {
    return createTeam(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
    TResult Function(UserActUpdateTeams value)? updateTeams,
    TResult Function(UserActCreateTeam value)? createTeam,
    TResult Function(UserActDeleteTeam value)? deleteTeam,
  }) {
    return createTeam?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
    TResult Function(UserActUpdateTeams value)? updateTeams,
    TResult Function(UserActCreateTeam value)? createTeam,
    TResult Function(UserActDeleteTeam value)? deleteTeam,
    required TResult orElse(),
  }) {
    if (createTeam != null) {
      return createTeam(this);
    }
    return orElse();
  }
}

abstract class UserActCreateTeam implements UserAct {
  const factory UserActCreateTeam(final String name) = _$UserActCreateTeam;

  String get name;
  @JsonKey(ignore: true)
  _$$UserActCreateTeamCopyWith<_$UserActCreateTeam> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserActDeleteTeamCopyWith<$Res> {
  factory _$$UserActDeleteTeamCopyWith(
          _$UserActDeleteTeam value, $Res Function(_$UserActDeleteTeam) then) =
      __$$UserActDeleteTeamCopyWithImpl<$Res>;
  $Res call({String teamId});
}

/// @nodoc
class __$$UserActDeleteTeamCopyWithImpl<$Res>
    extends _$UserActCopyWithImpl<$Res>
    implements _$$UserActDeleteTeamCopyWith<$Res> {
  __$$UserActDeleteTeamCopyWithImpl(
      _$UserActDeleteTeam _value, $Res Function(_$UserActDeleteTeam) _then)
      : super(_value, (v) => _then(v as _$UserActDeleteTeam));

  @override
  _$UserActDeleteTeam get _value => super._value as _$UserActDeleteTeam;

  @override
  $Res call({
    Object? teamId = freezed,
  }) {
    return _then(_$UserActDeleteTeam(
      teamId == freezed
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UserActDeleteTeam implements UserActDeleteTeam {
  const _$UserActDeleteTeam(this.teamId);

  @override
  final String teamId;

  @override
  String toString() {
    return 'UserAct.deleteTeam(teamId: $teamId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserActDeleteTeam &&
            const DeepCollectionEquality().equals(other.teamId, teamId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(teamId));

  @JsonKey(ignore: true)
  @override
  _$$UserActDeleteTeamCopyWith<_$UserActDeleteTeam> get copyWith =>
      __$$UserActDeleteTeamCopyWithImpl<_$UserActDeleteTeam>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function() updateTeams,
    required TResult Function(String name) createTeam,
    required TResult Function(String teamId) deleteTeam,
  }) {
    return deleteTeam(teamId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function()? updateTeams,
    TResult Function(String name)? createTeam,
    TResult Function(String teamId)? deleteTeam,
  }) {
    return deleteTeam?.call(teamId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function()? updateTeams,
    TResult Function(String name)? createTeam,
    TResult Function(String teamId)? deleteTeam,
    required TResult orElse(),
  }) {
    if (deleteTeam != null) {
      return deleteTeam(teamId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserActInitModel value) initModel,
    required TResult Function(UserActUpdateTeams value) updateTeams,
    required TResult Function(UserActCreateTeam value) createTeam,
    required TResult Function(UserActDeleteTeam value) deleteTeam,
  }) {
    return deleteTeam(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
    TResult Function(UserActUpdateTeams value)? updateTeams,
    TResult Function(UserActCreateTeam value)? createTeam,
    TResult Function(UserActDeleteTeam value)? deleteTeam,
  }) {
    return deleteTeam?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
    TResult Function(UserActUpdateTeams value)? updateTeams,
    TResult Function(UserActCreateTeam value)? createTeam,
    TResult Function(UserActDeleteTeam value)? deleteTeam,
    required TResult orElse(),
  }) {
    if (deleteTeam != null) {
      return deleteTeam(this);
    }
    return orElse();
  }
}

abstract class UserActDeleteTeam implements UserAct {
  const factory UserActDeleteTeam(final String teamId) = _$UserActDeleteTeam;

  String get teamId;
  @JsonKey(ignore: true)
  _$$UserActDeleteTeamCopyWith<_$UserActDeleteTeam> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(List<TeamModel> teams) done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<TeamModel> teams)? done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<TeamModel> teams)? done,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserStateInit value) init,
    required TResult Function(UserStateDone value) done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    TResult Function(UserStateDone value)? done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    TResult Function(UserStateDone value)? done,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStateCopyWith<$Res> {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) then) =
      _$UserStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$UserStateCopyWithImpl<$Res> implements $UserStateCopyWith<$Res> {
  _$UserStateCopyWithImpl(this._value, this._then);

  final UserState _value;
  // ignore: unused_field
  final $Res Function(UserState) _then;
}

/// @nodoc
abstract class _$$UserStateInitCopyWith<$Res> {
  factory _$$UserStateInitCopyWith(
          _$UserStateInit value, $Res Function(_$UserStateInit) then) =
      __$$UserStateInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserStateInitCopyWithImpl<$Res> extends _$UserStateCopyWithImpl<$Res>
    implements _$$UserStateInitCopyWith<$Res> {
  __$$UserStateInitCopyWithImpl(
      _$UserStateInit _value, $Res Function(_$UserStateInit) _then)
      : super(_value, (v) => _then(v as _$UserStateInit));

  @override
  _$UserStateInit get _value => super._value as _$UserStateInit;
}

/// @nodoc

class _$UserStateInit implements UserStateInit {
  const _$UserStateInit();

  @override
  String toString() {
    return 'UserState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserStateInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(List<TeamModel> teams) done,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<TeamModel> teams)? done,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<TeamModel> teams)? done,
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
    required TResult Function(UserStateInit value) init,
    required TResult Function(UserStateDone value) done,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    TResult Function(UserStateDone value)? done,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    TResult Function(UserStateDone value)? done,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class UserStateInit implements UserState {
  const factory UserStateInit() = _$UserStateInit;
}

/// @nodoc
abstract class _$$UserStateDoneCopyWith<$Res> {
  factory _$$UserStateDoneCopyWith(
          _$UserStateDone value, $Res Function(_$UserStateDone) then) =
      __$$UserStateDoneCopyWithImpl<$Res>;
  $Res call({List<TeamModel> teams});
}

/// @nodoc
class __$$UserStateDoneCopyWithImpl<$Res> extends _$UserStateCopyWithImpl<$Res>
    implements _$$UserStateDoneCopyWith<$Res> {
  __$$UserStateDoneCopyWithImpl(
      _$UserStateDone _value, $Res Function(_$UserStateDone) _then)
      : super(_value, (v) => _then(v as _$UserStateDone));

  @override
  _$UserStateDone get _value => super._value as _$UserStateDone;

  @override
  $Res call({
    Object? teams = freezed,
  }) {
    return _then(_$UserStateDone(
      teams == freezed
          ? _value.teams
          : teams // ignore: cast_nullable_to_non_nullable
              as List<TeamModel>,
    ));
  }
}

/// @nodoc

class _$UserStateDone implements UserStateDone {
  const _$UserStateDone(this.teams);

  @override
  final List<TeamModel> teams;

  @override
  String toString() {
    return 'UserState.done(teams: $teams)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStateDone &&
            const DeepCollectionEquality().equals(other.teams, teams));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(teams));

  @JsonKey(ignore: true)
  @override
  _$$UserStateDoneCopyWith<_$UserStateDone> get copyWith =>
      __$$UserStateDoneCopyWithImpl<_$UserStateDone>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(List<TeamModel> teams) done,
  }) {
    return done(teams);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<TeamModel> teams)? done,
  }) {
    return done?.call(teams);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<TeamModel> teams)? done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(teams);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserStateInit value) init,
    required TResult Function(UserStateDone value) done,
  }) {
    return done(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    TResult Function(UserStateDone value)? done,
  }) {
    return done?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    TResult Function(UserStateDone value)? done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(this);
    }
    return orElse();
  }
}

abstract class UserStateDone implements UserState {
  const factory UserStateDone(final List<TeamModel> teams) = _$UserStateDone;

  List<TeamModel> get teams;
  @JsonKey(ignore: true)
  _$$UserStateDoneCopyWith<_$UserStateDone> get copyWith =>
      throw _privateConstructorUsedError;
}

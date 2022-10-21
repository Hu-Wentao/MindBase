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
            AuthTp authVerify, String identityStr, String password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, String password)
        login,
    required TResult Function() loginAnonymous,
    required TResult Function() recover,
    required TResult Function() logout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        login,
    TResult? Function()? loginAnonymous,
    TResult? Function()? recover,
    TResult? Function()? logout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, String password)?
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
    TResult? Function(AppActSignupLogin value)? signupLogin,
    TResult? Function(AppActLogin value)? login,
    TResult? Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult? Function(AppActRecover value)? recover,
    TResult? Function(AppActLogout value)? logout,
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
      _$AppActCopyWithImpl<$Res, AppAct>;
}

/// @nodoc
class _$AppActCopyWithImpl<$Res, $Val extends AppAct>
    implements $AppActCopyWith<$Res> {
  _$AppActCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AppActSignupLoginCopyWith<$Res> {
  factory _$$AppActSignupLoginCopyWith(
          _$AppActSignupLogin value, $Res Function(_$AppActSignupLogin) then) =
      __$$AppActSignupLoginCopyWithImpl<$Res>;
  @useResult
  $Res call({AuthTp authVerify, String identityStr, String password});
}

/// @nodoc
class __$$AppActSignupLoginCopyWithImpl<$Res>
    extends _$AppActCopyWithImpl<$Res, _$AppActSignupLogin>
    implements _$$AppActSignupLoginCopyWith<$Res> {
  __$$AppActSignupLoginCopyWithImpl(
      _$AppActSignupLogin _value, $Res Function(_$AppActSignupLogin) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authVerify = null,
    Object? identityStr = null,
    Object? password = null,
  }) {
    return _then(_$AppActSignupLogin(
      authVerify: null == authVerify
          ? _value.authVerify
          : authVerify // ignore: cast_nullable_to_non_nullable
              as AuthTp,
      identityStr: null == identityStr
          ? _value.identityStr
          : identityStr // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
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
  final AuthTp authVerify;
  @override
  final String identityStr;
  @override
  final String password;

  @override
  String toString() {
    return 'AppAct.signupLogin(authVerify: $authVerify, identityStr: $identityStr, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppActSignupLogin &&
            (identical(other.authVerify, authVerify) ||
                other.authVerify == authVerify) &&
            (identical(other.identityStr, identityStr) ||
                other.identityStr == identityStr) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, authVerify, identityStr, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppActSignupLoginCopyWith<_$AppActSignupLogin> get copyWith =>
      __$$AppActSignupLoginCopyWithImpl<_$AppActSignupLogin>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthTp authVerify, String identityStr, String password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, String password)
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
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        login,
    TResult? Function()? loginAnonymous,
    TResult? Function()? recover,
    TResult? Function()? logout,
  }) {
    return signupLogin?.call(authVerify, identityStr, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, String password)?
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
    TResult? Function(AppActSignupLogin value)? signupLogin,
    TResult? Function(AppActLogin value)? login,
    TResult? Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult? Function(AppActRecover value)? recover,
    TResult? Function(AppActLogout value)? logout,
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
      {required final AuthTp authVerify,
      required final String identityStr,
      required final String password}) = _$AppActSignupLogin;

  AuthTp get authVerify;
  String get identityStr;
  String get password;
  @JsonKey(ignore: true)
  _$$AppActSignupLoginCopyWith<_$AppActSignupLogin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AppActLoginCopyWith<$Res> {
  factory _$$AppActLoginCopyWith(
          _$AppActLogin value, $Res Function(_$AppActLogin) then) =
      __$$AppActLoginCopyWithImpl<$Res>;
  @useResult
  $Res call({AuthTp authVerify, String identityStr, String password});
}

/// @nodoc
class __$$AppActLoginCopyWithImpl<$Res>
    extends _$AppActCopyWithImpl<$Res, _$AppActLogin>
    implements _$$AppActLoginCopyWith<$Res> {
  __$$AppActLoginCopyWithImpl(
      _$AppActLogin _value, $Res Function(_$AppActLogin) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authVerify = null,
    Object? identityStr = null,
    Object? password = null,
  }) {
    return _then(_$AppActLogin(
      authVerify: null == authVerify
          ? _value.authVerify
          : authVerify // ignore: cast_nullable_to_non_nullable
              as AuthTp,
      identityStr: null == identityStr
          ? _value.identityStr
          : identityStr // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
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
  final AuthTp authVerify;
  @override
  final String identityStr;
  @override
  final String password;

  @override
  String toString() {
    return 'AppAct.login(authVerify: $authVerify, identityStr: $identityStr, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppActLogin &&
            (identical(other.authVerify, authVerify) ||
                other.authVerify == authVerify) &&
            (identical(other.identityStr, identityStr) ||
                other.identityStr == identityStr) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, authVerify, identityStr, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppActLoginCopyWith<_$AppActLogin> get copyWith =>
      __$$AppActLoginCopyWithImpl<_$AppActLogin>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthTp authVerify, String identityStr, String password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, String password)
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
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        login,
    TResult? Function()? loginAnonymous,
    TResult? Function()? recover,
    TResult? Function()? logout,
  }) {
    return login?.call(authVerify, identityStr, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, String password)?
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
    TResult? Function(AppActSignupLogin value)? signupLogin,
    TResult? Function(AppActLogin value)? login,
    TResult? Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult? Function(AppActRecover value)? recover,
    TResult? Function(AppActLogout value)? logout,
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
      {required final AuthTp authVerify,
      required final String identityStr,
      required final String password}) = _$AppActLogin;

  AuthTp get authVerify;
  String get identityStr;
  String get password;
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
    extends _$AppActCopyWithImpl<$Res, _$AppActLoginAnonymous>
    implements _$$AppActLoginAnonymousCopyWith<$Res> {
  __$$AppActLoginAnonymousCopyWithImpl(_$AppActLoginAnonymous _value,
      $Res Function(_$AppActLoginAnonymous) _then)
      : super(_value, _then);
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
            AuthTp authVerify, String identityStr, String password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, String password)
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
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        login,
    TResult? Function()? loginAnonymous,
    TResult? Function()? recover,
    TResult? Function()? logout,
  }) {
    return loginAnonymous?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, String password)?
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
    TResult? Function(AppActSignupLogin value)? signupLogin,
    TResult? Function(AppActLogin value)? login,
    TResult? Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult? Function(AppActRecover value)? recover,
    TResult? Function(AppActLogout value)? logout,
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
class __$$AppActRecoverCopyWithImpl<$Res>
    extends _$AppActCopyWithImpl<$Res, _$AppActRecover>
    implements _$$AppActRecoverCopyWith<$Res> {
  __$$AppActRecoverCopyWithImpl(
      _$AppActRecover _value, $Res Function(_$AppActRecover) _then)
      : super(_value, _then);
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
            AuthTp authVerify, String identityStr, String password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, String password)
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
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        login,
    TResult? Function()? loginAnonymous,
    TResult? Function()? recover,
    TResult? Function()? logout,
  }) {
    return recover?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, String password)?
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
    TResult? Function(AppActSignupLogin value)? signupLogin,
    TResult? Function(AppActLogin value)? login,
    TResult? Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult? Function(AppActRecover value)? recover,
    TResult? Function(AppActLogout value)? logout,
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
class __$$AppActLogoutCopyWithImpl<$Res>
    extends _$AppActCopyWithImpl<$Res, _$AppActLogout>
    implements _$$AppActLogoutCopyWith<$Res> {
  __$$AppActLogoutCopyWithImpl(
      _$AppActLogout _value, $Res Function(_$AppActLogout) _then)
      : super(_value, _then);
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
            AuthTp authVerify, String identityStr, String password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, String password)
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
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, String password)?
        login,
    TResult? Function()? loginAnonymous,
    TResult? Function()? recover,
    TResult? Function()? logout,
  }) {
    return logout?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthTp authVerify, String identityStr, String password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, String password)?
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
    TResult? Function(AppActSignupLogin value)? signupLogin,
    TResult? Function(AppActLogin value)? login,
    TResult? Function(AppActLoginAnonymous value)? loginAnonymous,
    TResult? Function(AppActRecover value)? recover,
    TResult? Function(AppActLogout value)? logout,
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
    TResult? Function()? init,
    TResult? Function(UserModel user)? logged,
    TResult? Function()? unLogged,
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
    TResult? Function(AppStateInit value)? init,
    TResult? Function(AppStateLogged value)? logged,
    TResult? Function(AppStateUnLogged value)? unLogged,
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
      _$AppStateCopyWithImpl<$Res, AppState>;
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res, $Val extends AppState>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AppStateInitCopyWith<$Res> {
  factory _$$AppStateInitCopyWith(
          _$AppStateInit value, $Res Function(_$AppStateInit) then) =
      __$$AppStateInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppStateInitCopyWithImpl<$Res>
    extends _$AppStateCopyWithImpl<$Res, _$AppStateInit>
    implements _$$AppStateInitCopyWith<$Res> {
  __$$AppStateInitCopyWithImpl(
      _$AppStateInit _value, $Res Function(_$AppStateInit) _then)
      : super(_value, _then);
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
    TResult? Function()? init,
    TResult? Function(UserModel user)? logged,
    TResult? Function()? unLogged,
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
    TResult? Function(AppStateInit value)? init,
    TResult? Function(AppStateLogged value)? logged,
    TResult? Function(AppStateUnLogged value)? unLogged,
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
  @useResult
  $Res call({UserModel user});
}

/// @nodoc
class __$$AppStateLoggedCopyWithImpl<$Res>
    extends _$AppStateCopyWithImpl<$Res, _$AppStateLogged>
    implements _$$AppStateLoggedCopyWith<$Res> {
  __$$AppStateLoggedCopyWithImpl(
      _$AppStateLogged _value, $Res Function(_$AppStateLogged) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$AppStateLogged(
      user: null == user
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
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
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
    TResult? Function()? init,
    TResult? Function(UserModel user)? logged,
    TResult? Function()? unLogged,
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
    TResult? Function(AppStateInit value)? init,
    TResult? Function(AppStateLogged value)? logged,
    TResult? Function(AppStateUnLogged value)? unLogged,
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
    extends _$AppStateCopyWithImpl<$Res, _$AppStateUnLogged>
    implements _$$AppStateUnLoggedCopyWith<$Res> {
  __$$AppStateUnLoggedCopyWithImpl(
      _$AppStateUnLogged _value, $Res Function(_$AppStateUnLogged) _then)
      : super(_value, _then);
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
    TResult? Function()? init,
    TResult? Function(UserModel user)? logged,
    TResult? Function()? unLogged,
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
    TResult? Function(AppStateInit value)? init,
    TResult? Function(AppStateLogged value)? logged,
    TResult? Function(AppStateUnLogged value)? unLogged,
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
    TResult? Function(String msg)? msg,
    TResult? Function()? recovering,
    TResult? Function(String? errMsg)? recoverDone,
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
    TResult? Function(AppEvtMsg value)? msg,
    TResult? Function(AppEvtRecovering value)? recovering,
    TResult? Function(AppEvtRecoverDone value)? recoverDone,
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
      _$AppEvtCopyWithImpl<$Res, AppEvt>;
}

/// @nodoc
class _$AppEvtCopyWithImpl<$Res, $Val extends AppEvt>
    implements $AppEvtCopyWith<$Res> {
  _$AppEvtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AppEvtMsgCopyWith<$Res> {
  factory _$$AppEvtMsgCopyWith(
          _$AppEvtMsg value, $Res Function(_$AppEvtMsg) then) =
      __$$AppEvtMsgCopyWithImpl<$Res>;
  @useResult
  $Res call({String msg});
}

/// @nodoc
class __$$AppEvtMsgCopyWithImpl<$Res>
    extends _$AppEvtCopyWithImpl<$Res, _$AppEvtMsg>
    implements _$$AppEvtMsgCopyWith<$Res> {
  __$$AppEvtMsgCopyWithImpl(
      _$AppEvtMsg _value, $Res Function(_$AppEvtMsg) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? msg = null,
  }) {
    return _then(_$AppEvtMsg(
      null == msg
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
            (identical(other.msg, msg) || other.msg == msg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, msg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
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
    TResult? Function(String msg)? msg,
    TResult? Function()? recovering,
    TResult? Function(String? errMsg)? recoverDone,
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
    TResult? Function(AppEvtMsg value)? msg,
    TResult? Function(AppEvtRecovering value)? recovering,
    TResult? Function(AppEvtRecoverDone value)? recoverDone,
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
class __$$AppEvtRecoveringCopyWithImpl<$Res>
    extends _$AppEvtCopyWithImpl<$Res, _$AppEvtRecovering>
    implements _$$AppEvtRecoveringCopyWith<$Res> {
  __$$AppEvtRecoveringCopyWithImpl(
      _$AppEvtRecovering _value, $Res Function(_$AppEvtRecovering) _then)
      : super(_value, _then);
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
    TResult? Function(String msg)? msg,
    TResult? Function()? recovering,
    TResult? Function(String? errMsg)? recoverDone,
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
    TResult? Function(AppEvtMsg value)? msg,
    TResult? Function(AppEvtRecovering value)? recovering,
    TResult? Function(AppEvtRecoverDone value)? recoverDone,
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
  @useResult
  $Res call({String? errMsg});
}

/// @nodoc
class __$$AppEvtRecoverDoneCopyWithImpl<$Res>
    extends _$AppEvtCopyWithImpl<$Res, _$AppEvtRecoverDone>
    implements _$$AppEvtRecoverDoneCopyWith<$Res> {
  __$$AppEvtRecoverDoneCopyWithImpl(
      _$AppEvtRecoverDone _value, $Res Function(_$AppEvtRecoverDone) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errMsg = freezed,
  }) {
    return _then(_$AppEvtRecoverDone(
      freezed == errMsg
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
            (identical(other.errMsg, errMsg) || other.errMsg == errMsg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errMsg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
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
    TResult? Function(String msg)? msg,
    TResult? Function()? recovering,
    TResult? Function(String? errMsg)? recoverDone,
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
    TResult? Function(AppEvtMsg value)? msg,
    TResult? Function(AppEvtRecovering value)? recovering,
    TResult? Function(AppEvtRecoverDone value)? recoverDone,
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
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserActInitModel value) initModel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserActInitModel value)? initModel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserActCopyWith<$Res> {
  factory $UserActCopyWith(UserAct value, $Res Function(UserAct) then) =
      _$UserActCopyWithImpl<$Res, UserAct>;
}

/// @nodoc
class _$UserActCopyWithImpl<$Res, $Val extends UserAct>
    implements $UserActCopyWith<$Res> {
  _$UserActCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$UserActInitModelCopyWith<$Res> {
  factory _$$UserActInitModelCopyWith(
          _$UserActInitModel value, $Res Function(_$UserActInitModel) then) =
      __$$UserActInitModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserActInitModelCopyWithImpl<$Res>
    extends _$UserActCopyWithImpl<$Res, _$UserActInitModel>
    implements _$$UserActInitModelCopyWith<$Res> {
  __$$UserActInitModelCopyWithImpl(
      _$UserActInitModel _value, $Res Function(_$UserActInitModel) _then)
      : super(_value, _then);
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
  }) {
    return initModel();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
  }) {
    return initModel?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
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
  }) {
    return initModel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserActInitModel value)? initModel,
  }) {
    return initModel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserActInitModel value)? initModel,
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
mixin _$UserState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserStateInit value) init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserStateInit value)? init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStateCopyWith<$Res> {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) then) =
      _$UserStateCopyWithImpl<$Res, UserState>;
}

/// @nodoc
class _$UserStateCopyWithImpl<$Res, $Val extends UserState>
    implements $UserStateCopyWith<$Res> {
  _$UserStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$UserStateInitCopyWith<$Res> {
  factory _$$UserStateInitCopyWith(
          _$UserStateInit value, $Res Function(_$UserStateInit) then) =
      __$$UserStateInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserStateInitCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserStateInit>
    implements _$$UserStateInitCopyWith<$Res> {
  __$$UserStateInitCopyWithImpl(
      _$UserStateInit _value, $Res Function(_$UserStateInit) _then)
      : super(_value, _then);
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
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
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
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserStateInit value)? init,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserStateInit value)? init,
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

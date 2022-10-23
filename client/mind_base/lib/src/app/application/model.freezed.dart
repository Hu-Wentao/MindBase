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
    required TResult Function(UserModel model) logged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String msg)? msg,
    TResult? Function()? recovering,
    TResult? Function(String? errMsg)? recoverDone,
    TResult? Function(UserModel model)? logged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
    TResult Function(UserModel model)? logged,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppEvtMsg value) msg,
    required TResult Function(AppEvtRecovering value) recovering,
    required TResult Function(AppEvtRecoverDone value) recoverDone,
    required TResult Function(AppEvtLogged value) logged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppEvtMsg value)? msg,
    TResult? Function(AppEvtRecovering value)? recovering,
    TResult? Function(AppEvtRecoverDone value)? recoverDone,
    TResult? Function(AppEvtLogged value)? logged,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
    TResult Function(AppEvtLogged value)? logged,
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
    required TResult Function(UserModel model) logged,
  }) {
    return msg(this.msg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String msg)? msg,
    TResult? Function()? recovering,
    TResult? Function(String? errMsg)? recoverDone,
    TResult? Function(UserModel model)? logged,
  }) {
    return msg?.call(this.msg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
    TResult Function(UserModel model)? logged,
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
    required TResult Function(AppEvtLogged value) logged,
  }) {
    return msg(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppEvtMsg value)? msg,
    TResult? Function(AppEvtRecovering value)? recovering,
    TResult? Function(AppEvtRecoverDone value)? recoverDone,
    TResult? Function(AppEvtLogged value)? logged,
  }) {
    return msg?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
    TResult Function(AppEvtLogged value)? logged,
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
    required TResult Function(UserModel model) logged,
  }) {
    return recovering();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String msg)? msg,
    TResult? Function()? recovering,
    TResult? Function(String? errMsg)? recoverDone,
    TResult? Function(UserModel model)? logged,
  }) {
    return recovering?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
    TResult Function(UserModel model)? logged,
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
    required TResult Function(AppEvtLogged value) logged,
  }) {
    return recovering(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppEvtMsg value)? msg,
    TResult? Function(AppEvtRecovering value)? recovering,
    TResult? Function(AppEvtRecoverDone value)? recoverDone,
    TResult? Function(AppEvtLogged value)? logged,
  }) {
    return recovering?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
    TResult Function(AppEvtLogged value)? logged,
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
    required TResult Function(UserModel model) logged,
  }) {
    return recoverDone(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String msg)? msg,
    TResult? Function()? recovering,
    TResult? Function(String? errMsg)? recoverDone,
    TResult? Function(UserModel model)? logged,
  }) {
    return recoverDone?.call(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
    TResult Function(UserModel model)? logged,
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
    required TResult Function(AppEvtLogged value) logged,
  }) {
    return recoverDone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppEvtMsg value)? msg,
    TResult? Function(AppEvtRecovering value)? recovering,
    TResult? Function(AppEvtRecoverDone value)? recoverDone,
    TResult? Function(AppEvtLogged value)? logged,
  }) {
    return recoverDone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
    TResult Function(AppEvtLogged value)? logged,
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
abstract class _$$AppEvtLoggedCopyWith<$Res> {
  factory _$$AppEvtLoggedCopyWith(
          _$AppEvtLogged value, $Res Function(_$AppEvtLogged) then) =
      __$$AppEvtLoggedCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel model});
}

/// @nodoc
class __$$AppEvtLoggedCopyWithImpl<$Res>
    extends _$AppEvtCopyWithImpl<$Res, _$AppEvtLogged>
    implements _$$AppEvtLoggedCopyWith<$Res> {
  __$$AppEvtLoggedCopyWithImpl(
      _$AppEvtLogged _value, $Res Function(_$AppEvtLogged) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = null,
  }) {
    return _then(_$AppEvtLogged(
      null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ));
  }
}

/// @nodoc

class _$AppEvtLogged implements AppEvtLogged {
  const _$AppEvtLogged(this.model);

  @override
  final UserModel model;

  @override
  String toString() {
    return 'AppEvt.logged(model: $model)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppEvtLogged &&
            (identical(other.model, model) || other.model == model));
  }

  @override
  int get hashCode => Object.hash(runtimeType, model);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppEvtLoggedCopyWith<_$AppEvtLogged> get copyWith =>
      __$$AppEvtLoggedCopyWithImpl<_$AppEvtLogged>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String msg) msg,
    required TResult Function() recovering,
    required TResult Function(String? errMsg) recoverDone,
    required TResult Function(UserModel model) logged,
  }) {
    return logged(model);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String msg)? msg,
    TResult? Function()? recovering,
    TResult? Function(String? errMsg)? recoverDone,
    TResult? Function(UserModel model)? logged,
  }) {
    return logged?.call(model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String msg)? msg,
    TResult Function()? recovering,
    TResult Function(String? errMsg)? recoverDone,
    TResult Function(UserModel model)? logged,
    required TResult orElse(),
  }) {
    if (logged != null) {
      return logged(model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppEvtMsg value) msg,
    required TResult Function(AppEvtRecovering value) recovering,
    required TResult Function(AppEvtRecoverDone value) recoverDone,
    required TResult Function(AppEvtLogged value) logged,
  }) {
    return logged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppEvtMsg value)? msg,
    TResult? Function(AppEvtRecovering value)? recovering,
    TResult? Function(AppEvtRecoverDone value)? recoverDone,
    TResult? Function(AppEvtLogged value)? logged,
  }) {
    return logged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppEvtMsg value)? msg,
    TResult Function(AppEvtRecovering value)? recovering,
    TResult Function(AppEvtRecoverDone value)? recoverDone,
    TResult Function(AppEvtLogged value)? logged,
    required TResult orElse(),
  }) {
    if (logged != null) {
      return logged(this);
    }
    return orElse();
  }
}

abstract class AppEvtLogged implements AppEvt {
  const factory AppEvtLogged(final UserModel model) = _$AppEvtLogged;

  UserModel get model;
  @JsonKey(ignore: true)
  _$$AppEvtLoggedCopyWith<_$AppEvtLogged> get copyWith =>
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
    TResult? Function()? initModel,
    TResult? Function()? updateTeams,
    TResult? Function(String name)? createTeam,
    TResult? Function(String teamId)? deleteTeam,
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
    TResult? Function(UserActInitModel value)? initModel,
    TResult? Function(UserActUpdateTeams value)? updateTeams,
    TResult? Function(UserActCreateTeam value)? createTeam,
    TResult? Function(UserActDeleteTeam value)? deleteTeam,
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
    required TResult Function() updateTeams,
    required TResult Function(String name) createTeam,
    required TResult Function(String teamId) deleteTeam,
  }) {
    return initModel();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function()? updateTeams,
    TResult? Function(String name)? createTeam,
    TResult? Function(String teamId)? deleteTeam,
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
    TResult? Function(UserActInitModel value)? initModel,
    TResult? Function(UserActUpdateTeams value)? updateTeams,
    TResult? Function(UserActCreateTeam value)? createTeam,
    TResult? Function(UserActDeleteTeam value)? deleteTeam,
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
    extends _$UserActCopyWithImpl<$Res, _$UserActUpdateTeams>
    implements _$$UserActUpdateTeamsCopyWith<$Res> {
  __$$UserActUpdateTeamsCopyWithImpl(
      _$UserActUpdateTeams _value, $Res Function(_$UserActUpdateTeams) _then)
      : super(_value, _then);
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
    TResult? Function()? initModel,
    TResult? Function()? updateTeams,
    TResult? Function(String name)? createTeam,
    TResult? Function(String teamId)? deleteTeam,
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
    TResult? Function(UserActInitModel value)? initModel,
    TResult? Function(UserActUpdateTeams value)? updateTeams,
    TResult? Function(UserActCreateTeam value)? createTeam,
    TResult? Function(UserActDeleteTeam value)? deleteTeam,
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
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$UserActCreateTeamCopyWithImpl<$Res>
    extends _$UserActCopyWithImpl<$Res, _$UserActCreateTeam>
    implements _$$UserActCreateTeamCopyWith<$Res> {
  __$$UserActCreateTeamCopyWithImpl(
      _$UserActCreateTeam _value, $Res Function(_$UserActCreateTeam) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$UserActCreateTeam(
      null == name
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
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
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
    TResult? Function()? initModel,
    TResult? Function()? updateTeams,
    TResult? Function(String name)? createTeam,
    TResult? Function(String teamId)? deleteTeam,
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
    TResult? Function(UserActInitModel value)? initModel,
    TResult? Function(UserActUpdateTeams value)? updateTeams,
    TResult? Function(UserActCreateTeam value)? createTeam,
    TResult? Function(UserActDeleteTeam value)? deleteTeam,
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
  @useResult
  $Res call({String teamId});
}

/// @nodoc
class __$$UserActDeleteTeamCopyWithImpl<$Res>
    extends _$UserActCopyWithImpl<$Res, _$UserActDeleteTeam>
    implements _$$UserActDeleteTeamCopyWith<$Res> {
  __$$UserActDeleteTeamCopyWithImpl(
      _$UserActDeleteTeam _value, $Res Function(_$UserActDeleteTeam) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teamId = null,
  }) {
    return _then(_$UserActDeleteTeam(
      null == teamId
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
            (identical(other.teamId, teamId) || other.teamId == teamId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, teamId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
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
    TResult? Function()? initModel,
    TResult? Function()? updateTeams,
    TResult? Function(String name)? createTeam,
    TResult? Function(String teamId)? deleteTeam,
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
    TResult? Function(UserActInitModel value)? initModel,
    TResult? Function(UserActUpdateTeams value)? updateTeams,
    TResult? Function(UserActCreateTeam value)? createTeam,
    TResult? Function(UserActDeleteTeam value)? deleteTeam,
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
    TResult? Function()? init,
    TResult? Function(List<TeamModel> teams)? done,
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
    TResult? Function(UserStateInit value)? init,
    TResult? Function(UserStateDone value)? done,
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
    required TResult Function(List<TeamModel> teams) done,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(List<TeamModel> teams)? done,
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
    TResult? Function(UserStateInit value)? init,
    TResult? Function(UserStateDone value)? done,
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
  @useResult
  $Res call({List<TeamModel> teams});
}

/// @nodoc
class __$$UserStateDoneCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserStateDone>
    implements _$$UserStateDoneCopyWith<$Res> {
  __$$UserStateDoneCopyWithImpl(
      _$UserStateDone _value, $Res Function(_$UserStateDone) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teams = null,
  }) {
    return _then(_$UserStateDone(
      null == teams
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
  @pragma('vm:prefer-inline')
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
    TResult? Function()? init,
    TResult? Function(List<TeamModel> teams)? done,
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
    TResult? Function(UserStateInit value)? init,
    TResult? Function(UserStateDone value)? done,
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

/// @nodoc
mixin _$SpaceAct {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(String name) updateName,
    required TResult Function(CollectionDto data) updateTableDetail,
    required TResult Function(MetaDto data) insertMeta,
    required TResult Function(String metaId) deleteMeta,
    required TResult Function(TableDto dto) updateByTable,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(String name)? updateName,
    TResult? Function(CollectionDto data)? updateTableDetail,
    TResult? Function(MetaDto data)? insertMeta,
    TResult? Function(String metaId)? deleteMeta,
    TResult? Function(TableDto dto)? updateByTable,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(String name)? updateName,
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
    required TResult Function(SpaceActUpdateName value) updateName,
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
    TResult? Function(SpaceActUpdateName value)? updateName,
    TResult? Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult? Function(SpaceActInsertMeta value)? insertMeta,
    TResult? Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult? Function(SpaceActUpdateByTable value)? updateByTable,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceActInitModel value)? initModel,
    TResult Function(SpaceActUpdateName value)? updateName,
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
    required TResult Function(String name) updateName,
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
    TResult? Function(String name)? updateName,
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
    TResult Function(String name)? updateName,
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
    required TResult Function(SpaceActUpdateName value) updateName,
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
    TResult? Function(SpaceActUpdateName value)? updateName,
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
    TResult Function(SpaceActUpdateName value)? updateName,
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
abstract class _$$SpaceActUpdateNameCopyWith<$Res> {
  factory _$$SpaceActUpdateNameCopyWith(_$SpaceActUpdateName value,
          $Res Function(_$SpaceActUpdateName) then) =
      __$$SpaceActUpdateNameCopyWithImpl<$Res>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$SpaceActUpdateNameCopyWithImpl<$Res>
    extends _$SpaceActCopyWithImpl<$Res, _$SpaceActUpdateName>
    implements _$$SpaceActUpdateNameCopyWith<$Res> {
  __$$SpaceActUpdateNameCopyWithImpl(
      _$SpaceActUpdateName _value, $Res Function(_$SpaceActUpdateName) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$SpaceActUpdateName(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SpaceActUpdateName implements SpaceActUpdateName {
  const _$SpaceActUpdateName(this.name);

  @override
  final String name;

  @override
  String toString() {
    return 'SpaceAct.updateName(name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpaceActUpdateName &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpaceActUpdateNameCopyWith<_$SpaceActUpdateName> get copyWith =>
      __$$SpaceActUpdateNameCopyWithImpl<_$SpaceActUpdateName>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initModel,
    required TResult Function(String name) updateName,
    required TResult Function(CollectionDto data) updateTableDetail,
    required TResult Function(MetaDto data) insertMeta,
    required TResult Function(String metaId) deleteMeta,
    required TResult Function(TableDto dto) updateByTable,
  }) {
    return updateName(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initModel,
    TResult? Function(String name)? updateName,
    TResult? Function(CollectionDto data)? updateTableDetail,
    TResult? Function(MetaDto data)? insertMeta,
    TResult? Function(String metaId)? deleteMeta,
    TResult? Function(TableDto dto)? updateByTable,
  }) {
    return updateName?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initModel,
    TResult Function(String name)? updateName,
    TResult Function(CollectionDto data)? updateTableDetail,
    TResult Function(MetaDto data)? insertMeta,
    TResult Function(String metaId)? deleteMeta,
    TResult Function(TableDto dto)? updateByTable,
    required TResult orElse(),
  }) {
    if (updateName != null) {
      return updateName(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SpaceActInitModel value) initModel,
    required TResult Function(SpaceActUpdateName value) updateName,
    required TResult Function(SpaceActUpdateTableDetail value)
        updateTableDetail,
    required TResult Function(SpaceActInsertMeta value) insertMeta,
    required TResult Function(SpaceActDeleteMeta value) deleteMeta,
    required TResult Function(SpaceActUpdateByTable value) updateByTable,
  }) {
    return updateName(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SpaceActInitModel value)? initModel,
    TResult? Function(SpaceActUpdateName value)? updateName,
    TResult? Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult? Function(SpaceActInsertMeta value)? insertMeta,
    TResult? Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult? Function(SpaceActUpdateByTable value)? updateByTable,
  }) {
    return updateName?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SpaceActInitModel value)? initModel,
    TResult Function(SpaceActUpdateName value)? updateName,
    TResult Function(SpaceActUpdateTableDetail value)? updateTableDetail,
    TResult Function(SpaceActInsertMeta value)? insertMeta,
    TResult Function(SpaceActDeleteMeta value)? deleteMeta,
    TResult Function(SpaceActUpdateByTable value)? updateByTable,
    required TResult orElse(),
  }) {
    if (updateName != null) {
      return updateName(this);
    }
    return orElse();
  }
}

abstract class SpaceActUpdateName implements SpaceAct {
  const factory SpaceActUpdateName(final String name) = _$SpaceActUpdateName;

  String get name;
  @JsonKey(ignore: true)
  _$$SpaceActUpdateNameCopyWith<_$SpaceActUpdateName> get copyWith =>
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
    required TResult Function(String name) updateName,
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
    TResult? Function(String name)? updateName,
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
    TResult Function(String name)? updateName,
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
    required TResult Function(SpaceActUpdateName value) updateName,
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
    TResult? Function(SpaceActUpdateName value)? updateName,
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
    TResult Function(SpaceActUpdateName value)? updateName,
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
    required TResult Function(String name) updateName,
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
    TResult? Function(String name)? updateName,
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
    TResult Function(String name)? updateName,
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
    required TResult Function(SpaceActUpdateName value) updateName,
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
    TResult? Function(SpaceActUpdateName value)? updateName,
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
    TResult Function(SpaceActUpdateName value)? updateName,
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
    required TResult Function(String name) updateName,
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
    TResult? Function(String name)? updateName,
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
    TResult Function(String name)? updateName,
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
    required TResult Function(SpaceActUpdateName value) updateName,
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
    TResult? Function(SpaceActUpdateName value)? updateName,
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
    TResult Function(SpaceActUpdateName value)? updateName,
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
    required TResult Function(String name) updateName,
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
    TResult? Function(String name)? updateName,
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
    TResult Function(String name)? updateName,
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
    required TResult Function(SpaceActUpdateName value) updateName,
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
    TResult? Function(SpaceActUpdateName value)? updateName,
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
    TResult Function(SpaceActUpdateName value)? updateName,
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
    required TResult Function(Collection metaTableDetail, List<MetaModel> metas)
        done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(Collection metaTableDetail, List<MetaModel> metas)? done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(Collection metaTableDetail, List<MetaModel> metas)? done,
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
    required TResult Function(Collection metaTableDetail, List<MetaModel> metas)
        done,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(Collection metaTableDetail, List<MetaModel> metas)? done,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(Collection metaTableDetail, List<MetaModel> metas)? done,
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
  $Res call({Collection metaTableDetail, List<MetaModel> metas});
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
              as Collection,
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
  final Collection metaTableDetail;
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
    required TResult Function(Collection metaTableDetail, List<MetaModel> metas)
        done,
  }) {
    return done(metaTableDetail, metas);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(Collection metaTableDetail, List<MetaModel> metas)? done,
  }) {
    return done?.call(metaTableDetail, metas);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(Collection metaTableDetail, List<MetaModel> metas)? done,
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
          final Collection metaTableDetail, final List<MetaModel> metas) =
      _$SpaceStateDone;

  Collection get metaTableDetail;
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
    required TResult Function(Team team) updateTeam,
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
    TResult? Function(Team team)? updateTeam,
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
    TResult Function(Team team)? updateTeam,
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
    required TResult Function(Team team) updateTeam,
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
    TResult? Function(Team team)? updateTeam,
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
    TResult Function(Team team)? updateTeam,
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
  $Res call({Team team});
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
              as Team,
    ));
  }
}

/// @nodoc

class _$TeamActUpdateTeam implements TeamActUpdateTeam {
  const _$TeamActUpdateTeam(this.team);

  @override
  final Team team;

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
    required TResult Function(Team team) updateTeam,
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
    TResult? Function(Team team)? updateTeam,
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
    TResult Function(Team team)? updateTeam,
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
  const factory TeamActUpdateTeam(final Team team) = _$TeamActUpdateTeam;

  Team get team;
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
    required TResult Function(Team team) updateTeam,
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
    TResult? Function(Team team)? updateTeam,
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
    TResult Function(Team team)? updateTeam,
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
    required TResult Function(Team team) updateTeam,
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
    TResult? Function(Team team)? updateTeam,
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
    TResult Function(Team team)? updateTeam,
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
    required TResult Function(Team team) updateTeam,
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
    TResult? Function(Team team)? updateTeam,
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
    TResult Function(Team team)? updateTeam,
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
    required TResult Function(Team team) updateTeam,
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
    TResult? Function(Team team)? updateTeam,
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
    TResult Function(Team team)? updateTeam,
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
    required TResult Function(Team team) updateTeam,
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
    TResult? Function(Team team)? updateTeam,
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
    TResult Function(Team team)? updateTeam,
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
    required TResult Function(Team team) updateTeam,
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
    TResult? Function(Team team)? updateTeam,
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
    TResult Function(Team team)? updateTeam,
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
            List<SpaceModel> spaces, List<MemberModel> members)
        done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(List<SpaceModel> spaces, List<MemberModel> members)? done,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<SpaceModel> spaces, List<MemberModel> members)? done,
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
            List<SpaceModel> spaces, List<MemberModel> members)
        done,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(List<SpaceModel> spaces, List<MemberModel> members)? done,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<SpaceModel> spaces, List<MemberModel> members)? done,
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
  $Res call({List<SpaceModel> spaces, List<MemberModel> members});
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
    Object? spaces = null,
    Object? members = null,
  }) {
    return _then(_$TeamStateDone(
      spaces: null == spaces
          ? _value.spaces
          : spaces // ignore: cast_nullable_to_non_nullable
              as List<SpaceModel>,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<MemberModel>,
    ));
  }
}

/// @nodoc

class _$TeamStateDone implements TeamStateDone {
  const _$TeamStateDone({required this.spaces, required this.members});

  @override
  final List<SpaceModel> spaces;
  @override
  final List<MemberModel> members;

  @override
  String toString() {
    return 'TeamState.done(spaces: $spaces, members: $members)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamStateDone &&
            const DeepCollectionEquality().equals(other.spaces, spaces) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(spaces),
      const DeepCollectionEquality().hash(members));

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
            List<SpaceModel> spaces, List<MemberModel> members)
        done,
  }) {
    return done(spaces, members);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(List<SpaceModel> spaces, List<MemberModel> members)? done,
  }) {
    return done?.call(spaces, members);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(List<SpaceModel> spaces, List<MemberModel> members)? done,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(spaces, members);
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
      {required final List<SpaceModel> spaces,
      required final List<MemberModel> members}) = _$TeamStateDone;

  List<SpaceModel> get spaces;
  List<MemberModel> get members;
  @JsonKey(ignore: true)
  _$$TeamStateDoneCopyWith<_$TeamStateDone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TeamEvt {
  SpaceDto get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SpaceDto data) spaceCreated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SpaceDto data)? spaceCreated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SpaceDto data)? spaceCreated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamEvtSpaceCreated value) spaceCreated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamEvtSpaceCreated value)? spaceCreated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamEvtSpaceCreated value)? spaceCreated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TeamEvtCopyWith<TeamEvt> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamEvtCopyWith<$Res> {
  factory $TeamEvtCopyWith(TeamEvt value, $Res Function(TeamEvt) then) =
      _$TeamEvtCopyWithImpl<$Res, TeamEvt>;
  @useResult
  $Res call({SpaceDto data});

  $SpaceDtoCopyWith<$Res> get data;
}

/// @nodoc
class _$TeamEvtCopyWithImpl<$Res, $Val extends TeamEvt>
    implements $TeamEvtCopyWith<$Res> {
  _$TeamEvtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SpaceDto,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SpaceDtoCopyWith<$Res> get data {
    return $SpaceDtoCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeamEvtSpaceCreatedCopyWith<$Res>
    implements $TeamEvtCopyWith<$Res> {
  factory _$$TeamEvtSpaceCreatedCopyWith(_$TeamEvtSpaceCreated value,
          $Res Function(_$TeamEvtSpaceCreated) then) =
      __$$TeamEvtSpaceCreatedCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SpaceDto data});

  @override
  $SpaceDtoCopyWith<$Res> get data;
}

/// @nodoc
class __$$TeamEvtSpaceCreatedCopyWithImpl<$Res>
    extends _$TeamEvtCopyWithImpl<$Res, _$TeamEvtSpaceCreated>
    implements _$$TeamEvtSpaceCreatedCopyWith<$Res> {
  __$$TeamEvtSpaceCreatedCopyWithImpl(
      _$TeamEvtSpaceCreated _value, $Res Function(_$TeamEvtSpaceCreated) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$TeamEvtSpaceCreated(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SpaceDto,
    ));
  }
}

/// @nodoc

class _$TeamEvtSpaceCreated implements TeamEvtSpaceCreated {
  const _$TeamEvtSpaceCreated(this.data);

  @override
  final SpaceDto data;

  @override
  String toString() {
    return 'TeamEvt.spaceCreated(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamEvtSpaceCreated &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamEvtSpaceCreatedCopyWith<_$TeamEvtSpaceCreated> get copyWith =>
      __$$TeamEvtSpaceCreatedCopyWithImpl<_$TeamEvtSpaceCreated>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SpaceDto data) spaceCreated,
  }) {
    return spaceCreated(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SpaceDto data)? spaceCreated,
  }) {
    return spaceCreated?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SpaceDto data)? spaceCreated,
    required TResult orElse(),
  }) {
    if (spaceCreated != null) {
      return spaceCreated(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TeamEvtSpaceCreated value) spaceCreated,
  }) {
    return spaceCreated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TeamEvtSpaceCreated value)? spaceCreated,
  }) {
    return spaceCreated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TeamEvtSpaceCreated value)? spaceCreated,
    required TResult orElse(),
  }) {
    if (spaceCreated != null) {
      return spaceCreated(this);
    }
    return orElse();
  }
}

abstract class TeamEvtSpaceCreated implements TeamEvt {
  const factory TeamEvtSpaceCreated(final SpaceDto data) =
      _$TeamEvtSpaceCreated;

  @override
  SpaceDto get data;
  @override
  @JsonKey(ignore: true)
  _$$TeamEvtSpaceCreatedCopyWith<_$TeamEvtSpaceCreated> get copyWith =>
      throw _privateConstructorUsedError;
}

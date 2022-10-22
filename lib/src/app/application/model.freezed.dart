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
            AuthTp authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, Password password)
        login,
    required TResult Function() loginAnonymous,
    required TResult Function() recover,
    required TResult Function() logout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
        login,
    TResult? Function()? loginAnonymous,
    TResult? Function()? recover,
    TResult? Function()? logout,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
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
  $Res call({AuthTp authVerify, String identityStr, Password password});
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
  final AuthTp authVerify;
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
            AuthTp authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, Password password)
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
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
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
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
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
      required final Password password}) = _$AppActSignupLogin;

  AuthTp get authVerify;
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
  @useResult
  $Res call({AuthTp authVerify, String identityStr, Password password});
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
  final AuthTp authVerify;
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
            AuthTp authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, Password password)
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
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
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
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
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
      required final Password password}) = _$AppActLogin;

  AuthTp get authVerify;
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
            AuthTp authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, Password password)
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
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
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
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
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
            AuthTp authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, Password password)
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
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
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
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
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
            AuthTp authVerify, String identityStr, Password password)
        signupLogin,
    required TResult Function(
            AuthTp authVerify, String identityStr, Password password)
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
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult? Function(AuthTp authVerify, String identityStr, Password password)?
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
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
        signupLogin,
    TResult Function(AuthTp authVerify, String identityStr, Password password)?
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
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

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
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

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
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

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
            const DeepCollectionEquality().equals(other.dto, dto));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(dto));

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
            const DeepCollectionEquality()
                .equals(other.metaTableDetail, metaTableDetail) &&
            const DeepCollectionEquality().equals(other.metas, metas));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(metaTableDetail),
      const DeepCollectionEquality().hash(metas));

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

part of 'value.dart';

/// 认证请求
class AuthReq {
  final bool isRegister;
  final AuthTp authVerify;
  final String identityStr;
  final String password;

  AuthReq(this.isRegister, this.authVerify, this.identityStr, this.password);

  @override
  String toString() =>
      'AuthInfo{isRegister: $isRegister, authVerify: $authVerify, identityStr: $identityStr, password: $password}';
}

/// 认证响应
class AuthRsp {
  final BaseException? err;

  AuthRsp.err(this.err);

  bool get isSuccess => err == null;

  String? get msg => err?.msg;
}

enum AuthTp {
  email, // 绑定邮箱
  // phoneNumber, // 绑定手机
  // wechatOfficial, // 关注公众号
  // qqConnect, // QQ互联
  // qqNumber, // QQ号, 用于QQ机器人
  // github,
}

@JsonSerializable()
class Password extends Object {
  static const validator =
  LengthRangeValidator(min: 8, max: 64, errorMsg: '密码长度只能在8到64个字符之间');

  @JsonKey(name: 'v')
  String v;

  Password(
      this.v,
      );

  factory Password.create(String value) {
    if (!validator.isValid(value)) {
      throw ValidationException(validator.errorMsg);
    }
    return Password(value);
  }

  factory Password.fromJson(Map<String, dynamic> srcJson) =>
      _$PasswordFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PasswordToJson(this);
}

@JsonSerializable()
class Email extends Object {
  static const EmailValidator validator =
  EmailValidator(errorMsg: '请填写正确的邮箱地址');

  @JsonKey(name: 'v')
  String v;

  Email(
      this.v,
      );

  factory Email.create(String value) {
    if (!validator.isValid(value)) {
      throw ValidationException(validator.errorMsg);
    }
    return Email(value);
  }

  factory Email.fromJson(Map<String, dynamic> srcJson) =>
      _$EmailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EmailToJson(this);
}

@JsonSerializable()
class PhoneNumber extends Object {
  static const PatternValidator validator =
  PatternValidator(r"^1[0-9]{10}$", errorMsg: '请填写正确的手机号');

  @JsonKey(name: 'v')
  String v;

  PhoneNumber(
      this.v,
      );

  factory PhoneNumber.create(String value) {
    if (!validator.isValid(value)) {
      throw ValidationException(validator.errorMsg);
    }
    return PhoneNumber(value);
  }

  factory PhoneNumber.fromJson(Map<String, dynamic> srcJson) =>
      _$PhoneNumberFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PhoneNumberToJson(this);
}

@JsonSerializable()
class QQNumber extends Object {
  static const PatternValidator validator =
  PatternValidator(r"^[0-9]{5,13}$", errorMsg: '请填写正确的QQ号');

  @JsonKey(name: 'v')
  int v;

  QQNumber(
      this.v,
      );

  factory QQNumber.create(int value) {
    if (!validator.isValid(value.toString())) {
      throw ValidationException(validator.errorMsg);
    }
    return QQNumber(value);
  }

  factory QQNumber.fromJson(Map<String, dynamic> srcJson) =>
      _$QQNumberFromJson(srcJson);

  Map<String, dynamic> toJson() => _$QQNumberToJson(this);
}

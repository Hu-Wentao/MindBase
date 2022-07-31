import 'package:get_arch_core/get_arch_core.dart';

class AuthBaseException extends BaseException {
  AuthBaseException(super.msg, String debugInfo) : super(debugInfo: debugInfo);
}

/// 用户尚未登录
/// 将会触发 "跳转登录Dialog"
class UnLoginException extends AuthBaseException {
  UnLoginException(super.msg, super.debugInfo);
}
/// 没有权限
/// 包括了[UnLoginException]
class NoPermissionException extends AuthBaseException {
  NoPermissionException(super.msg, super.debugInfo);
}

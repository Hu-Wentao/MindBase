import 'package:get_arch_core/get_arch_core.dart';

/// 用户尚未登录
/// 将会触发 "跳转登录Dialog"
class UnLoginException extends BaseException {
  UnLoginException(String msg, String debugInfo)
      : super(msg, debugInfo: debugInfo);
}
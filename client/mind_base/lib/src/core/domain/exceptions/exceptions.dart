import 'package:appwrite/appwrite.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/config/common_config.dart';
import 'package:mind_base/src/user/domain/exceptions/exceptions.dart';

part 'exception_adapter.dart';

class ServerAppException extends BaseException {
  final int code;

  ServerAppException(this.code, String msg, String debugInfo)
      : super(msg, debugInfo: debugInfo);

}

/// 对错误信息和StackTrace进行包装
/// 用于保护真实异常的 StackTrace信息
class WrappedException extends BaseException {
  final String realMsg;
  final Object realException;
  final StackTrace realTrace;

  WrappedException(this.realMsg, this.realException, this.realTrace)
      : super('WrappedException($realMsg)',
            debugInfo: 'e:$realException,s$realTrace');
}

part of 'config.dart';

/// 异常适配器
abstract class ExceptionAdapter {
  static BaseException of(dynamic e, [StackTrace? s]) {
    log("ExceptionAdapter.of: ${e.runtimeType}# ${e?.toString()} \n${s?.toString()}");
    switch (e.runtimeType) {
      case AppwriteException:
        return _adapterAppwriteException(e);
      default:
        // 如果本来就是[BaseException],就不用再转换了
        if (e is BaseException) return e;
        return BaseException(e.toString(), debugInfo: e.toString());
    }
  }
}

BaseException _adapterAppwriteException(AppwriteException e) {
  final code = e.code ?? 0;
  switch (code) {
    case 401:
      switch (e.type) {
        case 'general_unauthorized_scope':
        case 'user_unauthorized':
          return NoPermissionException("您没有权限!\n请登陆有权限的账号后再执行操作", e.toString());
        case 'user_invalid_credentials':
          return AuthBaseException("账号或密码错误", e.toString());
        // default:
        //   return UnauthorizedException(e.message);
      }
  }
  return ServerAppException(code, "${e.message}", e.toString());
}

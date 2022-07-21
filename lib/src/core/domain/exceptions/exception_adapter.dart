part of 'exceptions.dart';

/// 异常适配器
abstract class ExceptionAdapter {
  static BaseException of(dynamic e, [StackTrace? s]) {
    print("ExceptionAdapter.of: ${e.runtimeType}# \n${s?.toString()}");
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
      if (e.type == 'general_unauthorized_scope' || e.type == "user_unauthorized") {
        return UnLoginException("登陆后再执行操作", e.toString());
      }
  }
  return ServerAppException(code, "${e.message}", e.toString());
}

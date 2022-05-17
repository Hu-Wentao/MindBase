part of 'exceptions.dart';

/// 异常适配器
abstract class ExceptionAdapter {
  static BaseException of(dynamic e,[StackTrace? s]) {
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
  // switch(code){
  //   case 409: // 账户已存在(重复注册)
  // }
  return ServerAppException(code, "${e.message}", e.toString());
}

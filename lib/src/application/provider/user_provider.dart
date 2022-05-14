import 'package:appwrite/models.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/service/account_service.dart';
import 'package:mind_base/src/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/domain/value/value.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

class UserProvider extends ProviderSidecar {
  late final AccountService _accountService;

  // 表示已登陆的用户, 后期考虑持久化到本地,以便客户端/网页自动登录
  User? user;
  Session? cachedSession;

  bool get isLogged => user != null && cachedSession != null;

  @override
  onInitializing() {
    _accountService = sl<AccountService>();
  }

  @override
  // ignore: prefer_function_declarations_over_variables
  BaseException Function(dynamic e, StackTrace s) onCatch =
      (e, s) => ExceptionAdapter.of(e, s);

  // 注册/登录
  Future<BaseException?> actAuthWith(
    bool isRegister,
    AuthVerify authVerify,
    String identityStr,
    Password password,
  ) async =>
      await actWrapper(() async {
        // 先注册
        if (isRegister) {
          user = await _onRegister(authVerify, identityStr, password);
        }
        // 注册完成后自动登录
        await _onLogin(authVerify, identityStr, password);
      });

  Future<User> _onRegister(
    AuthVerify authVerify,
    String identityStr,
    Password password, {
    String m = "正在注册...",
  }) async {
    setInitializing(m);
    switch (authVerify) {
      case AuthVerify.email:
        return await _accountService.signup(
          name: identityStr,
          email: identityStr,
          password: password.v,
        );
      case AuthVerify.phoneNumber:
      case AuthVerify.wechatOfficial:
      case AuthVerify.qqConnect:
      case AuthVerify.qqNumber:
        throw BaseException('功能尚未实现', debugInfo: '逻辑错误');
    }
  }

  // 登录,得到token
  Future<BaseException?> _onLogin(
    AuthVerify authVerify,
    String identityStr,
    Password password, {
    String m = "正在登录...",
    // Session? oldSession,
  }) async {
    setInitializing(m);
    //
    Session nSession;
    switch (authVerify) {
      case AuthVerify.email:
        nSession = await _accountService.login(
          email: identityStr,
          password: password.v,
        );
        break;
      case AuthVerify.phoneNumber:
      case AuthVerify.wechatOfficial:
      case AuthVerify.qqConnect:
      case AuthVerify.qqNumber:
        throw BaseException('尚未支持的登录方式[$authVerify]');
    }
    cachedSession = nSession;
    if (user == null || user!.$id != cachedSession!.userId) {
      user = await _accountService.getUser();
    }
    setInitialized("已登陆");
    return null;

    // // 新建还是更新 nSession
    // if (auth == null) {
    //   auth = UserAuthInfo.create(authVerify, identityStr, password, nSession);
    // } else {
    //   auth = auth.copyWith(token: nSession);
    // }
    // // 必须先存储token到本地，否则无法从后端查询User信息
    // setLogged(auth);
    // // 刷新 info
    // _updateUser();
  }

  Future<BaseException?> actCheckLoggedUser() async {
    print("debug# 检查登录状F态 $isLogged");
    return await actWrapper(() async =>
        isLogged ? null : UnLoginException('尚未登录', 'actCheckLoggedUser'));
  }

  User loggedUser() => user!;

  actLogout() async => await actWrapper(() {
        if (cachedSession != null) _accountService.logout(cachedSession!.$id);
      });
}

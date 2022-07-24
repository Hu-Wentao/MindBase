import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/user/application/service/account_service.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/user/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/user/domain/value/value.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

class UserProvider extends ProviderSidecar<BaseException?> {
  late final AccountService _accountService;

  // 表示已登陆的用户, 后期考虑持久化到本地,以便客户端/网页自动登录
  User? user;
  Session? cachedSession;

  bool get isLogged => user != null;

  // bool get isLogged => user != null && cachedSession != null;

  @override
  onInitializing() async {
    _accountService = sl<AccountService>();
    _tryRecoveryUser();
  }

  UserProvider() : super(onCatch: ExceptionAdapter.of);

  // 尝试恢复用户登录状态, 如果之前的session还有效,在这里可以直接自动登录
  _tryRecoveryUser() async {
    try {
      final u = await _accountService.getUser();
      _setLogged(u, "已恢复登录状态[$u]");
    } catch (e, s) {
      log("尝试恢复用户登录状态时出错", e, s);
      // AppwriteException: general_unauthorized_scope, User (role: guest) missing scope (account) (401)],
      if (e is AppwriteException &&
          e.code == 401 &&
          e.type == 'general_unauthorized_scope') {
        _setLogout("尚未登录");
      }
      setInitialized("初始化出错,$e");
      rethrow;
    }
  }

  _setLogout([String m = '已退出登录']) {
    user = null;
    cachedSession = null;
    setInitialized(m);
  }

  _setLogged(User u, [String m = '已登陆']) {
    user = u;
    setInitialized(m);
  }

  // 注册/登录
  Future<BaseException?> actAuthWith(
    bool isRegister,
    AuthVerify authVerify,
    String identityStr,
    Password password,
  ) async =>
      actAuthWithReq(AuthReq(isRegister, authVerify, identityStr, password));

  Future<BaseException?> actAuthWithReq(AuthReq? req) async =>
      await actWrapper(() async {
        if (req == null) return;
        // 先注册
        if (req.isRegister) {
          user =
              await _onRegister(req.authVerify, req.identityStr, req.password);
        }
        // 注册完成后自动登录
        await _onLogin(req.authVerify, req.identityStr, req.password);
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
      case AuthVerify.github:
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
      case AuthVerify.github:
        throw BaseException('尚未支持的登录方式[$authVerify]');
    }
    cachedSession = nSession;
    if (user == null || user!.$id != cachedSession!.userId) {
      user = await _accountService.getUser();
    }
    _setLogged(user!, "已登陆");
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
        // 'current' 代表登录登录的用户的session
        _accountService.logout(cachedSession?.$id ?? 'current');
        _setLogout('已退出登录');
      });
}

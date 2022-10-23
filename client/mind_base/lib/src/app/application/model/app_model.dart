part of '../model.dart';

@freezed
class AppAct with _$AppAct {
  const factory AppAct.signupLogin({
    required AuthTp authVerify,
    required String identityStr,
    required String password,
  }) = AppActSignupLogin;

  const factory AppAct.login({
    required AuthTp authVerify,
    required String identityStr,
    required String password,
  }) = AppActLogin;

  const factory AppAct.loginAnonymous() = AppActLoginAnonymous;

  const factory AppAct.recover() = AppActRecover;

  const factory AppAct.logout() = AppActLogout;
}

@freezed
class AppState with _$AppState {
  const factory AppState.init() = AppStateInit;

  const factory AppState.logged({required UserModel user}) = AppStateLogged;

  const factory AppState.unLogged() = AppStateUnLogged;
}

@freezed
class AppEvt with _$AppEvt {
  // 由于没有级联逻辑，Evt目前只承担消息通知功能
  const factory AppEvt.msg(String msg) = AppEvtMsg;

  const factory AppEvt.recovering() = AppEvtRecovering;

  const factory AppEvt.recoverDone(String? errMsg) = AppEvtRecoverDone;

  const factory AppEvt.logged(UserModel model) = AppEvtLogged; // 登陆成功
}

class AppModel extends BaseActEntranceModel<AppAct, AppState>
    with EvtEntranceMx<AppEvt> {
  final MindBaseConfig config;

  AppModel(this.config, [AppState state = const AppState.init()])
      : super(state: state, onCatch: ExceptionAdapter.of);

  @override
  onActEntrance(AppAct act) async => await act.when(
        signupLogin: signupLogin,
        login: login,
        logout: logout,
        recover: recover,
        loginAnonymous: loginAnonymous,
      );

  @override
  onEvent(AppEvt evt) {
    super.onEvent(evt);
    evt.maybeWhen(
        logged: (m) => setState(AppState.logged(user: m), '登陆成功'),
        orElse: () {});
  }

  /// 注册+登陆
  signupLogin(
    AuthTp authVerify,
    String identityStr,
    String password,
  ) async {
    final user = await _onSignup(authVerify, identityStr, password);
    evtEntrance(const AppEvt.msg("注册成功"));
    await login(authVerify, identityStr, password, user: user);
  }

  /// 登陆
  login(
    AuthTp authVerify,
    String identityStr,
    String password, {
    User? user,
  }) async {
    final session = await _onLogin(authVerify, identityStr, password);
    user ??= await _recoverUser();
    evtEntrance(AppEvt.logged(UserModel(user, session)));
  }

  recover() async {
    evtEntrance(const AppEvt.recovering());
    try {
      final session = await _recoverSession();
      final user = await _recoverUser();
      evtEntrance(AppEvt.logged(UserModel(user, session)));
    } catch (e) {
      evtEntrance(AppEvt.recoverDone('恢复登陆失败 $e'));
      rethrow;
    }
  }

  loginAnonymous() async {
    final session = await _anonymousSession();
    final user = await _recoverUser();
    evtEntrance(AppEvt.logged(UserModel(user, session)));
  }

  logout() async {
    await _logout(null);
    evtEntrance(const AppEvt.msg("您已退出登陆"));
    setState(const AppState.unLogged(), '退出登陆');
  }
}

extension AppAccountX on AppModel {
  AccountService get _accountSrv => sl<AccountService>();

  _logout(String? sessionId) async => await _accountSrv.logout(sessionId);

  Future<Session> _recoverSession() async => await _accountSrv.getSession();

  Future<Session> _anonymousSession() async =>
      await _accountSrv.createAnonymousSession();

  Future<User> _recoverUser() async {
    return await _accountSrv.getUser();
    // try {
    // } catch (e) {
    //   late AppEvt evt;
    //   if (e is cli.AppwriteException &&
    //       e.code == 401 &&
    //       e.type == 'general_unauthorized_scope') {
    //     evt = const AppEvt.recoverDone("您尚未登录");
    //   } else {
    //     evt = AppEvt.recoverDone("恢复User遇到未知错误, $e");
    //   }
    //   evtEntrance(evt);
    //   rethrow;
    // }
  }

  Future<User> _onSignup(
      AuthTp authVerify, String identityStr, String password) async {
    switch (authVerify) {
      case AuthTp.email:
        return await _accountSrv.signup(
          name: identityStr,
          email: identityStr,
          password: password,
        );
      // case AuthTp.phoneNumber:
      // case AuthTp.wechatOfficial:
      // case AuthTp.qqConnect:
      // case AuthTp.qqNumber:
      // case AuthTp.github:
      //   throw FeatDeveloping('注册方式[$authVerify]尚未实现');
    }
  }

  // 登录,得到token
  Future<Session> _onLogin(
    AuthTp authVerify,
    String identityStr,
    String password,
  ) async {
    Session nSession;
    switch (authVerify) {
      case AuthTp.email:
        nSession = await _accountSrv.login(
          email: identityStr,
          password: password,
        );
        break;
      // case AuthTp.phoneNumber:
      // case AuthTp.wechatOfficial:
      // case AuthTp.qqConnect:
      // case AuthTp.qqNumber:
      // case AuthTp.github:
      //   throw BaseException('尚未支持的登录方式[$authVerify]');
    }
    return nSession;
  }
}

@Deprecated('')
extension AppStateModelBizX on AppModel {
// 注册/登录
  @Deprecated("register / login")
  Future<BaseException?> actAuthWithReq(AuthReq? req) async =>
      await actWrapper(() async {
        if (req == null) return null;
        if (req.isRegister) {
          return await actEntrance(AppAct.signupLogin(
              authVerify: req.authVerify,
              identityStr: req.identityStr,
              password: req.password));
        }
        return await actEntrance(AppAct.login(
            authVerify: req.authVerify,
            identityStr: req.identityStr,
            password: req.password));
      });
}

part of '../model.dart';

enum AuthTp {
  email,
}

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
}

class AppModel extends BaseActEntranceModel<AppAct, AppState>
    with EvtEntranceMx<AppEvt> {
  final MindBaseConfig config;

  AppModel(this.config, [AppState state = const AppState.init()])
      : super(state: state);

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
    evt.maybeWhen(orElse: () {});
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
    evtEntrance(const AppEvt.msg("登陆成功"));
    setState(AppState.logged(user: UserModel(user, session)), '登陆成功');
  }

  recover() async {
    evtEntrance(const AppEvt.recovering());
    try {
      final session = await _recoverSession();
      final user = await _recoverUser();
      setState(AppState.logged(user: UserModel(user, session)), '恢复登陆成功');
    } catch (e) {
      evtEntrance(AppEvt.recoverDone('恢复登陆失败 $e'));
      rethrow;
    }
    evtEntrance(const AppEvt.recoverDone(null));
  }

  loginAnonymous() async {
    final session = await _anonymousSession();
    final user = await _recoverUser();
    evtEntrance(const AppEvt.msg("匿名登陆成功"));
    setState(AppState.logged(user: UserModel(user, session)), '匿名登陆成功');
  }

  logout() async {
    await _logout(null);
    evtEntrance(const AppEvt.msg("您已退出登陆"));
    setState(const AppState.unLogged(), '退出登陆');
  }
}

extension AppAccountX on AppModel {
  AccountService get _actSrv => sl<AccountService>();

  _logout(String? sessionId) async => await _actSrv.logout(sessionId);

  Future<Session> _recoverSession() async => await _actSrv.getSession();

  Future<Session> _anonymousSession() async =>
      await _actSrv.createAnonymousSession();

  Future<User> _recoverUser() async {
    try {
      return await _actSrv.getUser();
    } catch (e) {
      evtEntrance(AppEvt.msg("恢复User失败, $e"));
      rethrow;
    }
  }

  Future<User> _onSignup(
      AuthTp authVerify, String identityStr, String password) async {
    switch (authVerify) {
      case AuthTp.email:
        return await _actSrv.signup(
          name: identityStr,
          email: identityStr,
          password: password,
        );
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
        nSession = await _actSrv.login(
          email: identityStr,
          password: password,
        );
        break;
    }
    return nSession;
  }
}

part of 'model.dart';

class AppStateModel extends ModelSidecar<MindBaseConfig, BaseException?>
    with StateChangeMx<MindBaseConfig, BaseException?> {
  AccountService get _accountSrv => sl<AccountService>();

  AppStateModel(MindBaseConfig data)
      : user = UserModel(),
        super(data, ExceptionAdapter.of);

  // 子状态
  UserModel user;

  /// === 状态刷新

  @override
  Future<bool?> onFetch({bool isActive = false}) async {
    _setUserModel(await _fetchUser());

    return true;
  }

  @override
  Future<bool?> onReset() async {
    user.actCloseReset();

    return true;
  }

  /// === 状态更改

  // 刷新后立即初始化
  _setUserModel(Tuple2<aw.User, aw.Session>? u) {
    user.actUnsubscribe();
    user = UserModel(u?.value1, u?.value2)..actInitSubscription();
    setDoneKeepState('刷新并初始化user[$user]');
  }

  /// === 实现

  /// 尝试恢复用户登录状态, 如果之前的session还有效,在这里可以直接自动登录
  /// 注意,本方法会被 [onFetch] 调用
  /// 《立即初始化状态》
  Future<Tuple2<aw.User, aw.Session>?> _fetchUser() async {
    try {
      final usr = await _accountSrv.getUser();
      final sen = await _accountSrv.getSession();
      return Tuple2<aw.User, aw.Session>(usr, sen);
    } catch (e, s) {
      log("尝试恢复用户登录状态时出错", e, s);
      // AppwriteException: general_unauthorized_scope, User (role: guest) missing scope (account) (401)],
      if (e is cli.AppwriteException &&
          e.code == 401 &&
          e.type == 'general_unauthorized_scope') {
        setDone("您尚未登录");
      } else {
        setDone("初始化遇到未知错误, $e");
      }
      // 默认登陆匿名用户
      final sen = await _accountSrv.createAnonymousSession();
      final usr = await _accountSrv.getUser();
      log("以匿名身份登录[${usr.toMap()}]\n${sen.toMap()}");
      return Tuple2(usr, sen);
    }
  }

  Future<aw.User> _onRegister(
    AuthVerify authVerify,
    String identityStr,
    Password password, {
    String m = "正在注册...",
  }) async {
    setDoneKeepState(m);
    switch (authVerify) {
      case AuthVerify.email:
        return await _accountSrv.signup(
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
  Future<Tuple2<aw.User, aw.Session>> _onLogin(
    AuthVerify authVerify,
    String identityStr,
    Password password, {
    String m = "正在登录...",
  }) async {
    aw.Session nSession;
    switch (authVerify) {
      case AuthVerify.email:
        nSession = await _accountSrv.login(
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
    final u = await _accountSrv.getUser();
    return Tuple2<aw.User, aw.Session>(u, nSession);
  }
}

extension AppStateModelBizX on AppStateModel {
  // 注册/登录
  Future<BaseException?> actAuthWithReq(AuthReq? req) async =>
      await actWrapper(() async {
        if (req == null) return;
        // 先注册
        if (req.isRegister) {
          await _onRegister(req.authVerify, req.identityStr, req.password);
        }
        // 注册完成后自动登录
        _setUserModel(
            await _onLogin(req.authVerify, req.identityStr, req.password));
      });
}

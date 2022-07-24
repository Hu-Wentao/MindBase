import 'package:appwrite/appwrite.dart' as cli;
import 'package:appwrite/models.dart' as aw;
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/user/application/service/account_service.dart';
import 'package:mind_base/src/user/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/user/domain/value/value.dart';
import 'package:mind_base/src/workspace/application/model/model.dart';
import 'package:mind_base/src/workspace/application/service/service.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

class UserModel extends ProviderSidecar<BaseException?> {
  String? get id => _user?.$id;

  String? get name => _user?.name;

  String? get email => _user?.email;

  bool get isLogged => _user != null;

  /// 核心状态
  aw.User? _user;
  aw.Session? _cachedSession;
  List<TeamModel> teams = [];

  @Deprecated("避免使用")
  aw.User loggedUser() => _user!;

  UserModel(this._user) : super(onCatch: ExceptionAdapter.of);

  @override
  onInitializing() {}
}

extension UserModelX on UserModel {
  AccountService get _accountService => sl<AccountService>();

  actOnCreate() => actWrapper(() {
        _tryRecoveryUser();
      });

  // 尝试恢复用户登录状态, 如果之前的session还有效,在这里可以直接自动登录
  _tryRecoveryUser() async {
    try {
      final u = await _accountService.getUser();
      _setLogged(u, "已恢复登录状态[$u]");
    } catch (e, s) {
      log("尝试恢复用户登录状态时出错", e, s);
      // AppwriteException: general_unauthorized_scope, User (role: guest) missing scope (account) (401)],
      if (e is cli.AppwriteException &&
          e.code == 401 &&
          e.type == 'general_unauthorized_scope') {
        _setLogout("尚未登录");
      }
      setInitialized("初始化出错,$e");
      rethrow;
    }
  }

  _setLogout([String m = '已退出登录']) {
    _user = null;
    _cachedSession = null;
    setInitialized(m);
  }

  _setLogged(aw.User u, [String m = '已登陆']) {
    _user = u;
    setInitialized(m);
    // 后续调用
    actRefreshTeams();
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
          _user =
              await _onRegister(req.authVerify, req.identityStr, req.password);
        }
        // 注册完成后自动登录
        await _onLogin(req.authVerify, req.identityStr, req.password);
      });

  Future<aw.User> _onRegister(
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
    aw.Session nSession;
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
    _cachedSession = nSession;
    if (_user == null || _user!.$id != _cachedSession!.userId) {
      _user = await _accountService.getUser();
    }
    _setLogged(_user!, "已登陆");
    return null;
  }

  Future<BaseException?> actCheckLoggedUser() async =>
      await actWrapper(() async =>
          isLogged ? null : UnLoginException('尚未登录', 'actCheckLoggedUser'));

  actLogout() async => await actWrapper(() {
        // 'current' 代表登录登录的用户的session
        _accountService.logout(_cachedSession?.$id ?? 'current');
        _setLogout('已退出登录');
      });
}

extension TeamManagerX on UserModel {
  TeamService get _teamSrv => sl<TeamService>();

  // Future<BaseException?> actUpdateUser(aw.User? nUser) async {
  //   if (_user != nUser) {
  //     _user = nUser;
  //     if (_user != null) {
  //       setInitialized("新用户已登录[${_user!.name}]");
  //       return actRefreshTeams();
  //     } else {
  //       setUninitialized("用户退出登录");
  //       return null;
  //     }
  //   }
  //   return null;
  // }

  /// 在用户切换时,刷新用户名下Team数据
  Future<BaseException?> actRefreshTeams() async => await actWrapper(() async {
        final tms = await _teamSrv.getTeams();
        for (final t in tms) {
          final m = TeamModel(t);
          await m.actRefreshSpace();
          teams.add(m);
          setInitialized("刷新Team信息");
        }
        setInitialized("Team信息刷新完成");
      });
}

extension WorkspaceModelX on UserModel {
  Future<BaseException?> actDeleteTeam(String teamId) async =>
      await actWrapper(() async {
        await _teamSrv.deleteTeam(teamId);
        teams.removeWhere((tm) => tm.id == teamId);
        setInitialized("删除Team[$teamId]");
      });

  Future<BaseException?> actCreateTeam(String name) async =>
      await actWrapper(() async {
        final tm = await _teamSrv.createTeam(name);
        teams.add(TeamModel(tm));
        setInitialized("创建Team[${tm.$id}]");
      });
}

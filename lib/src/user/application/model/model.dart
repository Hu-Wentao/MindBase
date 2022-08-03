import 'dart:async';

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

@Deprecated('UserModel')
typedef UserProvider = UserModel;
@Deprecated('UserModel')
typedef TeamManagerModel = UserModel;

mixin UserStateChangeMx on IUserModel {
  final AccountService _accountService = sl<AccountService>();
  final TeamService _teamSrv = sl<TeamService>();

  @override
  FutureOr<void> onCloseSubs() {
    log('onCloseSubs 尚未实现...');
  }

  @override
  Future<FutureOr<void>> onFetch({bool isActive = false}) async {
    // user
    await _tryRecoveryUser();

    // team
    final tms = await _teamSrv.getTeams();
    for (final t in tms) {
      addNewTeamModel(t);
    }
  }

  @override
  FutureOr<void> onReset() {
    // 不能调用注销方法
    session = null;
    //
    data = null;
    //
    teams.clear();
  }

  @override
  FutureOr<void> onSubscription() {
    log('onSubscription 尚未实现...');
  }

  /// =====

  /// 尝试恢复用户登录状态, 如果之前的session还有效,在这里可以直接自动登录
  /// 注意,本方法会被 [onFetch] 调用
  _tryRecoveryUser() async {
    try {
      final user = await _accountService.getUser();
      updateData(user, state: ModelState.done, msg: "已恢复登录状态[$user]");
    } catch (e, s) {
      log("尝试恢复用户登录状态时出错", e, s);
      // AppwriteException: general_unauthorized_scope, User (role: guest) missing scope (account) (401)],
      if (e is cli.AppwriteException &&
          e.code == 401 &&
          e.type == 'general_unauthorized_scope') {
        actReset();
        setDoneKeepState("尚未登录");
      }
      actReset();
      setDone("初始化出错,$e");
    }
  }
}

abstract class IUserModel extends ModelSidecar<aw.User?, BaseException?>
    with ModelStateChangeMx<aw.User?, BaseException?> {
  IUserModel(aw.User? data, this.session) : super(data, ExceptionAdapter.of);

  aw.Session?  session;

  List<TeamModel> get teams;

  TeamModel addNewTeamModel(aw.Team data);
}

class UserModel extends IUserModel with UserStateChangeMx {
  UserModel([super.data, super.session]);

  String? get id => data?.$id;

  String? get name => data?.name;

  String? get email => data?.email;

  bool get isLogged => data != null;

  /// 核心状态
  @override
  aw.Session? session;
  @override
  List<TeamModel> teams = [];

  @override
  TeamModel addNewTeamModel(aw.Team data, [bool isMember = true]) {
    final m = TeamModel(data, this)..tmpIsMember = isMember;
    teams.add(m
      // 必须在此处初始化,否则Team列表无法显示Team内的工作空间信息
      ..actInitSubscription());
    setDoneKeepState("新增TeamModel[${m.id}]");
    return m;
  }

  @Deprecated("避免使用")
  aw.User loggedUser() => data!;
}

extension UserModelX on UserModel {
  AccountService get _accountService => sl<AccountService>();

  TeamService get _teamSrv => sl<TeamService>();

  /// 尝试加载指定[TeamModel]
  /// 1. 查询当前用户名下是否存在team
  ///   1.1 如果存在, 则加载该team; 结束;
  ///   1.2 如果不存在, 则尝试以访客身份加入team; 结束;
  Future<BaseException?> actLoadTeam(String teamId) async =>
      await actWrapper(() async {
        final any = teams.any((tm) => tm.id == teamId);
        if (!any) {
          final tm = await _teamSrv.getTeam(teamId);
          addNewTeamModel(tm);
        }
        return;
      });

  actLogout() async => await actWrapper(() {
        // 'current' 代表登录登录的用户的session
        _accountService.logout(session?.$id ?? 'current');
        actReset();
        setDoneKeepState('已退出登录');
      });
}

extension WorkspaceModelX on UserModel {
  Future<BaseException?> actDeleteTeam(String teamId) async =>
      await actWrapper(() async {
        await _teamSrv.deleteTeam(teamId);
        teams.removeWhere((tm) => tm.id == teamId);
        setDoneKeepState("删除Team[$teamId]");
      });

  Future<BaseException?> actCreateTeam(String name) async =>
      await actWrapper(() async {
        final tm = await _teamSrv.createTeam(name);
        addNewTeamModel(tm);
      });

  // 打开一个空间
  Future<BaseException?> actOpenWorkspaceById(String workspaceId) async =>
      await actWrapper(() {
        // todo 在team中查询是否存在该空间
      });
}

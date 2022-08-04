import 'dart:async';

import 'package:appwrite/appwrite.dart' as cli;
import 'package:appwrite/models.dart' as aw;
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/user/application/service/account_service.dart';
import 'package:mind_base/src/workspace/application/model/model.dart';
import 'package:mind_base/src/workspace/application/service/service.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

@Deprecated('UserModel')
typedef UserProvider = UserModel;
@Deprecated('UserModel')
typedef TeamManagerModel = UserModel;

mixin UserStateChangeMx on IUserModel {
  final TeamService _teamSrv = sl<TeamService>();

  @override
  FutureOr<void> onCloseSubs() {
    log('onCloseSubs 尚未实现...');
  }

  @override
  Future<FutureOr<void>> onFetch({bool isActive = false}) async {
    // team
    final tms = await _teamSrv.getTeams();
    for (final t in tms) {
      addNewTeamModel(t);
    }
  }

  @override
  FutureOr<void> onReset() {
    // 不能调用注销方法,因为重置本地缓存不代表退出登录
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
}

abstract class IUserModel extends ModelSidecar<aw.User?, BaseException?>
    with ModelStateChangeMx<aw.User?, BaseException?> {
  IUserModel(aw.User? data) : super(data, ExceptionAdapter.of);

  // 状态
  aw.Session? get session;

  set session(aw.Session? value);

  List<TeamModel> get teams;

  // 方法
  bool get isLogged;

  TeamModel addNewTeamModel(aw.Team data);
}

class UserModel extends IUserModel with UserStateChangeMx {
  UserModel([super.data, this.session]);

  String? get id => data?.$id;

  String? get name => data?.name;

  String? get email => data?.email;

  @override
  bool get isLogged => data != null;

  /// 核心状态
  @override
  aw.Session? session;
  @override
  List<TeamModel> teams = [];

  @override
  TeamModel addNewTeamModel(aw.Team data,
      [@Deprecated("弃用") bool isMember = true]) {
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

extension UserBizX on UserModel {
  AccountService get _accountSrv => sl<AccountService>();

  /// 退出登录
  /// 同时重置当前Model状态
  Future<BaseException?> actLogout() async =>
      await actWrapper(() => reqWrapper(() {
            _accountSrv.logout(session?.$id);
            actCloseReset().thenRethrow();
          }, accWhen: () => state != ModelState.init));

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
}

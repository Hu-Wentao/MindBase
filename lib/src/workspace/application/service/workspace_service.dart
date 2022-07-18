import 'package:appwrite/appwrite.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as srv;
import 'package:appwrite/models.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/workspace/domain/repo/repo.dart';
import 'package:mind_base/src/workspace/domain/value/value.dart';
import 'package:mind_base/src/workspace/infra/dao/dao_aw_impl.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/import_data_dialog.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';

import '../provider/opened_workspace.dart';
import 'meta_service.dart';

@lazySingleton
class WorkspaceService {
  final Teams _teams;
  final srv.Teams _srvTeams;
  final Database _db;
  final WorkspaceRepo _workspaceRepo;

  // 全局唯一的集合,已经注入在容器中,可以直接依赖
  final WorkspaceEttAccessor _workspaceEttAcc;

  const WorkspaceService(
    this._db,
    this._teams,
    this._workspaceRepo,
    this._workspaceEttAcc,
    this._srvTeams,
  );

  RecordMetaEttAccessor _getMetaAcc(String workspaceId) =>
      RecordMetaEttAccessor(_db, workspaceId);

  RecordEttAccessor _getRecordAcc(
    @Deprecated("已弃用") Workspace? ws,
    String meatId,
  ) =>
      RecordEttAccessor(_db, meatId);

  /// 查询一个工作空间内的所有Meta
  Stream<RecordMetaDto> queryMetasBy(String workspaceId) =>
      _getMetaAcc(workspaceId).findAll();

  Stream<RecordDto> queryRecordsBy(Workspace workspace, String metaId) =>
      _getRecordAcc(workspace, metaId).findAll();

  // 查询用户名下所有team,以及team对应的工作空间列表
  Future<Map<Team, List<Workspace>>> queryWorkspacesBy(List<Team> teams) async {
    final r = Map.fromIterables(
      teams,
      List.generate(teams.length, (index) => <Workspace>[]),
    );
    for (final t in teams) {
      final w = await _workspaceRepo.findAllByTeam(t.$id).toList();
      // print("debug workspaceList $w");
      if (w.isNotEmpty) {
        r[t] ??= <Workspace>[];
        r[t]!.addAll(w);
      }
    }
    return r;
  }

  Future<Map<Team, List<WorkspaceDto>>> queryWorkspaceDtoBy(
      List<Team> teams) async {
    final r = Map.fromIterables(
      teams,
      List.generate(teams.length, (index) => <WorkspaceDto>[]),
    );
    for (final t in teams) {
      final w = await _workspaceEttAcc.findAllByTeam(t.$id).toList();
      // print("debug workspaceList $w");
      if (w.isNotEmpty) {
        r[t] ??= <WorkspaceDto>[];
        r[t]!.addAll(w);
      }
    }
    return r;
  }

  /// 获取用户的所有Team
  Future<List<Team>> queryAllUserTeams() async => (await _teams.list()).teams;

  Future<Map<Team, List<Workspace>>> queryAllUserWorkspaces() async =>
      queryWorkspacesBy(await queryAllUserTeams());

  Future<Map<Team, List<WorkspaceDto>>> queryAllUserWorkspaceDtoList() async =>
      queryWorkspaceDtoBy(await queryAllUserTeams());

  /// 创建团队工作空间(没有团队的话将会自动创建团队)
  Future<Tuple2<Team, WorkspaceDto>> createWorkspaceDto(
    Team? team,
    String spaceName,
  ) async {
    team ??= await _teams.create(
      teamId: ObjectIdX.createHex,
      name: "$spaceName-team",
      // roles: []
    );
    final dto = WorkspaceDto(
      id: ObjectIdX.createHex,
      teamId: team.$id,
      name: spaceName,
      metas: [],
    );
    // 行级别的读写权限控制
    final readPermit = ["team:${team.$id}"]; // 团队成员可读
    final writePermit = [
      "team:${team.$id}/owner"
    ]; // 团队所有者可写(指`owner`可以更改工作空间名称等字段)
    final r = await _workspaceEttAcc.insert(
      dto,
      read: readPermit,
      write: writePermit,
    );
    // print("debug #新建 Workspace成功$r");
    // final ws = (await _workspaceRepo.findById(r.$id))!;
    return Tuple2(team, dto);
  }

  Future<OpenedWorkspace> openWorkspace(WorkspaceDto dto) async {
    final workspace = await _workspaceRepo.dtoToDomain(dto);
    return OpenedWorkspace.openBy(
      workspace: workspace,
      fetchAllMeta: _getMetaAcc(workspace.id).findAll,
      watchAllMeta: _getMetaAcc(workspace.id).watchAll(),
      getFetchAllRecords: (String metaId) =>
          _getRecordAcc(workspace, metaId).findAll(),
      getWatchAllRecords: (String metaId) =>
          _getRecordAcc(workspace, metaId).watchAll(),
    );
  }

  /// 同时创建Meta与数据
  Future insertTable(MetaService _metaSrv, TableDto table) async {
    // 更新Meta
    if (table.isCreate) {
      await _metaSrv.insertMetaDto(table.meta);
    } else {
      final origin = _metaSrv.findById(table.meta.id);
      await _metaSrv.updateWithRecordCollection(origin, table.meta);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    final RecordDtoRepo rcdRepo = RecordDtoRepo.withDtoDI(sl, table.meta);
    // 插入数据
    for (final rcd in table.data) {
      // print("debug 插入记录 #$rcd");
      await rcdRepo.insert(rcd);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<Team> updateName(Team team, String newName) async {
    return await _teams.update(teamId: team.$id, name: newName);
  }

  Future<void> deleteTeam(String teamId) async =>
      await _teams.delete(teamId: teamId);

  /// 直接拉取用户到团队,无需同意.
  Future<void> inviteMember(
    Team team,
    String userEmail, [
    List<String> roles = const [],
  ]) async {
    final r = await _srvTeams.createMembership(
      teamId: team.$id,
      email: userEmail,
      roles: [],
      // roles: roles ?? ["team:${team.$id}"], // 默认角色为 "团队成员"
      url: 'http://app.shuttlecloud.cn',
    );
    print("debug member ${r.toMap()}");
  }

  Future<void> updateWorkspaceName(
    WorkspaceDto space,
    String nName,
  ) {
    final dto = space..name = nName;
    return _workspaceRepo.update(dto);
  }

  Future<void> deleteSpace(String id) => _workspaceRepo.deleteById(id);
}

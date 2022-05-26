import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/workspace/domain/repo/repo.dart';
import 'package:mind_base/src/workspace/domain/value/value.dart';
import 'package:mind_base/src/workspace/infra/dao/dao_aw_impl.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';

import '../provider/opened_workspace.dart';

@lazySingleton
class WorkspaceService {
  final Teams _teams;
  final Database _db;
  final WorkspaceRepo _workspaceRepo;

  // 全局唯一的集合,已经注入在容器中,可以直接依赖
  final WorkspaceEttAccessor _workspaceEttAcc;

  const WorkspaceService(
    this._db,
    this._teams,
    this._workspaceRepo,
    this._workspaceEttAcc,
  );

  RecordMetaEttAccessor _getMetaAcc(String workspaceId) =>
      RecordMetaEttAccessor(_db, workspaceId);

  RecordEttAccessor _getRecordAcc(Workspace ws, String meatId) =>
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

  /// 获取用户的所有Team
  Future<List<Team>> queryAllUserTeams() async => (await _teams.list()).teams;

  Future<Map<Team, List<Workspace>>> queryAllUserWorkspaces() async =>
      queryWorkspacesBy(await queryAllUserTeams());

  /// 创建团队工作空间(没有团队的话将会自动创建团队)
  Future<Tuple2<Team, Workspace>> createWorkspace(
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
    final ws = (await _workspaceRepo.findById(r.$id))!;
    return Tuple2(team, ws);
  }

  openWorkspace(Workspace workspace) => OpenedWorkspace.openBy(
      workspace: workspace,
      fetchAllMeta: _getMetaAcc(workspace.id).findAll,
      watchAllMeta: _getMetaAcc(workspace.id).watchAll(),
      getFetchAllRecords: (String metaId)=> _getRecordAcc(workspace, metaId).findAll(),
      getWatchAllRecords: (String metaId) => _getRecordAcc(workspace, metaId).watchAll(),
    );
}

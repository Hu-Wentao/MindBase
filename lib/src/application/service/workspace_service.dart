import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/repo/repo.dart';
import 'package:mind_base/src/domain/value/value.dart';
import 'package:mind_base/src/infra/dao/dao_aw_impl.dart';
import 'package:mind_base/src/interface/i_dto.dart';

@lazySingleton
class WorkspaceService {
  final Teams _teams;
  final WorkspaceRepo _workspaceRepo;
  final WorkspaceEttAccessor _workspaceEttAcc;

  const WorkspaceService(
      this._teams, this._workspaceRepo, this._workspaceEttAcc);

  Future<Map<Team, List<Workspace>>> getWorkspaces(List<Team> teams) async {
    final r = Map.fromIterables(
      teams,
      List.generate(teams.length, (index) => <Workspace>[]),
    );
    for (final t in teams) {
      final w = await _workspaceRepo.findById(t.$id);
      if (w != null) {
        r[t] ??= <Workspace>[];
        r[t]!.add(w);
      }
    }
    return r;
  }

  Future<List<Team>> allTeams() async => (await _teams.list()).teams;

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
      id: team.$id,
      name: spaceName,
      metas: [],
    );
    final r = await _workspaceEttAcc.insert(dto);
    // print("debug #新建 Workspace成功$r");
    final ws = (await _workspaceRepo.findById(r.$id))!;
    return Tuple2(team, ws);
  }
}

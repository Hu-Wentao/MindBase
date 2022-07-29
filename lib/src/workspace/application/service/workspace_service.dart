import 'package:appwrite/appwrite.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as srv;
import 'package:appwrite/models.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/workspace/domain/repo/repo.dart';
import 'package:mind_base/src/workspace/domain/value/value.dart';
import 'package:mind_base/src/workspace/infra/dao/dao_aw_impl.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/import_data_dialog.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';

import 'meta_service.dart';

@lazySingleton
class WorkspaceService {
  final Databases _db;
  final WorkspaceEttAccessor _workspaceEttAcc;

  const WorkspaceService(
    this._db,
    this._workspaceEttAcc,
  );

  RecordMetaEttAccessor _getMetaAcc(String workspaceId) =>
      RecordMetaEttAccessor(_db, workspaceId);

  /// 查询一个工作空间内的所有Meta
  Stream<RecordMetaDto> queryMetasBy(String workspaceId) =>
      _getMetaAcc(workspaceId).findAll();

  Future<Map<Team, List<WorkspaceDto>>> queryWorkspaceDtoBy(
      List<Team> teams) async {
    final r = Map.fromIterables(
      teams,
      List.generate(teams.length, (index) => <WorkspaceDto>[]),
    );
    for (final t in teams) {
      final w = await queryWorkspaceDto(t.$id);
      if (w.isNotEmpty) {
        r[t] ??= <WorkspaceDto>[];
        r[t]!.addAll(w);
      }
    }
    return r;
  }

  Future<List<WorkspaceDto>> queryWorkspaceDto(String teamId) async {
    return await _workspaceEttAcc.findAllByTeam(teamId).toList();
  }

  Future<WorkspaceDto> createWorkspaceDtoBy(
    String teamId,
    String spaceName,
  ) async {
    final dto = WorkspaceDto(
      id: ObjectIdX.createHex,
      teamId: teamId,
      name: spaceName,
      metas: [],
    );
    // 行级别的读写权限控制
    final readPermit = ["team:$teamId"]; // 团队成员可读
    final writePermit = [
      "team:$teamId/owner"
    ]; // 团队所有者可写(指`owner`可以更改工作空间名称等字段)
    final r = await _workspaceEttAcc.insert(
      dto,
      read: readPermit,
      write: writePermit,
    );
    return dto;
  }

  /// 同时创建Meta与数据
  Future insertTable(MetaService _metaSrv, TableDto table) async {
    // 创建或更新Meta
    if (table.isCreate) {
      await _metaSrv.insertMetaDto(table.meta);
    } else {
      final origin = _metaSrv.findById(table.meta.id);
      await _metaSrv.updateWithRecordCollection(origin, table.meta);
    }
    // 插入数据
    final RecordDtoRepo rcdRepo = RecordDtoRepo.withDtoDI(sl, table.meta);
    await Future.delayed(const Duration(milliseconds: 1000));
    for (final rcd in table.data) {
      await rcdRepo.insert(rcd);
    }
  }

  Future<void> updateWorkspaceName(
    WorkspaceDto space,
    String nName,
  ) {
    final dto = space..name = nName;
    return _workspaceEttAcc.update(dto);
  }

  Future<void> deleteSpace(String id) => _workspaceEttAcc.deleteBy(id);
}

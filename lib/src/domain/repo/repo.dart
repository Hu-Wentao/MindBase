// repo 是对与聚合根而言的

import 'package:appwrite/appwrite.dart';
import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/infra/dao/dao_aw_impl.dart';
import 'package:mind_base/src/interface/i_dto.dart';

@lazySingleton
class WorkspaceRepo {
// class WorkspaceRepo implements IAsyncCrudRepo<Workspace, String> {
  final Database _db;
  final WorkspaceEttAccessor _workspaceAcc;

  const WorkspaceRepo(this._db, this._workspaceAcc);

  Future<Workspace?> findById(String id) async {
    final dto = (await _workspaceAcc.findById(id));
    if (dto == null) return null;
    dto.id = id; // 直接Find返回的Dto没有注入 ::id 属性, 必须手动填充
    return await _dtoToDomain(dto);
  }

  Future<Workspace> _dtoToDomain(WorkspaceDto dto) async {
    final _metaAccessor = RecordMetaEttAccessor(_db, dto.id);
    final metaList = <RecordMeta>[];
    final workspace = Workspace(id: dto.id, name: dto.name, metas: metaList);
    for (final metaId in dto.metas) {
      metaList.add(
        (await _metaAccessor.findById(metaId))!.toDm(workspace.queryMeta),
      );
    }
    return workspace;
  }

  // @override
  Future<void> deleteById(String id) async => _workspaceAcc.deleteBy(id);

  Stream<Workspace> findAllByTeam(String teamId) => _workspaceAcc.findAll([
        "teamId.equal('$teamId')",
      ]).asyncMap(_dtoToDomain);
}

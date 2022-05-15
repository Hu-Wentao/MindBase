// repo 是对与聚合根而言的

import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/infra/dao/dao_aw_impl.dart';

@lazySingleton
class WorkspaceRepo {
// class WorkspaceRepo implements IAsyncCrudRepo<Workspace, String> {
  final WorkspaceEttAccessor _workspaceAcc;
  final RecordMetaEttAccessor _metaEttAccessor;

  const WorkspaceRepo(this._workspaceAcc, this._metaEttAccessor);

  Future<Workspace?> findById(String id) async {
    final dto = (await _workspaceAcc.findById(id));
    if (dto == null) return null;
    final metaList = <RecordMeta>[];
    final workspace = Workspace(id: id, name: dto.name, metas: metaList);
    for (final metaId in dto.metas) {
      metaList.add(
        (await _metaEttAccessor.findById(metaId))!.toDm(workspace.queryMeta),
      );
    }
    return workspace;
  }

  // @override
  Future<void> deleteById(String id) async => _workspaceAcc.deleteBy(id);
}

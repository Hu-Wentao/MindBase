import 'package:dart_appwrite/dart_appwrite.dart' as srv;
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/config/appwrite_config.dart';
import 'package:mind_base/src/core/inter/i_dao.dart';
import 'package:mind_base/src/space/domain/repo/repo.dart';
import 'package:mind_base/src/space/domain/value/value.dart';
import 'package:mind_base/src/space/infra/dao/dao_aw_impl.dart';
import 'package:mind_base/src/space/infra/ui/dialog/import_data_dialog.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';
import 'package:mind_base/src/user/inter/dto.dart';

@lazySingleton
class SpaceService {
  final srv.Databases _srvDb;
  final SpaceModelEttAccessor _spaceEttAcc;

  SpaceService(
    this._spaceEttAcc,
    this._srvDb,
  );

  MetaDtoRepo _metaDtoRepo(String workspaceId) =>
      MetaDtoRepo.withDI(sl, workspaceId);

  /// 查询一个工作空间内的所有Meta
  Stream<MetaDto> findMetasBy(String workspaceId) =>
      _metaDtoRepo(workspaceId).findAll();

  Stream<AccessorEvt<MetaDto>> watchMetasBy(String workspaceId) =>
      _metaDtoRepo(workspaceId).watch();

  Future<Map<Team, List<SpaceDto>>> querySpaceModelDtoBy(
      List<Team> teams) async {
    final r = Map.fromIterables(
      teams,
      List.generate(teams.length, (index) => <SpaceDto>[]),
    );
    for (final t in teams) {
      final w = await querySpaceModelDto(t.$id);
      if (w.isNotEmpty) {
        r[t] ??= <SpaceDto>[];
        r[t]!.addAll(w);
      }
    }
    return r;
  }

  Future<List<SpaceDto>> querySpaceModelDto(String teamId) async {
    return await _spaceEttAcc.findAllByTeam(teamId).toList();
  }

  /// 创建工作空间，
  /// 1. 在 workspace表，新增一条workspace记录
  /// 2. 新建 meta_xxx表，用于存储Meta记录
  Future<SpaceDto> createSpaceModelDtoBy(
    String teamId,
    String spaceName,
  ) async {
    /// 1. 新增space记录
    final dto = SpaceDto(
      id: ObjectIdX.createHex,
      teamId: teamId,
      name: spaceName,
      metas: [],
    );
    // 行级别的读写权限控制
    final readPermit = [RoleX.team(teamId)]; // 团队成员可读
    final writePermit = [RoleX.owner(teamId)]; // 团队所有者可写(指`owner`可以更改工作空间名称等字段)
    final r = await _spaceEttAcc.insert(
      dto,
      read: readPermit,
      write: writePermit,
    );
    /// 2 建 meta表
    await _metaDtoRepo(dto.id).createMetaCollection(teamId);
    return dto;
  }

  /// 同时创建Meta与数据
  Future insertTable(TableDto table) async {
    // 创建或更新Meta
    if (table.isCreate) {
      await _metaDtoRepo(table.meta.id).insertDto(table.meta);
    } else {
      final origin = _metaDtoRepo(table.meta.id).findById(table.meta.id);
      await _metaDtoRepo(table.meta.id)
          .updateWithRecordCollection(origin, table.meta);
    }
    // 插入数据
    final RecordDtoRepo rcdRepo = RecordDtoRepo.withDtoDI(sl, table.meta);
    await Future.delayed(const Duration(milliseconds: 1000));
    for (final rcd in table.data) {
      await rcdRepo.insert(rcd);
    }
  }

  Future<void> updateSpaceModelName(
    SpaceDto space,
    String nName,
  ) {
    final dto = space.copyWith(name: nName);
    return _spaceEttAcc.update(dto);
  }

  Future<void> deleteSpace(String id) => _spaceEttAcc.deleteBy(id);

  deleteMeta(String metaId) async {
    await _metaDtoRepo(metaId).deleteBy(metaId);
    await _srvDb.deleteCollection(
      databaseId: mainDataBaseId,
      collectionId: metaId,
    );
  }
}

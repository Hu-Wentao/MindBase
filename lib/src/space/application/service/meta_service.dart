import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/config/appwrite_config.dart';
import 'package:mind_base/src/space/domain/repo/repo.dart';
import 'package:mind_base/src/space/domain/value/value.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';

/// 有状态服务, 不能依赖注入
@Deprecated("合并到SpaceService中")
class MetaService {
  final Databases _db;
  final MetaDtoRepo _metaDtoRepo;

  MetaService(this._metaDtoRepo, this._db);

  static MetaService? withDI(GetIt sl, String workspaceId) {
    return MetaService(MetaDtoRepo.withDI(sl, workspaceId), sl<Databases>());
  }

  Future insertMetaDto(MetaDto metaDto) {
    return _metaDtoRepo.insertDto(metaDto);
  }

  findAllBy(String metaName) {
    return _metaDtoRepo.findAllBy(metaName);
  }

  /// 删除Meta的同时, 还要关闭对应的Record表
  deleteBy(String metaId) async {
    await _metaDtoRepo.deleteBy(metaId);
    // 从数据库中删除 Meta对应的Record集合
    await _db.deleteCollection(
      databaseId: mainDataBaseId,
      collectionId: metaId,
    );
  }

  findById(String metaId) {
    return _metaDtoRepo.findById(metaId);
  }

  updateWithRecordCollection(MetaDto origin, MetaDto dto) {
    return _metaDtoRepo.updateWithRecordCollection(origin, dto);
  }

  updateAttribute(MetaDto origin, AttributeDto dto) {
    return _metaDtoRepo.updateAttribute(origin, dto);
  }

  /// view index==-1表示新增
  updateTableView(MetaDto origin, TableView view) {
    return _metaDtoRepo.updateTableView(origin, view);
  }

  deleteTableView(MetaDto dto, int vId) {
    return _metaDtoRepo.deleteTableView(dto, vId);
  }
}

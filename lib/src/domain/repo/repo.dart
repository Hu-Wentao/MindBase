// repo 是对与聚合根而言的

import 'package:appwrite/appwrite.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as server;
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

// 需要传入指定集合ID, 因此无法注入
class MetaDtoRepo {
  final server.Database _serverDb;
  final String collectionId; // 也是所在workspaceId
  final RecordMetaEttAccessor _metaAcc;

  MetaDtoRepo(
    this._serverDb,
    this._metaAcc,
    this.collectionId,
  );

  static MetaDtoRepo withDI(GetIt get, String workspaceId) => MetaDtoRepo(
        get<server.Database>(),
        RecordMetaEttAccessor(get<Database>(), workspaceId),
        workspaceId,
      );

  insert(RecordMetaDto dto) async {
    try {
      await _metaAcc.insert(dto);
    } on AppwriteException catch (e) {
      if (e.type == 'collection_not_found') {
        // 集合不存在,则创建集合
        // fixme 新建的集合为"所有人可读写"
        await createMetaCollection(null);
        // 再次尝试
        await _metaAcc.insert(dto);
      }
    } catch (e) {
      print('insert meta error[$e]');
      rethrow;
    }
  }

  update(RecordMetaDto dto) async {
    try {
      await _metaAcc.update(dto);
    } on AppwriteException catch (e) {
      if (e.type == 'collection_not_found') {
        // 集合不存在,则创建集合
        // fixme 新建的集合为"所有人可读写"
        await createMetaCollection(null);
        // 再次尝试
        await update(dto);
      } else if (e.type == 'document_not_found') {
        // 文档不存在,新建文档
        await insert(dto);
      }
    } catch (e) {
      print('insert meta error[$e], type ${e.runtimeType}');
      rethrow;
    }
  }

  /// [teamId] 为空表示"所有人可读写"
  /// 默认权限为 "团队内可读写"
  createMetaCollection(String? teamId) async {
    final permit = teamId == null ? ['role:all'] : ['team:$teamId'];
    // 创建集合
    await _serverDb.createCollection(
      collectionId: collectionId,
      name: 'meta_$collectionId',
      permission: 'collection',
      read: permit,
      write: permit,
    );
    // 添加属性 <固定属性,无需用户指定>
    await _serverDb.createStringAttribute(
        collectionId: collectionId, key: 'name', size: 127, xrequired: true);
    await _serverDb.createStringAttribute(
        collectionId: collectionId,
        key: 'memo',
        size: 255,
        xrequired: false,
        xdefault: '');
    await _serverDb.createIntegerAttribute(
        collectionId: collectionId, key: 'maxKey', xrequired: true);
    await _serverDb.createStringAttribute(
        collectionId: collectionId,
        key: 'attrs',
        size: 65535,
        xrequired: false,
        xdefault: '');
    await _serverDb.createStringAttribute(
        collectionId: collectionId,
        key: 'methods',
        size: 65535,
        xrequired: false,
        xdefault: '');
  }

  findById(String metaId) => _metaAcc.findById(metaId);

  findAllBy(String metaName) => _metaAcc.findAllBy(metaName);

  deleteBy(String metaId) => _metaAcc.deleteBy(metaId);
}

class RecordDtoRepo {
  final server.Database _serverDb;

  final RecordMeta meta;
  final RecordEttAccessor _recordAcc;

  RecordDtoRepo(
    this._serverDb,
    this._recordAcc,
    this.meta,
  );

  String get collectionId => meta.id; // 也是所在metaId

  static RecordDtoRepo withDI(GetIt get, RecordMeta meta) => RecordDtoRepo(
        get<server.Database>(),
        RecordEttAccessor(get<Database>(), meta.id),
        meta,
      );

  insert(RecordDto dto) async {
    try {
      await _recordAcc.insert(dto);
    } on AppwriteException catch (e) {
      if (e.type == 'collection_not_found') {
        // 集合不存在,则创建集合
        // fixme 新建的集合为"所有人可读写"
        await createRecordCollection(meta, null);
        // 再次尝试
        await _recordAcc.insert(dto);
      } else {
        rethrow;
      }
    } catch (e) {
      print('insert meta error[$e]');
      rethrow;
    }
  }

  update(RecordDto dto) async {
    try {
      await _recordAcc.update(dto);
    } on AppwriteException catch (e) {
      if (e.type == 'collection_not_found') {
        // 集合不存在,则创建集合
        // fixme 新建的集合为"所有人可读写"
        await createRecordCollection(meta, null);
        // 再次尝试
        await update(dto);
      } else if (e.type == 'document_not_found') {
        // 文档不存在,新建文档
        await insert(dto);
      } else {
        rethrow;
      }
    } catch (e) {
      print('insert meta error[$e], type ${e.runtimeType}');
      rethrow;
    }
  }

  /// [teamId] 为空表示"所有人可读写"
  /// 默认权限为 "团队内可读写"
  /// [meta] 应当是固定内存地址的对象,这样可以确保meta本身是实时更新的
  createRecordCollection(RecordMeta meta, String? teamId) async {
    // 权限
    final permit = teamId == null ? ['role:all'] : ['team:$teamId'];
    // 创建集合
    await _serverDb.createCollection(
      collectionId: collectionId,
      name: 'rcd_$collectionId',
      permission: 'collection',
      read: permit,
      write: permit,
    );
    // 添加属性 <固定属性,无需用户指定>
    for (var attr in meta.attrs) {
      await _serverDb.createStringAttribute(
        collectionId: collectionId,
        key: attr.propId, // Appwrite BUG,属性名称不能用纯数字
        size: 511,
        xrequired: false,
      );
    }
  }

  findById(String metaId) => _recordAcc.findById(metaId);

  findAll() => _recordAcc.findAll();

  deleteBy(String metaId) => _recordAcc.deleteBy(metaId);
}

// repo 是对与聚合根而言的

import 'package:appwrite/appwrite.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as server;
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/workspace/infra/dao/dao_aw_impl.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';

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

  /// 插入Meta记录的同时, 创建对应的Record集合;
  /// 解决监听不存在Record集合,在集合被创建后无法收到消息的问题
  insertEntity(RecordMeta meta) async {
    final r =
        await insertMetaWithCreateRecordCollection(meta).catchError((e, s) {
      print("debug #插入异常 理论步骤2, 插入meta记录,并创建对应的Record集合");
      if (e is AppwriteException && e.type == 'collection_not_found') {
        // 集合不存在,则创建集合
        // fixme 新建的集合为"所有人可读写"
        return createMetaCollection(null)
            // 再次尝试
            .then((_) => insertMetaWithCreateRecordCollection(meta));
      } else {
        return ExceptionAdapter.of(e, s);
      }
    });
    if (r is BaseException) throw r;
  }

  /// 更新
  /// 当前只实现对新增字段的添加功能, 删除考虑后面引入视图(隐藏字段)解决
  updateWithRecordCollection(
      RecordMeta originMeta, RecordMetaDto metaDto) async {
    // 原始MetaAttrList快照
    final originAttrDtoSnap = originMeta.toDto().attrs;
    // 1. 先更新meta记录
    await _update(metaDto);
    // 对比两个对象的属性, 只更新有新增的属性
    final snapAttrKs = originAttrDtoSnap.map((e) => e.k).toSet();
    final readyCreateKs =
        metaDto.attrs.map((e) => e.k).toSet().difference(snapAttrKs);
    // 2. 更新对应的Record表结构
    final readyCreateAttrs =
        metaDto.attrs.where((e) => readyCreateKs.contains(e.k));
    for (final attr in readyCreateAttrs) {
      await updateAttribute(null, attr);
    }
  }

  /// 更新表属性
  /// [originMeta]传null表示直接创建新列(请确保该列尚不存在)
  Future updateAttribute(RecordMeta? originMeta, AttributeDto attr) async {
    final index = originMeta?.attrs.indexWhere((at) => at.k == attr.k) ?? -1;
    if ((index != -1)) {
      // k已存在, 更新attr(只涉及Meta)
      final dto = originMeta!.toDto();
      dto.attrs.replaceRange(index, index + 1, [attr]);
      await _update(dto);
      return;
    } else {
      // k不存在, 新增attr(更新Meta, 并操作对应的Record表)
      final dto = originMeta!.toDto();
      dto.attrs.add(attr);
      await _update(dto);
      return await _createAttr(_serverDb, collectionId, attr);
    }
  }

  // 更新Meta记录
  _update(RecordMetaDto dto) async {
    try {
      await _metaAcc.update(dto);
    } on AppwriteException catch (e) {
      if (e.type == 'collection_not_found') {
        // 集合不存在,则创建集合
        // fixme 新建的集合为"所有人可读写"
        await createMetaCollection(null);
        // 再次尝试
        await _update(dto);
      } else if (e.type == 'document_not_found') {
        // 文档不存在,新建文档
        // await insertEntity(dto);
        throw "Meta记录尚未创建,必须创建后才能更新Meta!";
      }
    } catch (e) {
      print('insert meta error[$e], type ${e.runtimeType}');
      rethrow;
    }
  }

  /// 新增一条Meta记录,同时创建一个新的Record集合(否则会导致Record监听失效)
  ///   如果没有对应的Record集合, 即使realtime配置了相关的监听参数,再Record集合创建之后,数据也不会被接收到
  ///   因此必须要再Meta记录创建的同时,创建对应的Record集合
  Future insertMetaWithCreateRecordCollection(RecordMeta meta) async {
    print("debug #插入异常 理论步骤1, 插入meta记录,到Meta表中, 并创建对应的Record集合");
    await _metaAcc.insert(meta.toDto()).then((value) =>
        // 同时创建一个所有人可读写的Record集合
        RecordDtoRepo.withDI(sl, meta).createRecordCollection(null));
  }

  /// 创建Meta集合(存储某个工作空间内的所有Meta记录)
  /// [teamId] 为空表示"所有人可读写"
  /// 默认权限为 "团队内可读写"
  createMetaCollection(String? teamId) async {
    final permit = teamId == null ? ['role:all'] : ['team:$teamId'];
    // 创建集合
    await _serverDb.createCollection(
      collectionId: collectionId,
      name: 'meta_$collectionId',
      // 集合级权限
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

  /// #332 如果确认, 则本方法可以被简化
  RecordDto removeMethodEntry(RecordDto dto) {
    final methodKeySet = meta.methods.map((e) => e.k);
    return dto..fields.removeWhere((key, value) => methodKeySet.contains(key));
  }

  insert(RecordDto dto) async {
    // #332相关, 数据库不会持久化method的返回值, 只会持久化methods方法体(在Meta中)
    dto = removeMethodEntry(dto);
    try {
      await _recordAcc.insert(dto);
    } on AppwriteException catch (e) {
      if (e.type == 'collection_not_found') {
        // 集合不存在,则创建集合
        // fixme 新建的集合为"所有人可读写"
        await createRecordCollection(null);
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
    // #332相关, 数据库不会持久化method的返回值, 只会持久化methods方法体(在Meta中)
    dto = removeMethodEntry(dto);
    try {
      await _recordAcc.update(dto);
    } on AppwriteException catch (e) {
      if (e.type == 'collection_not_found') {
        // 集合不存在,则创建集合
        // fixme 新建的集合为"所有人可读写"
        await createRecordCollection(null);
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
  Future createRecordCollection(String? teamId) async {
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
    // 创建属性
    await createAttrs(meta.attrs.map((e) => e.toDto()));
  }

  findById(String metaId) => _recordAcc.findById(metaId);

  findAll() => _recordAcc.findAll();

  deleteBy(String metaId) => _recordAcc.deleteBy(metaId);

  Future createAttrs(Iterable<AttributeDto> attrs) async {
    for (final attr in attrs) {
      await _createAttr(_serverDb, collectionId, attr);
    }
  }
}

/// 为Record集合新增属性
Future _createAttr(
  server.Database _db,
  String metaId,
  AttributeDto attr,
) async {
  print('debug 为Record集合[$metaId]创建属性# create attr[$attr]');
  await _db.createStringAttribute(
    collectionId: metaId, // ==Record集合Id
    key: attr.propId, // Appwrite BUG,属性名称不能用纯数字
    size: 511,
    xrequired: false,
  );
}

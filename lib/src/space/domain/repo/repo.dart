// repo 是对与聚合根而言的

import 'package:appwrite/appwrite.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as srv;
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/config/appwrite_config.dart';
import 'package:mind_base/src/core/config/common_config.dart';
import 'package:mind_base/src/core/inter/i_dao.dart';
import 'package:mind_base/src/space/domain/value/value.dart';
import 'package:mind_base/src/space/infra/ap_adapter.dart';
import 'package:mind_base/src/space/infra/dao/dao_aw_impl.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';

import '../../../app/application/model.dart';

// 需要传入指定集合ID, 因此无法注入
class MetaDtoRepo {
  final srv.Databases _serverDb;
  final String collectionId; // 也是所在workspaceId
  final MetaModelEttAccessor _metaAcc;

  MetaDtoRepo(
    this._serverDb,
    this._metaAcc,
    this.collectionId,
  );

  static MetaDtoRepo withDI(GetIt get, String workspaceId) => MetaDtoRepo(
        get<srv.Databases>(),
        MetaModelEttAccessor(get<Databases>(), workspaceId),
        workspaceId,
      );

  /// 插入Meta记录的同时, 创建对应的Record集合;
  /// 解决监听不存在Record集合,在集合被创建后无法收到消息的问题
  Future insertDto(MetaDto dto) async {
    try {
      return await insertMetaDtoWithCreateRecordCollection(dto);
    } on AppwriteException catch (e, s) {
      if (e.type == 'collection_not_found') {
        // 集合不存在,则创建集合
        // fixme 新建的集合为"所有人可读写"
        return createMetaCollection(null)
            // 再次尝试
            .then((_) => insertDto(dto));
      } else if (e.type == 'document_invalid_structure') {
        // 文档结构错误（老版本创建导致），更新文档结构
        // Invalid document structure: Unknown attribute: "views"
        final reg = RegExp('Unknown attribute: "(.+)"');
        final attrName = reg.firstMatch("${e.message}")!.group(1) ?? '';
        await updateMetaDocStructure(attrName);
        // 再次尝试
        return await insertDto(dto);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// 更新
  /// 当前只实现对新增字段的添加功能, 删除考虑后面引入视图(隐藏字段)解决
  updateWithRecordCollection(
    MetaDto originMeta,
    MetaDto metaDto,
  ) async {
    // 原始MetaAttrList快照
    final originAttrDtoSnap = originMeta.attrs;
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
      await updateAttribute(originMeta, attr);
    }
  }

  /// 更新表属性
  /// [originMetaDto]传null表示直接创建新列(请确保该列尚不存在)
  Future updateAttribute(MetaDto dto, AttributeDto attr) async {
    final index = dto.attrs.indexWhere((at) => at.k == attr.k);
    if (index != -1) {
      // k已存在, 更新attr(只涉及Meta)
      dto.attrs.replaceRange(index, index + 1, [attr]);
      await _update(dto);
      return;
    } else {
      // k不存在, 新增attr(更新Meta, 并操作对应的Record表)
      dto.attrs.add(attr);
      await _update(dto);
      return await _createAttr(_serverDb, dto.id, attr);
    }
  }

  // 更新Meta记录
  _update(MetaDto dto) async {
    try {
      return await _metaAcc.update(dto);
    } on AppwriteException catch (e) {
      if (e.type == 'collection_not_found') {
        // 集合不存在,则创建集合
        // fixme 新建的集合为"所有人可读写"
        await createMetaCollection(null);
        // 再次尝试
        return await _update(dto);
      } else if (e.type == 'document_not_found') {
        // 文档不存在,新建文档
        // await insertEntity(dto);
        throw "Meta记录尚未创建,必须创建后才能更新Meta!";
      } else if (e.type == 'document_invalid_structure') {
        // 文档结构错误（老版本创建导致），更新文档结构
        // Invalid document structure: Unknown attribute: "views"
        final reg = RegExp('Unknown attribute: "(.+)"');
        final attrName = reg.firstMatch("${e.message}")!.group(1) ?? '';
        await updateMetaDocStructure(attrName);
        // 再次尝试
        return await _update(dto);
      }
      rethrow;
    } catch (e) {
      print('insert meta error[$e], type ${e.runtimeType}');
      rethrow;
    }
  }

  /// 新增一条Meta记录,同时创建一个新的Record集合(否则会导致Record监听失效)
  ///   如果没有对应的Record集合, 即使realtime配置了相关的监听参数,再Record集合创建之后,数据也不会被接收到
  ///   因此必须要再Meta记录创建的同时,创建对应的Record集合
  Future insertMetaDtoWithCreateRecordCollection(MetaDto meta) async {
    final r = await _metaAcc.insert(meta);
    // 同时创建一个所有人可读写的Record集合
    await RecordDtoRepo.withDtoDI(sl, meta).createRecordCollection(null);
    return r;
  }

  /// 创建Meta集合(存储某个工作空间内的所有Meta记录)
  /// [teamId] 为空表示"所有人可读写"
  /// 默认权限为 "团队内可读写"
  createMetaCollection(String? teamId) async {
    final permit = teamId == null
        ? ApAdapter.anyOneCrudPermit
        : ApAdapter.teamMemberCrudPermit(teamId);
    // 创建集合
    await _serverDb.createCollection(
        // 集合级权限
        documentSecurity: false,
        databaseId: mainDataBaseId,
        collectionId: collectionId,
        name: 'meta_$collectionId',
        permissions: permit);
    for (final attr in metaStructure.keys) {
      await updateMetaDocStructure(attr);
    }
  }

  /// 更新meta文档的属性
  /// 一般用于老版本数据结构升级
  updateMetaDocStructure(String attributeName) async {
    slLogger.info(
        "updateMetaDocStructure# 更新Meta表[$collectionId]属性 $attributeName");
    final structureCallback = metaStructure[attributeName];
    if (structureCallback == null) {
      throw '未知的MetaModel属性名称: $attributeName';
    } else {
      try {
        await structureCallback.call(collectionId, _serverDb);
      } on AppwriteException catch (e) {
        if (e.type == 'attribute_already_exists' && e.code == 409) {
          // 属性已存在,忽略
          return;
        } else {
          rethrow;
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  final metaStructure = {
    'name': (String collectionId, srv.Databases _serverDb) async =>
        await _serverDb.createStringAttribute(
            databaseId: mainDataBaseId,
            collectionId: collectionId,
            key: 'name',
            size: 127,
            xrequired: true),
    'memo': (String collectionId, srv.Databases _serverDb) async =>
        await _serverDb.createStringAttribute(
            databaseId: mainDataBaseId,
            collectionId: collectionId,
            key: 'memo',
            size: 255,
            xrequired: false,
            xdefault: ''),
    'maxKey': (String collectionId, srv.Databases _serverDb) async =>
        await _serverDb.createIntegerAttribute(
            databaseId: mainDataBaseId,
            collectionId: collectionId,
            key: 'maxKey',
            xrequired: true),
    'attrs': (String collectionId, srv.Databases _serverDb) async =>
        await _serverDb.createStringAttribute(
            databaseId: mainDataBaseId,
            collectionId: collectionId,
            key: 'attrs',
            size: 65535,
            xrequired: false,
            xdefault: ''),
    'methods': (String collectionId, srv.Databases _serverDb) async =>
        await _serverDb.createStringAttribute(
            databaseId: mainDataBaseId,
            collectionId: collectionId,
            key: 'methods',
            size: 65535,
            xrequired: false,
            xdefault: ''),
    'views': (String collectionId, srv.Databases _serverDb) async =>
        await _serverDb.createStringAttribute(
            databaseId: mainDataBaseId,
            collectionId: collectionId,
            key: 'views',
            size: 65535,
            xrequired: false,
            xdefault: ''),
  };

  findById(String metaId) => _metaAcc.findById(metaId);

  findAllBy(String metaName) => _metaAcc.findAllBy(metaName);

  deleteBy(String metaId) => _metaAcc.deleteBy(metaId);

  /// 更新TableView视图, [view]的index为-1表示新增
  updateTableView(MetaDto dto, TableView view) async {
    return await _update(dto.updateView(view));
  }

  deleteTableView(MetaDto dto, int vId) async {
    return await _update(
        dto..views.removeWhere((element) => element.vId == vId));
  }

  Stream<MetaDto> findAll() => _metaAcc.findAll();

  Stream<AccessorEvt<MetaDto>> watch() => _metaAcc.watch();
}

class RecordDtoRepo {
  final srv.Databases _serverDb;

  final MetaDto meta;
  final RecordEttAccessor _recordAcc;

  RecordEttAccessor get acc => _recordAcc;

  RecordDtoRepo(
    this._serverDb,
    this._recordAcc,
    this.meta,
  );

  String get collectionId => meta.id; // 也是所在metaId

  static RecordDtoRepo withDI(GetIt get, MetaModel meta) =>
      withDtoDI(get, meta.toDto());

  static RecordDtoRepo withDtoDI(GetIt get, MetaDto meta) => RecordDtoRepo(
        get<srv.Databases>(),
        RecordEttAccessor(get<Databases>(), meta.id),
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
        await insert(dto);
      } else if (e.type == 'document_invalid_structure') {
        // 文档结构错误（老版本创建导致），更新文档结构
        // Invalid document structure: Unknown attribute: "a5"
        final reg = RegExp('Unknown attribute: "(.+)"');
        final attrName = reg.firstMatch("${e.message}")!.group(1) ?? '';
        await updateRecordDocStructure(attrName);
        // 再次尝试
        return await insert(dto);
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

  /// 创建[RecordModel]表
  /// 集合id即对应的[MetaModel]的id
  /// [teamId] 为空表示"所有人可读写"
  /// 默认权限为 "团队内可读写"
  /// [meta] 应当是固定内存地址的对象,这样可以确保meta本身是实时更新的
  Future createRecordCollection(String? teamId) async {
    // 权限
    final permit = teamId == null
        ? ApAdapter.anyOneCrudPermit
        : ApAdapter.teamMemberCrudPermit(teamId);
    // 创建集合
    await _serverDb.createCollection(
      databaseId: mainDataBaseId,
      collectionId: collectionId,
      documentSecurity: false,
      name: 'rcd_$collectionId',
      permissions: permit,
    );
    // 创建属性
    for (final attr in meta.attrs) {
      await _createAttr(_serverDb, collectionId, attr);
    }
  }

  Future<RecordDto?> findById(String metaId) => _recordAcc.findById(metaId);

  Stream<RecordDto> findAll() => _recordAcc.findAll();

  Future deleteBy(String metaId) => _recordAcc.deleteBy(metaId);

  // #506 当前版本存在缺陷, 仅凭attrName无法判断要新增的属性size,等
  updateRecordDocStructure(String attrName) async {
    slLogger
        .info("updateMetaDocStructure# 更新Record表[$collectionId]属性 $attrName");
    try {
      await _createCollectionAttr(
        _serverDb,
        collectionId: collectionId,
        attrKey: attrName,
        size: 511,
      );
    } on AppwriteException catch (e) {
      if (e.type == 'attribute_already_exists' && e.code == 409) {
        // 属性已存在,忽略
        return;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
}

/// 为Record集合新增属性
Future _createAttr(
  srv.Databases _db,
  String metaId,
  AttributeDto attr,
) =>
    _createCollectionAttr(
      _db,
      collectionId: metaId,
      attrKey: attr.propId,
      size: 511,
    );

Future _createCollectionAttr(
  srv.Databases _db, {
  required String collectionId,
  required String attrKey,
  int size = 511,
  bool required = false,
}) async {
  slLogger.info("_createCollectionAttr 集合[$collectionId]创建属性# [$attrKey]");
  return await _db.createStringAttribute(
    databaseId: mainDataBaseId,
    collectionId: collectionId,
    // MetaId即==Record集合的Id
    key: attrKey,
    // Appwrite BUG,属性名称不能用纯数字
    size: size,
    xrequired: required,
  );
}

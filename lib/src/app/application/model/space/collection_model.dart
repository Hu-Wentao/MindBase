part of '../../model.dart';

/// 控制记录的状态
/// 包括表级读写权限, 逻辑删除
/// [data] collectionId, 表的Id
class DocumentInfoModel extends ModelSidecar<String, BaseException?>
    with StateChangeMx<String, BaseException?> {
  final _cliDb = sl<cli.Databases>();

  DocumentInfoModel(String metaId, this.metaCollectionId)
      : super(metaId, ExceptionAdapter.of);
  final String metaCollectionId;

  // 子状态
  Document? collection;

  get documentId => data; // at.id

  /// === 业务逻辑 ===
  actUpdateDocument(CollectionDto? dto) async =>
      await actWrapper(() => reqWrapper(
            accWhen: () => state != ModelState.init,
            () async {
              if (dto == null) return;
              try {
                await _cliDb.updateDocument(
                  databaseId: mainDataBaseId,
                  collectionId: metaCollectionId,
                  documentId: documentId,
                  // 访问级别, 表或者记录
                  permissions: dto.permissions.isEmpty
                      ? collection?.$permissions as List<String>?
                      : dto.permissions,
                );
              } catch (e) {
                lgShot('尝试更新meta记录的读写权限, 可能因为权限级别为集合而出错');
                rethrow;
              }
            },
          ));

  /// === 状态更改 ===

  @override
  Future<bool> onFetch({bool isActive = false}) async {
    collection = await _cliDb.getDocument(
      collectionId: metaCollectionId,
      documentId: documentId,
      databaseId: mainDataBaseId,
    );
    return true;
  }

  @override
  Future<bool> onReset() async {
    collection = null;
    return true;
  }

  @override
  Future<bool> onSubscription() async {
    log("尚未实现 onSubscription");
    return false;
  }

  @override
  Future<bool> onCloseSubs() async {
    log("尚未实现 onCloseSubs");
    return false;
  }
}

/// 控制表的状态
/// 包括表级读写权限, 逻辑删除
/// [data] collectionId, 表的Id
class CollectionInfoModel extends ModelSidecar<String, BaseException?>
    with StateChangeMx<String, BaseException?> {
  final _srvDb = sl<srv.Databases>();
  final CollectionService _srv = sl<CollectionService>();

  CollectionInfoModel(String data, [@Deprecated('弃用') _])
      : super(data, ExceptionAdapter.of);

  // 子状态
  Collection? collection;

  get collectionId => data;

  CollectionDto? get dto => CollectionDto.from(collection);

  /// === 业务逻辑 ===
  Future<BaseException?> actUpdateCollection(
    String? userId,
    String? teamOwnerId,
    CollectionDto? dto,
  ) async =>
      await actWrapper(() => reqWrapper(
            accWhen: () => state != ModelState.init,
            () async {
              if (dto == null) return;
              // 判断是否有权限更新
              final r = await _srv.updateCollection(
                userId,
                teamOwnerId,
                collection!,
                dto,
              );
              // 非响应式, 必须手动更新状态
              collection = r;
              setDone();
            },
          ));

  /// === 状态更改 ===

  @override
  Future<bool> onFetch({bool isActive = false}) async {
    collection = await _srvDb.getCollection(
      databaseId: mainDataBaseId,
      collectionId: data,
    );
    return true;
  }

  @override
  Future<bool> onReset() async {
    collection = null;
    return true;
  }

  @override
  Future<bool> onSubscription() async {
    log("尚未实现 onSubscription");
    return false;
  }

  @override
  Future<bool> onCloseSubs() async {
    log("尚未实现 onCloseSubs");
    return false;
  }
}

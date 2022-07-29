part of 'model.dart';

/// 控制表的状态
/// 包括表级读写权限, 逻辑删除
/// [data] collectionId, 表的Id
class CollectionModel extends ModelSidecar<String, BaseException?>
    with ModelStateChangeMx<String, BaseException?> {
  final _srvDb = sl<srv.Database>();

  CollectionModel(String data, [@Deprecated('弃用') _])
      : super(data, ExceptionAdapter.of);

  // 子状态
  da.Collection? collection;

  get collectionId => data;

  /// === 业务逻辑 ===
  actUpdateCollection(CollectionDto? dto) async =>
      await actWrapper(() => reqWrapper(
            accWhen: () => state != ModelState.init,
            () async {
              if (dto == null) return;
              await _srvDb.updateCollection(
                collectionId: collectionId,
                name: collection!.name,
                permission: collection!.permission,
                // 访问级别, 表或者记录
                read: dto.reads.isEmpty ? collection!.$read : dto.reads,
                write: dto.writes.isEmpty ? collection!.$write : dto.writes,
                enabled: dto.enabled ?? collection!.enabled,
              );
            },
          ));

  /// === 状态更改 ===

  @override
  Future<FutureOr<void>> onFetch({bool isActive = false}) async {
    collection = await _srvDb.getCollection(collectionId: data);
  }

  @override
  FutureOr<void> onReset() {
    collection = null;
  }

  @override
  FutureOr<void> onSubscription() {
    log("尚未实现 onSubscription");
  }

  @override
  FutureOr<void> onCloseSubs() {
    log("尚未实现 onCloseSubs");
  }
}

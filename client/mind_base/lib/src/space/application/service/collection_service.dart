part of 'service.dart';

/// todo 在后端加强数据访问权限控制
/// 管理表与记录的读写权限
@lazySingleton
class CollectionService {
  final _srvDb = sl<srv.Databases>();

  Future<da.Collection> findCollection(String collectionId) =>
      _srvDb.getCollection(
        collectionId: collectionId,
        databaseId: mainDataBaseId,
      );

  Future<da.Collection?> updateCollection(String? userId, String? teamOwnerId,
      da.Collection collection, CollectionDto? dto) async {
    if (dto == null) return null;
    if (userId == null) {
      throw UnLoginException('更新表权限需要登录',
          'updateCollection#userId-$userId, teamOwnerId-$teamOwnerId');
    }
    if (teamOwnerId == null) {
      throw BaseException('被更新表所属团队没有团队创建者(owner)角色,无法更新权限');
    }
    if (userId != teamOwnerId) {
      throw BaseException("您不是团队创建者, 没有权限更新表",
          debugInfo: "userId-$userId, teamOwnerId-$teamOwnerId");
    }

    return updateCollectionNoCheck(collection, dto);
  }

  // todo 普通用户改用_cliDb发送请求，自动过滤非法操作
  Future<da.Collection> updateCollectionNoCheck(
          da.Collection collection, CollectionDto dto) async =>
      await _srvDb.updateCollection(
        // 行级权限控制
        documentSecurity: collection.documentSecurity,
        collectionId: collection.$id,
        name: collection.name,
        permissions: dto.permissions.isEmpty
            ? (collection.$permissions as List<String>?)
            : dto.permissions,
        enabled: dto.enabled ?? collection.enabled,
        databaseId: mainDataBaseId,
      );
}

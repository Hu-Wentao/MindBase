part of 'service.dart';

/// 管理表与记录的读写权限
@lazySingleton
class CollectionService {
  final _srvDb = sl<srv.Databases>();

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
    if (userId != teamOwnerId) throw BaseException("您不是团队创建者, 没有权限更新表", debugInfo: "userId-$userId, teamOwnerId-$teamOwnerId");

    final r = await _srvDb.updateCollection(
      collectionId: collection.$id,
      name: collection.name,
      permission: collection.permission,
      // 访问级别, 表或者记录
      read: dto.reads.isEmpty ? collection.$read : dto.reads,
      write: dto.writes.isEmpty ? collection.$write : dto.writes,
      enabled: dto.enabled ?? collection.enabled,
    );
    return r;
  }
}

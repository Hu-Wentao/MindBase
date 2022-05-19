part of 'aggregate.dart';

class Workspace implements IAgg<String> {
  /// 开头`>>`用于防止用户自己设置同名变量
  /// 对应Value类型为 [QueryMetaFn] 将`MetaId->Meta查询`注入到ctx中, 以便读取meta,同时解决循环依赖问题
  static const ctxQueryMetaSign = ">>_workspace_ctx_query_meta_sign";

  @override
  final String id;

  // Map<String, User> users; // <身份,用户>; 如管理员,编辑人员,查看人员,或者是用户自定义的

  String name;

  // 空间内的表
  final List<RecordMeta> metas;

  Workspace({
    required this.id,
    required this.name,
    required this.metas,
  });

  // QueryMetaFn 的包装
  RecordMeta queryMeta(String metaId) => getMetaBy((metaId))!;

  /// 只能查询已存在与workspace
  RecordMeta? getMetaBy(String metaId) {
    for (final m in metas) {
      if (m.id == metaId) return m;
    }
    return null;
  }
}

/// 管理已打开的工作空间
/// 在这里, 将DTO组装为 Domain对象, 也是业务逻辑的一部分
///
class OpenedWorkspace {
  late final StreamSubscription<AccessorEvt<RecordMetaDto>> _metasSub;

// todo 改为 _workspace;  考虑直接用WorkspaceDto
  final Workspace workspace;
  final List<OpenedMeta> openedMetas = [];

  String get id => workspace.id;

  String get name => workspace.name;

  List<RecordMeta> get metas => workspace.metas;

  QueryMetaFn get queryMeta => workspace.queryMeta;

  RecordMeta? Function(String metaId) get getMetaBy => workspace.getMetaBy;

  Iterable<RecordMeta> allMetas() => metas;

  final Stream<AccessorEvt<RecordDto>> Function(String metaId) getWatchRecords;

  OpenedWorkspace.openBy({
    required this.workspace,
    required Stream<AccessorEvt<RecordMetaDto>> watchMetasEvt,
    required this.getWatchRecords,
  }) {
    _metasSub = watchMetasEvt.listen((event) {
      print("#OpenedWorkspace#realtimeStream: ${event}");
      onWatchMetaEvt(event);
    });
  }

  @protected
  RecordMeta insertMeta(RecordMeta meta) {
    //todo 可能要考虑meta/record在watchAll时,先收到create事件,然后又在getAll中被二次查询到的情况,这会导出出现两个相同Id的Meta/Record
    metas.add(meta);
    _openCacheMeta(meta);
    return meta;
  }

  RecordMeta updateMeta(RecordMeta meta) {
    final i = metas.indexWhere((element) => element.id == meta.id);
    if (i != -1) {
      metas[i].update(meta);
    } else {
      metas.add(meta);
    }
    return meta;
  }

  void removeMeta(String metaId) =>
      metas.removeWhere((meta) => meta.id == metaId);

  List<Record>? closeMeta(String metaId) =>
      openedMetas.firstWhere((element) => element.id == metaId).close();

  List<Record> getRecords(String metaId) =>
      openedMetas.firstWhere((element) => element.id == metaId).records;

  Iterable<List<Record>> allRecords() =>
      openedMetas.map((element) => element.records);

  Record queryRecordBy(String recordId, {String? metaId}) {
    if (metaId != null) {
      return getRecords(metaId).firstWhere((record) => record.id == recordId);
    }
    for (var recordList in allRecords()) {
      final i = recordList.indexWhere((element) => element.id == recordId);
      if (i != -1) {
        return recordList[i];
      }
    }
    throw "Workspace中找不到ID为[$recordId]的Record";
  }

  /// 数据同步 ===================================================================
  void onWatchMetaEvt(AccessorEvt<RecordMetaDto> event) {
    switch (event.type) {
      case AccessorEvtTp.insert:
        _onEvtInsertMeta(event.dto!);
        break;
      case AccessorEvtTp.replace:
      case AccessorEvtTp.update:
        _onEvtUpdateMeta(event.dto!);
        break;
      case AccessorEvtTp.delete:
        _onEvtRemoveMeta(event.ettId);
        break;
    }
  }

  void _onEvtInsertMeta(RecordMetaDto metaDto) {
    final meta = metaDto.toDm(queryMeta);
    insertMeta(meta);
    // 缓存并监听Meta下Record
    _openCacheMeta(meta);
  }

  void _onEvtUpdateMeta(RecordMetaDto metaDto) {
    final meta = metaDto.toDm(queryMeta);
    updateMeta(meta);
  }

  void _onEvtRemoveMeta(String metaId) {
    removeMeta(metaId);
    // 取消缓存和监听Meta下Record
    closeMeta(metaId);
  }

  // 打开并缓存Meta
  _openCacheMeta(RecordMeta meta) {
    openedMetas.add(OpenedMeta.openBy(
      meta: meta,
      watchRecordsEvt: getWatchRecords(meta.id),
    ));
  }

  Workspace close() {
    openedMetas.map((openedMeta) => openedMeta.close());
    _metasSub.cancel();
    return workspace;
  }
}

class OpenedMeta {
  final RecordMeta meta;

  String get id => meta.id;
  late final StreamSubscription<AccessorEvt<RecordDto>> _cachedRecordSubs;

  OpenedMeta(this.meta);

  OpenedMeta.openBy({
    required this.meta,
    required Stream<AccessorEvt<RecordDto>> watchRecordsEvt,
  }) {
    _cachedRecordSubs = watchRecordsEvt.listen((event) {
      _onWatchRecord(event);
    });
  }

  void _onWatchRecord(AccessorEvt<RecordDto> event) {
    print("debug #监听WatchRecord # $event");
    switch (event.type) {
      case AccessorEvtTp.insert:
        _onEvtInsertRecord(event.dto!.toDomain(meta));
        // _onEvtInsertRecordSource(event.dto!);
        break;
      case AccessorEvtTp.replace:
      case AccessorEvtTp.update:
        final index = _onEvtUpdateRecord(event.dto!.toDomain(meta));
        // _onEvtUpdateRecordSource(event.dto!, index);
        break;
      case AccessorEvtTp.delete:
        final index = _onEvtRemoveRecord(event.ettId);
        // _onEvtRemoveRecordSource(event.ettId, metaId, index);
        break;
    }
  }

  final List<Record> records = [];

  Record _onEvtInsertRecord(Record record) {
    records.add(record);
    return record;
  }


// 返回被更新的元素index
  void _onEvtUpdateRecord(Record record) {
    final index = records.indexWhere((element) => element.id == record.id);
    if (index != -1) {
      records[index].update(record);
    } else {
      _onEvtInsertRecord(record);
    }
  }

// 返回被更新的元素index
  void _onEvtRemoveRecord(String ettId) {
    records.removeWhere((element) => element.id == ettId);
  }

  close() {
    _cachedRecordSubs.cancel();
    records.clear();
  }
}

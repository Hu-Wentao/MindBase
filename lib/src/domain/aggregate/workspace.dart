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

  /// 打开工作空间
  /// 1. 同步,监听内部所有Meta
  /// 2. 同步,监听内幕所有Meta下的Record
  OpenedWorkspace open(Stream<RealTimeEvt> realtimeStream) => OpenedWorkspace(
        workspace: this,
        records: {},
        realtimeStream: realtimeStream,
      );
}

/// 管理已打开的工作空间
/// todo 可以考虑将更新Record/Meta的入参改为DTO,同时将相关方法转移到Dto所在文件的Ext中
class OpenedWorkspace {
  final Workspace workspace;

  // 空间内的记录 <Record集合Id, Record>
  final Map<String, List<Record>> records;
  final Stream<RealTimeEvt> realtimeStream;

  List<RecordMeta> get metas => workspace.metas;

  OpenedWorkspace({
    required this.workspace,
    required this.records,
    required this.realtimeStream,
  }) {
    realtimeStream.listen((event) {
      print("#OpenedWorkspace#realtimeStream: $event");
    });
  }

  get queryMeta => workspace.queryMeta;

  Workspace close() => workspace;

  @protected
  RecordMeta insertMeta(RecordMeta meta) {
    metas.add(meta);
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

  Iterable<RecordMeta> allMetas() => metas;

  @protected
  Record insertRecord(Record record) {
    records.putIfAbsent(record.meta.id, () => []);
    records[record.meta.id]!.add(record);
    return record;
  }

  List<Record>? removeRecords(String metaId) => records.remove(metaId);

  List<Record> getRecords(String metaId) => records[metaId] ??= [];

  Iterable<List<Record>> allRecords() => records.values;

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
  _cacheAllMetaByWorkspace() {
    // 先查询有所元素 // 然后开始监听变更
    // _metaRepo
    //   ..findAll().listen(_onEvtInsertMeta)
    //   ..watchAll().listen(_onWatchMetaEvt);
  }

// // 不指定则移除所有的监听
// _disposeSubject([String? metaId]) {
//   if (metaId != null) {
//     removeMeta(metaId);
//     removeRecords(metaId);
//     _cacheSubject.remove(metaId)?.close();
//   } else {
//     clearMeta();
//     clearRecord();
//     for (var element in _cacheSubject.values) {
//       element.close();
//     }
//     _cacheSubject.clear();
//   }
// }

// void _onEvtInsertRecord(Record record) =>getRecords(record.meta.id).add(record);
//
// // 返回被更新的元素index
// int _onEvtUpdateRecord(Record record) =>
//        updateRecord(record);
//
// // 返回被更新的元素index
// int _onEvtRemoveRecord(String ettId) {
//       // 遍历所有的 <RecordId,Record>
//       var index = -1;
//       for (var recordList in allRecords()) {
//         index = recordList.indexWhere((element) => element.id == ettId);
//         if (index != -1) {
//           recordList.removeAt(index);
//           break;
//         }
//       }
//       return index;
//     }
//
// void _onWatchRecord(RepoEvent<Record> event, String metaId) {
//   print("debug #监听WatchRecord meta# $metaId # $event");
//   switch (event.type) {
//     case RepoEventType.insert:
//       _onEvtInsertRecord(event.entity!);
//       _onEvtInsertRecordSource(event.entity!);
//       break;
//     case RepoEventType.replace:
//     case RepoEventType.update:
//       final index = _onEvtUpdateRecord(event.entity!);
//       _onEvtUpdateRecordSource(event.entity!, index);
//       break;
//     case RepoEventType.delete:
//       final index = _onEvtRemoveRecord(event.ettId);
//       _onEvtRemoveRecordSource(event.ettId, metaId, index);
//       break;
//     case RepoEventType.drop:
//       print("###debug drop 尚未确认 '${event.type}'事件的机制, 按照delete处理");
//       final index = _onEvtRemoveRecord(event.ettId);
//       _onEvtRemoveRecordSource(event.ettId, metaId, index);
//       break;
//     case RepoEventType.rename:
//     case RepoEventType.dropDatabase:
//     case RepoEventType.invalidate:
//       print("###debug drop 尚未确认 '${event.type}'事件的机制,事件内容 $event");
//       break;
//   }
// }
// //
// // @override
// // void dispose() {
// //   _disposeSubject();
// //   super.dispose();
// // }
//
// void _onEvtInsertMeta(RecordMeta meta) => setInitialized("插入Meta", () {
//       insertMeta(meta);
//       // 缓存并监听Meta下Record
//       _cacheRecordByMeta(meta);
//     });
//
// void _onEvtUpdateMeta(RecordMeta meta) => setInitialized("更新/替换Meta", () {
//       updateMeta(meta);
//       if (watchedMeta?.id == meta.id) {
//         watchedMeta = meta; // 提示UI可以刷新
//       }
//     });
//
// void _onEvtRemoveMeta(String ettId) => setInitialized("移除Meta", () {
//       removeMeta(ettId);
//       // 取消缓存和监听Meta下Record
//       _disposeSubject(ettId);
//     });
//
// void onWatchMetaEvt(RepoEvent<RecordMeta> event) {
//   switch (event.type) {
//     case RepoEventType.insert:
//       _onEvtInsertMeta(event.entity!);
//       break;
//     case RepoEventType.replace:
//     case RepoEventType.update:
//       _onEvtUpdateMeta(event.entity!);
//       break;
//     case RepoEventType.delete:
//       _onEvtRemoveMeta(event.ettId);
//       break;
//     case RepoEventType.drop:
//       print("###debug drop 尚未确认 '${event.type}'事件的机制, 按照delete处理");
//       _onEvtRemoveMeta(event.ettId);
//       break;
//     case RepoEventType.rename:
//     case RepoEventType.dropDatabase:
//     case RepoEventType.invalidate:
//       print("###debug drop 尚未确认 '${event.type}'事件的机制,事件内容 $event");
//       break;
//   }
// }
//
// _cacheRecordByMeta(RecordMeta meta) {
//   // _recordRepo.findAllByMeta(meta.id).listen(_onEvtInsertRecord);
//   final acc = _recordAccessor(meta.id.$oid)
//     ..findAll()
//         .map((event) => event.toDomain(meta))
//         .listen(_onEvtInsertRecord);
//   // 异步广播流,暂停的监听器将在内部缓存事件,直到监听器取消暂停/被Cancel (需要UI及时dispose子流)
//   // 同步广播流,Provider中始终有一个监听器用于刷新数据；其他监听器只用于刷新UI(可能会有丢失UI数据..)
//   _cacheSubject[meta.id]?.close();
//   _cacheSubject[meta.id] =
//       StreamController<RepoEvent<Record>>.broadcast(sync: false)
//         ..addStream(
//           acc.watchAll().map((dtoEvt) => RepoEvent.of<Record, RecordDto>(
//                 dtoEvt,
//                 (dto) => dto?.toDomainOr(meta),
//               )),
//         )
//         // ..addStream(_recordRepo.watchAllByMeta(meta))
//         ..stream.listen((evt) => onWatchRecord(evt, meta.id));
// }
}

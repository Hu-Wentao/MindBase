import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/entity/entity.dart';
import 'package:mind_base/src/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_source.dart';
import 'package:mind_base/src/interface/i_dao.dart';
import 'package:mind_base/src/interface/i_dto.dart';

/// 管理已打开的工作空间
/// 在这里, 将DTO组装为 Domain对象, 也是业务逻辑的一部分
///
class OpenedWorkspace extends ChangeNotifier {
  late final StreamSubscription<AccessorEvt<RecordMetaDto>> _metasSub;

// todo 改为 _workspace;  考虑直接用WorkspaceDto
  final Workspace workspace;

  // fixme 本类缺少 openMeta的代码,导致选中meta后,openedMetas里面没有被选中的openedMeta
  final List<OpenedMeta> openedMetas = [];

  String get id => workspace.id;

  String get name => workspace.name;

  List<RecordMeta> get metas => workspace.metas;

  QueryMetaFn get queryMeta => workspace.queryMeta;

  RecordMeta? Function(String metaId) get getMetaBy => workspace.getMetaBy;

  Iterable<RecordMeta> allMetas() => metas;

  final Stream<RecordDto> Function(String metaId) getFetchAllRecords;
  final Stream<AccessorEvt<RecordDto>> Function(String metaId)
      getWatchAllRecords;

  OpenedWorkspace.openBy({
    required this.workspace,
    required Stream<RecordMetaDto> Function() fetchAllMeta,
    required Stream<AccessorEvt<RecordMetaDto>> watchAllMeta,
    required this.getFetchAllRecords,
    required this.getWatchAllRecords,
  }) {
    // 获取全部 fixme (执行成功了,但是没有刷新到UI上)
    fetchAllMeta().listen((e) {
      print("debug getAllMetal XXX $e");
      _onEvtInsertMeta(e);
      notifyListeners();
    }, onError: (e, s) {
      if (e.code == 404 && e.type == "collection_not_found") {
        // 不存在则无需抛出异常
        print("debug OpenedMeta.openBy: [$e], 由推测的`Meta集合`尚未创建导致的,无需抛出异常");
      } else {
        // print("debug OpenedMeta.openBy: 抛出未知异常 [$e]");
        throw ExceptionAdapter.of(e, s);
      }
    });
    // 开始监听
    _metasSub = watchAllMeta.listen((event) {
      print("#OpenedWorkspace#realtimeStream: $event");
      onWatchMetaEvt(event);
    });
  }

  StreamSubscription<AccessorEvt<RecordMetaDto>> get subs => _metasSub;

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
    print("debug onWatchMetaEvt: $event");
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
    notifyListeners();
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
      fetchAllRecords: getFetchAllRecords(meta.id),
      watchAllRecords: getWatchAllRecords(meta.id),
    ));
    print("debug _openCacheMeta: ${meta.id}");
  }

  Workspace close() {
    openedMetas.map((openedMeta) => openedMeta.close());
    _metasSub.cancel();
    return workspace;
  }
}

class OpenedMeta extends ChangeNotifier {
  late final StreamSubscription<AccessorEvt<RecordDto>> _cachedRecordSubs;

  // 附加状态
  final List<Record> records = [];
  final RecordMeta meta;

  String get id => meta.id;

  OpenedMeta(this.meta);

  OpenedMeta.openBy({
    required this.meta,
    required Stream<RecordDto> fetchAllRecords,
    required Stream<AccessorEvt<RecordDto>> watchAllRecords,
  }) {
    fetchAllRecords.listen((event) {
      _onEvtInsertRecord(event.toDomain(meta));
      notifyListeners();
    }, onError: (e, s) {
      if (e.code == 404 && e.type == "collection_not_found") {
        // 不存在则无需抛出异常
        print("debug OpenedMeta.openBy: [$e], 由推测的`Record集合`尚未创建导致的,无需抛出异常");
      } else {
        // print("debug OpenedMeta.openBy: 抛出未知异常 [$e]");
        throw ExceptionAdapter.of(e, s);
      }
    });
    _cachedRecordSubs = watchAllRecords.listen((event) {
      _onWatchRecord(event);
    });
  }

  RecordDataGridSourcePluto get dataSource => RecordDataGridSourcePluto(
        meta: meta,
        cachedColumns: meta.toPlutoCols,
        cachedRows: records.map((e) => e.toPlutoRow()).toList(),
      );

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
    notifyListeners();
  }

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

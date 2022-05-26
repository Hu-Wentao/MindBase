import 'dart:async';

import 'package:appwrite/appwrite.dart';
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

// todo 改为 _workspace;
//  不能使用WorkspaceDto,必须持有RecordMeta,用于处理ref关系
  final Workspace workspace;

  // fixme 本类缺少 openMeta的代码,导致选中meta后,openedMetas里面没有被选中的openedMeta
  final List<OpenedMeta> openedMetas = [];

  String get id => workspace.id;

  String get name => workspace.name;

  List<RecordMeta> get metas => workspace.metas;

  QueryMetaFn get queryMeta => workspace.queryMeta;

  RecordMeta? Function(String metaId) get getMetaBy => workspace.getMetaBy;

  Record findRecord(ExprValue value) {
    assert(value.type.isRef, "findRecord: value.type.isRef 必须是Ref类型才能作为查询参数");
    // value.type.meta
    return getRecords(value.type.meta!.id)
        .firstWhere((record) => record.id == value.value);
  }

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
      onMetaAdd(e.toDm(queryMeta));
      notifyListeners();
    }, onError: (e, s) {
      if (e is AppwriteException &&
          e.code == 404 &&
          e.type == "collection_not_found") {
        // 不存在则无需抛出异常
        print("debug OpenedMeta.openBy: [$e], 由推测的`Meta集合`尚未创建导致的,无需抛出异常");
      } else {
        // print("debug OpenedMeta.openBy: 抛出未知异常 [$e]");
        throw ExceptionAdapter.of(e, s);
      }
    });
    // 开始监听
    _metasSub = watchAllMeta.listen((event) {
      print("#OpenedWorkspace[$id]#开始监听Meta变更: $event");
      onWatchMetaEvt(event);
    });
  }

  StreamSubscription<AccessorEvt<RecordMetaDto>> get subs => _metasSub;

  @protected
  RecordMeta onMetaAdd(RecordMeta meta) {
    //todo 可能要考虑meta/record在watchAll时,先收到create事件,然后又在getAll中被二次查询到的情况,这会导出出现两个相同Id的Meta/Record
    metas.add(meta);
    openedMetas.add(OpenedMeta.openBy(
      at: this,
      meta: meta,
      fetchAllRecords: getFetchAllRecords(meta.id),
      watchAllRecords: getWatchAllRecords(meta.id),
    ));
    print("debug _openCacheMeta: ${meta.id}");
    return meta;
  }

  RecordMeta onMetaUpdate(RecordMeta meta) {
    final i = metas.indexWhere((element) => element.id == meta.id);
    if (i != -1) {
      metas[i].update(meta);
    } else {
      metas.add(meta);
    }
    return meta;
  }

  void onMetaDelete(String metaId) {
    // 先关闭,后移除,否则会找不到Meta
    final i = __indexByOpenedMetas(metaId, onFind: (i, m) {
      m.close();
    });
    if (i != -1) openedMetas.removeAt(i);
    __indexByMetas(metaId, onFind: (i, m) => metas.remove(m));
  }

  @Deprecated("应当使用 selectedMeta.getRecords()")
  List<Record> getRecords(String metaId) =>
      openedMetas[__indexByOpenedMetas(metaId)].records;

  Iterable<List<Record>> allRecords() =>
      openedMetas.map((element) => element.records);

  @Deprecated("改用 findRecord")
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

  int __indexByOpenedMetas(
    String metaId, {
    Function(int index, OpenedMeta meta)? onFind,
  }) {
    final i = openedMetas.indexWhere((element) => element.id == metaId);
    if (i != -1) {
      onFind?.call(i, openedMetas[i]);
    }
    return i;
  }

  int __indexByMetas(
    String metaId, {
    Function(int index, RecordMeta meta)? onFind,
  }) {
    final i = metas.indexWhere((element) => element.id == metaId);
    if (i != -1) {
      onFind?.call(i, metas[i]);
    }
    return i;
  }

  /// 数据同步 ===================================================================
  void onWatchMetaEvt(AccessorEvt<RecordMetaDto> event) {
    print("debug 工作空间#onWatchMetaEvt: $event");
    switch (event.type) {
      case AccessorEvtTp.insert:
        onMetaAdd(event.dto!.toDm(queryMeta));
        break;
      case AccessorEvtTp.replace:
      case AccessorEvtTp.update:
        onMetaUpdate(event.dto!.toDm(queryMeta));
        break;
      case AccessorEvtTp.delete:
        onMetaDelete(event.ettId);
        break;
    }
    notifyListeners();
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
  final OpenedWorkspace at;
  final List<Record> records = [];
  final RecordMeta meta;

  String get id => meta.id;

  String get name => meta.name;

  OpenedMeta(this.meta, this.at);

  OpenedMeta.openBy({
    required this.at,
    required this.meta,
    required Stream<RecordDto> fetchAllRecords,
    required Stream<AccessorEvt<RecordDto>> watchAllRecords,
  }) {
    fetchAllRecords.listen((event) {
      _onEvtInsertRecord(event.toDomain(meta));
      notifyListeners();
    }, onError: (e, s) {
      if (e is AppwriteException &&
          e.code == 404 &&
          e.type == "collection_not_found") {
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

  /// 内部缓存表格数据
  /// fixme 如果meta更新,
  RecordDataGridSourcePluto? _cachedDataSource;

  RecordDataGridSourcePluto get dataSource =>
      _cachedDataSource ??= RecordDataGridSourcePluto(
        meta: meta,
        findRecord: at.findRecord,
        cachedColumns: meta.toPlutoCols,
        cachedRows: records.map((e) => e.toPlutoRow(at.findRecord)).toList(),
      );

  void _onWatchRecord(AccessorEvt<RecordDto> event) {
    print("debug #监听WatchRecord # $event");
    switch (event.type) {
      case AccessorEvtTp.insert:
        _onEvtInsertRecord(event.dto!.toDomain(meta));
        break;
      case AccessorEvtTp.replace:
      case AccessorEvtTp.update:
        _onEvtUpdateRecord(event.dto!.toDomain(meta));
        break;
      case AccessorEvtTp.delete:
        _onEvtRemoveRecord(event.ettId);
        break;
    }
    notifyListeners();
  }

  Record _onEvtInsertRecord(Record record) {
    records.add(record);
    _cachedDataSource?.onInsertEvt(record);
    return record;
  }

  // 返回被更新的元素index
  int _onEvtUpdateRecord(Record record) {
    final index = records.indexWhere((element) => element.id == record.id);
    if (index == -1) {
      _onEvtInsertRecord(record);
    } else {
      records[index].update(record);
      _cachedDataSource?.onUpdateEvt(record, index);
    }
    return index;
  }

  // 返回被更新的元素index
  void _onEvtRemoveRecord(String ettId) {
    records.removeWhere((element) => element.id == ettId);
    // RecordDataGridSourcePluto.onRemoveEvt 不需要传入index,这里使用0
    _cachedDataSource?.onRemoveEvt(ettId, 0);
  }

  close() {
    _cachedRecordSubs.cancel();
    records.clear();
  }
}

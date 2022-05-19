import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/service/realtime_service.dart';
import 'package:mind_base/src/application/service/workspace_service.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/infra/dto/dto_aw_impl.dart';
import 'package:mind_base/src/interface/i_dto.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

abstract class Event {}

// 首次打开
class WorkspaceOpenedEvt implements Event {
  final Workspace workspace;

  WorkspaceOpenedEvt(this.workspace);

  @override
  String toString() =>
      'WorkspaceOpenedEvt{id: [${workspace.id}], name: [${workspace.name}]}';
}

class WorkspaceCloseEvt implements Event {
  final Workspace workspace;

  WorkspaceCloseEvt(this.workspace);

  @override
  String toString() =>
      'WorkspaceCloseEvt{id: [${workspace.id}], name: [${workspace.name}]}';
}

enum WatchEventType {
  insert, // 元素插入
  delete, // 某个元素被移除 - 只返回id
  replace, // 某个元素被替换 - 返回新的完整对象
  update, // 某个元素被更新
  // drop, // 所监听的集合被删除
}

class DatabaseEvent implements Event {
  final WatchEventType type;
  final String ettId;
  final String collectionId;

  final Map<String, dynamic> data;

  const DatabaseEvent(
    this.type,
    this.ettId,
    this.collectionId,
    this.data,
  );

  DatabaseEvent.insert(this.ettId, this.collectionId, this.data)
      : type = WatchEventType.insert;

  DatabaseEvent.delete(this.ettId, this.collectionId, this.data)
      : type = WatchEventType.delete;

  DatabaseEvent.replace(this.ettId, this.collectionId, this.data)
      : type = WatchEventType.replace;

  DatabaseEvent.update(this.ettId, this.collectionId, this.data)
      : type = WatchEventType.update;
}

// 临时包装一下
class RealTimeEvtFactory extends Event {
  static final eventsMap = {
    "database": {
      "create": null,
      "delete": null,
      "update": null,
      "documents": {"create": null, "delete": null, "update": onDocumentUpdate},
      "attributes": {"create": null, "delete": null},
      "indexes": {"create": null, "delete": null},
    },
  };

  // (event: database.documents.update,
  // payload:{
  //  $id: 628504d3560d1ec67330,
  //  $collection: 6283e2b508850ed24d82968b
  //  name: XXX, memo: sdf, maxKey: 4, attrs: null, methods: null, $read: [], $write: [],
  //},
  //channels: [documents, collections.6283e2b508850ed24d82968b.documents, collections.6283e2b508850ed24d82968b.documents.628504d3560d1ec67330],
  //timestamp: 1652892787)
  static Event onDocumentUpdate(RealtimeMessage msg) {
    // msg.event;
    return DatabaseEvent(WatchEventType.update, msg.payload['\$id'],
        msg.payload['\$collection'], msg.payload);
    // final type = data['type'];
    // final id = data['document']['id'];
    // final data = data['document']['data'];
    // final event = eventsMap['database']['documents']['update'](data);
    // event.data.id = id;
    // return event;
    return RealTimeEvt(msg);
  }

  static Event of(RealtimeMessage msg) {
    print("RealTimeEvtFactory of $msg");
    final events = msg.event.split('.');
    dynamic targetCall;
    for (var i = 0; i < events.length; i++) {
      targetCall = eventsMap[events[i]];
    }
    return (targetCall == null) ? RealTimeEvt(msg) : targetCall(msg);
  }
}

// 临时包装一下
class RealTimeEvt extends Event {
  final RealtimeMessage msg;

  RealTimeEvt(this.msg);
}

/// 整个App的事件提供者, 生命周期与App一致
/// todo 重命名为RealtimeProvider,
/// todo 由于Realtime生命周期是大于User的,考虑改为全局`有状态Service`(主要状态是Channel)
class EventProvider extends ProviderSidecar {
  late EventBus eventBus;
  late RealTimeService _realtimeService;
  final Set<SubChannel> _subChannels = {};
  final Set<SubChannel> _readyRemoveChannels = {};
  RealtimeSubscription? _cachedRealTimeSub;

  @override
  onInitializing() {
    eventBus = sl<EventBus>();
    _realtimeService = sl<RealTimeService>();

    _listen(eventBus);
    setInitialized("EventProvider已加载");
  }

  void _listen(EventBus bus) {
    bus
      ..on<WorkspaceOpenedEvt>().listen(onOpenWorkspaceEvt)
      ..on<WorkspaceCloseEvt>().listen(onCloseWorkspaceEvt)
      // 全局日志
      ..on().listen((event) {
        // fixme 可能存在只有第二次发送数据才有接收的问题, 需要检测
        print(
            "debug 全局事件日志:EventProvider._listen#log [${event.runtimeType}], $event");
      });
  }

  Stream<Event> get eventStream => eventBus.on<Event>();

  _getWsSubTag(Workspace workspace) => 'tag_ws_${workspace.id}';

  /// 打开某个工作空间
  onOpenWorkspaceEvt(WorkspaceOpenedEvt evt) {
    final workspace = evt.workspace;
    // <订阅更新> 添加内部所有Meta,Record事件订阅
    final tag = _getWsSubTag(workspace);
    actAddChannel(SubChannel.watchMeta(workspace.id, tag: tag));
    for (var meta in workspace.metas) {
      actAddChannel(SubChannel.watchRecord(meta.id, tag: tag));
    }
    // <获取Meta所在集合记录和Record所在集合记录>
    _fetchMetaAndRecord(workspace);
  }

  // (根据Workspace, 推测对应的Meta集合的Id(对应集合名称为meta_$workspaceId), 并进行查询)
  void _fetchMetaAndRecord(Workspace workspace) =>
      sl<WorkspaceService>().queryMetasBy(workspace.id).listen(
        (metaDto) {
          // <初始化Record记录>
          _fetchRecord(metaDto, workspace);
          // 发送查询到的Meta
          eventBus.fire(DatabaseEvent.insert(metaDto.id, workspace.id,
              RecordMetaDtoAppwriteX(metaDto).toJson()));
        },
        onError: _ignoreCollectionNotFoundE,
      );

  // (根据Meta,推测对应的Record集合Id(对应集合名称为rcd_$metaId), 并进行查询)
  void _fetchRecord(RecordMetaDto metaDto, Workspace workspace) =>
      sl<WorkspaceService>().queryRecordsBy(workspace, metaDto.id).listen(
            // 发送查询到的Record
            (event) => eventBus.fire(DatabaseEvent.insert(
                event.id, workspace.id, RecordDtoAppwriteX(event).toJson())),
            onError: _ignoreCollectionNotFoundE,
          );

  static void _ignoreCollectionNotFoundE(dynamic e, [dynamic s]) {
    if (e is AppwriteException &&
        e.code == 404 &&
        e.type == "collection_not_found") {
      // 是则忽略
      return;
    } else {
      // 如果不是这种情况,则确实需要抛出异常
      throw ExceptionAdapter.of(e, s);
    }
  }

  /// 关闭某个工作空间
  onCloseWorkspaceEvt(WorkspaceCloseEvt evt) {
    return actRemoveChannelBy(_getWsSubTag(evt.workspace));
  }

  // 添加订阅并择时刷新
  actAddChannel(SubChannel channel) {
    _subChannels.add(channel);
    // 防抖
    EasyDebounce.debounce('刷新订阅', const Duration(milliseconds: 500), () {
      _actUpdateChannels();
    });
  }

  // 移除订阅
  actRemoveChannel(SubChannel channel, {bool immediate = false}) {
    _readyRemoveChannels.add(channel);
    if (immediate) {
      _actUpdateChannels();
    }
  }

  actRemoveChannelBy(String tag, {bool immediate = false}) {
    _readyRemoveChannels.addAll(_subChannels.where((e) => e.tag == tag));
    if (immediate) {
      _actUpdateChannels();
    }
  }

  // 刷新订阅流
  _actUpdateChannels() {
    print("debug 刷新订阅Channel# 待移除# $_readyRemoveChannels, 新增# $_subChannels");
    // 处理待订阅的频道
    _subChannels.removeWhere(
      (element) => _readyRemoveChannels.contains(element),
    );
    _readyRemoveChannels.clear();

    // 关闭原有订阅, 重新订阅新的频道
    _cachedRealTimeSub?.close;
    _cachedRealTimeSub = _realtimeService.sub(_subChannels.toList());

    // 订阅流绑定到Controller
    _cachedRealTimeSub!.stream.map(RealTimeEvtFactory.of).listen(eventBus.fire);
  }
}

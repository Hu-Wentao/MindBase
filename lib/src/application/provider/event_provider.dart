import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/service/realtime_service.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

abstract class Event {}

class WorkspaceOpenedEvt implements Event {
  final Workspace workspace;

  WorkspaceOpenedEvt(this.workspace);
}
class WorkspaceCloseEvt implements Event {
  final Workspace workspace;

  WorkspaceCloseEvt(this.workspace);
}

// 临时包装一下
class RealTimeEvt extends Event {
  final RealtimeMessage msg;

  RealTimeEvt(this.msg);
}

/// 整个App的事件提供者, 生命周期与App一致
/// todo 重命名为RealtimeProvider
class EventProvider extends ProviderSidecar {
  late EventBus eventBus;
  late RealTimeService _realtimeService;
  final List<SubChannel> _subChannels = [];
  final List<SubChannel> _readyRemoveChannels = [];
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
      ..on<WorkspaceOpenedEvt>().listen((event) {
        print("debug EventProvider._listen# log [${event.runtimeType}], $event");
        actOnOpenWorkspace(event.workspace);
      })
      ..on<WorkspaceCloseEvt>().listen((event) {
        print("debug EventProvider._listen# log [${event.runtimeType}], $event");
        actOnCloseWorkspace(event.workspace);
      })
      // 全局日志
      ..on().listen((event) {
        print("debug EventProvider._listen#Global#log [${event.runtimeType}], $event");
      });
  }

  Stream<Event> get eventStream => eventBus.on<Event>();

  /// 打开某个工作空间
  actOnOpenWorkspace(Workspace workspace) {
    final tag = 'tag_ws_${workspace.id}';
    actAddChannel(SubChannel.watchMeta(workspace.id, tag: tag));
    for (var meta in workspace.metas) {
      actAddChannel(SubChannel.watchRecord(meta.id, tag: tag));
    }
  }

  actOnCloseWorkspace(Workspace workspace) {
    final tag = workspace.id;
    actRemoveChannelBy(tag);
  }

  // 添加订阅
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
    _cachedRealTimeSub = _realtimeService.sub(_subChannels);

    // 订阅流绑定到Controller

    _cachedRealTimeSub!.stream.map(RealTimeEvt.new).doOnData((data) {
      print("debug#收到消息: ${data.msg}");
    }).listen(eventBus.fire);
  }
}

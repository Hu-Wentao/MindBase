import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/service/reailtime_service.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

abstract class Event {}

// 临时包装一下
class RealTimeEvt extends Event {
  final RealtimeMessage msg;

  RealTimeEvt(this.msg);
}

/// 整个App的事件提供者, 生命周期与App一致
class EventProvider extends ProviderSidecar {
  late RealTimeService _realtimeService;
  final StreamController<Event> _streamController =
      StreamController.broadcast();
  final List<SubChannel> _subChannels = [];
  final List<SubChannel> _readyRemoveChannels = [];
  RealtimeSubscription? _cachedRealTimeSub;

  @override
  onInitializing() {
    _realtimeService = sl<RealTimeService>();
    setInitialized("EventProvider已加载");
  }

  Stream<Event> get eventStream => _streamController.stream;

  // 添加订阅
  actAddChannel(SubChannel channel) {
    _subChannels.add(channel);
    _actUpdateChannels();
  }

  // 移除订阅
  actRemoveChannel(SubChannel channel, {bool immediate = false}) {
    _readyRemoveChannels.add(channel);
    if (immediate) {
      _actUpdateChannels();
    }
  }

  // 刷新订阅流
  _actUpdateChannels() {
    // 处理待订阅的频道
    _subChannels.removeWhere(
      (element) => _readyRemoveChannels.contains(element),
    );
    _readyRemoveChannels.clear();

    // 关闭原有订阅, 重新订阅新的频道
    _cachedRealTimeSub?.close;
    _cachedRealTimeSub = _realtimeService.sub(_subChannels);

    // 订阅流绑定到Controller
    _streamController.addStream(
      _cachedRealTimeSub!.stream.map(RealTimeEvt.new),
    );
  }

  actOnUserLogged() {
    // todo
  }
}

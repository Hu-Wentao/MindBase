import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/service/realtime_service.dart';
import 'package:mind_base/src/application/service/workspace_service.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/domain/value/event.dart';
import 'package:mind_base/src/infra/dto/dto_aw_impl.dart';
import 'package:mind_base/src/interface/i_dao.dart';
import 'package:mind_base/src/interface/i_dto.dart';
import 'package:provider_sidecar/provider_sidecar.dart';


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

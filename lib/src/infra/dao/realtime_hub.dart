import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:get_arch_core/get_arch_core.dart';

/// 统一管理Appwrite-Realtime的Channel
/// 由于Realtime是基于单个websocket的, 因此需要统一管理订阅channel
@lazySingleton
class RealtimeChannelHub {
  final Realtime _realtime;
  final Set<SubChannel> _readyAddChannels = {};
  final Set<SubChannel> _readyRemoveChannels = {};
  Set<SubChannel> _subChannels = {}; // 存储当前的订阅状态
  RealtimeSubscription? _cachedRealTimeSub;

  final StreamController<RealtimeMessage> _messageStreamController =
      StreamController.broadcast();

  RealtimeChannelHub(this._realtime);

  Stream<RealtimeMessage> get stream =>
      _messageStreamController.stream.doOnCancel(() {
        // 如果Dao中的doOnCancel有效,则这里的doOnCancel可以移除
        print("debug #RealtimeChannelHub stream cancel! ${DateTime.now()}");
      });

  // 添加订阅并择时刷新
  actAddChannel(SubChannel channel) {
    _readyAddChannels.add(channel);
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
    _readyAddChannels.addAll(_subChannels);
    _readyAddChannels.removeWhere((ch) => _readyRemoveChannels.contains(ch));
    _readyRemoveChannels.clear();
    // 如果新的订阅和旧的不同,则需要刷新
    if (_readyAddChannels.union(_subChannels).length == _subChannels.length) {
      _cachedRealTimeSub?.close;
      _cachedRealTimeSub = sub(_readyAddChannels.toList());
    }
    // 更新已订阅频道数据
    _subChannels = _readyAddChannels;
  }

  sub(List<SubChannel> channels) =>
      _realtime.subscribe(channels.map((e) => e.channel).toList());
}

// 临时包装一下
abstract class RealTimeEvtFactory {
  // static final eventsMap = {
  //   "database": {
  //     "create": null,
  //     "delete": null,
  //     "update": null,
  //     "documents": {"create": null, "delete": null, "update": onDocumentUpdate},
  //     "attributes": {"create": null, "delete": null},
  //     "indexes": {"create": null, "delete": null},
  //   },
  // };

// (event: database.documents.update,
// payload:{
//  $id: 628504d3560d1ec67330,
//  $collection: 6283e2b508850ed24d82968b
//  name: XXX, memo: sdf, maxKey: 4, attrs: null, methods: null, $read: [], $write: [],
//},
//channels: [documents, collections.6283e2b508850ed24d82968b.documents, collections.6283e2b508850ed24d82968b.documents.628504d3560d1ec67330],
//timestamp: 1652892787)
// static Event onDocumentUpdate(RealtimeMessage msg) {
//   // msg.event;
//   return DatabaseEvent(DatabaseEventTp.update, msg.payload['\$id'],
//       msg.payload['\$collection'], msg.payload);
//   // final type = data['type'];
//   // final id = data['document']['id'];
//   // final data = data['document']['data'];
//   // final event = eventsMap['database']['documents']['update'](data);
//   // event.data.id = id;
//   // return event;
//   return RealTimeEvt(msg);
// }
//
// static Event of(RealtimeMessage msg) {
//   print("RealTimeEvtFactory of $msg");
//   final events = msg.event.split('.');
//   dynamic targetCall;
//   for (var i = 0; i < events.length; i++) {
//     targetCall = eventsMap[events[i]];
//   }
//   return (targetCall == null) ? RealTimeEvt(msg) : targetCall(msg);
// }
}

class SubChannel {
  // https://appwrite.io/docs/realtime#channels
  static const _collectionsL1 = "collections";
  static const _accountL1 = "account";
  static const _filesL1 = "files";
  static const _bucketsL1 = "buckets";
  static const _teamsL1 = "teams";
  static const _membershipsL1 = "memberships";
  static const _executionsL1 = "executions";
  static const _functionsL1 = "functions";
  static const _documentsL2 = "documents";
  static const _filesL2 = "files";

  final String tag; // 自定义标签
  final String channel; // 用于订阅的channel字符串

  const SubChannel(this.channel, this.tag);

  // 监听某个文档(记录)的删改事件
  const SubChannel.document(String collectionId, String documentId,
      {String tag = ''})
      : this("$_collectionsL1.$collectionId.$_documentsL2.$documentId", tag);

  // 监听某个集合(表)中所有记录的 增删改事件
  const SubChannel.collection(String collectionId, {String tag = ''})
      : this("$_collectionsL1.$collectionId.$_documentsL2", tag);

  /// 监听一个工作空间内所有Meta的`增删改`事件
  const SubChannel.watchMeta(String workspaceId, {String tag = ''})
      : this.collection(workspaceId, tag: tag);

  /// 监听一个Meta下所有Record的`增删改`事件
  const SubChannel.watchRecord(String metaId, {String tag = ''})
      : this.collection(metaId, tag: tag);

  //
  const SubChannel.team(String teamId, {String tag = ''})
      : this("$_teamsL1.$teamId", tag);

  //
  // SubChannel.member(String teamId) : this("$_membershipsL1.$teamId");
  /// 监听指定团队的 `删改` 事件
  const SubChannel.watchTeam(String teamId, {String tag = ''})
      : this.team(teamId, tag: tag);

  @override
  String toString() => 'SubChannel{tag: $tag, channel: $channel}';

  /// 注意, 只有 [channel] 参与比较
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubChannel &&
          runtimeType == other.runtimeType &&
          channel == other.channel;

  @override
  int get hashCode => channel.hashCode;
}

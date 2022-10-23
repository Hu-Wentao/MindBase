import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:slowly/slowly.dart';

/// 统一管理Appwrite-Realtime的Channel
/// 由于Realtime是基于单个websocket的, 因此需要统一管理订阅channel
@lazySingleton
class RealtimeChannelHub {
  final Realtime _realtime;
  final Set<SubChannel> _readyAddChannels = {};
  final Set<SubChannel> _readyRemoveChannels = {};

  // 存储当前的已订阅的频道
  final Set<SubChannel> _subChannels = {};
  RealtimeSubscription? _cachedRealTimeSub;
  StreamSubscription<RealtimeMessage>? _cachedRealTimeSubListen;

  final StreamController<RealtimeMessage> _messageStreamController =
      StreamController.broadcast()

      // ..stream.listen((event) {
      //   print("debug RealtimeChannelHub [${event.toMap()}]");
      // })
      ;

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
    final accept = sl<Slowly>().ms('刷新订阅', tp: SlowlyTp.debounce, ms: 500);
    if (!accept) return;
    _actUpdateChannels();
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
    print(
        "debug 刷新订阅Channel# 待移除# $_readyRemoveChannels, 新增# $_readyAddChannels");
    // 处理待订阅的频道
    _readyAddChannels.addAll(_subChannels);
    _readyAddChannels.removeWhere((ch) => _readyRemoveChannels.contains(ch));
    _readyRemoveChannels.clear();
    // 如果新的订阅和旧的不同,则需要刷新
    if (_readyAddChannels.union(_subChannels).length != _subChannels.length) {
      _cachedRealTimeSubListen?.cancel();
      _cachedRealTimeSub?.close;
      _cachedRealTimeSub = sub(_readyAddChannels);
      _cachedRealTimeSubListen =
          _cachedRealTimeSub!.stream.listen(_messageStreamController.add);
    }
    // 更新已订阅频道数据
    _subChannels.clear();
    _subChannels.addAll(_readyAddChannels);
    // 刷新状态后就清空ready
    _readyAddChannels.clear();
  }

  sub(Iterable<SubChannel> channels) =>
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
  static const _databasesL0 = 'databases';
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

  @Deprecated('应当从AppClientConfig中读取')
  static const mainDataBaseId = 'default';

  final String tag; // 自定义标签
  final String channel; // 用于订阅的channel字符串

  const SubChannel(this.channel, this.tag);

  // 监听某个文档(记录)的删改事件
  const SubChannel.document(
    String collectionId,
    String documentId, {
    String tag = '',
    String databaseId = mainDataBaseId, // 默认的主数据库Id
  }) : this("$_databasesL0.$databaseId.$_collectionsL1.$collectionId.$_documentsL2.$documentId",
            tag);

  // 监听某个集合(表)中所有记录的 增删改事件
  const SubChannel.collection(
    String collectionId, {
    String tag = '',
    String databaseId = mainDataBaseId, // 默认的主数据库Id
  }) : this("$_databasesL0.$databaseId.$_collectionsL1.$collectionId.$_documentsL2",
            tag);

  /// 监听一个工作空间内所有Meta的`增删改`事件
  const SubChannel.watchMeta(
    String workspaceId, {
    String tag = '',
    String databaseId = mainDataBaseId, // 默认的主数据库Id
  }) : this.collection(
          workspaceId,
          databaseId: databaseId,
          tag: tag,
        );

  /// 监听一个Meta下所有Record的`增删改`事件
  const SubChannel.watchRecord(
    String metaId, {
    String tag = '',
    String databaseId = mainDataBaseId, // 默认的主数据库Id
  }) : this.collection(
          metaId,
          databaseId: databaseId,
          tag: tag,
        );

  /// 监听所有团队的 `增删改` 事件
  const SubChannel.watchTeams({String tag = ''}) : this(_teamsL1, tag);

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

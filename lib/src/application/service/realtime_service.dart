import 'package:appwrite/appwrite.dart';
import 'package:get_arch_core/get_arch_core.dart';

/// 订阅服务, 用户在重新登录后,已有的订阅将会失效,需要重新创建订阅
/// 注意,根据https://appwrite.io/docs/realtime, 每创建一个新的Sub,Client就会取消掉之前的Sub
/// 因此, RealTime创建的Sub应该存储在顶层Provider中, 中间再通过StreamController转发
@lazySingleton
class RealTimeService {
  final Realtime _realtime;

  RealTimeService(this._realtime);

  sub(List<SubChannel> channels) =>
      _realtime.subscribe(channels.map((e) => e.channel).toList());

// /// 监听指定集合的文档
// /// [collectionIdList] 要鉴定的Doc所在集合的id列表
// DocEventSubscription subscribeDoc(List<String> collectionIdList) =>
//     DocEventSubscription.of(
//       _realtime.subscribe(collectionIdList
//           .map((id) => "$collectionChannel.$id.$documentChannel")
//           .toList()),
//     );
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

  // 监听某个集合(表)的增删改事件
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
}

// class DocEventSubscription {
//   final Stream<DocumentEvent> stream;
//   final Future<void> Function() close;
//
//   DocEventSubscription(this.stream, this.close);
//
//   DocEventSubscription.of(RealtimeSubscription sub)
//       : stream = sub.stream.map((msg) {
//           print("debug# event 更新 $msg");
//           return DocumentEvent.of(msg);
//         }),
//         close = sub.close;
// }

// enum EventType {
//   create,
//   update,
//   delete,
// }
//
// class DocumentEvent {
//   final EventType type;
//   final String collection; // doc所在集合的Id
//   final String id; //         doc的Id
//   final List<String> read;
//   final List<String> write;
//
//   const DocumentEvent({
//     required this.id,
//     required this.collection,
//     required this.read,
//     required this.write,
//     required this.type,
//   });
//
//   DocumentEvent.of(RealtimeMessage msg)
//       : this(
//           type: EventType.values.byName(msg.event.split('.').last),
//           collection: msg.payload['collection'],
//           id: msg.payload['id'],
//           read: msg.payload['read'],
//           write: msg.payload['write'],
//         );
// }

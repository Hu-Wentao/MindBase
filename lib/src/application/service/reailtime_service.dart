import 'package:appwrite/appwrite.dart';
import 'package:get_arch_core/get_arch_core.dart';

/// 订阅服务, 用户在重新登录后,已有的订阅将会失效,需要重新创建订阅
@lazySingleton
class RealTimeService {
  static const collectionChannel = "collections";
  static const documentChannel = "documents";
  final Realtime _realtime;

  RealTimeService(this._realtime);

  /// 监听指定集合的文档
  /// [collectionIdList] 要鉴定的Doc所在集合的id列表
  RealtimeSubscription subscribeDoc(List<String> collectionIdList) =>
      _realtime.subscribe(
        collectionIdList
            .map((id) => "$collectionChannel.$id.$documentChannel")
            .toList(),
      );
}

extension RealTimeSubDocEventX on RealtimeSubscription {
  Stream<DocumentEvent> get docEventStream => stream.map((msg) {
        print("debug# event 更新 $msg");
        return DocumentEvent.of(msg);
      });
}

enum EventType {
  create,
  update,
  delete,
}

class DocumentEvent {
  final EventType type;
  final String collection; // doc所在集合的Id
  final String id; //         doc的Id
  final List<String> read;
  final List<String> write;

  const DocumentEvent({
    required this.id,
    required this.collection,
    required this.read,
    required this.write,
    required this.type,
  });

  DocumentEvent.of(RealtimeMessage msg)
      : this(
          type: EventType.values.byName(msg.event.split('.').last),
          collection: msg.payload['collection'],
          id: msg.payload['id'],
          read: msg.payload['read'],
          write: msg.payload['write'],
        );
}

import 'package:appwrite/appwrite.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/interface/i_dao.dart';

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

// 临时包装一下
abstract class RealTimeEvtFactory {
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
    return DatabaseEvent(DatabaseEventTp.update, msg.payload['\$id'],
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
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';

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

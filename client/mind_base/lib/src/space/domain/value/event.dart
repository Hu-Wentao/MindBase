
import 'package:mind_base/src/app/application/model.dart';

abstract class Event {}

// 首次打开
class SpaceModelOpenedEvt implements Event {
  final SpaceModel workspace;

  SpaceModelOpenedEvt(this.workspace);

  @override
  String toString() =>
      'SpaceModelOpenedEvt{id: [${workspace.id}], name: [${workspace.name}]}';
}

class SpaceModelCloseEvt implements Event {
  final SpaceModel workspace;

  SpaceModelCloseEvt(this.workspace);

  @override
  String toString() =>
      'SpaceModelCloseEvt{id: [${workspace.id}], name: [${workspace.name}]}';
}

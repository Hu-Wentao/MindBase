part of '../model.dart';

@freezed
class SpaceAct with _$SpaceAct {
  /// 初始化：更新collection/metas,并watch metas变更
  const factory SpaceAct.initModel() = SpaceActInitModel;
}

@Freezed(makeCollectionsUnmodifiable: false)
class SpaceState with _$SpaceState {
  const factory SpaceState.init() = SpaceStateInit;
}

class SpaceModel extends BaseActEntranceModel<SpaceAct, SpaceState> {
  SpaceModel({super.state = const SpaceState.init()});

  SpaceDto get data => throw UnimplementedError();
  @override
  onActEntrance(SpaceAct act) {
    // TODO: implement onActEntrance
    throw UnimplementedError();
  }

  updateData(nData) {}
}

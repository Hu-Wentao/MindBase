part of '../model.dart';

@freezed
class UserAct with _$UserAct {
  const factory UserAct.initModel() = UserActInitModel;
}

@Freezed(makeCollectionsUnmodifiable: false)
class UserState with _$UserState {
  const factory UserState.init() = UserStateInit;
}

class UserModel extends BaseActEntranceModel<UserAct, UserState> {
  final Session session;
  final User data;

  UserModel(
    this.data,
    this.session, {
    super.state = const UserState.init(),
  });

  @override
  onActEntrance(UserAct act) async => await act.when(initModel: initModel);

  initModel() {}
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:appwrite/appwrite.dart' as _i3;
import 'package:dart_appwrite/dart_appwrite.dart' as _i4;
import 'package:event_bus/event_bus.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logging/logging.dart' as _i7;

import '../application.dart' as _i8;
import '../application/service/account_service.dart' as _i5;
import '../application/service/realtime_service.dart' as _i12;
import '../application/service/workspace_service.dart' as _i11;
import '../domain/repo/repo.dart' as _i10;
import '../infra/dao/dao_aw_impl.dart' as _i9;
import 'app_client_config.dart' as _i13;
import 'app_server_config.dart' as _i14;
import 'common_config.dart' as _i16;
import 'event_bus_config.dart' as _i15; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appClientConfig = _$AppClientConfig();
  final appServerConfig = _$AppServerConfig();
  final eventBusConfig = _$EventBusConfig();
  final configCommon = _$ConfigCommon();
  gh.lazySingleton<_i3.Account>(() => appClientConfig.account);
  gh.lazySingleton<_i4.Account>(() => appServerConfig.account);
  gh.lazySingleton<_i5.AccountService>(
      () => _i5.AccountService(get<_i3.Account>()));
  gh.lazySingleton<_i3.Avatars>(() => appClientConfig.avatars);
  gh.lazySingleton<_i4.Avatars>(() => appServerConfig.avatars);
  gh.lazySingleton<_i3.Client>(() => appClientConfig.client);
  gh.lazySingleton<_i4.Client>(() => appServerConfig.client);
  gh.lazySingleton<_i3.Database>(() => appClientConfig.database);
  gh.lazySingleton<_i4.Database>(() => appServerConfig.database);
  gh.lazySingleton<_i6.EventBus>(() => eventBusConfig.eventBus);
  gh.lazySingleton<_i7.Logger>(
      () => configCommon.logger(get<_i8.MindBaseConfig>()));
  gh.lazySingleton<_i3.Realtime>(() => appClientConfig.realtime);
  gh.lazySingleton<_i3.Storage>(() => appClientConfig.storage);
  gh.lazySingleton<_i4.Storage>(() => appServerConfig.storage);
  gh.lazySingleton<_i3.Teams>(() => appClientConfig.teams);
  gh.lazySingleton<_i4.Teams>(() => appServerConfig.teams);
  gh.lazySingleton<_i9.WorkspaceEttAccessor>(() => appClientConfig.wsEttAcc);
  gh.lazySingleton<_i10.WorkspaceRepo>(() =>
      _i10.WorkspaceRepo(get<_i3.Database>(), get<_i9.WorkspaceEttAccessor>()));
  gh.lazySingleton<_i11.WorkspaceService>(() => _i11.WorkspaceService(
      get<_i3.Teams>(),
      get<_i10.WorkspaceRepo>(),
      get<_i9.WorkspaceEttAccessor>()));
  gh.lazySingleton<_i12.RealTimeService>(
      () => _i12.RealTimeService(get<_i3.Realtime>()));
  return get;
}

class _$AppClientConfig extends _i13.AppClientConfig {}

class _$AppServerConfig extends _i14.AppServerConfig {}

class _$EventBusConfig extends _i15.EventBusConfig {}

class _$ConfigCommon extends _i16.ConfigCommon {}

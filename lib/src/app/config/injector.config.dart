// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:appwrite/appwrite.dart' as _i4;
import 'package:dart_appwrite/dart_appwrite.dart' as _i3;
import 'package:event_bus/event_bus.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logging/logging.dart' as _i8;
import 'package:slowly/slowly.dart' as _i12;

import '../../user/application/service/account_service.dart' as _i5;
import '../../workspace/application/service/service.dart' as _i6;
import '../../workspace/application/service/workspace_service.dart' as _i14;
import '../../workspace/infra/dao/dao_aw_impl.dart' as _i13;
import '../../workspace/infra/dao/realtime_hub.dart' as _i10;
import '../application.dart' as _i9;
import '../application/service/service.dart' as _i11;
import 'app_client_config.dart' as _i16;
import 'app_server_config.dart' as _i15;
import 'common_config.dart' as _i18;
import 'event_bus_config.dart' as _i17;
import 'slowly_config.dart' as _i19;

const String _dev = 'dev';
const String _test = 'test';
const String _prod = 'prod';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appServerConfig = _$AppServerConfig();
  final appClientConfig = _$AppClientConfig();
  final eventBusConfig = _$EventBusConfig();
  final configCommon = _$ConfigCommon();
  final slowlyConfig = _$SlowlyConfig();
  gh.lazySingleton<_i3.Account>(() => appServerConfig.account);
  gh.lazySingleton<_i4.Account>(() => appClientConfig.account);
  gh.lazySingleton<_i5.AccountService>(
      () => _i5.AccountService(get<_i4.Account>()));
  gh.lazySingleton<_i3.Avatars>(() => appServerConfig.avatars);
  gh.lazySingleton<_i4.Avatars>(() => appClientConfig.avatars);
  gh.lazySingleton<_i3.Client>(() => appServerConfig.client);
  gh.lazySingleton<_i4.Client>(() => appClientConfig.client);
  gh.lazySingleton<_i6.CollectionService>(() => _i6.CollectionService());
  gh.lazySingleton<_i3.Databases>(() => appServerConfig.database);
  gh.lazySingleton<_i4.Databases>(() => appClientConfig.database);
  gh.lazySingleton<_i7.EventBus>(() => eventBusConfig.eventBus);
  gh.lazySingleton<_i8.Logger>(
      () => configCommon.logger(get<_i9.MindBaseConfig>()));
  gh.lazySingleton<_i4.Realtime>(() => appClientConfig.realtime);
  gh.lazySingleton<_i10.RealtimeChannelHub>(
      () => _i10.RealtimeChannelHub(get<_i4.Realtime>()));
  gh.lazySingleton<_i11.RealtimeSrv>(
      () => _i11.RealtimeSrv(get<_i10.RealtimeChannelHub>()));
  gh.lazySingleton<_i12.Slowly<dynamic>>(() => slowlyConfig.slowly,
      registerFor: {_dev, _test, _prod});
  gh.lazySingleton<_i3.Storage>(() => appServerConfig.storage);
  gh.lazySingleton<_i4.Storage>(() => appClientConfig.storage);
  gh.factory<String>(() => appClientConfig.mainDataBaseId);
  gh.lazySingleton<_i3.Teams>(() => appServerConfig.teams);
  gh.lazySingleton<_i4.Teams>(() => appClientConfig.teams);
  gh.lazySingleton<_i13.WorkspaceEttAccessor>(() => appClientConfig.wsEttAcc);
  gh.lazySingleton<_i14.WorkspaceService>(() => _i14.WorkspaceService(
      get<_i4.Databases>(), get<_i13.WorkspaceEttAccessor>()));
  gh.lazySingleton<_i6.TeamService>(
      () => _i6.TeamService(get<_i4.Teams>(), get<_i3.Teams>()));
  return get;
}

class _$AppServerConfig extends _i15.AppServerConfig {}

class _$AppClientConfig extends _i16.AppClientConfig {}

class _$EventBusConfig extends _i17.EventBusConfig {}

class _$ConfigCommon extends _i18.ConfigCommon {}

class _$SlowlyConfig extends _i19.SlowlyConfig {}

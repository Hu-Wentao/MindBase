// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:appwrite/appwrite.dart' as _i3;
import 'package:dart_appwrite/dart_appwrite.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logging/logging.dart' as _i7;
import 'package:slowly/slowly.dart' as _i12;

import '../../app/application/service.dart' as _i11;
import '../../space/application/service.dart' as _i14;
import '../../space/application/service/service.dart' as _i6;
import '../../space/application/service/workspace_service.dart' as _i15;
import '../../space/infra/dao/dao_aw_impl.dart' as _i13;
import '../../space/infra/dao/realtime_hub.dart' as _i10;
import '../../user/application/service.dart' as _i5;
import '../infra/dao.dart' as _i9;
import 'appwrite_config.dart' as _i16;
import 'common_config.dart' as _i17;
import 'config.dart' as _i8;
import 'slowly_config.dart' as _i18;

const String _dev = 'dev';
const String _test = 'test';
const String _prod = 'prod';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final appClientConfig = _$AppClientConfig();
  final appServerConfig = _$AppServerConfig();
  final configCommon = _$ConfigCommon();
  final slowlyConfig = _$SlowlyConfig();
  gh.lazySingleton<_i3.Account>(() => appClientConfig.account);
  gh.lazySingleton<_i4.Account>(() => appServerConfig.account);
  gh.lazySingleton<_i5.AccountService>(
      () => _i5.AccountService(get<_i3.Account>()));
  gh.lazySingleton<_i3.Avatars>(() => appClientConfig.avatars);
  gh.lazySingleton<_i4.Avatars>(() => appServerConfig.avatars);
  gh.lazySingleton<_i3.Client>(() => appClientConfig.client);
  gh.lazySingleton<_i4.Client>(() => appServerConfig.client);
  gh.lazySingleton<_i6.CollectionService>(() => _i6.CollectionService());
  gh.lazySingleton<_i3.Databases>(() => appClientConfig.database);
  gh.lazySingleton<_i4.Databases>(() => appServerConfig.database);
  gh.lazySingleton<_i7.Logger>(
      () => configCommon.logger(get<_i8.MindBaseConfig>()));
  gh.lazySingleton<_i3.Realtime>(() => appClientConfig.realtime);
  gh.lazySingleton<_i9.RealtimeChannelHub>(
      () => _i9.RealtimeChannelHub(get<_i3.Realtime>()));
  gh.lazySingleton<_i10.RealtimeChannelHub>(
      () => _i10.RealtimeChannelHub(get<_i3.Realtime>()));
  gh.lazySingleton<_i11.RealtimeSrv>(
      () => _i11.RealtimeSrv(get<_i10.RealtimeChannelHub>()));
  gh.lazySingleton<_i12.Slowly<dynamic>>(
    () => slowlyConfig.slowly,
    registerFor: {
      _dev,
      _test,
      _prod,
    },
  );
  gh.lazySingleton<_i13.SpaceModelEttAccessor>(() => appClientConfig.wsEttAcc);
  gh.lazySingleton<_i14.SpaceService>(() => _i14.SpaceService());
  gh.lazySingleton<_i15.SpaceService>(() => _i15.SpaceService(
        get<_i13.SpaceModelEttAccessor>(),
        get<_i4.Databases>(),
      ));
  gh.lazySingleton<_i3.Storage>(() => appClientConfig.storage);
  gh.lazySingleton<_i4.Storage>(() => appServerConfig.storage);
  gh.lazySingleton<_i3.Teams>(() => appClientConfig.teams);
  gh.lazySingleton<_i4.Teams>(() => appServerConfig.teams);
  gh.lazySingleton<_i5.TeamService>(() => _i5.TeamService(
        get<_i3.Teams>(),
        get<_i4.Teams>(),
      ));
  return get;
}

class _$AppClientConfig extends _i16.AppClientConfig {}

class _$AppServerConfig extends _i16.AppServerConfig {}

class _$ConfigCommon extends _i17.ConfigCommon {}

class _$SlowlyConfig extends _i18.SlowlyConfig {}

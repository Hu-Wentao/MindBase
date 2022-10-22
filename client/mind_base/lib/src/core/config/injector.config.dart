// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:appwrite/appwrite.dart' as _i3;
import 'package:dart_appwrite/dart_appwrite.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:slowly/slowly.dart' as _i8;

import '../../app/application/service/service.dart' as _i7;
import '../../space/application/service.dart' as _i9;
import '../../user/application/service.dart' as _i5;
import '../infra/dao.dart' as _i6;
import 'appwrite_config.dart' as _i10;
import 'slowly_config.dart' as _i11;

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
  final slowlyConfig = _$SlowlyConfig();
  gh.lazySingleton<_i3.Account>(() => appClientConfig.account);
  gh.lazySingleton<_i4.Account>(() => appServerConfig.account);
  gh.lazySingleton<_i5.AccountService>(
      () => _i5.AccountService(get<_i3.Account>()));
  gh.lazySingleton<_i3.Avatars>(() => appClientConfig.avatars);
  gh.lazySingleton<_i4.Avatars>(() => appServerConfig.avatars);
  gh.lazySingleton<_i3.Client>(() => appClientConfig.client);
  gh.lazySingleton<_i4.Client>(() => appServerConfig.client);
  gh.lazySingleton<_i3.Databases>(() => appClientConfig.database);
  gh.lazySingleton<_i4.Databases>(() => appServerConfig.database);
  gh.lazySingleton<_i3.Realtime>(() => appClientConfig.realtime);
  gh.lazySingleton<_i6.RealtimeChannelHub>(
      () => _i6.RealtimeChannelHub(get<_i3.Realtime>()));
  gh.lazySingleton<_i7.RealtimeSrv>(
      () => _i7.RealtimeSrv(get<_i6.RealtimeChannelHub>()));
  gh.lazySingleton<_i8.Slowly<dynamic>>(
    () => slowlyConfig.slowly,
    registerFor: {
      _dev,
      _test,
      _prod,
    },
  );
  gh.lazySingleton<_i9.SpaceService>(() => _i9.SpaceService());
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

class _$AppClientConfig extends _i10.AppClientConfig {}

class _$AppServerConfig extends _i10.AppServerConfig {}

class _$SlowlyConfig extends _i11.SlowlyConfig {}

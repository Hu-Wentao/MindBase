// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:appwrite/appwrite.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logging/logging.dart' as _i6;
import 'package:mongo_dart/mongo_dart.dart' as _i11;

import '../application.dart' as _i7;
import '../application/service/account_service.dart' as _i4;
import '../application/service/realtime_service.dart' as _i12;
import '../application/service/workspace_service.dart' as _i10;
import '../domain/repo/repo.dart' as _i9;
import '../infra/dao/dao_aw_impl.dart' as _i8;
import '../infra/mongo_storage.dart' as _i5;
import 'app_client_config.dart' as _i13;
import 'common_config.dart' as _i15;
import 'mongo_config.dart' as _i14; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appClientConfig = _$AppClientConfig();
  final configMongo = _$ConfigMongo();
  final configCommon = _$ConfigCommon();
  gh.factory<_i3.Account>(() => appClientConfig.account);
  gh.lazySingleton<_i4.AccountService>(
      () => _i4.AccountService(get<_i3.Account>()));
  gh.factory<_i3.Avatars>(() => appClientConfig.avatars);
  gh.factory<_i3.Client>(() => appClientConfig.client);
  gh.factory<_i3.Database>(() => appClientConfig.database);
  gh.factory<_i5.IMongoStorage>(() => configMongo.mongoStorage);
  gh.factory<_i6.Logger>(() => configCommon.logger(get<_i7.MindBaseConfig>()));
  gh.factory<_i3.Realtime>(() => appClientConfig.realtime);
  gh.factory<_i3.Storage>(() => appClientConfig.storage);
  gh.factory<_i3.Teams>(() => appClientConfig.teams);
  gh.factory<_i8.WorkspaceEttAccessor>(() => appClientConfig.wsEttAcc);
  gh.lazySingleton<_i9.WorkspaceRepo>(() =>
      _i9.WorkspaceRepo(get<_i3.Database>(), get<_i8.WorkspaceEttAccessor>()));
  gh.lazySingleton<_i10.WorkspaceService>(() => _i10.WorkspaceService(
      get<_i3.Teams>(),
      get<_i9.WorkspaceRepo>(),
      get<_i8.WorkspaceEttAccessor>()));
  await gh.factoryAsync<_i11.Db>(
      () => configMongo.getDb(get<_i5.IMongoStorage>()),
      preResolve: true);
  gh.lazySingleton<_i12.RealTimeService>(
      () => _i12.RealTimeService(get<_i3.Realtime>()));
  return get;
}

class _$AppClientConfig extends _i13.AppClientConfig {}

class _$ConfigMongo extends _i14.ConfigMongo {}

class _$ConfigCommon extends _i15.ConfigCommon {}

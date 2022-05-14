// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:appwrite/appwrite.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logging/logging.dart' as _i5;
import 'package:mongo_dart/mongo_dart.dart' as _i9;

import '../application.dart' as _i6;
import '../application/provider/workspace_provider.dart' as _i8;
import '../domain/repo/repo.dart' as _i7;
import '../infra/mongo_storage.dart' as _i4;
import '../interface/dao.dart' as _i10;
import 'app_client_config.dart' as _i11;
import 'common_config.dart' as _i13;
import 'mongo_config.dart' as _i12; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appClientConfig = _$AppClientConfig();
  final configMongo = _$ConfigMongo();
  final configCommon = _$ConfigCommon();
  gh.factory<_i3.Account>(() => appClientConfig.account);
  gh.factory<_i3.Client>(() => appClientConfig.client);
  gh.factory<_i4.IMongoStorage>(() => configMongo.mongoStorage);
  gh.factory<_i5.Logger>(() => configCommon.logger(get<_i6.MindBaseConfig>()));
  gh.lazySingleton<_i7.MetaRepo>(() => _i7.MetaRepo(get<_i4.IMongoStorage>()));
  gh.factory<_i3.Realtime>(() => appClientConfig.realtime);
  gh.singleton<_i8.WorkspaceDataHolder>(_i8.WorkspaceDataHolder());
  await gh.factoryAsync<_i9.Db>(
      () => configMongo.getDb(get<_i4.IMongoStorage>()),
      preResolve: true);
  gh.lazySingleton<_i10.RecordMetaAccessor>(
      () => _i10.RecordMetaAccessor(get<_i9.Db>()));
  return get;
}

class _$AppClientConfig extends _i11.AppClientConfig {}

class _$ConfigMongo extends _i12.ConfigMongo {}

class _$ConfigCommon extends _i13.ConfigCommon {}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logging/logging.dart' as _i4;
import 'package:mongo_dart/mongo_dart.dart' as _i8;

import '../application.dart' as _i5;
import '../application/provider/workspace_provider.dart' as _i7;
import '../domain/repo.dart' as _i6;
import '../infra/mongo_storage.dart' as _i3;
import '../interface/dao.dart' as _i9;
import 'common_config.dart' as _i11;
import 'mongo_config.dart' as _i10; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final configMongo = _$ConfigMongo();
  final configCommon = _$ConfigCommon();
  gh.factory<_i3.IMongoStorage>(() => configMongo.mongoStorage);
  gh.factory<_i4.Logger>(() => configCommon.logger(get<_i5.MindBaseConfig>()));
  gh.lazySingleton<_i6.MetaRepo>(() => _i6.MetaRepo(get<_i3.IMongoStorage>()));
  gh.singleton<_i7.WorkspaceDataHolder>(_i7.WorkspaceDataHolder());
  await gh.factoryAsync<_i8.Db>(
      () => configMongo.getDb(get<_i3.IMongoStorage>()),
      preResolve: true);
  gh.lazySingleton<_i9.RecordMetaAccessor>(
      () => _i9.RecordMetaAccessor(get<_i8.Db>()));
  return get;
}

class _$ConfigMongo extends _i10.ConfigMongo {}

class _$ConfigCommon extends _i11.ConfigCommon {}

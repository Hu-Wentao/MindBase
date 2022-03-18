// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logging/logging.dart' as _i4;
import 'package:mongo_dart/mongo_dart.dart' as _i7;

import '../application.dart' as _i5;
import '../domain/repo.dart' as _i6;
import '../infra/mongo_storage.dart' as _i3;
import '../interface/dao.dart' as _i8;
import 'common_config.dart' as _i10;
import 'mongo_config.dart' as _i9; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i6.RecordRepo>(
      () => _i6.RecordRepo(get<_i3.IMongoStorage>(), get<_i6.MetaRepo>()));
  await gh.factoryAsync<_i7.Db>(
      () => configMongo.getDb(get<_i3.IMongoStorage>()),
      preResolve: true);
  gh.lazySingleton<_i8.RecordAccessor>(() => _i8.RecordAccessor(get<_i7.Db>()));
  gh.lazySingleton<_i8.RecordMetaAccessor>(
      () => _i8.RecordMetaAccessor(get<_i7.Db>()));
  return get;
}

class _$ConfigMongo extends _i9.ConfigMongo {}

class _$ConfigCommon extends _i10.ConfigCommon {}

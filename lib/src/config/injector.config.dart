// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../domain/repo.dart' as _i4;
import '../infra/mongo_storage.dart' as _i3;
import 'mongo_config.dart' as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final configMongo = _$ConfigMongo();
  gh.factory<_i3.IMongoStorage>(() => configMongo.mongoStorage);
  gh.lazySingleton<_i4.SchemaRepo>(
      () => _i4.SchemaRepo(get<_i3.IMongoStorage>()));
  gh.lazySingleton<_i4.RecordRepo>(
      () => _i4.RecordRepo(get<_i3.IMongoStorage>(), get<_i4.SchemaRepo>()));
  return get;
}

class _$ConfigMongo extends _i5.ConfigMongo {}

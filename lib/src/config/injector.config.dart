// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
 import 'package:mongo_dart/mongo_dart.dart' as _i3;

import '../domain/repo.dart' as _i6;
import '../infra/mongo_storage.dart' as _i4;
import '../interface/dao.dart' as _i5;
import 'mongo_config.dart' as _i7; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final configMongo = _$ConfigMongo();
  await gh.factoryAsync<_i3.Db>(() => configMongo.db, preResolve: true);
  gh.factory<_i4.IMongoStorage>(() => configMongo.mongoStorage);
  gh.lazySingleton<_i5.RecordAccessor>(() => _i5.RecordAccessor(get<_i3.Db>()));
  gh.lazySingleton<_i5.RecordMetaAccessor>(
      () => _i5.RecordMetaAccessor(get<_i3.Db>()));
  gh.lazySingleton<_i6.SchemaRepo>(
      () => _i6.SchemaRepo(get<_i4.IMongoStorage>()));
  gh.lazySingleton<_i6.RecordRepo>(
      () => _i6.RecordRepo(get<_i4.IMongoStorage>(), get<_i6.SchemaRepo>()));
  return get;
}

class _$ConfigMongo extends _i7.ConfigMongo {}

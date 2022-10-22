// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:appwrite/appwrite.dart' as _i4;
import 'package:dart_appwrite/dart_appwrite.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../app/application/service/service.dart' as _i5;
import '../../user/application/service.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i3.AccountService>(
      () => _i3.AccountService(get<_i4.Account>()));
  gh.lazySingleton<_i5.RealtimeSrv>(() => _i5.RealtimeSrv(get<dynamic>()));
  gh.lazySingleton<_i3.TeamService>(() => _i3.TeamService(
        get<_i4.Teams>(),
        get<_i6.Teams>(),
      ));
  return get;
}

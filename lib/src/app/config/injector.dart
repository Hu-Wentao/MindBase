import 'package:get_arch_core/get_arch_core.dart';
import 'injector.config.dart';

///
/// Please copy this file to your project and rename it to `injector.dart`
/// run `dart run build_runner build` to generate `./injector.config.dart`
/// do not edit method name `initPackageDI`
@InjectableInit()
Future initPackageDI(GetIt getIt, IConfig config) async =>
    await $initGetIt(getIt, environmentFilter: config.filter);
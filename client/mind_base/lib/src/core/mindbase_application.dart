import 'package:get_arch_core/get_arch_core.dart';

class MindBaseConfig extends BaseConfig {
  MindBaseConfig({
    required EnvSign sign,
    required String name,
    required String version,
    required DateTime packAt,
  }) : super(sign: sign, name: name, version: version, packAt: packAt);
}

class MindBasePackage extends BasePackage<MindBaseConfig> {
  MindBasePackage({
    required Future<void> Function(GetIt getIt, IConfig config) initPackageDI,
    Future<void> Function(GetIt g, MindBaseConfig c)? onBeforePkgInit,
    Future<void> Function(GetIt g, MindBaseConfig config)? onAfterPkgInit,
    Future<void> Function(MindBaseConfig config, Object e, StackTrace s)?
        onPkgInitError,
    Future<void> Function(MindBaseConfig config)? onPkgInitFinally,
  }) : super(
          onBeforePkgInit,
          onAfterPkgInit,
          onPkgInitError,
          onPkgInitFinally,
          initPackageDI,
        );
}

class MindBaseApplication extends MindBasePackage
    with MxAppRun<MindBaseConfig> {
  @override
  final Future<void> Function()? onAfterAppRun;

  @override
  final Future<void> Function(Object e, StackTrace s)? onAppError;

  @override
  final Future<void> Function()? onAppFinally;

  @override
  final Future<void> Function(GetIt getIt, MindBaseConfig config)?
      onApplicationRun;

  @override
  final Future<void> Function(GetIt getIt, MindBaseConfig config)?
      onBeforeAppInit;

  @override
  final Future<void> Function(GetIt g)? onBeforeAppRun;

  @override
  final Iterable<IPackage<IConfig>> packages;

  MindBaseApplication({
    this.packages = const [],
    this.onBeforeAppInit,
    required Future<void> Function(GetIt getIt, IConfig config) appInit,
    this.onBeforeAppRun,
    this.onApplicationRun,
    this.onAfterAppRun,
    this.onAppError,
    this.onAppFinally,
  }) : super(initPackageDI: appInit);
}

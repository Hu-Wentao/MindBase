import 'package:get_arch_core/get_arch_core_interface.dart';

export './pubspec.yaml.g.dart';
export './assets/assets.gen.dart';


class MindBaseConfig extends BaseConfig {
  MindBaseConfig({
    required EnvSign sign,
    required String name,
    required String version,
    required DateTime packAt,
  }) : super(sign: sign, name: name, version: version, packAt: packAt);
}

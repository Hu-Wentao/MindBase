import 'package:get_arch_core/get_arch_core.dart';
import './pubspec.yaml.g.dart' as spec;

export './pubspec.yaml.g.dart';
export './injector.dart';

part 'const.dart';

class MindBaseConfig extends BaseConfig {
  MindBaseConfig({
    required EnvSign sign,
    required String name,
    required String version,
    required DateTime packAt,
  }) : super(sign: sign, name: name, version: version, packAt: packAt);
}

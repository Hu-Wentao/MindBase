import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/constants/pubspec.yaml.g.dart' as spec;
import 'package:mind_base/src/app/application.dart';

const kName = spec.name;
const kVersion = spec.version;
final kPackAt = DateTime.fromMillisecondsSinceEpoch(spec.timestamp * 1000);

final kEnvDev = MindBaseConfig(
    sign: EnvSign.dev, name: kName, version: kVersion, packAt: kPackAt);
final kEnvTest = MindBaseConfig(
    sign: EnvSign.test, name: kName, version: kVersion, packAt: kPackAt);
final kEnvProd = MindBaseConfig(
    sign: EnvSign.prod, name: kName, version: kVersion, packAt: kPackAt);

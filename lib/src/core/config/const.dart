import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/config/config.dart' as spec;

const kName = spec.name;
const kVersion = spec.version;
final kPackAt = DateTime.fromMillisecondsSinceEpoch(spec.timestamp * 1000);

final kEnvDev = spec.MindBaseConfig(
    sign: EnvSign.dev, name: kName, version: kVersion, packAt: kPackAt);
final kEnvTest = spec.MindBaseConfig(
    sign: EnvSign.test, name: kName, version: kVersion, packAt: kPackAt);
final kEnvProd = spec.MindBaseConfig(
    sign: EnvSign.prod, name: kName, version: kVersion, packAt: kPackAt);

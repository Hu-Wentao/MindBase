import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/domain/exceptions.dart';
import 'package:mind_base/src/user/domain/exceptions.dart';
import './pubspec.yaml.g.dart' as spec;

export './pubspec.yaml.g.dart';
export './injector.dart';

part 'const.dart';
part 'exception_adapter.dart';

class MindBaseConfig extends BaseConfig {
  MindBaseConfig({
    required EnvSign sign,
    required String name,
    required String version,
    required DateTime packAt,
  }) : super(sign: sign, name: name, version: version, packAt: packAt);
}

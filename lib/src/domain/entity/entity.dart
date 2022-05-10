import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/value/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'dart:math' as math;

import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

import '../../application/expr_evaluator.dart';

part 'func.dart';
part 'functor.dart';
part 'property.dart';
import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/app/application.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/user/application/service/account_service.dart';
import 'package:mind_base/src/user/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/user/domain/value/value.dart';
import 'package:mind_base/src/workspace/application/model/model.dart';
import 'package:mind_base/src/workspace/application/service/service.dart';
import 'package:provider_sidecar/provider_sidecar.dart';
import 'package:appwrite/appwrite.dart' as cli;
import 'package:appwrite/models.dart' as aw;

part 'app_state_model.dart';
part 'user_model.dart';
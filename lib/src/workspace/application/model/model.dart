import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/core/inter/i_dao.dart';
import 'package:mind_base/src/user/application/model/model.dart';
import 'package:mind_base/src/workspace/application/service/expr/expr_evaluator.dart';
import 'package:mind_base/src/workspace/application/service/meta_service.dart';
import 'package:mind_base/src/workspace/domain/repo/repo.dart';
import 'package:mind_base/src/workspace/domain/value/value.dart';
import 'package:mind_base/src/workspace/infra/dao/dao_aw_impl.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/data_table_source.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

import 'package:mind_base/src/workspace/application/service/workspace_service.dart';
import 'package:mind_base/src/workspace/domain/entity/entity.dart';

import '../../infra/ui/dialog/import_data_dialog.dart';
import '../service/meta_service.dart';
import 'package:collection/collection.dart';
import 'package:mind_base/src/workspace/application/service/service.dart';

@Deprecated('use cli.')
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/appwrite.dart' as cli;
import 'package:appwrite/models.dart' as aw;
import 'package:dart_appwrite/dart_appwrite.dart' as srv;
import 'package:dart_appwrite/models.dart' as da;

part 'workspace.dart';

part 'meta.dart';

part 'record.dart';

part 'propery.dart';

part 'team.dart';

part 'collection_model.dart';
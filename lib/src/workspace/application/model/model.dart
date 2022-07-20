import 'dart:async';

import 'package:dart_appwrite/dart_appwrite.dart' as srv;
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/core/inter/i_dao.dart';
import 'package:mind_base/src/workspace/application/service/meta_service.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/workspace/domain/repo/repo.dart';
import 'package:mind_base/src/workspace/domain/value/value.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/data_table_source.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

import 'package:appwrite/appwrite.dart';
import 'package:mind_base/src/workspace/application/service/workspace_service.dart';
import 'package:mind_base/src/workspace/domain/entity/entity.dart';

import '../../infra/ui/dialog/import_data_dialog.dart';
import '../service/meta_service.dart';
import 'package:collection/collection.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite/models.dart' as aw;
import 'package:mind_base/src/workspace/application/service/service.dart';
part 'opened_meta.dart';

part 'opened_space.dart';

part 'opened_space_manager.dart';

part 'team.dart';

part 'team_manager.dart';

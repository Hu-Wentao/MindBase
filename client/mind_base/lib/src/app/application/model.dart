import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_sweet/get_sweet.dart';
import 'package:mind_base/src/core/config/appwrite_config.dart';
import 'package:mind_base/src/core/config/config.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/core/inter/i_dao.dart';
import 'package:mind_base/src/user/application/service.dart';
import 'package:mind_base/src/user/inter/dto.dart';
import 'package:mind_base/src/space/application/service/expr/expr_evaluator.dart';
import 'package:mind_base/src/space/domain/repo/repo.dart';
import 'package:mind_base/src/space/domain/value/value.dart';
import 'package:mind_base/src/space/infra/ui/widget/data_table_source.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

import 'package:mind_base/src/space/application/service/workspace_service.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:slowly/slowly.dart';

import 'package:collection/collection.dart';
import 'package:mind_base/src/space/application/service/service.dart';

import 'package:appwrite/appwrite.dart' as cli;
import 'package:dart_appwrite/dart_appwrite.dart' as srv;
import 'package:mind_base/src/app/application/service.dart';
import 'package:mind_base/src/core/inter/i_dto.dart';
import 'package:mind_base/src/user/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/user/domain/value/value.dart';
import 'package:mind_base/src/space/infra/ui/dialog/import_data_dialog.dart';
import 'package:mockito/annotations.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([
  MockSpec<UserModel>(),
  MockSpec<TeamModel>(),
])
import 'model.mocks.dart';

part 'model/app_model.dart';

part 'model/user_model.dart';

part 'model/space/space_model.dart';

part 'model.freezed.dart';

part 'model/space/meta_model.dart';

part 'model/space/record_model.dart';

part 'model/team_model.dart';

part 'model/space/collection_model.dart';

abstract class BaseActEntranceModel<ACT, S> extends Sidecar<S, BaseException?>
    with ActEntranceMx<ACT, S, BaseException?> {
  BaseActEntranceModel({
    required super.state,
    super.msg = 'Init with Constructor',
    super.onCatch = ExceptionAdapter.of,
  });

  // 如果实现类在程序中不是单例，则应当覆写该字段，避免被全局Slowly过滤掉Act
  String get id => 'singleton';

  @override
  BaseException? onBeforeActEntrance(ACT act) =>
      sl<Slowly>().seconds('${id}_${act.runtimeType}', sec: 1)
          ? null
          : const BaseException('Slowly error');
}

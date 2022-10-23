import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/app/application/service/service.dart';
import 'package:mind_base/src/core/config/config.dart';
import 'package:mind_base/src/space/application/service.dart';
import 'package:mind_base/src/space/inter/dto.dart';
import 'package:mind_base/src/user/application/service.dart';
import 'package:mind_base/src/user/domain/exceptions.dart';
import 'package:mind_base/src/user/domain/value.dart';
import 'package:mind_base/src/user/domain/value/value.dart';
import 'package:mind_base/src/user/inter/dto.dart';
import 'package:provider_sidecar/provider_sidecar.dart';
import 'package:slowly/slowly.dart';
import 'package:get_sweet/get_sweet.dart';

part 'model.freezed.dart';

part 'model/app_model.dart';

part 'model/user_model.dart';

part 'model/team_model.dart';

part 'model/space/space_model.dart';

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
          : const BaseException('msg');
}

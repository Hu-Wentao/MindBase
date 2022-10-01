import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:provider_sidecar/provider_sidecar.dart';
import 'package:slowly/slowly.dart';

abstract class BaseActEntranceModel<ACT, S> extends Sidecar<S, BaseException?>
    with ActEntranceMx<ACT, S, BaseException?> {
  BaseActEntranceModel({
    required super.state,
    super.msg = 'Init with Constructor',
    super.onCatch = ExceptionAdapter.of,
  });

  @override
  BaseException? onBeforeActEntrance(ACT act) =>
      sl<Slowly>().seconds(act.runtimeType, sec: 1)
          ? null
          : BaseException('msg');
}

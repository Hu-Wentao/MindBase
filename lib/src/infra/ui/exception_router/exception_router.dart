import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/infra/ui/exception_router/dialog.dart';
import 'package:mind_base/src/infra/ui/exception_router/snack.dart';

extension BaseExceptionRouterX on BaseException? {
  showDialog(BuildContext context) =>
      DialogFactory.byException(this, context)?.show(context);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
      BuildContext context,
      {Function? onNull}) {
    if (this == null) {
      onNull?.call();
      return null;
    } else {
      // print("debug# showSnackBar $this");
      return SnackFactory.byException(this, context);
    }
  }
}

extension BaseFutureExceptionRouterX on Future<BaseException?> {
  thenDialog(BuildContext context) async => (await this).showDialog(context);

  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?>
      thenSnackBar(BuildContext context, {Function? onNull}) async =>
          (await this).showSnackBar(context, onNull: onNull);
}

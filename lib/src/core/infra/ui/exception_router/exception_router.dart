import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/dialog.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/snack.dart';

extension BaseExceptionRouterX on BaseException? {
  rethrowException() => (this == null) ? null : throw this!;

  Future<dynamic> showDialog(
    BuildContext context, {
    Function()? onNull,
  }) async =>
      (this == null)
          ? onNull?.call()
          : DialogFactory.byException(this, context)?.show(context);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
      BuildContext context,
      {Function? onNull}) {
    if (this == null) {
      onNull?.call();
      return null;
    } else {
      return SnackFactory.byException(this, context);
    }
  }
}

extension BaseFutureExceptionRouterX on Future<BaseException?> {
  Future thenRethrow() async => (await this).rethrowException();

  Future thenDialog(BuildContext context, {Function()? onNoneErr}) async =>
      (await this).showDialog(context, onNull: onNoneErr);

  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?>
      thenSnackBar(BuildContext context, {Function? onNull}) async =>
          (await this).showSnackBar(context, onNull: onNull);
}

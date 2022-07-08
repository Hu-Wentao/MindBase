import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:logging/logging.dart';

class SnackFactory {
  static final log = Logger("SnackFactory");

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? byException(
      BaseException? exception, BuildContext context) {
    if (exception == null) return null;
    log.info("byException#\n$exception");
    log.info("trace#\n${exception.debugInfo}");

    switch (exception.runtimeType) {
      case BaseException:
        return _buildBase(exception, context);
      default:
        return _buildDefault(exception, context);
    }
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _buildBase(
          BaseException exception, BuildContext context) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${exception.msg}")));

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      _buildDefault(BaseException exception, BuildContext context) =>
          _buildBase(exception, context);
}

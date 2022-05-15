import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:logging/logging.dart';
import 'package:mind_base/src/application/provider/user_provider.dart';
import 'package:mind_base/src/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/infra/ui/dialog/auth_dialog.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

class DialogFactory {
  static final log = Logger("DialogFactory");

  static NDialog? byException(BaseException? exception, BuildContext context) {
    if (exception == null) return null;
    log.info("byException#\n$exception");
    log.info("trace#\n${exception.debugInfo}");

    switch (exception.runtimeType) {
      case BaseException:
        return _buildBase(exception, context);
      case UnLoginException:
        return _buildUnLogin(exception, context);
      default:
        return _buildDefault(exception, context);
    }
  }

  static NDialog _buildUnLogin(BaseException exception, BuildContext context) =>
      NDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: const Text("您尚未登录..."),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(exception.msg),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("前往登录页"),
            onPressed: () => showAuthDialog(
              context: context,
              actAuthWith:
                  Provider.of<UserProvider>(context, listen: false).actAuthWith,
            ),
          ),
          TextButton(
              child: const Text("取消"), onPressed: () => context.popRoute()),
        ],
      );

  static NDialog _buildBase(BaseException exception, BuildContext context) =>
      _buildDefault(exception, context);

  static NDialog _buildDefault(BaseException exception, BuildContext context) =>
      NDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: const Text("发生了未知的错误.."),
        content: Text(exception.msg),
        actions: <Widget>[
          TextButton(
              child: const Text("Ok"), onPressed: () => context.popRoute()),
        ],
      );
}

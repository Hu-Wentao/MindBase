import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:logging/logging.dart';
import 'package:mind_base/src/app/infra/ui/page/auth/auth.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/user/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/user/domain/value/value.dart';
import 'package:mind_base/src/user/infra/ui/dialog/auth_dialog.dart';
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
      case NoPermissionException:
        return _buildNoPermission(exception, context);
      case AuthBaseException:
        return _buildAuth(exception, context);
      default:
        return _buildDefault(exception, context);
    }
  }

  static _buildAuth(BaseException exc, BuildContext context) async {
    final withRsp = (exc is AuthBaseException) ? AuthRsp.err(exc) : null;
    const AuthRoute(true).go(context);
    // final req = await showAuthDialog(context: context, withRsp: withRsp);
    // context.read<AppStateModel>().actAuthWithReq(req).thenDialog(context);
  }

  static NDialog _buildUnLogin(BaseException exception, BuildContext context) =>
      NDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: const Text("您尚未登录"),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(exception.msg),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("前往登录页"),
            onPressed: () async {
              Navigator.of(context).pop(); //关闭当前Dialog
              _buildAuth(exception, context);
            },
          ),
          TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop()),
        ],
      );

  static NDialog _buildNoPermission(
          BaseException exception, BuildContext context) =>
      NDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: const Text("权限不足"),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(exception.msg),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("登录新账号"),
            onPressed: () async {
              Navigator.of(context).pop(); //关闭当前Dialog
              _buildAuth(exception, context);
            },
          ),
          TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop()),
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
              child: const Text("Ok"),
              onPressed: () => Navigator.of(context).pop()),
        ],
      );
}

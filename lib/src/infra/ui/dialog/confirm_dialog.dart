import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

///
/// 确认返回true
/// 取消返回false
/// 其他(未点击确认)返回null
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  Function? onConfirm,
  Function? onCancel,
}) =>
    NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      // title: const Text("提示"),
      content: Padding(
        padding: const EdgeInsets.only(top: 32, left: 8.0,right: 8,bottom: 8),
        child: Text(title),
      ),
      // content: RecordForm(
      //   meta: meta,
      //   origin: origin,
      //   kRecordBuilder: kRecordBuilder,
      // ),
      actions: <Widget>[
        TextButton(
            child: const Text("确认"),
            onPressed: () {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text("OK")),
              // );
              onConfirm?.call();
              Navigator.of(context).pop(true);
            }),
        TextButton(
          child: const Text("取消"),
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(false);
          },
        ),
      ],
    ).show(context);

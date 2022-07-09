import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

///
/// 确认返回true
/// 取消返回false
/// 其他(未点击确认)返回null
Future<String?> showTextInputDialog({
  required BuildContext context,
  required String title,
  String? origin,
  Function? onConfirm,
  Function? onCancel,
}) {
  final ctrl = TextEditingController(text: origin);
  return NAlertDialog(
    dialogStyle: DialogStyle(titleDivider: true),
    content: Padding(
      padding: const EdgeInsets.only(top: 32, left: 8.0, right: 8, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          TextField(
            controller: ctrl,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "请输入",
              hintText: "$origin",
            ),
          )
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
          child: const Text("确认"),
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(ctrl.text.isEmpty ? null : ctrl.text);
          }),
      TextButton(
        child: const Text("取消"),
        onPressed: () {
          onCancel?.call();
          Navigator.of(context).pop(null);
        },
      ),
    ],
  ).show(context);
}

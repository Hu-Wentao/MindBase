import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

///
/// 确认返回true
/// 取消返回false
/// 其他(未点击确认)返回null
Future<String?> showTextInputDialog({
  required BuildContext context,
  required String title,
  String label = "请输入",
  String? hint,
  String? origin,
  Function? onConfirm,
  Function? onCancel,
}) {
  final ctrl = TextEditingController(text: origin);
  return NAlertDialog(
    dialogStyle: DialogStyle(titleDivider: true),
    title: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: Text(title),
    ),
    content: Padding(
      padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8,bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: ctrl,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: label,
              hintText: hint,
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

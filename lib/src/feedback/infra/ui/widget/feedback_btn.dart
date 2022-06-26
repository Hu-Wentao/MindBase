import 'package:flutter/material.dart';
import 'package:mind_base/src/core/infra/ui/dialog/confirm_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// 兔小巢不直接支持截图上传, 因此暂不使用feedback;
class FeedbackBtn extends StatelessWidget {
  const FeedbackBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: "反馈",
        onPressed: () {
          // 进入兔小巢
          showConfirmDialog(
              context: context,
              title: "是否进入反馈社区",
              onConfirm: () {
                launchUrl(Uri.parse("https://support.qq.com/product/399336"));
              });

          // 在web端仅支持 canvas渲染
          // BetterFeedback.of(context).show((UserFeedback feedback) {
          //   print("debug feedback ${feedback.text} ${feedback.screenshot}");
          // });
        },
        icon: const Icon(Icons.feedback_outlined));
  }
}

import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:mind_base/src/core/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/core/infra/ui/widget/RadiusInkWell.dart';
import 'package:mind_base/src/user/application/provider/user_provider.dart';
import 'package:mind_base/src/user/infra/ui/dialog/auth_dialog.dart';
import 'package:provider/provider.dart';

class UserInfoTile extends StatelessWidget {
  const UserInfoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<UserProvider>(
    builder: (c, p, _) => RadiusInkWell(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // todo 展示用户头像
          const Icon(Icons.person),
          const SizedBox(width: 4),
          // 手机竖屏模式不展示用户名
          if (getWindowType(c) != AdaptiveWindowType.xsmall)
            Text(p.user?.name ?? "未登录"),
        ],
      ),
      onTap: () async {
        if (p.isLogged) {
          //  退出登录
          await showConfirmDialog(
              context: context, title: "确认退出登录吗", onConfirm: p.actLogout);
        } else {
          // 登录/注册
          await showAuthDialog(
            context: context,
            actAuthWith: p.actAuthWith,
          );
        }
      },
    ),
  );
}

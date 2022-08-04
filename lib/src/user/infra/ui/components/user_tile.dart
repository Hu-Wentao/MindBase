import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:mind_base/src/app/application/model/model.dart';
import 'package:mind_base/src/core/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/core/infra/ui/widget/RadiusInkWell.dart';
import 'package:mind_base/src/user/application/model/model.dart';
import 'package:mind_base/src/user/infra/ui/dialog/auth_dialog.dart';
import 'package:provider/provider.dart';

class UserInfoTile extends StatelessWidget {
  const UserInfoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<UserModel>(
        builder: (c, user, _) => RadiusInkWell(
          margin: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // todo 展示用户头像
              const Icon(Icons.person),
              const SizedBox(width: 4),
              // 手机竖屏模式不展示用户名
              if (getWindowType(c) != AdaptiveWindowType.xsmall)
                Text(user.isLogged ? user.data!.name : "未登录"),
            ],
          ),
          onTap: () async {
            if (user.isLogged) {
              //  退出登录
              await showConfirmDialog(
                context: context,
                title: "确认退出登录吗",
                onConfirm: user.actLogout,
              );
            } else {
              // 登录/注册
              final req = await showAuthDialog(context: context);
              if (req != null) {
                await context
                    .read<AppStateModel>()
                    .actAuthWithReq(req)
                    .thenDialog(context);
              }
            }
          },
        ),
      );
}

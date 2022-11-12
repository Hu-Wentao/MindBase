import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/app/infra/ui/page/splash/splash.dart';
import 'package:mind_base/src/core/infra/ui/dialog/dialog.dart';
import 'package:mind_base/src/user/infra/ui/dialog/auth_dialog.dart';
import 'package:mind_base/src/user/infra/ui/widget/RadiusInkWell.dart';
import 'package:provider_sidecar/provider_sidecar_ex.dart';

class UserInfoTile extends StatelessWidget {
  const UserInfoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<UserModel>(
        builder: (c, user, _) => RadiusInkWell(
          margin: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              (user.isAnonymous)
                  ? const Icon(LineIcons.userSecret)
                  // todo 展示用户头像
                  : const Icon(Icons.person),
              const SizedBox(width: 4),
              // 手机竖屏模式不展示用户名
              if (getWindowType(c) != AdaptiveWindowType.xsmall)
                Text(user.isAnonymous ? "匿名用户" : user.data.name),
            ],
          ),
          onTap: () async {
            if (!user.isAnonymous) {
              //  退出登录
              await showConfirmDialog(
                context: context,
                title: "确认退出登录吗",
                onConfirm: () {
                  context.read<AppModel>().logout();
                  const SplashRoute().go(context);
                },
              );
            } else {
              // 登录/注册
              final req = await showAuthDialog(context: context);
              if (req != null) {
                final m = context.read<AppModel>();
                final act = (req.isRegister)
                    ? AppAct.signupLogin(
                        authVerify: req.authVerify,
                        identityStr: req.identityStr,
                        password: req.password)
                    : AppAct.login(
                        authVerify: req.authVerify,
                        identityStr: req.identityStr,
                        password: req.password);
                m.actEntrance(act);
              }
            }
          },
        ),
      );
}

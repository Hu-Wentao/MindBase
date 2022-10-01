import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/app/application/model/model.dart';
import 'package:mind_base/src/app/infra/ui/page/auth/auth.dart';
import 'package:mind_base/src/app/infra/ui/page/home/home.dart';
import 'package:provider/provider.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

part 'router.dart';

part 'splash.g.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with OnInitStateMx<AppStateModel, SplashPage> {
  bool recovering = false;

  @override
  onInitState(AppStateModel model, ScaffoldMessengerState msgr) => model
    ..events.listen((evt) => evt.maybeWhen(
        msg: (msg) => msgr.showSnackBar(SnackBar(content: Text(msg))),
        recovering: () => setState(() => recovering = true),
        recoverDone: (msg) {
          if (msg == null) {
            const HomeRoute.auto().go(context);
            msgr.showSnackBar(const SnackBar(content: Text('欢迎回来')));
          } else {
            const AuthRoute.auto().go(context);
            msgr.showSnackBar(SnackBar(content: Text(msg)));
          }
          return null;
        },
        orElse: () => null))
    // 尝试恢复登陆状态
    ..actEntrance(const AppAct.recover());

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Consumer<AppStateModel>(
          builder: (c, m, _) => m.state.when(
            init: init,
            logged: logged,
            unLogged: unLogged,
          ),
        ),
      );

  /// 初始化状态，展示Logo
  Widget init() => Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "MindBase",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Opacity(
                  opacity: recovering ? 1 : 0,
                  child: const LinearProgressIndicator(),
                ),
              )
            ],
          ),
        ),
      );

  /// 恢复登陆成功，展示用户头像
  Widget logged(UserModel user) {
    return Center(
      child: Text("欢迎回来 ${user.name}"),
    );
  }

  /// 恢复登陆失败，展示错误信息
  Widget unLogged() {
    return const Center(
      child: Text("恢复登陆失败"),
    );
  }
}

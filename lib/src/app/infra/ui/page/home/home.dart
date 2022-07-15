import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:mind_base/src/app/infra/ui/route/routes_config.gr.dart';
import 'package:mind_base/src/core/infra/ui/dialog/text_input_dialog.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/feedback/infra/ui/widget/feedback_btn.dart';
import 'package:mind_base/src/user/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/workspace/application/provider/opened_workspace.dart';
import 'package:mind_base/src/user/application/provider/user_provider.dart';
import 'package:mind_base/src/workspace/application/provider/workspace_manager_provider.dart';
import 'package:mind_base/src/workspace/application/provider/workspace_provider.dart';
import 'package:mind_base/src/constants/pubspec.yaml.g.dart';
import 'package:mind_base/src/user/infra/ui/dialog/auth_dialog.dart';
import 'package:mind_base/src/core/infra/ui/dialog/confirm_dialog.dart';
 import 'package:mind_base/src/workspace/domain/value/value.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/import_data_dialog.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/core/infra/ui/widget/RadiusInkWell.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/data_table_grid.dart';
import 'package:provider/provider.dart';
import 'package:provider_sidecar/provider_sidecar.dart';
import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';

import 'auto_adaptive_scaffold.dart';

part 'workspace_screen.dart';

part 'team_screen.dart';

part 'discover_screen.dart';

part 'settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AdaptiveScaffoldDestination selectedDest(activeIndex) =>
      _destinations[activeIndex];

  @override
  Widget build(BuildContext context) => AutoAdaptiveScaffold(
        appBarBuilder: _buildAppbar,
        routes: const [
          WorkspaceRoute(),
          TeamScreenRoute(),
          DiscoverScreenRoute(),
          SettingScreenRoute(),
        ],
        destinations: _destinations,
        // drawerHeader: _buildDrawerHeader(context),
        // navigationTypeResolver: (ctx) {
        //   if (MediaQuery.of(context).size.width > 600) {
        //     return NavigationType.drawer;
        //   } else {
        //     return NavigationType.bottom;
        //   }
        // },
        // floatingActionButton: _buildFloatActionButton(context),
        // includeBaseDestinationsInMenu: false,
      );
  final _destinations = const [
    AdaptiveScaffoldDestination(
      title: "工作空间",
      icon: Icons.list_alt_outlined,
    ),
    AdaptiveScaffoldDestination(
      title: '团队',
      icon: Icons.people_alt_outlined,
    ),
    AdaptiveScaffoldDestination(
      title: '发现',
      icon: Icons.search_outlined,
    ),
    AdaptiveScaffoldDestination(
      title: '设置',
      icon: Icons.settings_outlined,
    ),
  ];

  PreferredSizeWidget _buildAppbar(BuildContext c, TabsRouter tabsRouter) =>
      AdaptiveAppBar(
        // leading: tabsRouter.urlState.segments.length <= 3
        //     ? Container()
        //     : const AutoLeadingButton(),
        title: _buildAppbarTitle(c, tabsRouter),
        actions: [
          _buildUserInfoTile(c),
          const FeedbackBtn(),
        ],
      );

  _buildAppbarTitle(BuildContext context, TabsRouter tabsRouter) {
    final selectedIndex = tabsRouter.activeIndex;
    // print("debug #${}, #${tabsRouter.urlState.url}, #${tabsRouter.urlState
    //     .flatten}, #${tabsRouter.urlState.segments}");
    AdaptiveScaffoldDestination dest = selectedDest(selectedIndex);
    switch (selectedIndex) {
      case 0:
        return WorkspaceSelectorTitle(path: tabsRouter.urlState.path);
      case 1:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(dest.title),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(dest.title),
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(dest.title),
        );
      default:
        throw "error 未知的 selectedIndex[$selectedIndex]";
    }
  }

  _buildUserInfoTile(BuildContext context) => Consumer<UserProvider>(
        builder: (c, p, _) {
          return RadiusInkWell(
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
          );
        },
      );
}

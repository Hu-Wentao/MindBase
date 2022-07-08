import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/feedback/infra/ui/widget/feedback_btn.dart';
import 'package:mind_base/src/workspace/application/provider/opened_workspace.dart';
import 'package:mind_base/src/user/application/provider/user_provider.dart';
import 'package:mind_base/src/workspace/application/provider/workspace_manager_provider.dart';
import 'package:mind_base/src/workspace/application/provider/workspace_provider.dart';
import 'package:mind_base/src/constants/pubspec.yaml.g.dart';
import 'package:mind_base/src/user/infra/ui/dialog/auth_dialog.dart';
import 'package:mind_base/src/core/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/import_data_dialog.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/core/infra/ui/widget/RadiusInkWell.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/data_table_grid.dart';
import 'package:provider/provider.dart';
import 'package:provider_sidecar/provider_sidecar.dart';
import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';

part 'workspace_screen.dart';

part 'settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  AdaptiveScaffoldDestination get selectedDest => _destinations[selectedIndex];

  @override
  Widget build(BuildContext context) => AdaptiveNavigationScaffold(
        appBar: _buildAppbar(context),
        body: _buildBody(context),
        selectedIndex: selectedIndex,
        destinations: _destinations,
        onDestinationSelected: (i) => setState(() => selectedIndex = i),
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
      title: '联系人',
      icon: Icons.person_search_outlined,
    ),
    AdaptiveScaffoldDestination(
      title: '模板商店',
      icon: LineIcons.shoppingBag,
    ),
    AdaptiveScaffoldDestination(
      title: '设置',
      icon: Icons.settings_outlined,
    ),
  ];

  _buildAppbar(BuildContext context) => AdaptiveAppBar(
        title: _buildAppbarTitle(context, selectedIndex, selectedDest),
        actions: [
          _buildUserInfoTile(context),
          const FeedbackBtn(),
        ],
      );

  _buildAppbarTitle(BuildContext context, int selectedIndex,
      AdaptiveScaffoldDestination selectedDest) {
    switch (selectedIndex) {
      case 0:
        return const WorkspaceSelectorTitle();
      case 1:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(selectedDest.title),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(selectedDest.title),
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(selectedDest.title),
        );
      default:
        throw "error 未知的 selectedIndex[$selectedIndex]";
    }
  }

  _buildBody(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const WorkspaceScreen();
      case 1:
        return const ContactScreen();
      case 2:
        return const FunctionShopScreen();
      case 3:
        return const SettingScreen();
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
                //  注销
                showConfirmDialog(
                    context: context, title: "确认注销吗", onConfirm: p.actLogout);
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

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("联系人");
  }
}

class FunctionShopScreen extends StatelessWidget {
  const FunctionShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("函数商店");
  }
}

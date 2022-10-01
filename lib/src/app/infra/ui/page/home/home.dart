import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/app/application/model/model.dart';
import 'package:mind_base/src/app/infra/ui/app.dart';
import 'package:mind_base/src/core/infra/ui/dialog/text_input_dialog.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/feedback/infra/ui/widget/feedback_btn.dart';
import 'package:mind_base/src/user/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/user/infra/ui/components/user_tile.dart';
import 'package:mind_base/src/workspace/application/model/model.dart';
import 'package:mind_base/src/constants/pubspec.yaml.g.dart';
import 'package:mind_base/src/core/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/workspace/inter/dto/i_dto.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

part 'workspace_screen.dart';

part 'team_screen.dart';

part 'discover_screen.dart';

part 'settings_screen.dart';

part 'router.dart';

part 'home.g.dart';

enum ScreenType {
  workspaces,
  teams,
  discover,
  settings,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.screenType = ScreenType.workspaces})
      : super(key: key);
  final ScreenType screenType;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int activeIdx;

  @override
  void initState() {
    super.initState();
    activeIdx = widget.screenType.index;
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    activeIdx = widget.screenType.index;
  }

  AdaptiveScaffoldDestination selectedDest(int activeIdx) =>
      _destinations[activeIdx];

  @override
  Widget build(BuildContext context) => AdaptiveNavigationScaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(selectedDest(activeIdx).title),
          ),
          actions: const [
            UserInfoTile(),
            FeedbackBtn(),
          ],
        ),
        body: _buildBody(context),
        selectedIndex: activeIdx,
        destinations: _destinations,
        onDestinationSelected: (i) {
          context.go("/${ScreenType.values[i].name}");
        },
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

  _buildBody(BuildContext context) {
    switch (activeIdx) {
      case 0:
        return const WorkspacesScreen();
      case 1:
        return const TeamScreen();
      case 2:
        return const DiscoverScreen();
      case 3:
        return const SettingScreen();
      default:
        throw "error 未知的 selectedIndex[$activeIdx]";
    }
  }
}

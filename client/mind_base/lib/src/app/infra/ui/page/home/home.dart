import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_sweet/get_sweet.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/app/infra/ui/widget/widget.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/user/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/user/infra/ui/components/user_tile.dart';
import 'package:mind_base/src/core/config/config.dart';
import 'package:mind_base/src/core/infra/ui/dialog/dialog.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';
import 'package:provider/provider.dart';
import 'package:provider_sidecar/provider_sidecar.dart';
import 'package:url_launcher/link.dart';

part 'workspace_screen.dart';

part 'team_screen.dart';

part 'discover_screen.dart';

part 'settings_screen.dart';

part 'router.dart';

part 'home.g.dart';

enum ScreenTp {
  workspaces,
  teams,
  discover,
  settings,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.screenType = ScreenTp.workspaces})
      : super(key: key);
  final ScreenTp screenType;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with OnInitStateMx<HomePage, UserModel> {
  @override
  onInitState(msgr, m) {
    m.actEntrance(const UserAct.initModel());
    return null;
  }

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
          ],
        ),
        body: _buildBody(context),
        selectedIndex: activeIdx,
        destinations: _destinations,
        onDestinationSelected: (i) =>
            HomeRoute(ScreenTp.values[i]).go(context),
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
        return const SpaceModelsScreen();
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

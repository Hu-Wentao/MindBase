import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get_sweet/get_sweet.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/core/infra/ui/dialog/dialog.dart';
import 'package:mind_base/src/app/infra/ui/widget/widget.dart';
import 'package:mind_base/src/space/inter/dto.dart';
import 'package:provider_sidecar/provider_sidecar_ex.dart';
import 'package:url_launcher/link.dart';

part 'home.g.dart';
part 'workspace_screen.dart';

@TypedGoRoute<HomeRoute>(path: '/home/:screen', routes: [])
class HomeRoute extends GoRouteData {
  final ScreenTp screen;

  const HomeRoute(this.screen);

  const HomeRoute.auto([this.screen = ScreenTp.workspaces]);

  @override
  Widget build(BuildContext context) => HomePage(
        key: const ValueKey('home'),
        screenTp: screen,
      );
}

enum ScreenTp {
  workspaces,
  teams,
  discover,
  settings,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.screenTp = ScreenTp.workspaces})
      : super(key: key);
  final ScreenTp screenTp;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with OnInitStateMx<HomePage, UserModel> {
  @override
  onInitState(msgr, m) => m..actEntrance(const UserAct.initModel());

  late ScreenTp screenTp;

  @override
  void initState() {
    super.initState();
    screenTp = widget.screenTp;
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    screenTp = widget.screenTp;
  }

  AdaptiveScaffoldDestination selectedDest(ScreenTp screenTp) =>
      _destinations()[screenTp.index];

  @override
  Widget build(BuildContext context) => AdaptiveNavigationScaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(selectedDest(screenTp).title),
          ),
          actions: const [],
        ),
        body: _buildBody(context),
        selectedIndex: screenTp.index,
        destinations: _destinations(),
        onDestinationSelected: (i) => HomeRoute(ScreenTp.values[i]).go(context),
      );

  List<AdaptiveScaffoldDestination> _destinations() => const [
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
    switch (screenTp) {
      case ScreenTp.workspaces:
      case ScreenTp.teams:
      case ScreenTp.discover:
      case ScreenTp.settings:
        return Center(child: Text("Hello World [$screenTp]"));
    }
  }
}

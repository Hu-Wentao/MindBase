import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mind_base/src/infra/ui/page/home/home.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, initial: true),
    // AutoRoute<ShopEnvInfo>(page: ShopEnvInfoPage),
    // AutoRoute(page: FramePage, initial: true),
    // AutoRoute(page: NatPlatServicePage),
    // AutoRoute(page: AuthPage),
  ],
)
class $AppRouter {}

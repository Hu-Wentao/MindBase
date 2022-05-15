import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mind_base/src/application/provider/user_provider.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/infra/ui/dialog/auth_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_grid.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_source.dart';
import 'package:provider/provider.dart';

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
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildAppbarTitle(context, selectedIndex, selectedDest),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildUserInfoTile(context),
          ),
        ],
      );

  _buildAppbarTitle(BuildContext context, int selectedIndex,
      AdaptiveScaffoldDestination selectedDest) {
    switch (selectedIndex) {
      case 0:
        return InkResponse(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // todo 工作空间名称
              Text(selectedDest.title),
              const SizedBox(width: 4),
              const Icon(Icons.menu_open_outlined),
            ],
          ),
          onTap: () {
            // todo 展示工作空间列表(我创建的和受邀请的)
          },
        );
      case 1:
        return Text(selectedDest.title);
      case 2:
        return Text(selectedDest.title);
      case 3:
        return Text(selectedDest.title);
      default:
        throw "error 未知的 selectedIndex[$selectedIndex]";
    }
  }

  _buildBody(BuildContext context) => Consumer<WorkspaceProvider>(
      builder: (c, pWorkspace, _) => Row(
            children: [
              /// Meta List
              SizedBox(
                width: 200,
                child: ListView.builder(
                  itemCount: pWorkspace.metaList.length,
                  itemBuilder: (c, i) => ListTile(
                    title: Text(pWorkspace.metaList[i].name),
                    onTap: () =>
                        pWorkspace.actWatchMeta(pWorkspace.metaList[i]),
                  ),
                ),
              ),

              /// table
              if (pWorkspace.watchedMeta == null)
                const Expanded(
                  child: Center(child: Text("请选择/创建 一个Meta")),
                ),
              if (pWorkspace.watchedMeta != null)
                RecordDataGrid(
                  key: ValueKey(pWorkspace.watchedMeta),
                  dataGridSource: pWorkspace.actGetDataSource()
                      as RecordDataGridSourcePluto,
                  onSaveRecord: pWorkspace.actSaveRecord,
                  onSaveMeta: pWorkspace.actSaveMeta,
                ),
            ],
          ));

  _buildUserInfoTile(BuildContext context) => Consumer<UserProvider>(
        builder: (c, p, _) {
          // fixme thenDialog 未生效
          // await p.actCheckLoggedUser().thenDialog(context);
          return InkResponse(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // todo 展示用户头像
                const Icon(Icons.person),
                const SizedBox(width: 4),
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

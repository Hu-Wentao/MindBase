import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mind_base/src/application/provider/user_provider.dart';
import 'package:mind_base/src/application/provider/workspace_manager_provider.dart';
import 'package:mind_base/src/application/provider/workspace_provider.dart';
import 'package:mind_base/src/infra/ui/dialog/auth_dialog.dart';
import 'package:mind_base/src/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/infra/ui/widget/RadiusInkWell.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_grid.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_source.dart';
import 'package:provider/provider.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

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
          // fixme thenDialog 未生效
          // await p.actCheckLoggedUser().thenDialog(context);
          return RadiusInkWell(
            margin: const EdgeInsets.all(8.0),
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

class WorkspaceSelectorTitle extends StatelessWidget {
  const WorkspaceSelectorTitle({Key? key}) : super(key: key);

  //选择工作空间, 如果已打开则选择, 如果未开打,则先打开,然后再选择
  static const selectWorkspaceEvt = 'open_workspace_';
  static const createWorkspaceEvt = 'create_workspace';

  @override
  Widget build(BuildContext context) =>
      Consumer2<WorkspaceManagerProvider, WorkspaceProvider>(
        builder: (c, pManger, pWs, _) => RadiusInkWell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(pWs.openedWorkspace?.workspace.name ?? "请选择工作空间"),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: createWorkspaceEvt,
                    child: ListTile(
                      leading: Icon(Icons.add),
                      title: Text("新建工作空间"),
                    ),
                  ),
                  ...pManger.workspaces.entries
                      .expand((entry) => entry.value.map(
                            (e) => Tuple2(entry.key, e),
                          ))
                      .map(
                        (e) => PopupMenuItem<String>(
                          value: '$selectWorkspaceEvt${e.value2.id}',
                          child: ListTile(
                            leading: Text(e.value1.name),
                            title: Text(e.value2.name),
                          ),
                        ),
                      ),
                ],
                onSelected: (value) {
                  // 选中Item后,在这里会被二次调用
                  print("debug##$value");
                  switch (value) {
                    case 'create_workspace':
                      // showCreateWorkspaceDialog(context: context, actCreate: pManger.actCreateWorkspace);
                      // fixme 用户可指定团队和空间名
                      pManger
                          .actCreateWorkspace(null, '新建空间')
                          .thenDialog(context);
                      break;
                    default:
                      if (value.startsWith(selectWorkspaceEvt)) {
                        final wsId = value.substring(selectWorkspaceEvt.length);
                        // pManger.actOpenWorkspaceById(wsId);
                        pWs.actSelectWorkspace(pManger, wsId);
                        return;
                      }
                      print("debug#未知的value#$value");
                      break;
                  }
                },
              )
            ],
          ),
        ),
      );
}

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer<WorkspaceProvider>(builder: (c, pWorkspace, _) {
        switch (pWorkspace.state) {
          case SidecarState.uninitialized:
            return _buildWorkspaceSelector(context, pWorkspace);
          case SidecarState.initializing:
            return const Center(child: CircularProgressIndicator());
          case SidecarState.initialized:
            return _buildWorkspaceDetail(context, pWorkspace);
        }
      });

  /// 选择工作空间
  _buildWorkspaceSelector(context, pWorkspace) {
    // todo 考虑将选择菜单展示在这里
    // return Consumer<WorkspaceManagerProvider>(
    //   builder: (c,p,_){
    //   },
    // );

    return const Center(child: Text("请在左上角打开一个工作空间"));
  }

  /// 工作空间内容
  _buildWorkspaceDetail(context, pWorkspace) => Row(
        children: [
          /// 左侧Meta List
          SizedBox(
            width: 200,
            child: ListView.builder(
              itemCount: pWorkspace.metaList.length,
              itemBuilder: (c, i) => ListTile(
                title: Text(pWorkspace.metaList[i].name),
                onTap: () => pWorkspace.actWatchMeta(pWorkspace.metaList[i]),
              ),
            ),
          ),

          /// 右侧 table
          if (pWorkspace.watchedMeta == null)
            const Expanded(
              child: Center(child: Text("请选择/创建 一个Meta")),
            ),
          if (pWorkspace.watchedMeta != null)
            RecordDataGrid(
              key: ValueKey(pWorkspace.watchedMeta),
              dataGridSource:
                  pWorkspace.actGetDataSource() as RecordDataGridSourcePluto,
              onSaveRecord: pWorkspace.actSaveRecord,
              onSaveMeta: pWorkspace.actSaveMeta,
            ),
        ],
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

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("设置");
  }
}

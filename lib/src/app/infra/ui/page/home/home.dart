import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_arch_core/get_arch_core_interface.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/workspace/application/provider/opened_workspace.dart';
import 'package:mind_base/src/user/application/provider/user_provider.dart';
import 'package:mind_base/src/workspace/application/provider/workspace_manager_provider.dart';
import 'package:mind_base/src/workspace/application/provider/workspace_provider.dart';
import 'package:mind_base/src/constants/pubspec.yaml.g.dart';
import 'package:mind_base/src/user/infra/ui/dialog/auth_dialog.dart';
import 'package:mind_base/src/core/infra/ui/dialog/confirm_dialog.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/record_meta_edit_dialog.dart';
import 'package:mind_base/src/core/infra/ui/widget/RadiusInkWell.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/data_table_grid.dart';
import 'package:provider/provider.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

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
                        pManger.actOpenWorkspaceById(wsId);
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

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({Key? key}) : super(key: key);

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  final _kMetaBuilder = GlobalKey<FormBuilderState>();
  final _kAttrBuilder = GlobalKey<FormBuilderState>();
  final _kMethodBuilder = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) => Consumer<WorkspaceManagerProvider>(
        builder: (c, pManager, _) {
          switch (pManager.state) {
            case SidecarState.uninitialized:
              return _buildWorkspaceSelector(context, pManager);
            case SidecarState.initializing:
              return const Center(child: CircularProgressIndicator());
            case SidecarState.initialized:
              return (pManager.selectedWorkspace == null)
                  ? _buildWorkspaceSelector(context, pManager)
                  : _buildWorkspaceDetail(context);
          }
        },
      );

  /// 选择工作空间
  _buildWorkspaceSelector(context, pWorkspace) {
    // todo 考虑将选择菜单展示在这里
    // return Consumer<WorkspaceManagerProvider>(
    //   builder: (c,p,_){
    //   },
    // );
    return const Center(child: Text("请在左上角打开一个工作空间"));
  }

  // 已打开工作空间
  /// 工作空间内容
  _buildWorkspaceDetail(context) => Consumer<WorkspaceProvider>(
        builder: (c, pWorkspace, _) =>
            ChangeNotifierProvider<OpenedWorkspace?>.value(
          value: pWorkspace.openedWorkspace,
          child: ChangeNotifierProvider<OpenedMeta?>.value(
            value: pWorkspace.selectedMeta,
            child: Row(
              children: [
                /// 左侧Meta List
                SizedBox(
                  width: 200,
                  child: Stack(
                    children: [
                      // MetaList
                      Consumer<OpenedWorkspace?>(
                        builder: (c, p, _) => (p == null)
                            // 此时本组件不应该存在
                            ? const Text("Error selectedWorkspace==null")
                            : ListView.builder(
                                itemCount: p.openedMetas.length,
                                // itemCount: pWorkspace.metaList.length,
                                itemBuilder: (c, i) => ListTile(
                                  title: Text(p.openedMetas[i].meta.name),
                                  onTap: () => pWorkspace
                                      .actSelectOpenMeta(p.openedMetas[i]),
                                ),
                              ),
                      ),
                      // 新建Meta
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ListTile(
                            title: const Text("新建一个表"),
                            trailing: const Icon(Icons.add),
                            onTap: () async => await pWorkspace
                                .actInsertMeta((await showRecordMetaEditDialog(
                                  context: context,
                                  kAttrBuilder: _kAttrBuilder,
                                  kMetaBuilder: _kMetaBuilder,
                                  kMethodBuilder: _kMethodBuilder,
                                  queryMetaFn: pWorkspace.workspace.queryMeta,
                                  allMetas: pWorkspace.workspace.allMetas,
                                ))!
                                    .toDm(
                                        pWorkspace.openedWorkspace!.queryMeta))
                                .thenDialog(context),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                /// 右侧 table
                (pWorkspace.selectedMeta == null)
                    ? const Expanded(
                        child: Center(child: Text("请选择/创建 一个Meta")),
                      )
                    : RecordDataGrid(
                        // fixme 数据更新后,本widget没有刷新, 添加key之后,可以在selectedMeta刷新时,被动刷新表格
                        key: ValueKey(pWorkspace.selectedMeta),
                        dataGridSource: pWorkspace.selectedMeta!.dataSource,
                        onSaveRecord: pWorkspace.actSaveRecord,
                        onSaveMeta: (dto) => pWorkspace.actUpdateMeta(
                          pWorkspace.selectedMeta!.meta,
                          dto,
                        ),
                      ),
              ],
            ),
          ),
        ),
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

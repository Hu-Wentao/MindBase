part of 'home.dart';

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
              Text(pWs.openedWorkspace?.name ?? "请选择工作空间"),
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
                                itemBuilder: (c, i) => ListTile(
                                  selected: p.openedMetas[i].meta.id ==
                                      pWorkspace.selectedMeta?.id,
                                  title: Text(p.openedMetas[i].meta.name),
                                  onTap: () => pWorkspace
                                      .actSelectOpenMeta(p.openedMetas[i]),
                                  trailing: PopupMenuButton<String>(
                                    itemBuilder: (ctx) => [
                                      const PopupMenuItem(
                                        value: 'deleteViewEvt',
                                        child: ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text("删除视图"),
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      // 选中Item后,在这里会被二次调用
                                      switch (value) {
                                        case 'deleteViewEvt':
                                          pWorkspace.actRemoveMeta(
                                              p.openedMetas[i].meta.id);
                                          break;
                                        default:
                                          print("debug#未知的value#$value");
                                          break;
                                      }
                                    },
                                  ),
                                ),
                              ),
                      ),
                      // 新建Meta
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ListTile(
                            title: const Text("新建表"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () async {
                                    final nMeta =
                                        (await showRecordMetaEditDialog(
                                      context: context,
                                      kAttrBuilder: _kAttrBuilder,
                                      kMetaBuilder: _kMetaBuilder,
                                      kMethodBuilder: _kMethodBuilder,
                                      queryMetaFn:
                                          pWorkspace.openedWorkspace!.queryMeta,
                                      allMetas:
                                          pWorkspace.openedWorkspace!.allMetas,
                                    ));
                                    if (nMeta == null) return;
                                    return await pWorkspace
                                        .actInsertMetaDto(nMeta)
                                        .thenDialog(context);
                                  },
                                ),
                                PopupMenuButton<String>(
                                  itemBuilder: (ctx) => [
                                    const PopupMenuItem(
                                        value: "importByJson",
                                        child: ListTile(
                                          title: Text("通过Json导入"),
                                          trailing: Icon(Icons.input_rounded),
                                        ))
                                  ],
                                  onSelected: (key) async {
                                    switch (key) {
                                      case "importByJson":
                                        final dto = await showImportDataDialog(
                                            context: context);
                                        if (dto == null) return;
                                        return await pWorkspace
                                            .actUpdateByTable(dto)
                                            .thenDialog(context);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                /// 右侧 table
                Consumer<OpenedMeta?>(
                  builder: (c, openedMeta, _) => (openedMeta == null)
                      ? const Expanded(
                          child: Center(child: Text("请选择/创建 一个Meta")),
                        )
                      : RecordDataGrid(
                          pWorkspace: pWorkspace,
                          openedMeta: openedMeta,
                        ),
                ),
              ],
            ),
          ),
        ),
      );
}

part of 'home.dart';

class WorkspaceSelectorTitle extends StatelessWidget {
  final String path;

  const WorkspaceSelectorTitle({Key? key, this.path = ''}) : super(key: key);

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
              Text((path == "/workspace" || pWs.openedWorkspace?.name == null)
                  ? "请选择工作空间"
                  : pWs.openedWorkspace!.name),
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
                        context.replaceRoute(
                            WorkspaceScreenRoute(workspaceId: wsId));
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

class EmptyWorkspaceScreen extends StatelessWidget {
  const EmptyWorkspaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("尚未打开工作空间"));
  }
}

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({
    Key? key,
    @PathParam() this.workspaceId = '',
  }) : super(key: key);

  final String workspaceId;

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  @override
  Widget build(BuildContext context) => Consumer<WorkspaceManagerProvider>(
        builder: (c, pManager, _) {
          switch (pManager.state) {
            case SidecarState.uninitialized:
              return _buildWorkspaceSelector(context, pManager);
            case SidecarState.initializing:
              return const Center(child: CircularProgressIndicator());
            case SidecarState.initialized:
              return _buildWorkspaceDetail(context, pManager);
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
  _buildWorkspaceDetail(context, WorkspaceManagerProvider pManager) =>
      Consumer<WorkspaceProvider>(
          builder: (c, pWorkspace, _) => FutureBuilder(
              future: pManager.actOpenWorkspaceById(widget.workspaceId),
              builder: (c, snap) {
                return (pWorkspace.openedWorkspace?.id != widget.workspaceId &&
                        snap.connectionState != ConnectionState.done)
                    ? _buildWorkspaceSelector(context, pManager)
                    : ChangeNotifierProvider<OpenedWorkspace?>.value(
                        value: pWorkspace.openedWorkspace,
                        child: ChangeNotifierProvider<OpenedMeta?>.value(
                          value: pWorkspace.selectedMeta,
                          child: Row(
                            children: [
                              /// 左侧Meta List
                              MetaTableList(pWorkspace),

                              /// 右侧 table
                              Consumer<OpenedMeta?>(
                                builder: (c, openedMeta, _) =>
                                    (openedMeta == null)
                                        ? const Expanded(
                                            child: Center(
                                                child: Text("请选择/创建 一个Meta")),
                                          )
                                        : RecordDataGrid(
                                            pWorkspace: pWorkspace,
                                            openedMeta: openedMeta,
                                          ),
                              ),
                            ],
                          ),
                        ),
                      );
              }));
}

class MetaTableList extends StatefulWidget {
  final WorkspaceProvider pWorkspace;

  const MetaTableList(this.pWorkspace, {Key? key}) : super(key: key);

  @override
  State<MetaTableList> createState() => _MetaTableListState();
}

class _MetaTableListState extends State<MetaTableList> {
  final _kMetaBuilder = GlobalKey<FormBuilderState>();
  final _kAttrBuilder = GlobalKey<FormBuilderState>();
  final _kMethodBuilder = GlobalKey<FormBuilderState>();

  WorkspaceProvider get pWorkspace => widget.pWorkspace;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 240,
        child: Stack(
          children: [
            // MetaList
            Consumer<OpenedWorkspace?>(
              builder: (c, p, _) => (p == null)
                  // 此时本组件不应该存在
                  ? const Text("Error selectedWorkspace==null")
                  : SingleChildScrollView(
                      controller: ScrollController(),
                      child: ExpansionPanelList.radio(
                        expansionCallback: (panelIndex, isExpanded) {
                          if (isExpanded) {
                            pWorkspace
                                .actSelectOpenMeta(p.openedMetas[panelIndex]);
                          }
                        },
                        children: List.generate(
                          p.openedMetas.length,
                          (i) => ExpansionPanelRadio(
                            value: i,
                            headerBuilder: (c, ex) => ListTile(
                              selected: p.openedMetas[i].meta.id ==
                                  pWorkspace.selectedMeta?.id,
                              title: Text(p.openedMetas[i].meta.name),
                              onTap: () => pWorkspace
                                  .actSelectOpenMeta(p.openedMetas[i]),
                              trailing: PopupMenuButton<String>(
                                itemBuilder: (ctx) => [
                                  const PopupMenuItem(
                                      value: "newTableViewSheet",
                                      child: ListTile(
                                        leading: Icon(Icons.add_chart_rounded),
                                        title: Text("新增表格视图"),
                                      )),
                                  const PopupMenuItem(
                                    value: 'deleteViewEvt',
                                    child: ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text("删除表"),
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  // 选中Item后,在这里会被二次调用
                                  switch (value) {
                                    case 'newTableViewSheet':
                                      pWorkspace
                                          .actNewTableView(ViewType.sheet,
                                              p.openedMetas[i].meta)
                                          .thenDialog(c);
                                      break;
                                    case 'deleteViewEvt':
                                      pWorkspace
                                          .actRemoveMeta(
                                              p.openedMetas[i].meta.id)
                                          .thenDialog(c);
                                      break;
                                    default:
                                      print("debug#未知的value#$value");
                                      break;
                                  }
                                },
                              ),
                            ),
                            body: ListView.separated(
                              shrinkWrap: true,
                              itemCount: p.openedMetas[i].meta.views.length,
                              itemBuilder: (BuildContext context, int index) {
                                final v = p.openedMetas[i].meta.views[index];
                                return ListTile(
                                  title: Text(v.name),
                                  onTap: () => pWorkspace
                                      .actSelectView(v)
                                      .thenDialog(context),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      Container(
                                          height: 1.0,
                                          color: const Color(0xfff2f2f2)),
                            ),
                          ),
                        ),
                        animationDuration: const Duration(microseconds: 50),
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
                          final nMeta = (await showRecordMetaEditDialog(
                            context: context,
                            kAttrBuilder: _kAttrBuilder,
                            kMetaBuilder: _kMetaBuilder,
                            kMethodBuilder: _kMethodBuilder,
                            queryMetaFn: pWorkspace.openedWorkspace!.queryMeta,
                            allMetas: pWorkspace.openedWorkspace!.allMetas,
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
                              final dto =
                                  await showImportDataDialog(context: context);
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
      );
}

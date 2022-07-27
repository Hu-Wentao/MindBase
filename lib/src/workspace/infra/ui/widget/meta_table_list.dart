part of 'widget.dart';

class MetaTableList extends StatefulWidget {
  final WorkspaceModel? space;
  final String? metaId;

  const MetaTableList({
    Key? key,
    required this.space,
    required this.metaId,
  }) : super(key: key);

  @override
  State<MetaTableList> createState() => _MetaTableListState();
}

class _MetaTableListState extends State<MetaTableList> {
  final _kMetaBuilder = GlobalKey<FormBuilderState>();
  final _kAttrBuilder = GlobalKey<FormBuilderState>();
  final _kMethodBuilder = GlobalKey<FormBuilderState>();

  WorkspaceModel? get space => widget.space;

  final _panelExpanded = <int, bool>{};

  void _onExpandedCall(int panelIndex, bool isExpanded) => setState(() {
        _panelExpanded[panelIndex] = !isExpanded;
      });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 240,
        child: Stack(
          children: (space == null)
              ? const [
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: LinearProgressIndicator())
                ]
              : [
                  /// 左侧上部 Meta列表
                  Padding(
                    padding: const EdgeInsets.only(bottom: 48),
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: ExpansionPanelList(
                        expansionCallback: _onExpandedCall,
                        children: List.generate(
                          space!.metas.length,
                          (i) {
                            final meta = space!.metas[i];
                            final metaDto = meta.data;
                            return ExpansionPanel(
                              canTapOnHeader: true,
                              isExpanded: _panelExpanded[i] ??= false,
                              headerBuilder: (c, ex) => TableTile(
                                openedSpace: space!,
                                openedMeta: meta,
                                selected: meta.id == widget.metaId,
                                onTap: () {
                                  context.go(workspaceRouterPathBuilder(
                                      teamId: space!.at.id,
                                      workspaceId: space!.id,
                                      metaId: meta.id));
                                },
                              ),

                              /// 构建视图列表
                              body: ListView.separated(
                                shrinkWrap: true,
                                itemCount: metaDto.views.length,
                                itemBuilder: (context, int index) =>
                                    TableViewTile(
                                  openedMeta: meta,
                                  view: metaDto.views[index],
                                  viewUri: Uri.parse(workspaceRouterPathBuilder(
                                      teamId: space!.at.id,
                                      workspaceId: space!.id,
                                      metaId: meta.id,
                                      viewId: metaDto.views[index].vId)),
                                ),
                                separatorBuilder: (ctx, i) => const Divider(),
                              ),
                            );
                          },
                        ),
                        animationDuration: const Duration(microseconds: 50),
                      ),
                    ),
                  ),

                  /// 左侧下部 新建Meta
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
                                  queryMetaFn: space!.queryMeta,
                                  allMetas: space!.allMetas,
                                ));
                                if (nMeta == null) return;
                                return await space!
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
                                    return await space!
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

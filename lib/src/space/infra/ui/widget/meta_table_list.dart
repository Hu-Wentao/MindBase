part of 'widget.dart';

class MetaTableList extends StatefulWidget {
  final String teamId;
  final List<MetaModel> metas;
  final String? markedMetaId;
  final String Function(String metaId, int? viewId) fetchMetaViewLocation;

  const MetaTableList({
    Key? key,
    required this.teamId,
    required this.fetchMetaViewLocation,
    required this.metas,
    required this.markedMetaId,
  }) : super(key: key);

  @override
  State<MetaTableList> createState() => _MetaTableListState();
}

class _MetaTableListState extends State<MetaTableList> {
  final _kMetaBuilder = GlobalKey<FormBuilderState>();
  final _kAttrBuilder = GlobalKey<FormBuilderState>();
  final _kMethodBuilder = GlobalKey<FormBuilderState>();

  List<MetaModel> get metas => widget.metas;

  String get teamId => widget.teamId;

  final _panelExpanded = <int, bool>{};

  void _onExpandedCall(int panelIndex, bool isExpanded) => setState(() {
        _panelExpanded[panelIndex] = !isExpanded;
      });

  @override
  Widget build(BuildContext context) => Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: SizedBox(
          width: 240,
          child: Stack(
            children: [
              /// 左侧上部 Meta列表
              Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: ExpansionPanelList(
                    expansionCallback: _onExpandedCall,
                    children: [
                      for (int i = 0; i < metas.length; i++)
                        ExpansionPanel(
                          canTapOnHeader: true,
                          isExpanded: _panelExpanded[i] ??= false,
                          headerBuilder: (c, ex) {
                            final meta = metas[i];
                            return TableTile(
                              meta: meta,
                              selected: meta.id == widget.markedMetaId,
                              onTap: () => context.go(
                                  widget.fetchMetaViewLocation(meta.id, null)),
                            );
                          },

                          /// 构建视图列表
                          body: Column(children: [
                            for (int j = 0; j < metas[i].data.views.length; j++)
                              TableViewTile(
                                openedMeta: metas[i],
                                view: metas[i].data.views[j],
                                viewUri: Uri.parse(widget.fetchMetaViewLocation(
                                    metas[i].id, metas[i].data.views[j].vId)),
                              ),
                          ]),
                        )
                    ],
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
                            final space = context.read<SpaceModel>();
                            final nMeta = (await showMetaModelEditDialog(
                              context: context,
                              kAttrBuilder: _kAttrBuilder,
                              kMetaBuilder: _kMetaBuilder,
                              kMethodBuilder: _kMethodBuilder,
                              queryMetaFn: space.queryMeta,
                              allMetas: space.allMetas,
                            ));
                            if (nMeta == null) return;
                            await space
                                .actEntrance(SpaceAct.insertMeta(nMeta))
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
                                return await context
                                    .read<SpaceModel>()
                                    .actEntrance(SpaceAct.updateByTable(dto))
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
      );
}

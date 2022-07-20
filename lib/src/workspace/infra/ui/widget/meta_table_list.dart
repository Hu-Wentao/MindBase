part of 'widget.dart';
class MetaTableList extends StatefulWidget {
  final OpenedWorkspace openedSpace;

  const MetaTableList({
    Key? key,
    required this.openedSpace,
  }) : super(key: key);

  @override
  State<MetaTableList> createState() => _MetaTableListState();
}

class _MetaTableListState extends State<MetaTableList> {
  final _kMetaBuilder = GlobalKey<FormBuilderState>();
  final _kAttrBuilder = GlobalKey<FormBuilderState>();
  final _kMethodBuilder = GlobalKey<FormBuilderState>();

  OpenedWorkspace get space => widget.openedSpace;

  final _panelExpanded = <int, bool>{};

  void _onExpandedCall(int panelIndex, bool isExpanded) => setState(() {
    _panelExpanded[panelIndex] = !isExpanded;
  });

  void _switchExpanded(int panelIdx) {
    _panelExpanded[panelIdx] = !(_panelExpanded[panelIdx] ??= false);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 240,
    child: Stack(
      children: [
        /// 左侧Meta列表
        Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: ExpansionPanelList(
              expansionCallback: _onExpandedCall,
              children: List.generate(
                space.openedMetas.length,
                    (i) {
                  final openedMeta = space.openedMetas[i];
                  final meta = openedMeta.meta;
                  return ExpansionPanel(
                    isExpanded: _panelExpanded[i] ??= false,
                    headerBuilder: (c, ex) => TableTile(
                        openedSpace: space,
                        openedMeta: openedMeta,
                        selected: _panelExpanded[i] ??= false,
                        onTap: () {
                          _switchExpanded(i);
                          context.go(
                              '/workspace/${widget.openedSpace.id}/meta/${meta.id}');
                        }),

                    /// 构建视图列表
                    body: ListView.separated(
                        shrinkWrap: true,
                        itemCount: meta.views.length,
                        itemBuilder: (context, int index) => TableViewTile(
                          openedMeta: openedMeta,
                          view: meta.views[index],
                          viewUri: Uri.parse(
                              '/workspace/${space.id}/meta/${openedMeta.meta.id}/view/${meta.views[index].vId}'),
                        ),
                        separatorBuilder: (ctx, i) => const Divider()),
                  );
                },
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
                        queryMetaFn: space.queryMeta,
                        allMetas: space.allMetas,
                      ));
                      if (nMeta == null) return;
                      return await space
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
                          return await space
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

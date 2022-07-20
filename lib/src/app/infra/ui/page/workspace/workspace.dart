import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/feedback/infra/ui/widget/feedback_btn.dart';
import 'package:mind_base/src/user/infra/ui/components/user_tile.dart';
import 'package:mind_base/src/workspace/application/model/model.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/data_table_grid.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/space_selector_bar.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/widget.dart';
import 'package:provider/provider.dart';

/// 工作空间页
class WorkspacePage extends StatefulWidget {
  const WorkspacePage({
    Key? key,
    this.workspaceId,
    this.metaId,
    this.viewId,
  }) : super(key: key);

  final String? workspaceId;
  final String? metaId;
  final int? viewId;

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  String? workspaceId;

  String? metaId;

  int? viewId;

  @override
  void initState() {
    super.initState();
    workspaceId = widget.workspaceId;
    metaId = widget.metaId;
    viewId = widget.viewId;
  }

  @override
  void didUpdateWidget(WorkspacePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    workspaceId = widget.workspaceId;
    metaId = widget.metaId;
    viewId = widget.viewId;
  }

  @override
  Widget build(BuildContext context) => Consumer<OpenedSpaceManagerModel>(
      builder: (c, model, _) => FutureBuilder(
          key: ValueKey(workspaceId),
          future: model.actOpenWorkspaceById(workspaceId!),
          builder: (c, s) {
            switch (s.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Scaffold(body: CircularProgressIndicator());
              case ConnectionState.done:
                final space = model.openedWorkspaces
                    .firstWhere((element) => element.id == workspaceId);
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.home_rounded),
                      onPressed: () => context.go('/'),
                    ),
                    title: SpaceSelectorBar(
                      spaceName: space.name,
                      menuBtn: PopupMenuButton<String>(
                        itemBuilder: (ctx) => [
                          ...model.openedWorkspaces.map(
                            (e) => PopupMenuItem<String>(
                              value: 'selectWorkspaceEvt${e.id}',
                              child: ListTile(
                                leading:
                                    const Icon(Icons.space_dashboard_rounded),
                                title: Text(e.name),
                              ),
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          // 选中Item后,在这里会被二次调用
                          switch (value) {
                            default:
                              if (value.startsWith('selectWorkspaceEvt')) {
                                final wsId = value
                                    .substring('selectWorkspaceEvt'.length);
                                context.go('/workspace/$wsId');
                                return;
                              }
                              print("debug#未知的value#$value");
                              break;
                          }
                        },
                      ),
                    ),
                    // title: const WorkspaceSelectorTitle(),
                    actions: const [
                      UserInfoTile(),
                      FeedbackBtn(),
                    ],
                  ),
                  body: ChangeNotifierProvider<OpenedWorkspace?>.value(
                    value: space,
                    child: ChangeNotifierProvider<OpenedMeta?>.value(
                      value: space.openedMetas
                          .firstWhereOrNull((element) => element.id == metaId),
                      child: Row(
                        children: [
                          /// 左侧Meta List
                          MetaTableList(openedSpace: space),

                          /// 右侧 table
                          Consumer<OpenedMeta?>(
                            builder: (c, openedMeta, _) => (openedMeta == null)
                                ? const Expanded(
                                    child: Center(child: Text("请选择/创建 一个Meta")),
                                  )
                                : RecordDataGrid(
                                    openedSpace: space,
                                    openedMeta: openedMeta,
                                    view: openedMeta.meta.views
                                        .firstWhereOrNull(
                                            (element) => element.vId == viewId),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
            }
          }));
}

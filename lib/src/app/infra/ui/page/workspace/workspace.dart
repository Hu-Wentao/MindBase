import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<OpenedSpaceManagerModel>(context, listen: false)
          .actOpenWorkspaceById(workspaceId!)
          .then((value) {
        if (value != null) {
          value.showDialog(context);
        }
        return Future.delayed(
            const Duration(milliseconds: 500), () => setState(() {}));
      });
    });
  }

  @override
  void didUpdateWidget(WorkspacePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    workspaceId = widget.workspaceId;
    metaId = widget.metaId;
    viewId = widget.viewId;
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<OpenedSpaceManagerModel>(builder: (c, model, _) {
        final space = model.openedWorkspaces
            .firstWhereOrNull((element) => element.id == workspaceId);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.home_rounded),
              onPressed: () => context.go('/'),
            ),
            title: SpaceSelectorBar(
              spaceName: Text(space?.name ?? 'loading ...'),
              menuBtn: PopupMenuButton<String>(
                itemBuilder: (ctx) => [
                  ...model.openedWorkspaces.map(
                    (e) => PopupMenuItem<String>(
                      value: 'selectWorkspaceEvt${e.id}',
                      child: ListTile(
                        leading: const Icon(Icons.space_dashboard_rounded),
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
                        final wsId =
                            value.substring('selectWorkspaceEvt'.length);
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
              value: metaId == ''
                  ? null
                  : space?.openedMetas
                      .firstWhereOrNull((element) => element.id == metaId),
              child: Consumer<OpenedWorkspace?>(
                builder: (c, space, _) => Row(
                  children: [
                    /// 左侧Meta 列表
                    MetaTableList(
                      key: ValueKey(space?.metas.length),
                      openedSpace: space,
                      metaId: metaId,
                    ),

                    /// 右侧 table
                    if (space != null)
                      Consumer<OpenedMeta?>(
                        builder: (c, openedMeta, _) => (openedMeta == null)
                            ? const Expanded(
                                child: Center(child: Text("请选择/创建 一个Meta")),
                              )
                            : RecordDataGrid(
                                openedSpace: space,
                                openedMeta: openedMeta,
                                view: viewId == -1 // -1代表无视图
                                    ? null
                                    : openedMeta.meta.views.firstWhereOrNull(
                                        (element) => element.vId == viewId)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

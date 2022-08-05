import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_base/src/app/config/common_config.dart';
import 'package:mind_base/src/app/infra/ui/app.dart';
import 'package:mind_base/src/core/domain/exceptions/exceptions.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/feedback/infra/ui/widget/feedback_btn.dart';
import 'package:mind_base/src/app/application/model/model.dart';
import 'package:mind_base/src/user/infra/ui/components/user_tile.dart';
import 'package:mind_base/src/workspace/application/model/model.dart';
import 'package:mind_base/src/workspace/infra/ui/dialog/collection_edit_dialog.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/data_table_grid.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/space_selector_bar.dart';
import 'package:mind_base/src/workspace/infra/ui/widget/widget.dart';
import 'package:provider/provider.dart';

/// 工作空间页
class WorkspacePage extends StatefulWidget {
  const WorkspacePage({
    Key? key,
    required this.teamId,
    this.workspaceId,
    this.metaId,
    this.viewId,
  }) : super(key: key);
  final String teamId;
  final String? workspaceId;
  final String? metaId;
  final int? viewId;

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  String? teamId;
  String? workspaceId;
  String? metaId;
  int? viewId;

  final StreamController<TeamModel?> __modelStreamController =
      StreamController<TeamModel?>();
  late final Future<TeamModel?> _futureTeamModel =
      __modelStreamController.stream.first;

  @override
  void initState() {
    super.initState();
    workspaceId = widget.workspaceId;
    teamId = widget.teamId;
    metaId = widget.metaId;
    viewId = widget.viewId;
    assert(() {
      slLogger.info('[$runtimeType] initState ${workspaceRouterPathBuilder(
        teamId: teamId,
        workspaceId: workspaceId,
        metaId: metaId,
        viewId: viewId,
      )}');
      return true;
    }());
    Future.microtask(() async {
      try {
        final model = context.read<UserModel>();
        // 加载并返回Team
        final team = await model.actLoadTeam(teamId!).then((value) {
          if (value != null) throw value;
          return model.teams.firstWhere((t) => t.id == teamId);
        }).onError((error, stackTrace) {
          throw ExceptionAdapter.of(error, stackTrace);
        });
        __modelStreamController.add(team);
        // 加载 Workspace
        team.workspaces
            .firstWhere((space) => space.id == workspaceId)
            .actInitSubscription();
      } catch (e, s) {
        final err = ExceptionAdapter.of(e, s);
        err.showDialog(context);
      }
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
  Widget build(BuildContext context) => FutureBuilder<TeamModel?>(
        future: _futureTeamModel,
        builder: (c, s) => (s.data == null)
            ? (s.connectionState != ConnectionState.done)
                ? Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.home_rounded),
                        onPressed: () => context.go('/'),
                      ),
                      title: const Text("加载中 ..."),
                      actions: const [
                        UserInfoTile(),
                        FeedbackBtn(),
                      ],
                    ),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Text.rich(
                            TextSpan(children: [
                              const TextSpan(text: '长时间无响应请尝试 刷新页面 '),
                              const TextSpan(text: '或'),
                              WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: TextButton(
                                    child: Text(
                                      '回到首页',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(color: Colors.blueAccent),
                                    ),
                                    onPressed: () => context.go('/'),
                                  )),
                            ]),
                          ),
                        ),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  )
                : Center(child: Text('${s.error}'))
            : ChangeNotifierProvider<TeamModel>.value(
                value: s.data!,
                child: Consumer<TeamModel>(builder: (c, model, _) {
                  final space = model.workspaces
                      .firstWhereOrNull((sp) => sp.id == workspaceId);
                  return Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.home_rounded),
                        onPressed: () => context.go('/'),
                      ),
                      title: _buildTitle(context, model, space),
                      // title: const WorkspaceSelectorTitle(),
                      actions: const [
                        UserInfoTile(),
                        FeedbackBtn(),
                      ],
                    ),
                    body: ChangeNotifierProvider<WorkspaceModel?>.value(
                      value: space,
                      child: ChangeNotifierProvider<MetaModel?>.value(
                        value: metaId == ''
                            ? null
                            : space?.metas
                                .firstWhereOrNull((m) => m.id == metaId),
                        child: Consumer<WorkspaceModel?>(
                          builder: (c, space, _) => Row(
                            children: [
                              /// 左侧Meta 列表
                              MetaTableList(
                                key: ValueKey(space?.metas.length),
                                space: space,
                                metaId: metaId,
                              ),

                              /// 右侧 table
                              if (space != null)
                                Consumer<MetaModel?>(
                                  builder: (c, meta, _) => (meta == null)
                                      ? const Expanded(
                                          child: Center(
                                              child: Text("请选择/创建 一个Meta")),
                                        )
                                      : RecordDataGrid(
                                          openedSpace: space,
                                          openedMeta: meta,
                                          view: viewId == -1 // -1代表无视图
                                              ? null
                                              : meta.data.views
                                                  .firstWhereOrNull((element) =>
                                                      element.vId == viewId)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
      );

  _buildTitle(BuildContext context, TeamModel model, WorkspaceModel? space) =>
      Row(
        children: [
          SpaceSelectorBar(
            spaceName: Text(space?.name ?? 'loading ...'),
            menuBtn: PopupMenuButton<String>(
              itemBuilder: (ctx) => [
                ...model.workspaces.map(
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
                      final wsId = value.substring('selectWorkspaceEvt'.length);
                      context.go(workspaceRouterPathBuilder(
                          teamId: model.id, workspaceId: wsId));
                      return;
                    }
                    print("debug#未知的value#$value");
                    break;
                }
              },
            ),
          ),
          if (space != null)
            Tooltip(
              message: '修改表权限',
              child: TextButton.icon(
                onPressed: () async {
                  final data = space.metaCollection.dto;
                  if (data == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("集合权限信息正在加载中,请稍后再试"),
                    ));
                    space.actRefresh().thenDialog(context);
                    return;
                  } else {
                    final dto = await showCollectionEditDialog(
                        context, data, space.at.id);
                    if (dto == null) return;
                    final userId = context.read<UserModel>().id;
                    final teamOwnerId = space.at.teamOwner?.userId;
                    space.metaCollection
                        .actUpdateCollection(userId, teamOwnerId, dto)
                        .thenDialog(context);
                  }
                },
                icon: const Icon(Icons.shield_outlined, color: Colors.white),
                label: const Text("修改权限"),
              ),
            ),
        ],
      );
}

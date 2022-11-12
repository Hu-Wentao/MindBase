import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_sweet/get_sweet.dart';
import 'package:mind_base/src/app/infra/ui/page/home/home.dart';
import 'package:mind_base/src/core/infra/ui/exception_router/exception_router.dart';
import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/user/infra/ui/components/user_tile.dart';
import 'package:mind_base/src/space/infra/ui/dialog/collection_edit_dialog.dart';
import 'package:mind_base/src/space/infra/ui/widget/data_table_grid.dart';
import 'package:mind_base/src/space/infra/ui/widget/space_selector_bar.dart';
import 'package:mind_base/src/space/infra/ui/widget/widget.dart';
import 'package:provider_sidecar/provider_sidecar_ex.dart';

/// 工作空间页 todo 考虑该为stateless
class SpaceModelPage extends StatelessWidget {
  const SpaceModelPage({
    Key? key,
    required this.teamId,
    required this.spaceId,
    required this.metaId,
    required this.viewId,
  }) : super(key: key);
  final String teamId;
  final String spaceId;
  final String metaId;
  final int viewId;

  String? get realMetaId => metaId.takeIf((_) => _ != 'null');

  int? get realViewId => viewId.takeIf((_) => _ != -1);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProxyProvider<UserModel, TeamModel?>.value(
              update: (c, m, o) => m.findTeam(teamId)),
          ChangeNotifierProxyProvider<TeamModel?, SpaceModel?>.value(
              update: (c, m, o) => m?.findSpace(spaceId)),
          ChangeNotifierProxyProvider<SpaceModel?, MetaModel?>.value(
              update: (c, m, o) =>
                  m?.findMeta(realMetaId) ?? m?.metas.firstOrNull),
          // MetaModel
        ],
        child: SpaceView(markedMetaId: realMetaId, viewId: realViewId),
      );
}

class SpaceView extends StatefulWidget {
  final String? markedMetaId;
  final int? viewId;

  const SpaceView({Key? key, required this.markedMetaId, this.viewId})
      : super(key: key);

  @override
  State<SpaceView> createState() => _SpaceViewState();
}

class _SpaceViewState extends State<SpaceView>
    with OnInitStateMx<SpaceView, SpaceModel> {
  @override
  onInitState(ScaffoldMessengerState msgr, SpaceModel a) {
    a.actEntrance(const SpaceAct.initModel());
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TeamModel?, SpaceModel?>(
        builder: (c, mTeam, mSpace, _) => Scaffold(
              appBar: _buildAppBar(
                context,
                _buildTitle(context, mTeam, mSpace),
              ),
              body: (mTeam == null || mSpace == null)
                  ? _buildWaitingView(context)
                  : Row(
                      children: [
                        /// 左侧Meta 列表
                        MetaTableList(
                          key: ValueKey(mSpace.metas.length),
                          teamId: mTeam.id,
                          metas: mSpace.metas,
                          markedMetaId: widget.markedMetaId,
                          fetchMetaViewLocation: (String metaId, int? viewId) =>
                              SpaceRoute.auto(
                                      teamId: mTeam.id,
                                      spaceId: mSpace.id,
                                      metaId: metaId,
                                      viewId: viewId ?? -1)
                                  .location,
                        ),

                        /// 右侧 table
                        Consumer<MetaModel?>(
                          builder: (c, meta, _) => (meta == null)
                              ? const Expanded(
                                  child: Center(child: Text("请选择/创建 一个Meta")))
                              : RecordDataGrid(
                                  space: mSpace,
                                  meta: meta,
                                  view: widget.viewId == null
                                      ? null
                                      : meta.data.views.firstWhereOrNull(
                                          (_) => _.vId == widget.viewId)),
                        ),
                      ],
                    ),
            ));
  }

  _buildTitle(BuildContext context, TeamModel? mTeam, SpaceModel? mSpace) =>
      Row(
        children: [
          SpaceSelectorBar(
            spaceName: Text(mSpace?.name ?? 'loading ...'),
            menuBtn: (mTeam == null)
                ? const CircularProgressIndicator()
                : PopupMenuButton<String>(
                    itemBuilder: (ctx) => [
                      for (final space in mTeam.workspaces)
                        PopupMenuItem<String>(
                          value: 'selectSpaceModelEvt${space.id}',
                          child: ListTile(
                            leading: const Icon(Icons.space_dashboard_rounded),
                            title: Text(space.name),
                          ),
                        ),
                    ],
                    onSelected: (value) {
                      // 选中Item后,在这里会被二次调用
                      switch (value) {
                        default:
                          if (value.startsWith('selectSpaceModelEvt')) {
                            final spaceId =
                                value.substring('selectSpaceModelEvt'.length);
                            SpaceRoute.auto(
                              teamId: mTeam.id,
                              spaceId: spaceId,
                            ).go(context);
                            return;
                          }
                          print("debug#未知的value#$value");
                          break;
                      }
                    },
                  ),
          ),
          if (mTeam != null && mSpace != null)
            Tooltip(
              message: '修改表权限',
              child: TextButton.icon(
                onPressed: () async {
                  final data = mSpace.metaTableDetailDto;
                  if (data == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("集合权限信息正在加载中,请稍后再试"),
                    ));
                    mSpace
                        .actEntrance(const SpaceAct.initModel())
                        .thenDialog(context);
                    return;
                  } else {
                    final dto =
                        await showCollectionEditDialog(context, data, mTeam.id);
                    if (dto == null) return;
                    mSpace
                        .actEntrance(SpaceAct.updateTableDetail(dto))
                        // .actUpdateCollection(userId, teamOwnerId, dto)
                        .thenDialog(context);
                  }
                },
                icon: const Icon(Icons.shield_outlined, color: Colors.white),
                label: const Text("修改权限"),
              ),
            ),
        ],
      );

  _buildAppBar(BuildContext context, Widget title) => AppBar(
        leading: Tooltip(
          message: '回到首页',
          child: IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: () => const HomeRoute.auto().go(context),
          ),
        ),
        title: title,
        actions: const [
          UserInfoTile(),
        ],
      );

  _buildWaitingView(BuildContext context) => Column(
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
                      onPressed: () => const HomeRoute.auto().go(context),
                    )),
              ]),
            ),
          ),
          const Center(child: CircularProgressIndicator()),
        ],
      );
}

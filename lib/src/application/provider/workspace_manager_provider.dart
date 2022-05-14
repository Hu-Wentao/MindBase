import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/domain/repo/repo.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

/// 管理用户名下的所有工作空间
class WorkspaceManagerProvider extends ProviderSidecar {
  late final WorkspaceRepo _workspaceRepo;
  final List<Workspace> _cachedWorkspaces = [];

  @override
  onInitializing() {
    _workspaceRepo = sl<WorkspaceRepo>();

  }
}

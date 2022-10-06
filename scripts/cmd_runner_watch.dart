import 'utils.dart';
import 'utils_runner.dart';

main() async {
  await cmdRunBuildRunner(
    sdkPath: '/Users/huwentao/fvm/versions/3.3.3/bin/',
    runnerTp: RunnerTp.watch,
    deleteConflicting: true,
  ).printProcess();
}

import 'dart:io';

import 'utils_build_apk.dart';
import 'utils.dart';
import 'utils_git.dart';
import 'utils_message.dart';

main() async {
  const buildTp = ApkBuildTp.release;
  const envSign = EnvSign.prod;

  print("stage0 overview");
  final commit =
      (await cmdGitLog().printProcess()).first.split('\n').skip(4).join('\n');

  print("stage1 build");
  await cmdRunFlutterBuildApk(
    buildTp: buildTp,
    envSign: envSign,
  ).printProcess();

  print("stage2 move");
  final projectRootPath = shScriptFileFolder.parentPath;
  final version = File('$projectRootPath/pubspec.yaml')
      .readAsLinesSync()
      .firstWhere((element) => element.startsWith("version:"))
      .replaceAll(RegExp(r"version: "), '');
  final targetFile = "deng_kun-v$version-${buildTp.name}.apk";

  final source = cmdCopyApk_realApkPath(
    buildTp: buildTp,
    projectRootPath: projectRootPath,
  );
  final target = cmdCopyApk_realTargetPath(
    buildTp: buildTp,
    projectRootPath: projectRootPath,
    targetFile: targetFile,
  );
  await shCopy(source: source, target: target).printProcess();

  // print("stage3 upload");
  // final file = target;
  // await cmdCurlUpload(
  //   url: "http://120.55.164.108:6820/commonUpload/uploadFlutter",
  //   file: file,
  // ).printProcess();

  // print("stage4 message");
  // final download = "https://www.epcsaas.com/download/$targetFile";
  // final content = "App v$version 已发布\n"
  //     "[更新概览]\n"
  //     '$commit'
  //     "[配置]\n"
  //     "buildTp [$buildTp], envSign [$envSign]\n"
  //     "[下载地址]\n"
  //     "$download";
  // await cmdCurlDingDingRobotText(
  //   acToken: 'c1b1e74d5ed116d7eb8cb07190f30a137a0b5bef0f30ec3ccef5aab68a035d94',
  //   keyword: '登鲲',
  //   content: content,
  // ).printProcess();
}

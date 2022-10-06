import 'dart:io';

import 'utils.dart';

enum ApkBuildTp { debug, profile, release, flavor }

enum EnvSign { dev, uat, prod }

/// 构建Apk
Future<Process> cmdRunFlutterBuildApk({
  ApkBuildTp buildTp = ApkBuildTp.release,
  EnvSign envSign = EnvSign.prod,
}) async =>
    await (Process.start("flutter", [
      "build",
      "apk",
      "--${buildTp.name}",
      "--dart-define=EnvSign=${envSign.index}",
    ]));

/// 拷贝产物
Future<Process> cmdCopyApk({
  required ApkBuildTp buildTp,
  required String projectRootPath,
  String apkPath = "{projectRootPath}/build/app/outputs/flutter-apk/",
  String apkFile = "app-{buildTp.name}.apk",
  String targetPath = "{projectRootPath}/scripts/results/",
  String targetFile = "deng_kun-{buildTp.name}.apk",
}) async {
  final realAkpPath = cmdCopyApk_realApkPath(
    buildTp: buildTp,
    projectRootPath: projectRootPath,
    apkPath: apkPath,
    apkFile: apkFile,
  );
  final realTargetPath = cmdCopyApk_realTargetPath(
    buildTp: buildTp,
    projectRootPath: projectRootPath,
    targetPath: targetPath,
    targetFile: targetFile,
  );
  return await shCopy(
    source: realAkpPath,
    target: realTargetPath,
  );
}

String cmdCopyApk_realApkPath({
  required ApkBuildTp buildTp,
  required String projectRootPath,
  String apkPath = "{projectRootPath}/build/app/outputs/flutter-apk/",
  String apkFile = "app-{buildTp.name}.apk",
}) =>
    '${apkPath.replaceAll("{projectRootPath}", projectRootPath)}'
    '${apkFile.replaceAll('{buildTp.name}', buildTp.name)}';

String cmdCopyApk_realTargetPath({
  required ApkBuildTp buildTp,
  required String projectRootPath,
  String targetPath = "{projectRootPath}/scripts/results/",
  String targetFile = "deng_kun-{buildTp.name}.apk",
}) =>
    '${targetPath.replaceAll("{projectRootPath}", projectRootPath)}'
    '${targetFile.replaceAll('{buildTp.name}', buildTp.name)}';

// curl -X POST "http://120.55.164.108:6820/commonUpload/uploadFlutter" -H "accept: */*" -H "Content-Type: multipart/form-data" -F "file=@deng_kun-release.apk;type=application/vnd.android.package-archive"
Future<Process> cmdCurlUpload({
  required String url,
  required String file,
}) async {
  final fullHeaders = {
    "accept": "*/*",
    "Content-Type": "multipart/form-data",
  };

  // -X POST "http://120.55.164.108:6820/commonUpload/uploadFlutter"
  final pPost = ["-X", "POST", url];
  // '-H "accept: */*" -H "Content-Type: multipart/form-data"'
  final pHeaders =
      fullHeaders.entries.expand((e) => ["-H", '${e.key}: ${e.value}']);
  // -F "file=@deng_kun-release.apk;type=application/vnd.android.package-archive"
  final pFile = [
    "-F",
    "file=@$file",
    "type=application/vnd.android.package-archive"
  ];
  final params = [...pPost, ...pHeaders, ...pFile];
  print("curl# $params");
  return await Process.start("curl", params);
}

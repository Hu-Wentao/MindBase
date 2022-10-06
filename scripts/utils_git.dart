import 'dart:io';

/// 返回最近一次提交内容
Future<Process> cmdGitLog({int revisionRange = 1, bool oneLine = false}) async {
  return await Process.start('git', [
    'log',
    '-n',
    '$revisionRange',
    if (oneLine) '--oneline',
  ]);
}

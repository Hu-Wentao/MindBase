import 'dart:convert';
import 'dart:io';

/// extension

/// 打印 Process输出
extension PrintFutureProcessX on Future<Process> {
  Stream<String> processStdOut() async* {
    final r = (await this);
    yield* r.stdout.map((e) => utf8.decoder.convert(e));
  }

  Future<List<String>> printProcess() async => await processStdOut().map((_) {
        print("proc# $_");
        return _;
      }).toList();
}

extension PathStringX on String {
  String get parentPath {
    final i = lastIndexOf(Platform.pathSeparator);
    final r = substring(0, i);
    return (i + 1 == length) ? r.parentPath : r;
  }

  Uri get toPathUri => Uri.directory(this, windows: Platform.isWindows);
}

/// command

/// 复制
Future<Process> shCopy({
  required String source,
  required String target,
  bool autoCreateFolder = true,
}) async {
  // 自动创建文件夹
  if (autoCreateFolder) shMakeDir(target.parentPath);
  return await Process.start("cp", [
    source,
    target,
  ]).then((e) {
    print("shCopy# Copy $source to $target");
    return e;
  });
}

void shMakeDir(String path) {
  final uri = path.toPathUri;
  Directory.fromUri(uri).createSync(recursive: true);
  print("shMakeDir# $uri");
}

///  /Users/.../scripts/utils.dart
String get shScriptFile => Platform.script.path;

/// /Users/.../scripts
String get shScriptFileFolder => shScriptFile.parentPath;

import 'dart:convert';
import 'dart:io';

import 'utils.dart';

// curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=693axxx6-7aoc-4bc4-97a0-0ec2sifa5aaa' \
// -H 'Content-Type: application/json' \
// -d '
// {
// "msgtype": "text",
// "text": {
// "content": "hello world"
// }
// }'
Future<Process> cmdCurlWxRobotText({
  required String robotKey,
  required String content,
}) async {
  final fullUrl =
      'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=$robotKey';
  final fullHeaders = {
    "Content-Type": "application/json",
  };

  // '-H "accept: */*" -H "Content-Type: multipart/form-data"'
  final pHeaders =
      fullHeaders.entries.expand((e) => ["-H", '${e.key}: ${e.value}']);
  // -d
  final testData = [
    "-d",
    jsonEncode({
      "msgtype": "text",
      "text": {
        "content": content,
      }
    }),
  ];
  final params = [
    fullUrl,
    ...pHeaders,
    ...testData,
  ];
  print("curl# $params");
  return await Process.start("curl", params);
}

/// [keyword] 机器人设置"关键字安全"时使用，加在消息开头。
Future<Process> cmdCurlDingDingRobotText({
  required String acToken,
  required String content,
  String keyword = '',
}) async {
  final fullUrl = 'https://oapi.dingtalk.com/robot/send?access_token=$acToken';
  final fullHeaders = {
    "Content-Type": "application/json",
  };

  // '-H "accept: */*" -H "Content-Type: multipart/form-data"'
  final pHeaders =
      fullHeaders.entries.expand((e) => ["-H", '${e.key}: ${e.value}']);
  // -d
  final testData = [
    "-d",
    jsonEncode({
      "msgtype": "text",
      "text": {
        "content": '$keyword$content',
      }
    }),
  ];
  final params = [
    fullUrl,
    ...pHeaders,
    ...testData,
  ];
  print("curl# ${params.join(" ")}");
  return await Process.start("curl", params);
}

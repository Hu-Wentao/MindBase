import 'package:appwrite/appwrite.dart';
import 'package:dart_appwrite/models.dart' as srv;
import 'package:get_sweet/get_sweet.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';

/// 适配 0.15.x > 1.0.x
class ApAdapter {
  static List<String> anyOneCrudPermit = [
    Permission.read(Role.any()),
    Permission.write(Role.any()),
  ];

  static List<String> teamMemberCrudPermit(String teamId) => [
        Permission.read(Role.team(teamId)),
        Permission.write(Role.team(teamId)),
      ];

  static List<String> toPermissions(CollectionDto collection) =>
      toPermitBy(reads: collection.reads, writes: collection.writes);

  static List<String> toPermitBy({List<String>? reads, List<String>? writes}) =>
      [
        if (reads != null) ...reads.map((e) => Permission.read(e)),
        if (writes != null)
          ...writes
              .map((e) => [
                    Permission.write(e),
                  ])
              .expand((element) => element)
      ];

  static List<String> parsePermitToRead(srv.Collection collection) =>
      collection.$permissions
          .takeIf<List>((_) => _.isNotEmpty)
          ?.let<List, List<String>?>((it) => (it.map((e) => e as String))
              .where((e) => e.startsWith(RegExp(r'read')))
              .map((e) => e.replaceAllMapped(
                  RegExp(r'.+\(\"(.+)\"\)'), (m) => m.group(1) ?? ''))
              .toList()) ??
      [];

  static List<String> parsePermitToWrite(srv.Collection collection) =>
      collection.$permissions
          .takeIf<List>((_) => _.isNotEmpty)
          ?.let<List, List<String>?>((it) => (it.map((e) => e as String))
              .where((e) => e.startsWith(RegExp(r'write|create|update|delete')))
              .map((e) => e.replaceAllMapped(
                  RegExp(r'.+\(\"(.+)\"\)'), (m) => m.group(1) ?? ''))
              .toList()) ??
      [];
}

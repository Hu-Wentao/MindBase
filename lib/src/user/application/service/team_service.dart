part of '../service.dart';

@lazySingleton
class TeamService {
  final cli.Teams _teams;
  final srv.Teams _srvTeams;

  TeamService(this._teams, this._srvTeams);

  Future<List<Team>> getTeams() async {
    return (await _teams.list()).teams;
  }

  Future<Team> updateNameBy(String teamId, String name) async =>
      await _teams.update(teamId: teamId, name: name);

  Future<void> deleteTeam(String teamId) async =>
      await _teams.delete(teamId: teamId);

  /// 直接拉取用户到团队,无需同意.
  Future<void> inviteMember(
    Team team,
    String userEmail, [
    List<String> roles = const [],
  ]) async {
    final r = await _srvTeams.createMembership(
      teamId: team.$id,
      email: userEmail,
      roles: [],
      // roles: roles ?? ["team:${team.$id}"], // 默认角色为 "团队成员"
      url: 'http://app.shuttlecloud.cn',
    );
    // print("debug member ${r.toMap()}");
  }

  Future<Team> createTeam(String name) async {
    final r = await _teams.create(teamId: ObjectIdX.createHex, name: name);
    return r;
  }

  /// 获取团队
  Future<Team> getTeam(String teamId) async {
    final tm = await _srvTeams.get(teamId: teamId);
    final mp = tm.toMap();
    return Team.fromMap(mp);
  }

  Future<MembershipList> getMemberships({required String teamId}) =>
      _teams.listMemberships(teamId: teamId);
}

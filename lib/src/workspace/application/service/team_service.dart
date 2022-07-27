part of 'service.dart';

@lazySingleton
class TeamService {
  final Teams _teams;
  final srv.Teams _srvTeams;

  TeamService(this._teams, this._srvTeams);

  Future<List<aw.Team>> getTeams() async {
    return (await _teams.list()).teams;
  }

  Future<aw.Team> updateName(aw.Team team, String newName) async {
    return await _teams.update(teamId: team.$id, name: newName);
  }

  Future<void> deleteTeam(String teamId) async =>
      await _teams.delete(teamId: teamId);

  /// 直接拉取用户到团队,无需同意.
  Future<void> inviteMember(
    aw.Team team,
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
    print("debug member ${r.toMap()}");
  }

  Future<aw.Team> createTeam(String name) async {
    final r = await _teams.create(teamId: ObjectIdX.createHex, name: name);
    return r;
  }

  /// 获取团队
  Future<aw.Team> getTeam(String teamId) async => _teams.get(teamId: teamId);
}

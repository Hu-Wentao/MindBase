import 'package:appwrite/appwrite.dart' as cli;
import 'package:appwrite/models.dart' as md;

typedef User = md.Account;

abstract class RoleX {
  static String owner(String teamId) => cli.Role.team(teamId, 'owner');
}

typedef Session = md.Session;

typedef Team = md.Team;
typedef Member = md.Membership;

typedef MembershipList = md.MembershipList;


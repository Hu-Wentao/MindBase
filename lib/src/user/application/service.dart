import 'package:appwrite/appwrite.dart' as cli;
import 'package:dart_appwrite/dart_appwrite.dart' as srv;
import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/user/inter/dto.dart';
import 'package:mind_base/src/space/domain/value/value.dart';

part 'service/team_service.dart';

@lazySingleton
class AccountService {
  final cli.Account account;

  AccountService(this.account);

  Future<Session> login({
    required String email,
    required String password,
  }) {
    return account.createEmailSession(email: email, password: password);
  }

  Future<User> signup({
    String? name,
    required String email,
    required String password,
    String userId = 'unique()',
  }) =>
      account.create(
        userId: userId,
        name: name,
        email: email,
        password: password,
      );

  Future logout([String? sessionId]) =>
      account.deleteSession(sessionId: sessionId ?? 'current');

  Future<User> getUser() async => await account.get();

  Future<Session> getSession({String sessionId = 'current'}) =>
      account.getSession(sessionId: sessionId);

  Future<Session> createAnonymousSession() =>
      account.createAnonymousSession();
}

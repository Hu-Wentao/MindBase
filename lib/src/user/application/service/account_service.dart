import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get_arch_core/get_arch_core.dart';

@lazySingleton
class AccountService {
  final Account account;

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

  Future logout(String sessionId) => account.deleteSession(sessionId: sessionId);

  Future<User> getUser() async => await account.get();
}

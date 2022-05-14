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
    return account.createSession(email: email, password: password);
  }

  Future signup({
    required String name,
    required String email,
    required String password,
  }) {
    return account.create(
        name: name, email: email, password: password, userId: 'unique()');
  }

  Future logout() {
    return account.deleteSession(sessionId: 'current');
  }

  Future<User> getUser() async => await account.get();
}

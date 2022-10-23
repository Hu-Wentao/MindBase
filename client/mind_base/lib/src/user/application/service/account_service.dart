part of '../service.dart';

@lazySingleton
class AccountService {
  final cli.Account _actSrv;

  AccountService(this._actSrv);

  Future<Session> login({
    required String email,
    required String password,
  }) {
    return _actSrv.createEmailSession(email: email, password: password);
  }

  Future<User> signup({
    String? name,
    required String email,
    required String password,
    String userId = 'unique()',
  }) =>
      _actSrv.create(
        userId: userId,
        name: name,
        email: email,
        password: password,
      );

  Future logout([String? sessionId]) =>
      _actSrv.deleteSession(sessionId: sessionId ?? 'current');

  Future<User> getUser() async => await _actSrv.get();

  Future<Session> getSession({String sessionId = 'current'}) =>
      _actSrv.getSession(sessionId: sessionId);

  Future<Session> createAnonymousSession() => _actSrv.createAnonymousSession();
}

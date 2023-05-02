abstract class IAuthenticationService {
  bool get isAuthorized;

  String? get currentUserName;

  Future<bool> authenticate(String username);

  Future<bool> unAuthenticate();
}

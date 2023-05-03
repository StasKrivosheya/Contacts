abstract class IAuthenticationService {
  bool get isAuthorized;

  int? get currentUserId;

  Future<bool> authenticate(int userId);

  Future<bool> unAuthenticate();
}

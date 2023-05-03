import 'package:contacts/src/helpers/app_settings.dart';

import 'i_authentication_service.dart';

class AuthenticationService implements IAuthenticationService {
  const AuthenticationService();

  @override
  bool get isAuthorized => currentUserId != null;

  @override
  int? get currentUserId => AppSettings.getUserId();

  @override
  Future<bool> authenticate(int userId) {
    return AppSettings.setUserId(userId);
  }

  @override
  Future<bool> unAuthenticate() {
    return AppSettings.removeUserId();
  }
}

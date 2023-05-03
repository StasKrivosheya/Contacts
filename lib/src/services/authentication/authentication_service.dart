import 'package:contacts/src/helpers/app_settings.dart';

import 'i_authentication_service.dart';

class AuthenticationService implements IAuthenticationService {
  const AuthenticationService();

  @override
  bool get isAuthorized => currentUserName != null;

  @override
  String? get currentUserName => AppSettings.getLogin();

  @override
  Future<bool> authenticate(String username) {
    return AppSettings.setLogin(username);
  }

  @override
  Future<bool> unAuthenticate() {
    return AppSettings.removeLogin();
  }
}

import 'package:contacts/src/services/app_settings/i_app_settings.dart';

import 'i_authentication_service.dart';

class AuthenticationService implements IAuthenticationService {
  const AuthenticationService({required IAppSettings appSettings})
      : _appSettings = appSettings;

  final IAppSettings _appSettings;

  @override
  bool get isAuthorized => currentUserId != null;

  @override
  int? get currentUserId => _appSettings.getCurrentUserId();

  @override
  Future<bool> authenticate(int userId) {
    return _appSettings.setCurrentUserId(userId);
  }

  @override
  Future<bool> unAuthenticate() {
    return _appSettings.removeCurrentUserId();
  }
}

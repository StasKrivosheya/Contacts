import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String _keyUsername = "username";

  static SharedPreferences? _sharedPreferences;

  static Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setLogin(String username) {
    return _sharedPreferences!.setString(_keyUsername, username);
  }

  static String? getLogin() {
    return _sharedPreferences!.getString(_keyUsername);
  }

  static Future<bool> removeLogin() {
    return _sharedPreferences!.remove(_keyUsername);
  }
}

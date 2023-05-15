import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String _keyUserId = "userId";

  static SharedPreferences? _sharedPreferences;

  static Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setUserId(int userId) {
    return _sharedPreferences!.setInt(_keyUserId, userId);
  }

  static int? getUserId() {
    return _sharedPreferences!.getInt(_keyUserId);
  }

  static Future<bool> removeUserId() {
    return _sharedPreferences!.remove(_keyUserId);
  }
}

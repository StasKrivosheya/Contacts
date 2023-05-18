import 'package:contacts/src/languages/language.dart';
import 'package:contacts/src/services/app_settings/i_app_settings.dart';
import 'package:contacts/src/theme/app_themes.dart';
import 'package:contacts/src/widgets/settings_page/bloc/settings_page_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings implements IAppSettings {
  static const String _keyUserId = "userId";
  static const String _keySortField = "sortField";
  static const String _keyAppTheme = "appTheme";
  static const String _keyLanguage = "language";

  late final SharedPreferences _sharedPreferences;
  final _sortFieldStreamController = BehaviorSubject<ESortBy>();

  @override
  Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _initSortFieldStream();
  }

  @override
  Future<bool> setCurrentUserId(int userId) {
    return _sharedPreferences!.setInt(_keyUserId, userId);
  }

  @override
  int? getCurrentUserId() {
    return _sharedPreferences!.getInt(_keyUserId);
  }

  @override
  Future<bool> removeCurrentUserId() {
    return _sharedPreferences!.remove(_keyUserId);
  }

  @override
  Future<bool> setSortField(ESortBy sortField) {
    _sortFieldStreamController.add(sortField);
    return _sharedPreferences!.setString(_keySortField, sortField.name);
  }

  @override
  ESortBy getSortField() {
    final sortBy = _sharedPreferences!.getString(_keySortField);

    ESortBy savedPreference;
    if (sortBy != null) {
      savedPreference = ESortBy.values.firstWhere((u) => u.name == sortBy);
    } else {
      savedPreference = ESortBy.date;
    }

    return savedPreference;
  }

  @override
  Stream<ESortBy> getSortFieldStream() {
    return _sortFieldStreamController.stream.asBroadcastStream();
  }

  @override
  Future<bool> setAppTheme(AppTheme appTheme) {
    return _sharedPreferences!.setInt(_keyAppTheme, appTheme.index);
  }

  @override
  AppTheme getAppTheme() {
    final savedEnumIndex = _sharedPreferences!.getInt(_keyAppTheme);

    AppTheme themeToApply;
    if (savedEnumIndex != null) {
      themeToApply = AppTheme.values[savedEnumIndex];
    } else {
      themeToApply = AppTheme.light;
    }

    return themeToApply;
  }

  @override
  Future<bool> setLanguage(ELanguage language) {
    return _sharedPreferences!.setInt(_keyLanguage, language.index);
  }

  @override
  ELanguage getLanguage() {
    final preferredLanguageIndex = _sharedPreferences!.getInt(_keyLanguage);

    ELanguage result;

    if (preferredLanguageIndex != null) {
      result = ELanguage.values[preferredLanguageIndex];
    } else {
      result = ELanguage.english;
    }

    return result;
  }

  void _initSortFieldStream() {
    final savedPreference = getSortField();

    _sortFieldStreamController.add(savedPreference);
  }
}

import 'package:contacts/src/services/AppSettings/i_app_settings.dart';
import 'package:contacts/src/widgets/settings_page/bloc/settings_page_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings implements IAppSettings {
  static const String _keyUserId = "userId";
  static const String _keySortField = "sortField";

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

  void _initSortFieldStream() {
    final savedPreference = getSortField();

    _sortFieldStreamController.add(savedPreference);
  }
}

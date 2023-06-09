import 'package:contacts/src/languages/language.dart';
import 'package:contacts/src/theme/app_themes.dart';
import 'package:contacts/src/widgets/settings_page/bloc/settings_page_bloc.dart';

abstract class IAppSettings {
  Future init();

  Future<bool> setCurrentUserId(int userId);
  int? getCurrentUserId();
  Future<bool> removeCurrentUserId();

  Future<bool> setSortField(ESortBy sortField);
  ESortBy getSortField();
  Stream<ESortBy> getSortFieldStream();

  Future<bool> setAppTheme(AppTheme appTheme);
  AppTheme getAppTheme();

  Future<bool> setLanguage(ELanguage language);
  ELanguage getLanguage();
}
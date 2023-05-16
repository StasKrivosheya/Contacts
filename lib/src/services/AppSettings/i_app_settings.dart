import 'package:contacts/src/widgets/settings_page/bloc/settings_page_bloc.dart';

abstract class IAppSettings {
  Future init();

  Future<bool> setCurrentUserId(int userId);
  int? getCurrentUserId();
  Future<bool> removeCurrentUserId();

  Future<bool> setSortField(ESortBy sortField);
  ESortBy getSortField();
  Stream<ESortBy> getSortFieldStream();
}
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contacts/src/languages/language.dart';
import 'package:contacts/src/services/app_settings/i_app_settings.dart';
import 'package:contacts/src/theme/app_themes.dart';
import 'package:equatable/equatable.dart';

part 'settings_page_event.dart';

part 'settings_page_state.dart';

class SettingsPageBloc extends Bloc<SettingsPageEvent, SettingsPageState> {
  SettingsPageBloc({required IAppSettings appSettings})
      : _appSettings = appSettings,
        super(SettingsPageState(
          sortBy: appSettings.getSortField(),
          isDarkThemeEnabled: appSettings.getAppTheme() == AppTheme.dark,
          selectedLanguage: appSettings.getLanguage(),
        )) {
    on<SortByValueChanged>(_onSortByValueChanged);
    on<ThemePreferenceChanged>(_onThemePreferenceChanged);
    on<LanguageSettingsChanged>(_onLanguageSettingsChanged);
  }

  final IAppSettings _appSettings;

  void _onSortByValueChanged(SortByValueChanged event,
      Emitter<SettingsPageState> emit) async {
    await _appSettings.setSortField(event.sortBy);
    emit(state.copyWith(sortBy: event.sortBy));
  }

  void _onThemePreferenceChanged(ThemePreferenceChanged event,
      Emitter<SettingsPageState> emit) async {
    _appSettings.setAppTheme(
        event.isDarkThemeEnabled ? AppTheme.dark : AppTheme.light);
    emit(state.copyWith(isDarkThemeEnabled: event.isDarkThemeEnabled));
  }

  void _onLanguageSettingsChanged(
      LanguageSettingsChanged event, Emitter<SettingsPageState> emit) async {
    await _appSettings.setLanguage(event.selectedLanguage);
    emit(state.copyWith(selectedLanguage: event.selectedLanguage));
  }
}

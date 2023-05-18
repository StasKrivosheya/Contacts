part of 'settings_page_bloc.dart';

abstract class SettingsPageEvent extends Equatable {
  const SettingsPageEvent();
}

class SortByValueChanged extends SettingsPageEvent {
  final ESortBy sortBy;

  const SortByValueChanged(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}

class ThemePreferenceChanged extends SettingsPageEvent {
  final bool isDarkThemeEnabled;

  const ThemePreferenceChanged({required this.isDarkThemeEnabled});

  @override
  List<Object?> get props => [isDarkThemeEnabled];
}

class LanguageSettingsChanged extends SettingsPageEvent {
  const LanguageSettingsChanged({required this.selectedLanguage});

  final ELanguage selectedLanguage;

  @override
  List<Object?> get props => [selectedLanguage];
}

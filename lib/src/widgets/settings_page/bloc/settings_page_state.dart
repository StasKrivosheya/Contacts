part of 'settings_page_bloc.dart';

enum ESortBy { name, nickname, date }

class SettingsPageState extends Equatable {
  const SettingsPageState({
    this.sortBy = ESortBy.date,
    this.isDarkThemeEnabled = false,
    this.selectedLanguage = ELanguage.english,
  });

  final ESortBy sortBy;
  final bool isDarkThemeEnabled;
  final ELanguage selectedLanguage;

  SettingsPageState copyWith({
    ESortBy? sortBy,
    bool? isDarkThemeEnabled,
    ELanguage? selectedLanguage,
  }) {
    return SettingsPageState(
      sortBy: sortBy ?? this.sortBy,
      isDarkThemeEnabled: isDarkThemeEnabled ?? this.isDarkThemeEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [sortBy, isDarkThemeEnabled, selectedLanguage];
}

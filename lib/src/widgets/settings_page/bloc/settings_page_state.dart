part of 'settings_page_bloc.dart';

enum ESortBy { name, nickname, date }

enum ESupportedLanguages { english, ukrainian }

class SettingsPageState extends Equatable {
  const SettingsPageState({
    this.sortBy = ESortBy.date,
    this.isDarkThemeEnabled = false,
    this.selectedLanguage = ESupportedLanguages.english,
  });

  final ESortBy sortBy;
  final bool isDarkThemeEnabled;
  final ESupportedLanguages selectedLanguage;

  SettingsPageState copyWith({
    ESortBy? sortBy,
    bool? isDarkThemeEnabled,
    ESupportedLanguages? selectedLanguage,
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

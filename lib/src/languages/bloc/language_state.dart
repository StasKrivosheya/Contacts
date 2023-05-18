part of 'language_bloc.dart';

class LanguageState extends Equatable {
  const LanguageState({ELanguage? selectedLanguage})
      : selectedLanguage = selectedLanguage ?? ELanguage.english;

  final ELanguage selectedLanguage;

  @override
  List<Object?> get props => [selectedLanguage];

  LanguageState copyWith({ELanguage? selectedLanguage}) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

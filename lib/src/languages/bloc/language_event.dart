part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();
}

class LanguageChanged extends LanguageEvent {
  const LanguageChanged({required this.selectedLanguage});

  final ELanguage selectedLanguage;

  @override
  List<Object?> get props => [selectedLanguage];
}

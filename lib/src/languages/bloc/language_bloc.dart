import 'package:bloc/bloc.dart';
import 'package:contacts/src/languages/language.dart';
import 'package:contacts/src/services/app_settings/i_app_settings.dart';
import 'package:equatable/equatable.dart';

part 'language_event.dart';

part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc({required IAppSettings appSettings})
      : _appSettings = appSettings,
        super(LanguageState(selectedLanguage: appSettings.getLanguage())) {
    on<LanguageChanged>(_onLanguageChanged);
  }

  final IAppSettings _appSettings;

  void _onLanguageChanged(LanguageChanged event, Emitter<LanguageState> emit) {
    _appSettings.setLanguage(event.selectedLanguage);
    emit(state.copyWith(selectedLanguage: event.selectedLanguage));
  }
}

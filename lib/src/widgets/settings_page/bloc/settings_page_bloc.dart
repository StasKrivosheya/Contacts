import 'package:bloc/bloc.dart';
import 'package:contacts/src/services/AppSettings/i_app_settings.dart';
import 'package:equatable/equatable.dart';

part 'settings_page_event.dart';

part 'settings_page_state.dart';

class SettingsPageBloc extends Bloc<SettingsPageEvent, SettingsPageState> {
  SettingsPageBloc({required IAppSettings appSettings})
      : _appSettings = appSettings,
        super(SettingsPageState(sortBy: appSettings.getSortField())) {
    on<SortByValueChanged>(_onSortByValueChanged);
  }

  final IAppSettings _appSettings;

  void _onSortByValueChanged(
      SortByValueChanged event, Emitter<SettingsPageState> emit) async {
    await _appSettings.setSortField(event.sortBy);
    emit(state.copyWith(sortBy: event.sortBy));
  }
}

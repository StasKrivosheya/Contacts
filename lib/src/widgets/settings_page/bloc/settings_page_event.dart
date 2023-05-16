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

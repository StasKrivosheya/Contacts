part of 'main_list_bloc.dart';

abstract class MainListEvent extends Equatable {
  const MainListEvent();
}

class ContactsListRequested extends MainListEvent {
  @override
  List<Object?> get props => [];
}
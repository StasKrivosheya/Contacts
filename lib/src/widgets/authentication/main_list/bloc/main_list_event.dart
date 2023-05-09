part of 'main_list_bloc.dart';

abstract class MainListEvent extends Equatable {
  const MainListEvent();
}

class ContactsListRequested extends MainListEvent {
  @override
  List<Object?> get props => [];
}

class SignOutRequested extends MainListEvent {
  @override
  List<Object?> get props => [];
}

class DeleteContactRequested extends MainListEvent {
  const DeleteContactRequested(this.contactToDelete);

  final ContactModel contactToDelete;

  @override
  List<Object?> get props => [contactToDelete];
}

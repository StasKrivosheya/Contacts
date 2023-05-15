import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contacts/src/models/contact_model.dart';
import 'package:contacts/src/services/authentication/i_authentication_service.dart';
import 'package:contacts/src/services/repository/contact_repository.dart';
import 'package:equatable/equatable.dart';

part 'main_list_event.dart';

part 'main_list_state.dart';

class MainListBloc extends Bloc<MainListEvent, MainListState> {
  MainListBloc({
    required ContactRepository contactRepository,
    required IAuthenticationService authenticationService,
  })  : _contactRepository = contactRepository,
        _authenticationService = authenticationService,
        super(const MainListState()) {
    on<ContactsListRequested>(_onContactsListRequested);
    on<ContactsListSubscriptionRequested>(_onContactsListSubscriptionRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<DeleteContactRequested>(_onDeleteContactRequested);
  }

  final ContactRepository _contactRepository;
  final IAuthenticationService _authenticationService;

  void _onContactsListSubscriptionRequested(
      ContactsListSubscriptionRequested event,
      Emitter<MainListState> emit) async {
    emit(state.copyWith(status: PageStatus.loading));

    await emit.forEach(
        _contactRepository.getContacts(_authenticationService.currentUserId!),
        onData: (contacts) {
      MainListState stateToReturn;
      if (contacts.isEmpty) {
        stateToReturn = state.copyWith(
          status: PageStatus.empty,
        );
      } else {
        stateToReturn = state.copyWith(
          status: PageStatus.success,
          contacts: contacts,
        );
      }

      return stateToReturn;
    });
  }

  void _onContactsListRequested(
      ContactsListRequested event, Emitter<MainListState> emit) async {
    emit(state.copyWith(status: PageStatus.loading));

    int currentUserId = _authenticationService.currentUserId!;
    Iterable<ContactModel>? userContacts = await _contactRepository
        .getItemsAsync(predicate: (contact) => contact.userId == currentUserId);

    if (userContacts == null || userContacts.isEmpty) {
      emit(state.copyWith(status: PageStatus.empty));
    } else {
      emit(
        state.copyWith(
            contacts: userContacts.toList(growable: false),
            status: PageStatus.success),
      );
    }
  }

  void _onSignOutRequested(
      SignOutRequested event, Emitter<MainListState> emit) async {
    await _authenticationService.unAuthenticate();
  }

  void _onDeleteContactRequested(
      DeleteContactRequested event, Emitter<MainListState> emit) async {
    await _contactRepository.deleteItemAsync(event.contactToDelete);

    List<ContactModel> contacts = state.contacts
        .where((c) => c != event.contactToDelete)
        .toList(growable: false);

    PageStatus status =
        contacts.isEmpty ? PageStatus.empty : PageStatus.success;

    emit(state.copyWith(contacts: contacts, status: status));
  }
}

import 'package:bloc/bloc.dart';
import 'package:contacts/src/models/contact_model.dart';
import 'package:contacts/src/services/AppSettings/i_app_settings.dart';
import 'package:contacts/src/services/authentication/i_authentication_service.dart';
import 'package:contacts/src/services/repository/contact_repository.dart';
import 'package:contacts/src/widgets/settings_page/bloc/settings_page_bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_list_event.dart';

part 'main_list_state.dart';

class MainListBloc extends Bloc<MainListEvent, MainListState> {
  MainListBloc({
    required ContactRepository contactRepository,
    required IAuthenticationService authenticationService,
    required IAppSettings appSettings,
  })  : _contactRepository = contactRepository,
        _authenticationService = authenticationService,
        _appSettings = appSettings,
        super(const MainListState()) {
    on<ContactsListSubscriptionRequested>(_onContactsListSubscriptionRequested);
    on<ContactsSortFieldSubscriptionRequested>(_onContactsSortFieldSubscriptionRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<DeleteContactRequested>(_onDeleteContactRequested);
  }

  final ContactRepository _contactRepository;
  final IAuthenticationService _authenticationService;
  final IAppSettings _appSettings;

  void _onContactsListSubscriptionRequested(
      ContactsListSubscriptionRequested event, Emitter<MainListState> emit) async {
    emit(state.copyWith(status: PageStatus.loading));

    await emit.forEach(
        _contactRepository.getContacts(_authenticationService.currentUserId!),
        onData: (contacts) {
      MainListState updatedState;

      if (contacts.isEmpty) {
        updatedState = state.copyWith(status: PageStatus.empty);
      } else {
        _sortContacts(contacts, _appSettings.getSortField());
        updatedState = state.copyWith(status: PageStatus.success, contacts: contacts);
      }

      return updatedState;
    });
  }

  void _onContactsSortFieldSubscriptionRequested(
      ContactsSortFieldSubscriptionRequested event, Emitter<MainListState> emit) async {

    await emit.forEach(
      _appSettings.getSortFieldStream(),
      onData: (sortBy) {
        List<ContactModel> contacts = List.from(state.contacts);
        _sortContacts(contacts, sortBy);

        return state.copyWith(contacts: contacts);
      },
    );

  }

  void _onSignOutRequested(SignOutRequested event, Emitter<MainListState> emit) async {
    await _authenticationService.unAuthenticate();
  }

  void _onDeleteContactRequested(
      DeleteContactRequested event, Emitter<MainListState> emit) async {
    await _contactRepository.deleteItemAsync(event.contactToDelete);

    List<ContactModel> contacts = state.contacts
        .where((c) => c != event.contactToDelete)
        .toList(growable: false);

    PageStatus status = contacts.isEmpty ? PageStatus.empty : PageStatus.success;

    emit(state.copyWith(contacts: contacts, status: status));
  }

  void _sortContacts(List<ContactModel> contacts, ESortBy sortBy) {
    switch (sortBy) {
      case ESortBy.name:
        contacts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case ESortBy.nickname:
        contacts.sort((a, b) => a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase()));
        break;
      default:
        contacts.sort((a, b) => a.createdDateTime.compareTo(b.createdDateTime));
        break;
    }
  }
}

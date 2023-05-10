import 'package:bloc/bloc.dart';
import 'package:contacts/src/models/contact_model.dart';
import 'package:contacts/src/services/authentication/i_authentication_service.dart';
import 'package:contacts/src/services/repository/contact_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'add_edit_contact_event.dart';

part 'add_edit_contact_state.dart';

class AddEditContactBloc extends Bloc<AddEditContactEvent, AddEditContactState> {
  AddEditContactBloc({
    required ContactRepository contactRepository,
    required IAuthenticationService authenticationService,
    ContactModel? contactModel,
  })  : _contactRepository = contactRepository,
        _authenticationService = authenticationService,
        super(AddEditContactState(initialContactModel: contactModel)) {
    on<SaveContactRequested>(_onSaveContactRequested);
    on<ContactAvatarChanged>(_onContactAvatarChanged);
    on<ContactNicknameChanged>(_onContactNicknameChanged);
    on<ContactNameChanged>(_onContactNameChanged);
    on<ContactDescriptionChanged>(_onContactDescriptionChanged);
  }

  final ContactRepository _contactRepository;
  final IAuthenticationService _authenticationService;

  void _onSaveContactRequested(
      SaveContactRequested event, Emitter<AddEditContactState> emit) async {

    ContactModel contact = ContactModel(
      id: state.initialContactModel?.id,
      userId: state.initialContactModel?.userId ?? _authenticationService.currentUserId!,
      name: state.name,
      nickname: state.nickname,
      description: state.description,
      profileImagePath: state.profileImagePath,
      createdDateTime: state.initialContactModel?.createdDateTime ?? DateTime.now(),
    );

    if (contact.id == null) {
      await _contactRepository.insertItemAsync(contact);
    } else {
      await _contactRepository.updateItemAsync(contact);
    }

    emit(state.copyWith(pageStatus: AddEditPageStatus.saved));
  }

  void _onContactAvatarChanged(
      ContactAvatarChanged event, Emitter<AddEditContactState> emit) {
    emit(state.copyWith(profileImagePath: event.avatarSource));
  }

  void _onContactNicknameChanged(
      ContactNicknameChanged event, Emitter<AddEditContactState> emit) {
    AddEditPageStatus pageStatus;

    if (event.nickname.isEmpty) {
      pageStatus = AddEditPageStatus.cannotSave;
    } else {
      pageStatus = state.name.isEmpty
          ? AddEditPageStatus.cannotSave
          : AddEditPageStatus.canSave;
    }

    emit(state.copyWith(pageStatus: pageStatus, nickname: event.nickname));
  }

  void _onContactNameChanged(
      ContactNameChanged event, Emitter<AddEditContactState> emit) {
    AddEditPageStatus pageStatus;

    if (event.name.isEmpty) {
      pageStatus = AddEditPageStatus.cannotSave;
    } else {
      pageStatus = state.nickname.isEmpty
          ? AddEditPageStatus.cannotSave
          : AddEditPageStatus.canSave;
    }

    emit(state.copyWith(pageStatus: pageStatus, name: event.name));
  }

  void _onContactDescriptionChanged(
      ContactDescriptionChanged event, Emitter<AddEditContactState> emit) {
    bool canSave = state.name.isNotEmpty && state.nickname.isNotEmpty;

    AddEditPageStatus pageStatus = canSave
        ? AddEditPageStatus.canSave
        : AddEditPageStatus.cannotSave;
    
    emit(state.copyWith(pageStatus: pageStatus, description: event.description));
  }
}

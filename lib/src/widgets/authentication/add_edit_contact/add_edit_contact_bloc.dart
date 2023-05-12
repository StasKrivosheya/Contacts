import 'package:bloc/bloc.dart';
import 'package:contacts/src/models/contact_model.dart';
import 'package:contacts/src/services/authentication/i_authentication_service.dart';
import 'package:contacts/src/services/media_picker/i_media_picker.dart';
import 'package:contacts/src/services/repository/contact_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'add_edit_contact_event.dart';

part 'add_edit_contact_state.dart';

class AddEditContactBloc
    extends Bloc<AddEditContactEvent, AddEditContactState> {
  AddEditContactBloc({
    required ContactRepository contactRepository,
    required IAuthenticationService authenticationService,
    required IMediaPicker mediaPicker,
    ContactModel? contactModel,
  })  : _contactRepository = contactRepository,
        _authenticationService = authenticationService,
        _mediaPicker = mediaPicker,
        super(AddEditContactState(initialContactModel: contactModel)) {
    on<SaveContactRequested>(_onSaveContactRequested);
    on<ContactNicknameChanged>(_onContactNicknameChanged);
    on<ContactNameChanged>(_onContactNameChanged);
    on<ContactDescriptionChanged>(_onContactDescriptionChanged);
    on<PickFromGalleryRequested>(_onPickFromGalleryRequested);
    on<TakeWithCameraRequested>(_onTakeWithCameraRequested);
  }

  final ContactRepository _contactRepository;
  final IAuthenticationService _authenticationService;
  final IMediaPicker _mediaPicker;

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

  void _onContactNicknameChanged(
      ContactNicknameChanged event, Emitter<AddEditContactState> emit) {
    final pageStatus = _checkStatus(event.nickname, state.name);

    emit(state.copyWith(pageStatus: pageStatus, nickname: event.nickname));
  }

  void _onContactNameChanged(
      ContactNameChanged event, Emitter<AddEditContactState> emit) {
    final pageStatus = _checkStatus(state.nickname, event.name);

    emit(state.copyWith(pageStatus: pageStatus, name: event.name));
  }

  void _onContactDescriptionChanged(
      ContactDescriptionChanged event, Emitter<AddEditContactState> emit) {

    final pageStatus = _checkStatus(state.nickname, state.name);

    emit(state.copyWith(pageStatus: pageStatus, description: event.description));
  }

  void _onPickFromGalleryRequested(
      PickFromGalleryRequested event, Emitter<AddEditContactState> emit) async {
    final imagePath = await _mediaPicker.pickPhotoFromGallery();

    if (imagePath != null) {
      final pageStatus = _checkStatus(state.nickname, state.name);
      emit(state.copyWith(pageStatus: pageStatus, profileImagePath: imagePath));
    }
  }

  void _onTakeWithCameraRequested(
      TakeWithCameraRequested event, Emitter<AddEditContactState> emit) async {
    final imagePath = await _mediaPicker.takePhotoWithCamera();

    if (imagePath != null) {
      final pageStatus = _checkStatus(state.nickname, state.name);
      emit(state.copyWith(pageStatus: pageStatus, profileImagePath: imagePath));
    }
  }

  AddEditPageStatus _checkStatus(String nickname, String name) {
    bool canSave = nickname.isNotEmpty && name.isNotEmpty;

    AddEditPageStatus pageStatus = canSave
        ? AddEditPageStatus.canSave
        : AddEditPageStatus.cannotSave;

    return pageStatus;
  }
}

part of 'add_edit_contact_bloc.dart';

abstract class AddEditContactEvent extends Equatable {
  const AddEditContactEvent();
}

class SaveContactRequested extends AddEditContactEvent {
  @override
  List<Object?> get props => [];
}

class ContactNicknameChanged extends AddEditContactEvent {
  const ContactNicknameChanged(this.nickname);

  final String nickname;

  @override
  List<Object?> get props => [nickname];
}

class ContactNameChanged extends AddEditContactEvent {
  const ContactNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class ContactDescriptionChanged extends AddEditContactEvent {
  const ContactDescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

class ContactAvatarChanged extends AddEditContactEvent {
  const ContactAvatarChanged(this.avatarSource);

  final String avatarSource;

  @override
  List<Object?> get props => [avatarSource];
}

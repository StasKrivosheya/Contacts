part of 'add_edit_contact_bloc.dart';

enum AddEditPageStatus { canSave, cannotSave, saved }

@immutable
class AddEditContactState extends Equatable {
  AddEditContactState({
    this.initialContactModel,
    this.pageStatus = AddEditPageStatus.cannotSave,
    String? profileImagePath,
    String? nickname,
    String? name,
    String? description,
  })  : profileImagePath = profileImagePath ?? initialContactModel?.profileImagePath ?? '',
        nickname = nickname ?? initialContactModel?.nickname ?? '',
        name = name ?? initialContactModel?.name ?? '',
        description = description ?? initialContactModel?.description ?? '';

  final ContactModel? initialContactModel;
  final AddEditPageStatus pageStatus;
  final String profileImagePath;
  final String nickname;
  final String name;
  final String description;

  AddEditContactState copyWith(
      {AddEditPageStatus? pageStatus,
      String? profileImagePath,
      String? nickname,
      String? name,
      String? description}) {
    return AddEditContactState(
      initialContactModel: initialContactModel,
      pageStatus: pageStatus ?? this.pageStatus,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      nickname: nickname ?? this.nickname,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        pageStatus,
        initialContactModel,
        profileImagePath,
        nickname,
        name,
        description
      ];
}

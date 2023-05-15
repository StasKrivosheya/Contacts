part of 'main_list_bloc.dart';

enum PageStatus {
  initial,
  empty,
  loading,
  success,
  error,
}

extension PageStatusExtention on PageStatus {
  bool get isInitial => this == PageStatus.initial;
  bool get isEmpty => this == PageStatus.empty;
  bool get isLoading => this == PageStatus.loading;
  bool get isSuccess => this == PageStatus.success;
  bool get isError => this == PageStatus.error;
}

class MainListState extends Equatable {
  const MainListState({
    this.contacts = const [],
    this.status = PageStatus.loading,
  });

  final List<ContactModel> contacts;
  final PageStatus status;

  MainListState copyWith({
    List<ContactModel>? contacts,
    PageStatus? status,
  }) {
    return MainListState(
      contacts: contacts ?? this.contacts,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [contacts, status];
}

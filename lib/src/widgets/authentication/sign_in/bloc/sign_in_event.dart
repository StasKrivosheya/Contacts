part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
}

class SignInUsernameChanged extends SignInEvent {
  const SignInUsernameChanged(this.username);

  final String username;

  @override
  List<Object?> get props => [username];
}

class SignInPasswordChanged extends SignInEvent {
  const SignInPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class SignInSubmitted extends SignInEvent {
  @override
  List<Object?> get props => [];
}

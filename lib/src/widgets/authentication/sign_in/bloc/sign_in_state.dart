part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  const SignInState({
    this.username = '',
    this.password = '',
    this.canProceedToSignIn = false,
    this.status = AuthStatus.normal,
    this.errorMessages = const [],
    this.attemptsCount = 0,
  });

  final String username;
  final String password;
  final bool canProceedToSignIn;
  final AuthStatus status;
  final List<String> errorMessages;
  final int attemptsCount;

  SignInState copyWith({
    String? username,
    String? password,
    bool? canProceedToSignIn,
    AuthStatus? status,
    List<String>? errorMessages,
    int? attemptsCount,
  }) {
    return SignInState(
        username: username ?? this.username,
        password: password ?? this.password,
        canProceedToSignIn: canProceedToSignIn ?? this.canProceedToSignIn,
        status: status ?? this.status,
        errorMessages: errorMessages ?? this.errorMessages,
        attemptsCount: attemptsCount ?? this.attemptsCount);
  }

  @override
  List<Object> get props => [
        username,
        password,
        canProceedToSignIn,
        status,
        errorMessages,
        attemptsCount
      ];
}

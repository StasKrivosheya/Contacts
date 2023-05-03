part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState(
      {this.username = '',
      this.password = '',
      this.confirmPassword = '',
      this.canProceedToSignUp = false,
      this.status = AuthStatus.normal,
      this.errorMessages = const [],
      this.attemptsCount = 0});

  final String username;
  final String password;
  final String confirmPassword;
  final bool canProceedToSignUp;
  final AuthStatus status;
  final List<String> errorMessages;
  final int attemptsCount;

  SignUpState copyWith(
      {String? username,
      String? password,
      String? confirmPassword,
      bool? canProceedToSignUp,
      AuthStatus? status,
      List<String>? errorMessages,
      int? attemptsCount}) {
    return SignUpState(
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      canProceedToSignUp: canProceedToSignUp ?? this.canProceedToSignUp,
      status: status ?? this.status,
      errorMessages: errorMessages ?? this.errorMessages,
      attemptsCount: attemptsCount ?? this.attemptsCount,
    );
  }

  @override
  List<Object?> get props => [
        username,
        password,
        confirmPassword,
        canProceedToSignUp,
        status,
        errorMessages,
        attemptsCount
      ];
}

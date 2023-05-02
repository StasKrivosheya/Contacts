import 'package:bloc/bloc.dart';
import 'package:contacts/src/models/user_model.dart';
import 'package:contacts/src/services/repository/user_repository.dart';
import 'package:contacts/src/widgets/authentication/auth_status.dart';
import 'package:equatable/equatable.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const SignInState()) {
    on<SignInUsernameChanged>(_onSignInUsernameChanged);
    on<SignInPasswordChanged>(_onSignInPasswordChanged);
    on<SignInSubmitted>(_onSignInSubmitted);
  }

  final UserRepository _userRepository;

  void _onSignInUsernameChanged(SignInUsernameChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(username: event.username, status: AuthStatus.normal));

    bool canProceedToSignIn =
        state.username.isNotEmpty && state.password.isNotEmpty;
    emit(state.copyWith(canProceedToSignIn: canProceedToSignIn));
  }

  void _onSignInPasswordChanged(SignInPasswordChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(password: event.password, status: AuthStatus.normal));

    bool canProceedToSignIn =
        state.username.isNotEmpty && state.password.isNotEmpty;
    emit(state.copyWith(canProceedToSignIn: canProceedToSignIn));
  }

  void _onSignInSubmitted(SignInSubmitted event, Emitter<SignInState> emit) async {
    User? user = await _userRepository.getItemAsync(
        predicate: (user) => user.login == state.username);

    if (user == null) {
      String errorMessage =
          'There\'s no user with such login in our database.\n'
          'Double check it or consider registering.';

      emit(state.copyWith(
          status: AuthStatus.error,
          errorMessages: [errorMessage],
          attemptsCount: state.attemptsCount + 1));

    } else if (user.password != state.password) {
      String errorMessage =
          'Wrong password for ${state.username}. Try once more!';

      emit(state.copyWith(
          status: AuthStatus.error,
          errorMessages: [errorMessage],
          attemptsCount: state.attemptsCount + 1));

    } else {
      emit(state.copyWith(status: AuthStatus.success));
    }
  }
}

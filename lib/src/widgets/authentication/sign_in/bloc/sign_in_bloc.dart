import 'package:bloc/bloc.dart';
import 'package:contacts/src/models/user_model.dart';
import 'package:contacts/src/services/app_settings/i_app_settings.dart';
import 'package:contacts/src/services/authentication/i_authentication_service.dart';
import 'package:contacts/src/services/repository/user_repository.dart';
import 'package:contacts/src/widgets/authentication/auth_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc(
      {required UserRepository userRepository,
      required IAuthenticationService authenticationService,
      required IAppSettings appSettings})
      : _userRepository = userRepository,
        _authenticationService = authenticationService,
        _appSettings = appSettings,
        super(const SignInState()) {
    on<SignInUsernameChanged>(_onSignInUsernameChanged);
    on<SignInPasswordChanged>(_onSignInPasswordChanged);
    on<SignInSubmitted>(_onSignInSubmitted);
  }

  final UserRepository _userRepository;
  final IAuthenticationService _authenticationService;
  final IAppSettings _appSettings;

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

    final currentLocale = _appSettings.getLanguage().value;
    final appLocalizations = await AppLocalizations.delegate.load(currentLocale);

    if (user == null) {
      String errorMessage =
          appLocalizations.theresNoUserWithSuchLoginInOurDatabaseDoubleCheck;

      emit(state.copyWith(
          status: AuthStatus.error,
          errorMessages: [errorMessage],
          attemptsCount: state.attemptsCount + 1));

    } else if (user.password != state.password) {
      String errorMessage =
          '${appLocalizations.wrongPasswordFor} ${state.username}. ${appLocalizations.tryOnceMore}';

      emit(state.copyWith(
          status: AuthStatus.error,
          errorMessages: [errorMessage],
          attemptsCount: state.attemptsCount + 1));

    } else {
      bool wasSuccessful = await _authenticationService.authenticate(user.id!);

      if (wasSuccessful) {
        emit(state.copyWith(status: AuthStatus.success));
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessages: [appLocalizations.errorWhileSavingToSharedPreferences],
        ));
      }

    }
  }
}

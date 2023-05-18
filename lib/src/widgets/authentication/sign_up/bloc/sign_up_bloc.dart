import 'package:bloc/bloc.dart';
import 'package:contacts/src/models/user_model.dart';
import 'package:contacts/src/services/app_settings/i_app_settings.dart';
import 'package:contacts/src/services/repository/user_repository.dart';
import 'package:contacts/src/validators/string_validator.dart';
import 'package:contacts/src/widgets/authentication/auth_status.dart';
import 'package:equatable/equatable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(
      {required UserRepository userRepository,
      required IAppSettings appSettings})
      : _userRepository = userRepository,
        _appSettings = appSettings,
        super(const SignUpState()) {
    on<SignUpUsernameChanged>(_onSignUpUsernameChanged);
    on<SignUpPasswordChanged>(_onSignUpPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_onSignUpConfirmPasswordChanged);
    on<SignUpConfirmed>(_onSignUpConfirmed);
  }

  final UserRepository _userRepository;
  final IAppSettings _appSettings;

  void _onSignUpUsernameChanged(
      SignUpUsernameChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(username: event.username, status: AuthStatus.normal));

    _updateCanProceed(emit);
  }

  void _onSignUpPasswordChanged(
      SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(password: event.password, status: AuthStatus.normal));

    _updateCanProceed(emit);
  }

  void _onSignUpConfirmPasswordChanged(
      SignUpConfirmPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(
        confirmPassword: event.confirmPassword, status: AuthStatus.normal));

    _updateCanProceed(emit);
  }

  void _onSignUpConfirmed(
      SignUpConfirmed event, Emitter<SignUpState> emit) async {
    final currentLocale = _appSettings.getLanguage().value;
    final appLocalizations = await AppLocalizations.delegate.load(currentLocale);

    if (state.password == state.confirmPassword) {
      List<String> usernameErrors =
          StringValidator.validateLogin(state.username, appLocalizations);
      List<String> passwordErrors =
          StringValidator.validatePassword(state.password, appLocalizations);

      List<String> allErrors = usernameErrors + passwordErrors;

      if (allErrors.isNotEmpty) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessages: allErrors,
          attemptsCount: state.attemptsCount + 1,
        ));
      } else {
        try {
          await _userRepository.insertItemAsync(
              User(login: state.username, password: state.password));
          emit(state.copyWith(status: AuthStatus.success));
        } on DatabaseException {
          final String errorMessage =
              '${appLocalizations.username} ${state.username} ${appLocalizations.alreadyExistsPleaseConsiderAnother}';

          emit(state.copyWith(
            status: AuthStatus.error,
            errorMessages: [errorMessage],
            attemptsCount: state.attemptsCount + 1,
          ));
        }
      }
    } else {
      final String errorMessage = appLocalizations.passwordsAreDifferent;
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessages: [errorMessage],
        attemptsCount: state.attemptsCount + 1,
      ));
    }
  }

  void _updateCanProceed(Emitter<SignUpState> emit) {
    bool areInputsFilledIn = state.username.isNotEmpty &&
        state.password.isNotEmpty &&
        state.confirmPassword.isNotEmpty;

    emit(state.copyWith(canProceedToSignUp: areInputsFilledIn));
  }
}

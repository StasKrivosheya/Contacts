import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StringValidator {
  static const String _lowercasePattern = r'(?=.*[a-z])';
  static const String _uppercasePattern = r'(?=.*[A-Z])';
  static const String _digitPattern = r'(?=.*\d)';
  static const String _nonDigitBeginningPattern = r'^[^0-9]+.*';

  static List<String> validatePassword(String? value, AppLocalizations appLocalizations) {
    List<String> errors = [];

    if (value == null || value.isEmpty) {
      errors.add(appLocalizations.passwordIsRequired);
      return errors;
    }

    if (value.length < 8 || value.length > 16) {
      errors.add(appLocalizations.passwordMustBeFrom8To16Characters);
    }

    final RegExp lowercaseRegExp = RegExp(_lowercasePattern);
    if (!lowercaseRegExp.hasMatch(value)) {
      errors.add(appLocalizations.passwordMustContainAtLeast1Lowercase);
    }

    final RegExp uppercaseRegExp = RegExp(_uppercasePattern);
    if (!uppercaseRegExp.hasMatch(value)) {
      errors.add(appLocalizations.passwordMustContainAtLeast1Uppercase);
    }

    final RegExp digitRegExp = RegExp(_digitPattern);
    if (!digitRegExp.hasMatch(value)) {
      errors.add(appLocalizations.passwordMustContainAtLeast1digit);
    }

    return errors;
  }

  static List<String> validateLogin(String? value, AppLocalizations appLocalizations) {
    List<String> errors = [];

    if (value == null || value.isEmpty) {
      errors.add(appLocalizations.loginIsRequired);
      return errors;
    }

    if (value.length < 4 || value.length > 16) {
      errors.add(appLocalizations.loginMustBeFrom4To16Characters);
    }

    final RegExp nonDigitBeginningRegExp = RegExp(_nonDigitBeginningPattern);
    if (!nonDigitBeginningRegExp.hasMatch(value)) {
      errors.add(appLocalizations.loginMustMustNotStartFromADigit);
    }

    return errors;
  }
}

class StringValidator {
  static const String _lowercasePattern = r'(?=.*[a-z])';
  static const String _uppercasePattern = r'(?=.*[A-Z])';
  static const String _digitPattern = r'(?=.*\d)';
  static const String _nonDigitBeginningPattern = r'^[^0-9]+.*';

  static List<String> validatePassword(String? value) {
    List<String> errors = [];

    if (value == null || value.isEmpty) {
      errors.add('Password is required');
      return errors;
    }

    if (value.length < 8 || value.length > 16) {
      errors.add('Password must be from 8 to 16 characters long');
    }

    final RegExp lowercaseRegExp = RegExp(_lowercasePattern);
    if (!lowercaseRegExp.hasMatch(value)) {
      errors.add('Password must contain at least one lowercase letter');
    }

    final RegExp uppercaseRegExp = RegExp(_uppercasePattern);
    if (!uppercaseRegExp.hasMatch(value)) {
      errors.add('Password must contain at least one uppercase letter');
    }

    final RegExp digitRegExp = RegExp(_digitPattern);
    if (!digitRegExp.hasMatch(value)) {
      errors.add('Password must contain at least one digit');
    }

    return errors;
  }

  static List<String> validateLogin(String? value) {
    List<String> errors = [];

    if (value == null || value.isEmpty) {
      errors.add('Login is required');
      return errors;
    }

    if (value.length < 4 || value.length > 16) {
      errors.add('Login must be from 4 to 16 characters long');
    }

    final RegExp nonDigitBeginningRegExp = RegExp(_nonDigitBeginningPattern);
    if (!nonDigitBeginningRegExp.hasMatch(value)) {
      errors.add('Login must must not start from a digit');
    }

    return errors;
  }
}

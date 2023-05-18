import 'dart:ui';

enum ELanguage {
  english(
    Locale('en', 'US'),
    'English',
  ),
  ukrainian(
    Locale('uk', 'UA'),
    'Українська',
  );

  const ELanguage(this.value, this.displayableName);

  final Locale value;
  final String displayableName;
}

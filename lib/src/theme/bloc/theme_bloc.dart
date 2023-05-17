import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:contacts/src/services/app_settings/i_app_settings.dart';
import 'package:contacts/src/theme/app_themes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({required IAppSettings appSettings})
      : _appSettings = appSettings,
        super(ThemeState(themeData: appThemeData[appSettings.getAppTheme()]!)) {
    on<ThemeChanged>(_onThemeChanged);
  }

  final IAppSettings _appSettings;

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    emit(ThemeState(themeData: appThemeData[event.theme]!));
  }
}

import 'package:contacts/src/pages/add_edit_contact_page.dart';
import 'package:contacts/src/pages/authentication/sign_in_page.dart';
import 'package:contacts/src/pages/main_list_page.dart';
import 'package:contacts/src/pages/settings_page.dart';
import 'package:contacts/src/services/app_settings/app_settings.dart';
import 'package:contacts/src/services/app_settings/i_app_settings.dart';
import 'package:contacts/src/services/authentication/authentication_service.dart';
import 'package:contacts/src/services/authentication/i_authentication_service.dart';
import 'package:contacts/src/services/repository/contact_repository.dart';
import 'package:contacts/src/services/repository/user_repository.dart';
import 'package:contacts/src/theme/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/services/media_picker/media_picker.dart';
import 'src/widgets/authentication/main_list/bloc/main_list_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IAppSettings appSettings = AppSettings();
  await appSettings.init();

  runApp(MyApp(appSettings: appSettings));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required IAppSettings appSettings})
      : _appSettings = appSettings,
        _authenticationService = AuthenticationService(appSettings: appSettings);

  final IAppSettings _appSettings;
  final IAuthenticationService _authenticationService;

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = _authenticationService.isAuthorized;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _appSettings),
        RepositoryProvider.value(value: _authenticationService),
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => ContactRepository()),
        RepositoryProvider(create: (context) => MediaPicker()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                MainListBloc(
                  contactRepository: context.read<ContactRepository>(),
                  authenticationService: context.read<IAuthenticationService>(),
                  appSettings: context.read<IAppSettings>(),
                ),
          ),
          BlocProvider(
            create: (context) =>
                ThemeBloc(appSettings: context.read<IAppSettings>()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Contacts',
              theme: state.themeData,
              initialRoute: isLoggedIn ? '/mainList' : '/signIn',
              routes: {
                '/signIn': (context) => const SignInPage(),
                '/mainList': (context) => const MainListPage(),
                '/addEditContact': (context) => const AddEditContactPage(),
                '/settings': (context) => const SettingsPage(),
              },
            );
          },
        ),
      ),
    );
  }
}

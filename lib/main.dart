import 'package:contacts/src/pages/add_edit_contact_page.dart';
import 'package:contacts/src/pages/authentication/sign_in_page.dart';
import 'package:contacts/src/helpers/app_settings.dart';
import 'package:contacts/src/pages/main_list_page.dart';
import 'package:contacts/src/services/authentication/authentication_service.dart';
import 'package:contacts/src/services/authentication/i_authentication_service.dart';
import 'package:contacts/src/services/repository/contact_repository.dart';
import 'package:contacts/src/services/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/widgets/authentication/main_list/bloc/main_list_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final IAuthenticationService _authenticationService = const AuthenticationService();

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = _authenticationService.isAuthorized;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationService),
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => ContactRepository()),
      ],
      child: BlocProvider(
        create: (context) => MainListBloc(
          contactRepository: context.read<ContactRepository>(),
          authenticationService: context.read<IAuthenticationService>(),
        ),
        child: MaterialApp(
          title: 'Contacts',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: isLoggedIn ? '/mainList' : '/signIn',
          routes: {
            '/signIn': (context) => const SignInPage(),
            '/mainList': (context) => const MainListPage(),
            '/addEditContact': (context) => const AddEditContactPage(),
          },
        ),
      ),
    );
  }
}

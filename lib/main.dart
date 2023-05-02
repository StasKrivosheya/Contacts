import 'package:contacts/src/pages/authentication/sign_in_page.dart';
import 'package:contacts/src/helpers/app_settings.dart';
import 'package:contacts/src/pages/main_list_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String? usersLogin = AppSettings.getLogin();

    return MaterialApp(
      title: 'Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: usersLogin == null ? '/signIn' : '/mainList',
      routes: {
        '/signIn': (context) => const SignInPage(),
        '/mainList': (context) => const MainListPage(title: "Main List"),
      },
    );
  }
}

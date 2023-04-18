import 'package:contacts/src/features/authentication/presentation/sign_in_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/signIn',
      routes: {
        '/signIn': (context) => const SignInPage(title: 'Users SignIn')
      },
    );
  }
}
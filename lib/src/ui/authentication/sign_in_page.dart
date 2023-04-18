import 'package:contacts/src/helpers/app_settings.dart';
import 'package:contacts/src/helpers/database.dart';
import 'package:contacts/src/ui/authentication/sign_up_page.dart';
import 'package:contacts/src/ui/main_list_page.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _canSignIn = false;

  @override
  void initState() {
    _loginController.addListener(_updateSignInButton);
    _passwordController.addListener(_updateSignInButton);
    super.initState();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(widget.title),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: _loginController,
                      decoration: const InputDecoration(hintText: "Login"),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: "Password"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 35, right: 35, bottom: 35),
                alignment: Alignment.bottomCenter,
                child: Column(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Opacity(
                            opacity: _canSignIn ? 1 : 0.3,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor:
                                      const Color.fromRGBO(210, 105, 29, 1),
                                  disabledBackgroundColor:
                                      const Color.fromRGBO(210, 105, 29, 1),
                                  elevation: _canSignIn ? 5 : 0,
                                  side: const BorderSide(color: Colors.black),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                  )),
                              onPressed: _canSignIn ? _signInPressed : null,
                              child: const Text(
                                "SIGN IN",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _signUpTapped,
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Color.fromRGBO(26, 25, 255, 1),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSignInButton() {
    bool canSignIn =
        _loginController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    if (_canSignIn != canSignIn) {
      setState(() {
        _canSignIn = canSignIn;
      });
    }
  }

  void _signInPressed() async {
    User? user = await DBProvider.instance.readUser(_loginController.text);
    if (user == null) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Login error!'),
                content: const Text(
                    'There\'s no user with such login in our database.\n'
                    'Double check it or consider registering.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok')),
                ],
              );
            });
      }
    } else {
      if (_passwordController.text == user.password) {
        await AppSettings.setLogin(user.login);
        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  const MainListPage(title: "Main List")));
        }
      } else if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Password error!'),
                content: Text(
                    'Wrong password for ${_loginController.text}. Try once more!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'),
                  )
                ],
              );
            });
      }
    }
  }

  void _signUpTapped() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SignUpPage(title: 'Users SignUp');
    })).then((value) => {
          if (value != null)
            {
              setState(() {
                _loginController.text = value as String;
                _passwordController.text = '';
              })
            }
        });
  }
}

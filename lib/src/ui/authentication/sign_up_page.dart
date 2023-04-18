import 'package:contacts/src/validators/string_validator.dart';
import 'package:contacts/src/helpers/database.dart';
import 'package:contacts/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _canSignUp = false;

  @override
  void initState() {
    _loginController.addListener(_updateSignUpButton);
    _passwordController.addListener(_updateSignUpButton);
    _confirmPasswordController.addListener(_updateSignUpButton);

    super.initState();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            const SizedBox(width: 15),
            Text(widget.title),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 5,
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
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(hintText: "Confirm Password"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                alignment: Alignment.center,
                child: Opacity(
                  opacity: _canSignUp ? 1 : 0.3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color.fromRGBO(210, 105, 29, 1),
                      disabledBackgroundColor:
                          const Color.fromRGBO(210, 105, 29, 1),
                      minimumSize: const Size.fromHeight(50),
                      elevation: _canSignUp ? 5 : 0,
                      side: const BorderSide(color: Colors.black),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                    onPressed: _canSignUp ? _signUpPressed : null,
                    child: const Text(
                      "SIGN UP",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSignUpButton() {
    bool canSignIn = _loginController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
    if (_canSignUp != canSignIn) {
      setState(() {
        _canSignUp = canSignIn;
      });
    }
  }

  void _signUpPressed() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      List<String> loginErrors =
          StringValidator.validateLogin(_loginController.text);
      List<String> passwordErrors =
          StringValidator.validatePassword(_passwordController.text);
      List<String> allErrors = loginErrors + passwordErrors;

      if (allErrors.isNotEmpty) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Input error!'),
                content: Text(allErrors.join('\n')),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok')),
                ],
              );
            });
      } else {
        User user = User(
            login: _loginController.text, password: _passwordController.text);

        try {
          await DBProvider.instance.createUser(user);

          if (context.mounted) {
            Navigator.of(context).pop(user.login);
          }
        } on DatabaseException catch (e) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Input error!'),
                  content: Text(
                      'Username ${_loginController.text} already exists, please consider another one.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Ok')),
                  ],
                );
              });
        }
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Input error!'),
              content: const Text('Passwords are different!'),
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
  }
}

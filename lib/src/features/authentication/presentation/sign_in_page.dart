import 'package:contacts/src/features/authentication/presentation/sign_up_page.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _canSignIn = false;

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
                      controller: _usernameController,
                      onChanged: (_) => _updateSignInButton(),
                      decoration: const InputDecoration(hintText: "Login"),
                    ),
                    TextField(
                      controller: _passwordController,
                      onChanged: (_) => _updateSignInButton(),
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
    bool canSignIn = _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
    if (_canSignIn != canSignIn) {
      setState(() {
        _canSignIn = canSignIn;
      });
    }
  }

  void _signInPressed() {
    // TODO
  }

  void _signUpTapped() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SignUpPage(title: 'Users SignUp');
    }));
  }
}

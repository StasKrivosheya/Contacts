import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _canSignUp = false;

  @override
  void initState() {
    _usernameController.addListener(_updateSignUpButton);
    _passwordController.addListener(_updateSignUpButton);
    _confirmPasswordController.addListener(_updateSignUpButton);

    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
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
                      controller: _usernameController,
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
                      "SIGN IN",
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
    bool canSignIn = _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
    if (_canSignUp != canSignIn) {
      setState(() {
        _canSignUp = canSignIn;
      });
    }
  }

  void _signUpPressed() {
    // TODO
  }
}

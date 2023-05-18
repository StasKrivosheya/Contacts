import 'package:contacts/src/pages/authentication/sign_up_page.dart';
import 'package:contacts/src/pages/main_list_page.dart';
import 'package:contacts/src/services/app_settings/i_app_settings.dart';
import 'package:contacts/src/services/authentication/i_authentication_service.dart';
import 'package:contacts/src/services/repository/user_repository.dart';
import 'package:contacts/src/widgets/authentication/auth_status.dart';
import 'package:contacts/src/widgets/authentication/sign_in/bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(AppLocalizations.of(context)!.usersSignIn),
        ),
      ),
      body: BlocProvider<SignInBloc>(
        create: (context) => SignInBloc(
          userRepository: context.read<UserRepository>(),
          authenticationService: context.read<IAuthenticationService>(),
          appSettings: context.read<IAppSettings>(),
        ),
        child: const _SignInLayout(),
      ),
    );
  }
}

class _SignInLayout extends StatelessWidget {
  const _SignInLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
        listenWhen: (previous, current) =>
            current.status.isError || current.status.isSuccess,
        listener: (context, state) async {
          if (state.status.isSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const MainListPage()),
                (Route<dynamic> route) => false);
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.loginError),
                    content: Text(state.errorMessages.join('/n')),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(AppLocalizations.of(context)!.ok)),
                    ],
                  );
                });
          }
        },
        child: SafeArea(
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
                      _LoginInput(),
                      _PasswordInput(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 35, right: 35, bottom: 35),
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
                            child: _SignInButton(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _SignUpHyperLink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class _LoginInput extends StatelessWidget {
  final TextEditingController _loginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) => previous.username != current.username,
        builder: (context, state) {
          _loginController.value = TextEditingValue(
              text: state.username,
              selection: TextSelection.fromPosition(
                  TextPosition(offset: state.username.length)));
          return TextField(
            onChanged: (username) =>
                context.read<SignInBloc>().add(SignInUsernameChanged(username)),
            controller: _loginController,
            decoration: InputDecoration(hintText: AppLocalizations.of(context)!.login),
          );
        });
  }
}

class _PasswordInput extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          _passwordController.value = TextEditingValue(
            text: state.password,
            selection: TextSelection.fromPosition(
                TextPosition(offset: state.password.length)),
          );
          return TextField(
            onChanged: (password) =>
                context.read<SignInBloc>().add(SignInPasswordChanged(password)),
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: AppLocalizations.of(context)!.password),
          );
        });
  }
}

class _SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) =>
          previous.canProceedToSignIn != current.canProceedToSignIn,
      builder: (context, state) {
        return Opacity(
          opacity: state.canProceedToSignIn ? 1 : 0.3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: const Color.fromRGBO(210, 105, 29, 1),
                disabledBackgroundColor: const Color.fromRGBO(210, 105, 29, 1),
                elevation: state.canProceedToSignIn ? 5 : 0,
                side: const BorderSide(color: Colors.black),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                )),
            onPressed: state.canProceedToSignIn
                ? () {
                    context.read<SignInBloc>().add(SignInSubmitted());
                  }
                : null,
            child: Text(
              AppLocalizations.of(context)!.signIn.toUpperCase(),
              style: const TextStyle(color: Colors.black, ),
            ),
          ),
        );
      },
    );
  }
}

class _SignUpHyperLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _signUpTapped(context),
      child: Text(
        AppLocalizations.of(context)!.signUp.toUpperCase(),
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _signUpTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return const SignUpPage();
      }),
    ).then((value) {
      if (value != null) {
        context.read<SignInBloc>().add(
              SignInUsernameChanged(value as String),
            );
        context.read<SignInBloc>().add(
              const SignInPasswordChanged(''),
            );
      }
    });
  }
}

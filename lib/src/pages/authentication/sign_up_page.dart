import 'package:contacts/src/services/app_settings/i_app_settings.dart';
import 'package:contacts/src/services/repository/user_repository.dart';
import 'package:contacts/src/widgets/authentication/auth_status.dart';
import 'package:contacts/src/widgets/authentication/sign_up/bloc/sign_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
            Text(AppLocalizations.of(context)!.usersSignUp),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => SignUpBloc(
            userRepository: context.read<UserRepository>(),
            appSettings: context.read<IAppSettings>()),
        child: const _SignUpLayout(),
      ),
    );
  }
}

class _SignUpLayout extends StatelessWidget {
  const _SignUpLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) =>
          current.status.isError || current.status.isSuccess,
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop(state.username);
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.signUpError),
                  content: Text(state.errorMessages.join('\n')),
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
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    _LoginInput(),
                    _PasswordInput(),
                    _ConfirmPasswordInput(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                alignment: Alignment.center,
                child: _SignUpButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (login) {
        context.read<SignUpBloc>().add(SignUpUsernameChanged(login));
      },
      decoration: InputDecoration(hintText: AppLocalizations.of(context)!.login),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (password) {
        context.read<SignUpBloc>().add(SignUpPasswordChanged(password));
      },
      obscureText: true,
      decoration: InputDecoration(hintText: AppLocalizations.of(context)!.password),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (confirmPassword) {
        context
            .read<SignUpBloc>()
            .add(SignUpConfirmPasswordChanged(confirmPassword));
      },
      obscureText: true,
      decoration: InputDecoration(hintText: AppLocalizations.of(context)!.confirmPassword),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.canProceedToSignUp != current.canProceedToSignUp,
      builder: (context, state) {
        return Opacity(
          opacity: state.canProceedToSignUp ? 1 : 0.3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: const Color.fromRGBO(210, 105, 29, 1),
              disabledBackgroundColor: const Color.fromRGBO(210, 105, 29, 1),
              minimumSize: const Size.fromHeight(50),
              elevation: state.canProceedToSignUp ? 5 : 0,
              side: const BorderSide(color: Colors.black),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
            onPressed: state.canProceedToSignUp
                ? () {
                    context.read<SignUpBloc>().add(SignUpConfirmed());
                  }
                : null,
            child: Text(
              AppLocalizations.of(context)!.signUp.toUpperCase(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}

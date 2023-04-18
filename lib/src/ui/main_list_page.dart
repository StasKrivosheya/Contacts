import 'package:contacts/src/helpers/app_settings.dart';
import 'package:flutter/material.dart';

import 'authentication/sign_in_page.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _MainListPageState();
}

class _MainListPageState extends State<MainListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
            const Spacer(),
            IconButton(
                onPressed: _confirmLogOut, icon: const Icon(Icons.logout)),
            IconButton(
                onPressed: _navigateToSettings,
                icon: const Icon(Icons.settings)),
          ],
        ),
      ),
    );
  }

  void _confirmLogOut() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Log out'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: _performLogout, child: const Text('Confirm')),
            ],
          );
        });
  }

  void _navigateToSettings() {
    // TODO
  }

  void _performLogout() {
    AppSettings.removeLogin();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const SignInPage(title: 'Users SignIn')),
          (Route<dynamic> route) => false);
    }
  }
}

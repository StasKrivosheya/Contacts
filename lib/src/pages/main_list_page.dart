import 'package:contacts/src/models/contact_model.dart';
import 'package:contacts/src/widgets/authentication/main_list/bloc/main_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'authentication/sign_in_page.dart';

class MainListPage extends StatelessWidget {
  const MainListPage({super.key});

  final String title = 'Main List';

  @override
  Widget build(BuildContext context) {
    context.read<MainListBloc>().add(ContactsListRequested());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(title),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _confirmSignOut(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // TODO: create settings page, add route and navigate
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) {
                //     return const SettingsPage();
                //   }),
                // );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _MainListPageBody(),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 4,
              color: Colors.black54,
            ),
            borderRadius: BorderRadius.circular(35)),
        onPressed: () async {
          // TODO: create add edit page, add route and navigate, remove async
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) {
          //     return const AddEditPage();
          //   }),
          // );
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
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
                  onPressed: () {
                    context.read<MainListBloc>().add(SignOutRequested());
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const SignInPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text('Confirm')),
            ],
          );
        });
  }
}

class _MainListPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainListBloc, MainListState>(
      listenWhen: (prev, curr) => true,
      listener: (context, state) {
        // todo: e.g. perform navigation to pages
      },
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        Widget widgetToShow;
        switch (state.status) {
          case PageStatus.loading:
            widgetToShow = const Center(child: CircularProgressIndicator());
            break;
          case PageStatus.success:
            widgetToShow = _ContactsListView(contacts: state.contacts);
            break;
          default:
            widgetToShow = const Center(
              child: Text(
                'No contacts added yet...',
                style: TextStyle(fontSize: 21),
              ),
            );
            break;
        }

        return widgetToShow;
      },
    );
  }
}

class _ContactsListView extends StatelessWidget {
  const _ContactsListView({super.key, required this.contacts});

  final List<ContactModel> contacts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Image.network(
                            contacts[index].profileImagePath,
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    contacts[index].profileImagePath,
                    fit: BoxFit.scaleDown,
                    height: 100,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contacts[index].nickname,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(contacts[index].name),
                        const SizedBox(height: 6),
                        Text(
                          DateFormat('MM/dd/yy hh:mm a')
                              .format(contacts[index].createdDateTime),
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

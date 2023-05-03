import 'package:contacts/src/models/contact_model.dart';
import 'package:contacts/src/services/authentication/i_authentication_service.dart';
import 'package:contacts/src/services/repository/contact_repository.dart';
import 'package:contacts/src/widgets/authentication/main_list/bloc/main_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MainListPage extends StatelessWidget {
  const MainListPage({super.key});

  final String title = 'Main List';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainListBloc(
        contactRepository: context.read<ContactRepository>(),
        authenticationService: context.read<IAuthenticationService>(),
      )..add(ContactsListRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(title),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // TODO: uncomment when logout ready
                  //context.read<MainListBloc>().add(LogoutRequested());
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
            ContactRepository contactRepository = context.read<ContactRepository>();
            IAuthenticationService authenticationService = context.read<IAuthenticationService>();
            final ContactModel tmpContact1 = ContactModel(
                name: 'Stas',
                userId: authenticationService.currentUserId!,
                nickname: 'Stas Kryvosheia',
                profileImagePath: 'https://picsum.photos/200/300',
                createdDateTime: DateTime(2023, 13, 3, 12, 57, 13));
            final ContactModel tmpContact2 = ContactModel(
                name: 'Headworks',
                userId: authenticationService.currentUserId!,
                nickname: 'Office guy',
                profileImagePath: 'https://picsum.photos/300/200',
                createdDateTime: DateTime(2023, 13, 3, 12, 57, 13));
            int result1 = await contactRepository.insertItemAsync(tmpContact1);
            int result2 = await contactRepository.insertItemAsync(tmpContact2);
            // if (context.mounted) {
            //   context.read<MainListBloc>().add(ContactsListRequested());
            // }
          },
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
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
                child: Image.network(
                  contacts[index].profileImagePath,
                  fit: BoxFit.scaleDown,
                  height: 100,
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

// class _MainListPageState {
//
//   void _confirmLogOut() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Log out'),
//             content: const Text('Are you sure you want to log out?'),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel')),
//               TextButton(
//                   onPressed: _performLogout, child: const Text('Confirm')),
//             ],
//           );
//         });
//   }
//
//   void _performLogout() {
//     // TODO: use auth service and move to bloc
//     AppSettings.removeLogin();
//
//     if (context.mounted) {
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(
//               builder: (BuildContext context) => const SignInPage()),
//           (Route<dynamic> route) => false);
//     }
//   }
// }

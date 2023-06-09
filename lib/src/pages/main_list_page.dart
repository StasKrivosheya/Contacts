import 'dart:io';

import 'package:contacts/src/models/contact_model.dart';
import 'package:contacts/src/pages/add_edit_contact_page.dart';
import 'package:contacts/src/widgets/authentication/main_list/bloc/main_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'authentication/sign_in_page.dart';
import 'settings_page.dart';

class MainListPage extends StatelessWidget {
  const MainListPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MainListBloc>().add(ContactsListSubscriptionRequested());
    context.read<MainListBloc>().add(ContactsSortFieldSubscriptionRequested());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(AppLocalizations.of(context)!.mainList),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const SettingsPage();
                  }),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _MainListPageBody(),
      ),
      floatingActionButton: _AddContactFloatingButton(),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.logOut),
            content: Text(AppLocalizations.of(context)!.areYouSureYouWantLogOut),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancel)),
              TextButton(
                  onPressed: () {
                    context.read<MainListBloc>().add(SignOutRequested());
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                            const SignInPage()),
                            (Route<dynamic> route) => false);
                  },
                  child: Text(AppLocalizations.of(context)!.confirm)),
            ],
          );
        });
  }
}

class _AddContactFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 4,
            color: Colors.black54,
          ),
          borderRadius: BorderRadius.circular(35)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return const AddEditContactPage();
          }),
        );
      },
      child: const Icon(
        Icons.add,
        size: 30,
      ),
    );
  }
}

class _MainListPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainListBloc, MainListState>(
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        Widget widgetToShow;
        switch (state.status) {
          case PageStatus.loading:
            widgetToShow = const Center(child: CircularProgressIndicator());
            break;
          case PageStatus.success:
            widgetToShow = const _ContactsListView();
            break;
          default:
            widgetToShow = Center(
              child: Text(
                AppLocalizations.of(context)!.noContactsAddedYet,
                style: const TextStyle(fontSize: 21),
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
  const _ContactsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainListBloc, MainListState>(
      buildWhen: (previous, current) => previous.contacts != current.contacts,
      builder: (context, state) {
        List<ContactModel> contacts = state.contacts;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 5),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (contacts[index].profileImagePath.isNotEmpty) {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Image.file(
                          File(contacts[index].profileImagePath),
                          fit: BoxFit.scaleDown,
                        ),
                      );
                    },
                  );
                }
              },
              child: Slidable(
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.5,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _proceedWithContactDeletion(context, contacts[index]);
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: AppLocalizations.of(context)!.delete.toUpperCase(),
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.35,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            ContactModel swipedContact = contacts[index];
                            return AddEditContactPage(contactModel: swipedContact);
                          }),
                        );
                      },
                      backgroundColor: const Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.edit_note,
                      label: AppLocalizations.of(context)!.edit,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: BlocBuilder<MainListBloc, MainListState>(
                          buildWhen: (previous, current) =>
                              previous.contacts[index].profileImagePath !=
                              contacts[index].profileImagePath,
                          builder: (context, state) {
                            Widget imageToShow;
                            if (contacts[index].profileImagePath.isEmpty) {
                              imageToShow = const Image(
                                image: AssetImage(
                                    'assets/images/avatar_placeholder.png'),
                                fit: BoxFit.scaleDown,
                                height: 100,
                              );
                            } else {
                              imageToShow = Image.file(
                                File(contacts[index].profileImagePath),
                                fit: BoxFit.scaleDown,
                                height: 100,
                              );
                            }

                            return imageToShow;
                          },
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(contacts[index].name),
                                const SizedBox(height: 6),
                                Text(
                                  DateFormat('MM/dd/yy hh:mm a')
                                      .format(contacts[index].createdDateTime),
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _proceedWithContactDeletion(BuildContext context, ContactModel contact) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.deleteContact),
            content: Text(
                '${AppLocalizations.of(context)!.areYouSureYouWantToDelete} ${contact.nickname}?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancel)),
              TextButton(
                  onPressed: () {
                    context.read<MainListBloc>().add(
                        DeleteContactRequested(contact));
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.yes)),
            ],
          );
        });
  }
}

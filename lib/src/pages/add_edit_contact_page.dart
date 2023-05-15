import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:contacts/src/models/contact_model.dart';
import 'package:contacts/src/services/authentication/i_authentication_service.dart';
import 'package:contacts/src/services/media_picker/media_picker.dart';
import 'package:contacts/src/services/repository/contact_repository.dart';
import 'package:contacts/src/widgets/authentication/add_edit_contact/add_edit_contact_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditContactPage extends StatelessWidget {
  const AddEditContactPage({super.key, this.contactModel});

  final ContactModel? contactModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddEditContactBloc(
            contactRepository: context.read<ContactRepository>(),
            authenticationService: context.read<IAuthenticationService>(),
            mediaPicker: context.read<MediaPicker>(),
            contactModel: contactModel,
          ),
      child: _PageScaffold(),
    );
  }
}

class _PageScaffold extends StatelessWidget {
  final String title = 'Add/Edit contact';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(title),
            const Spacer(),
            BlocConsumer<AddEditContactBloc, AddEditContactState>(
              listenWhen: (_, current) =>
              current.pageStatus == AddEditPageStatus.saved,
              listener: (context, state) {
                Navigator.pop(context);
              },
              buildWhen: (previous, current) =>
              previous.pageStatus != current.pageStatus,
              builder: (context, state) {
                bool isButtonEnabled =
                    state.pageStatus == AddEditPageStatus.canSave;
                return IconButton(
                  onPressed: isButtonEnabled
                      ? () {
                    saveIconPressed(context);
                  }
                      : null,
                  icon: const Icon(Icons.save),
                );
              },
            )
          ],
        ),
      ),
      body: _PageBody(),
    );
  }

  saveIconPressed(BuildContext context) {
    context.read<AddEditContactBloc>().add(SaveContactRequested());
  }
}

class _PageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                final blocContext = context;
                showAdaptiveActionSheet(context: context, actions: <BottomSheetAction>[
                  BottomSheetAction(title: const Text('Gallery'), onPressed: (context) {
                    blocContext.read<AddEditContactBloc>().add(const PickFromGalleryRequested());
                    Navigator.pop(context);
                  }),
                  BottomSheetAction(title: const Text('Camera'), onPressed: (context) {
                    blocContext.read<AddEditContactBloc>().add(const TakeWithCameraRequested());
                    Navigator.pop(context);
                  }),
                ]);
              },
              child: BlocBuilder<AddEditContactBloc, AddEditContactState>(
                buildWhen: (prev, curr) =>
                    prev.profileImagePath != curr.profileImagePath,
                builder: (context, state) {
                  Widget image;
                  if (state.profileImagePath.isEmpty) {
                    image = const Image(
                      image: AssetImage('assets/images/avatar_placeholder.png'),
                    );
                  } else {
                    image = Image.file(File(state.profileImagePath));
                  }
                  return image;
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _NicknameInput(),
                const SizedBox(height: 15),
                _NameInput(),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _DescriptionInput(),
          ),
        ],
      ),
    );
  }
}

class _NicknameInput extends StatelessWidget {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditContactBloc, AddEditContactState>(
      buildWhen: (prev, curr) => prev.nickname != curr.nickname,
      builder: (context, state) {
        _nicknameController.value = TextEditingValue(
            text: state.nickname,
            selection: TextSelection.fromPosition(
                TextPosition(offset: state.nickname.length)));
        return TextField(
          onChanged: (input) {
            context
                .read<AddEditContactBloc>()
                .add(ContactNicknameChanged(input));
          },
          controller: _nicknameController,
          decoration: const InputDecoration(hintText: 'Nickname'),
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditContactBloc, AddEditContactState>(
      buildWhen: (prev, curr) => prev.name != curr.name,
      builder: (context, state) {
        _nameController.value = TextEditingValue(
            text: state.name,
            selection: TextSelection.fromPosition(
                TextPosition(offset: state.name.length)));
        return TextField(
          onChanged: (input) {
            context.read<AddEditContactBloc>().add(ContactNameChanged(input));
          },
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Name'),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditContactBloc, AddEditContactState>(
      buildWhen: (prev, curr) => prev.description != curr.description,
      builder: (context, state) {
        _descriptionController.value = TextEditingValue(
            text: state.description,
            selection: TextSelection.fromPosition(
                TextPosition(offset: state.description.length)));
        return TextField(
          onChanged: (input) {
            context
                .read<AddEditContactBloc>()
                .add(ContactDescriptionChanged(input));
          },
          controller: _descriptionController,
          decoration: const InputDecoration(
            hintText: 'Description',
            filled: true,
          ),
          minLines: 5,
          maxLines: 5,
        );
      },
    );
  }
}

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:contacts/src/services/AppSettings/i_app_settings.dart';
import 'package:contacts/src/widgets/settings_page/bloc/settings_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  final String title = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocProvider<SettingsPageBloc>(
        create: (context) => SettingsPageBloc(
          appSettings: context.read<IAppSettings>(),
        ),
        child: _SettingsLayout(),
      ),
    );
  }
}

class _SettingsLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsPageBloc, SettingsPageState>(
      builder: (context, state) {
        return SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Common'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.sort_by_alpha),
                  title: const Text('Sort By'),
                  value: Text(state.sortBy.name),
                  onPressed: _onSortByPressed,
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  value: Text(state.selectedLanguage.name),
                  // todo: show action sheet with options and fire corresponding event
                ),
                SettingsTile.switchTile(
                  initialValue: state.isDarkThemeEnabled,
                  leading: const Icon(Icons.format_paint),
                  title: const Text('Enable dark theme'),
                  // todo: show action sheet with options and fire corresponding event
                  onToggle: (value) {},
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _onSortByPressed(BuildContext context) {
    final blocContext = context;
    showAdaptiveActionSheet(context: context, actions: <BottomSheetAction>[
      BottomSheetAction(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.date_range),
              SizedBox(width: 10),
              Text('Date'),
            ],
          ),
          onPressed: (context) {
            blocContext.read<SettingsPageBloc>().add(const SortByValueChanged(ESortBy.date));
            Navigator.pop(context);
          }),
      BottomSheetAction(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.text_fields),
              SizedBox(width: 10),
              Text('Name'),
            ],
          ),
          onPressed: (context) {
            blocContext.read<SettingsPageBloc>().add(const SortByValueChanged(ESortBy.name));
            Navigator.pop(context);
          }),
      BottomSheetAction(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.text_fields),
              SizedBox(width: 10),
              Text('Nickname'),
            ],
          ),
          onPressed: (context) {
            blocContext.read<SettingsPageBloc>().add(const SortByValueChanged(ESortBy.nickname));
            Navigator.pop(context);
          }),
    ]);
  }
}

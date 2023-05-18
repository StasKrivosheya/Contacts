import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:contacts/src/languages/bloc/language_bloc.dart';
import 'package:contacts/src/languages/language.dart';
import 'package:contacts/src/services/app_settings/i_app_settings.dart';
import 'package:contacts/src/theme/app_themes.dart';
import 'package:contacts/src/theme/bloc/theme_bloc.dart';
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
                  value: Text(state.selectedLanguage.displayableName),
                  onPressed: _showLanguagesSheet,
                ),
                SettingsTile.switchTile(
                  initialValue: state.isDarkThemeEnabled,
                  leading: const Icon(Icons.format_paint),
                  title: const Text('Enable dark theme'),
                  onToggle: (isDarkThemeSwitched) {
                    context.read<SettingsPageBloc>().add(ThemePreferenceChanged(
                        isDarkThemeEnabled: isDarkThemeSwitched));

                    final wantedTheme =
                        isDarkThemeSwitched ? AppTheme.dark : AppTheme.light;
                    context
                        .read<ThemeBloc>()
                        .add(ThemeChanged(theme: wantedTheme));
                  },
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
            blocContext
                .read<SettingsPageBloc>()
                .add(const SortByValueChanged(ESortBy.date));
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
            blocContext
                .read<SettingsPageBloc>()
                .add(const SortByValueChanged(ESortBy.name));
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
            blocContext
                .read<SettingsPageBloc>()
                .add(const SortByValueChanged(ESortBy.nickname));
            Navigator.pop(context);
          }),
    ]);
  }

  void _showLanguagesSheet(BuildContext context) {
    final pageBlocContext = context;

    showAdaptiveActionSheet(context: context, actions: [
      BottomSheetAction(
          title: Text(ELanguage.english.displayableName),
          onPressed: (context) {
            context.read<LanguageBloc>().add(
                const LanguageChanged(selectedLanguage: ELanguage.english));
            pageBlocContext.read<SettingsPageBloc>().add(const LanguageSettingsChanged(
                selectedLanguage: ELanguage.english));
            Navigator.pop(context);
          }),
      BottomSheetAction(
          title: Text(ELanguage.ukrainian.displayableName),
          onPressed: (context) {
            context.read<LanguageBloc>().add(
                const LanguageChanged(selectedLanguage: ELanguage.ukrainian));
            pageBlocContext.read<SettingsPageBloc>().add(const LanguageSettingsChanged(
                selectedLanguage: ELanguage.ukrainian));
            Navigator.pop(context);
          }),
    ]);
  }
}

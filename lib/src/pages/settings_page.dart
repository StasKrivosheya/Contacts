import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:contacts/src/languages/bloc/language_bloc.dart';
import 'package:contacts/src/languages/language.dart';
import 'package:contacts/src/services/app_settings/i_app_settings.dart';
import 'package:contacts/src/theme/app_themes.dart';
import 'package:contacts/src/theme/bloc/theme_bloc.dart';
import 'package:contacts/src/widgets/settings_page/bloc/settings_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
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
              title: Text(AppLocalizations.of(context)!.common),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.sort_by_alpha),
                  title: Text(AppLocalizations.of(context)!.sortBy),
                  value: Text(
                    state.sortBy == ESortBy.date
                        ? AppLocalizations.of(context)!.date.toLowerCase()
                        : state.sortBy == ESortBy.name
                            ? AppLocalizations.of(context)!.name.toLowerCase()
                            : AppLocalizations.of(context)!.nickname.toLowerCase(),
                  ),
                  onPressed: _onSortByPressed,
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: Text(AppLocalizations.of(context)!.language),
                  value: Text(state.selectedLanguage.displayableName),
                  onPressed: _showLanguagesSheet,
                ),
                SettingsTile.switchTile(
                  initialValue: state.isDarkThemeEnabled,
                  leading: const Icon(Icons.format_paint),
                  title: Text(AppLocalizations.of(context)!.darkTheme),
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
            children: [
              const Icon(Icons.date_range),
              const SizedBox(width: 10),
              Text(AppLocalizations.of(context)!.date),
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
            children: [
              const Icon(Icons.text_fields),
              const SizedBox(width: 10),
              Text(AppLocalizations.of(context)!.name),
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
            children: [
              const Icon(Icons.text_fields),
              const SizedBox(width: 10),
              Text(AppLocalizations.of(context)!.nickname),
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

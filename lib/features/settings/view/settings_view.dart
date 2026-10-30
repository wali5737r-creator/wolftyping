import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/settings_controller.dart';
import '../model/app_settings.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.settings,
      body: Obx(() {
        final s = controller.settings.value;

        if (s == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: [
            const PageHeader(
              title: 'Settings',
              subtitle: 'Control typing behavior and app preferences.',
            ),
            const SizedBox(height: AppDimensions.gapLarge),

            _Section(
              'Appearance',
              [
                _Choice(
                  'Theme',
                  _themeLabel(s.themeMode),
                  Icons.palette_outlined,
                  () => _themeDialog(context, s),
                ),
              ],
            ),

            _Section(
              'Typing',
              [
                _Choice(
                  'Default duration',
                  _durationLabel(s.defaultDurationSeconds),
                  Icons.timer_outlined,
                  () => _durationDialog(context, s),
                ),
                _Choice(
                  'Default language',
                  s.defaultLanguage == 'ur' ? 'Urdu' : 'English',
                  Icons.language,
                  () => _languageDialog(context, s),
                ),
                _Choice(
                  'Default test type',
                  s.defaultTestType == 'ppsc'
                      ? 'PPSC Urdu'
                      : 'Normal',
                  Icons.assignment_outlined,
                  () => _testTypeDialog(context, s),
                ),
                _Switch(
                  'Auto focus',
                  s.autoFocus,
                  (v) => controller.saveSettings(
                    s.copyWith(autoFocus: v),
                  ),
                ),
                _Switch(
                  'Show timer',
                  s.showTimer,
                  (v) => controller.saveSettings(
                    s.copyWith(showTimer: v),
                  ),
                ),
                _Switch(
                  'Show live WPM',
                  s.showLiveWpm,
                  (v) => controller.saveSettings(
                    s.copyWith(showLiveWpm: v),
                  ),
                ),
                _Switch(
                  'Show live accuracy',
                  s.showLiveAccuracy,
                  (v) => controller.saveSettings(
                    s.copyWith(showLiveAccuracy: v),
                  ),
                ),
                _Switch(
                  'Allow backspace',
                  s.allowBackspace,
                  (v) => controller.saveSettings(
                    s.copyWith(allowBackspace: v),
                  ),
                ),
              ],
            ),

            _Section(
              'Daily Goal',
              [
                _Choice(
                  'Daily practice goal',
                  _goalLabel(s.dailyGoalSeconds),
                  Icons.flag_outlined,
                  () => _goalDialog(context, s),
                ),
              ],
            ),

            _Section(
              'Urdu & Practice',
              [
                _Switch(
                  'Urdu RTL display',
                  s.urduRtl,
                  (v) => controller.saveSettings(
                    s.copyWith(urduRtl: v),
                  ),
                ),
                _Choice(
                  'General practice difficulty',
                  s.practiceDifficulty.capitalizeFirst!,
                  Icons.school_outlined,
                  () => _difficultyDialog(context, s),
                ),
              ],
            ),

            _Section(
              'Data',
              [
                ListTile(
                  leading: const Icon(
                    Icons.delete_sweep_outlined,
                  ),
                  title: const Text('Clear typing history'),
                  subtitle: const Text(
                    'Deletes tests and related mistakes only',
                  ),
                  onTap: () => _confirmClear(context),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.restore_outlined,
                  ),
                  title: const Text('Reset settings'),
                  subtitle: const Text(
                    'Restores settings to safe defaults',
                  ),
                  onTap: () => _confirmReset(context),
                ),
              ],
            ),

            const _Section(
              'About',
              [
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('WolfTyping'),
                  subtitle: Text(
                    'Offline desktop typing practice for English, Urdu and PPSC.',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }

  String _themeLabel(ThemeMode mode) {
    if (mode == ThemeMode.light) return 'Light';
    if (mode == ThemeMode.dark) return 'Dark';
    return 'System';
  }

  String _durationLabel(int value) {
    if (value >= 60) {
      return '${value ~/ 60} minute${value == 60 ? '' : 's'}';
    }

    return '${value}s';
  }

  String _goalLabel(int value) {
    return '${value ~/ 60} minutes';
  }

  Future<void> _themeDialog(
    BuildContext context,
    AppSettings settings,
  ) async {
    final value = await _select<ThemeMode>(
      context,
      'Theme',
      [
        ThemeMode.system,
        ThemeMode.light,
        ThemeMode.dark,
      ],
      _themeLabel,
      settings.themeMode,
    );

    if (value != null) {
      await controller.setTheme(value);
    }
  }

  Future<void> _durationDialog(
    BuildContext context,
    AppSettings settings,
  ) async {
    final value = await _select<int>(
      context,
      'Default duration',
      [30, 60, 120, 300, 600],
      _durationLabel,
      settings.defaultDurationSeconds,
    );

    if (value != null) {
      await controller.saveSettings(
        settings.copyWith(
          defaultDurationSeconds: value,
        ),
      );
    }
  }

  Future<void> _languageDialog(
    BuildContext context,
    AppSettings settings,
  ) async {
    final value = await _select<String>(
      context,
      'Default language',
      ['en', 'ur'],
      (value) => value == 'en' ? 'English' : 'Urdu',
      settings.defaultLanguage,
    );

    if (value != null) {
      await controller.saveSettings(
        settings.copyWith(
          defaultLanguage: value,
          defaultTestType: value == 'en'
              ? 'normal'
              : settings.defaultTestType,
        ),
      );
    }
  }

  Future<void> _testTypeDialog(
    BuildContext context,
    AppSettings settings,
  ) async {
    // PPSC is an Urdu test, so choosing it also makes Urdu the default
    // language (see below) - it can be picked from either language.
    final options = ['normal', 'ppsc'];

    final value = await _select<String>(
      context,
      'Default test type',
      options,
      (value) => value == 'ppsc' ? 'PPSC Urdu' : 'Normal',
      settings.defaultTestType,
    );

    if (value != null) {
      await controller.saveSettings(
        settings.copyWith(
          defaultTestType: value,
          defaultLanguage: value == 'ppsc' ? 'ur' : settings.defaultLanguage,
        ),
      );
    }
  }

 

  Future<void> _goalDialog(
    BuildContext context,
    AppSettings settings,
  ) async {
    final value = await _select<int>(
      context,
      'Daily goal',
      [300, 600, 900, 1200, 1800, 2700, 3600],
      (value) => '${value ~/ 60} minutes',
      settings.dailyGoalSeconds,
    );

    if (value != null) {
      await controller.saveSettings(
        settings.copyWith(
          dailyGoalSeconds: value,
        ),
      );
    }
  }

  Future<void> _difficultyDialog(
    BuildContext context,
    AppSettings settings,
  ) async {
    final value = await _select<String>(
      context,
      'General practice difficulty',
      [
        'beginner',
        'intermediate',
        'advanced',
      ],
      (value) => value.capitalizeFirst!,
      settings.practiceDifficulty,
    );

    if (value != null) {
      await controller.saveSettings(
        settings.copyWith(
          practiceDifficulty: value,
        ),
      );
    }
  }

  Future<T?> _select<T>(
    BuildContext context,
    String title,
    List<T> values,
    String Function(T) label,
    T selected,
  ) {
    return showDialog<T>(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Text(title),
          children: [
            for (final value in values)
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, value);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(label(value)),
                    ),
                    if (value == selected)
                      const Icon(Icons.check),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Clear typing history?',
          ),
          content: const Text(
            'This deletes completed tests and related mistakes. '
            'Your profile, lessons and settings remain.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (ok == true) {
      await controller.clearHistory();

      Get.snackbar(
        'History cleared',
        'Typing history and mistakes were deleted.',
      );
    }
  }

  Future<void> _confirmReset(
    BuildContext context,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Reset settings?',
          ),
          content: const Text(
            'Only settings will be reset. Your typing history '
            'and paragraphs will stay safe.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (ok == true) {
      await controller.reset();

      Get.snackbar(
        'Settings reset',
        'Default settings restored.',
      );
    }
  }
}

class _Section extends StatelessWidget {
  const _Section(
    this.title,
    this.children,
  );

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              title,
              style: AppTextStyles.h3,
            ),
          ),
          const SizedBox(height: 10),
          SoftSurface(
            padding: EdgeInsets.zero,
            child: Material(
              // Transparent Material so ListTile/Switch ink shows above
              // the card colour instead of being hidden beneath it.
              type: MaterialType.transparency,
              child: Column(
                children: [
                  for (int i = 0; i < children.length; i++) ...[
                    if (i > 0)
                      Divider(
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.6),
                      ),
                    children[i],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice(
    this.title,
    this.value,
    this.icon,
    this.onTap,
  );

  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      onTap: onTap,
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch(
    this.title,
    this.value,
    this.onChanged,
  );

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';

class SettingsModal extends ConsumerStatefulWidget {
  const SettingsModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsModalState();
}

class _SettingsModalState extends ConsumerState<SettingsModal> {
  void handleToggle() {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings', style: AppStyles.headingFour),
          const SizedBox(height: 20),
          ListTile(
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            trailing: Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).themeMode ==
                  ThemeMode.dark,
              onChanged: (value) => handleToggle(),
            ),
          ),
        ],
      ),
    );
  }
}

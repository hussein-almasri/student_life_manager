import 'package:flutter/material.dart';
import '../../core/data/app_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = AppData.settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('settings '),
      ),
      body: ListView(
        children: [
          // 🌙 Dark Mode
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark mode'),
            subtitle: const Text('Turn on/off dark mode'),
            value: settings.darkMode,
            onChanged: (value) {
              final updatedSettings =
                  settings.copyWith(darkMode: value);

              AppData.saveSettings(updatedSettings);

              setState(() {});
            },
          ),

          const Divider(),

          // 🔔 Notifications (جاهز للمستقبل)
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('التنبيهات'),
            subtitle: const Text('تشغيل / إيقاف التنبيهات'),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              final updatedSettings =
                  settings.copyWith(notificationsEnabled: value);

              AppData.saveSettings(updatedSettings);

              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

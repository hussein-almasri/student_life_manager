import 'package:flutter/material.dart';
import 'package:student_life_manager/core/data/app_data.dart';
import 'package:student_life_manager/core/settings/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<AppSettings> _future;

  @override
  void initState() {
    super.initState();
    _future = AppData.getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppSettings>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final settings = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark mode'),
                value: settings.darkMode,
                onChanged: (v) async {
                  await AppData.saveSettings(
                    settings.copyWith(darkMode: v),
                  );
                  setState(() {
                    _future = AppData.getSettings();
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/data/app_data.dart';
import 'home_screen.dart';
import 'core/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('subjects');
  await Hive.openBox('tasks');
  await Hive.openBox('settings');
  await Hive.openBox('notes');

  await NotificationService.init();

  runApp(const StudentLifeApp());
}

class StudentLifeApp extends StatefulWidget {
  const StudentLifeApp({super.key});

  @override
  State<StudentLifeApp> createState() => _StudentLifeAppState();
}

class _StudentLifeAppState extends State<StudentLifeApp> {
  @override
  Widget build(BuildContext context) {
    final settings = AppData.settings;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Life Manager',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}

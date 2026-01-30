import 'package:flutter/material.dart';
import 'package:student_life_manager/core/theme/app_theme.dart';
import 'package:student_life_manager/core/data/app_data.dart';
import 'package:student_life_manager/core/settings/app_settings.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudentLifeApp());
}

class StudentLifeApp extends StatelessWidget {
  const StudentLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppSettings>(
      future: AppData.getSettings(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return ValueListenableBuilder<bool>(
          valueListenable: darkModeNotifier,
          builder: (context, isDark, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode:
                  isDark ? ThemeMode.dark : ThemeMode.light,
              home: const HomeScreen(),
            );
          },
        );
      },
    );
  }
}

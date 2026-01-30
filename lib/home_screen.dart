import 'package:flutter/material.dart';

import 'features/dashboard/dashboard_screen.dart';
import 'features/subjects/subjects_screen.dart';
import 'features/tasks/tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const DashboardScreen(),
      SubjectsScreen(), // ✅ بدون const
      const TasksScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book),
            label: 'subjects',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment),
            label: 'tasks',
          ),
        ],
      ),
    );
  }
}

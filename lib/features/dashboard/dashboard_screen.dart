import 'package:flutter/material.dart';
import '../../core/data/app_data.dart';
import '../settings/settings_screen.dart';
import '../../features/tasks/task_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: AppData.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final tasks = snapshot.data ?? [];

        final totalTasks = tasks.length;
        final completedTasks = tasks.where((t) => t.isDone).length;
        final pendingTasks = totalTasks - completedTasks;

        final progress =
            totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

        return Scaffold(
          appBar: AppBar(
            title: const Text('home'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Todays summary',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),

                Text(
                  'Percentage of completion',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 8),
                Text('${(progress * 100).toStringAsFixed(0)}% complete'),

                const SizedBox(height: 32),

                Row(
                  children: [
                    _StatCard(
                      title: 'all tasks',
                      value: totalTasks.toString(),
                      icon: Icons.assignment,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    _StatCard(
                      title: 'Completed',
                      value: completedTasks.toString(),
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _StatCard(
                      title: 'remaining',
                      value: pendingTasks.toString(),
                      icon: Icons.schedule,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: color),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}


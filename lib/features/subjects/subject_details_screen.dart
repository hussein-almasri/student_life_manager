import 'package:flutter/material.dart';
import 'package:student_life_manager/core/data/app_data.dart';
import 'package:student_life_manager/features/tasks/task_model.dart';
import 'package:student_life_manager/notes/notes_screen.dart';

class SubjectDetailsScreen extends StatelessWidget {
  final String subjectName;

  const SubjectDetailsScreen({
    super.key,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: AppData.getTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final tasks = snapshot.data!
            .where((t) => t.subject == subjectName)
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(subjectName),
          ),

          // ✅ هذا الزر هو الحل
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.note_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotesScreen(
                    subjectName: subjectName,
                  ),
                ),
              );
            },
          ),

          body: tasks.isEmpty
              ? const Center(
                  child: Text('No tasks for this subject'),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      leading: Icon(
                        task.isDone
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                      ),
                      title: Text(task.title),
                    );
                  },
                ),
        );
      },
    );
  }
}

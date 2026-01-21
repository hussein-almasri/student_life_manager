import 'package:flutter/material.dart';
import '../../core/data/app_data.dart';
import 'subject_details_screen.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  void _addSubject() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة مادة'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'اسم المادة',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;

                AppData.addSubject(controller.text.trim());
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjects = AppData.subjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المواد'),
      ),
      body: subjects.isEmpty
          ? const Center(child: Text('لا يوجد مواد'))
          : ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];

                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(subject.name),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubjectDetailsScreen(
                          subjectName: subject.name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSubject,
        child: const Icon(Icons.add),
      ),
    );
  }
}

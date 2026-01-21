import 'package:flutter/material.dart';
import '../../core/data/app_data.dart';

class SubjectDetailsScreen extends StatelessWidget {
  final String subjectName;

  const SubjectDetailsScreen({
    super.key,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    final subjectTasks = AppData.tasks
        .where((task) => task.subject == subjectName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
      ),
      body: subjectTasks.isEmpty
          ? const Center(
              child: Text('لا يوجد واجبات لهذه المادة'),
            )
          : ListView.builder(
              itemCount: subjectTasks.length,
              itemBuilder: (context, index) {
                final task = subjectTasks[index];
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.note),
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
    );
  }
}

/// ================= NOTES SCREEN =================

class NotesScreen extends StatefulWidget {
  final String subjectName;

  const NotesScreen({
    super.key,
    required this.subjectName,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _noteController = TextEditingController();

  /// ➕ إضافة ملاحظة (Hive)
  void _addNote() {
    _noteController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة ملاحظة'),
          content: TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: 'اكتب ملاحظتك هنا',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_noteController.text.trim().isEmpty) return;

                AppData.addNote(
                  subject: widget.subjectName,
                  title: 'ملاحظة',
                  content: _noteController.text.trim(),
                );

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

  /// ✏️ تعديل ملاحظة
  void _editNote(Map note) {
    _noteController.text = note['content'];
    final key = AppData.notesBoxKey(note);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تعديل الملاحظة'),
          content: TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: 'عدّل الملاحظة',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_noteController.text.trim().isEmpty) return;

                AppData.updateNote(
                  key,
                  note['title'],
                  _noteController.text.trim(),
                );

                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = AppData.notesBySubject(widget.subjectName);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes - ${widget.subjectName}'),
      ),
      body: notes.isEmpty
          ? const Center(child: Text('لا يوجد ملاحظات'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Dismissible(
                  key: ValueKey(note['id']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    final key = AppData.notesBoxKey(note);
                    AppData.deleteNote(key);
                    setState(() {});
                  },
                  child: ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(note['content']),
                    onTap: () => _editNote(note),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}

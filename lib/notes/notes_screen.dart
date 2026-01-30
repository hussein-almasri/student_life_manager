import 'package:flutter/material.dart';
import 'package:student_life_manager/core/data/app_data.dart';

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
  List<Map<String, dynamic>> notes = [];
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data =
        await AppData.getNotesBySubject(widget.subjectName);
    setState(() {
      notes = data;
    });
  }

  /// ➕ إضافة / ✏️ تعديل
  void _openNoteDialog({Map<String, dynamic>? note}) {
    if (note != null) {
      _noteController.text = note['content'];
    } else {
      _noteController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note == null ? 'Add a note' : 'Edit the note'),
          content: TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: 'Write your note here',
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _noteController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_noteController.text.trim().isEmpty) return;

                if (note == null) {
                  // ➕ إضافة
                  await AppData.addNote(
                    subject: widget.subjectName,
                    title: 'Note',
                    content: _noteController.text.trim(),
                  );
                } else {
                  // ✏️ تعديل
                  await AppData.updateNote(
                    note['id'],
                    note['title'],
                    _noteController.text.trim(),
                  );
                }

                _noteController.clear();
                Navigator.pop(context);
                _loadNotes(); // 🔥 إعادة تحميل من DB
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes - ${widget.subjectName}'),
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes yet'))
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
                    child: const Icon(Icons.delete,
                        color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    await AppData.deleteNote(note['id']);
                    _loadNotes();
                  },
                  child: ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(note['content']),
                    subtitle: Text(
                      note['createdDate']
                          .toString()
                          .substring(0, 10),
                    ),
                    onTap: () =>
                        _openNoteDialog(note: note),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

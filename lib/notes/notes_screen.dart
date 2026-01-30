import 'package:flutter/material.dart';

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
  final List<String> notes = [];

  final TextEditingController _noteController = TextEditingController();

  /// ➕ إضافة / ✏️ تعديل
  void _openNoteDialog({int? index}) {
    if (index != null) {
      _noteController.text = notes[index];
    } else {
      _noteController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? ' Add a note' : 'Edit the note '),
          content: TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: 'write your note here ',
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _noteController.clear();
                Navigator.pop(context);
              },
              child: const Text('delete'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_noteController.text.trim().isEmpty) return;

                setState(() {
                  if (index == null) {
                    notes.add(_noteController.text.trim());
                  } else {
                    notes[index] = _noteController.text.trim();
                  }
                });

                _noteController.clear();
                Navigator.pop(context);
              },
              child: const Text('save'),
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
        title: Text('note  - ${widget.subjectName}'),
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No note yet'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(notes[index]),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() {
                      notes.removeAt(index);
                    });
                  },
                  child: ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(notes[index]),
                    onTap: () => _openNoteDialog(index: index),
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

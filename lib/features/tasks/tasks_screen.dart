import 'package:flutter/material.dart';
import '../../core/data/app_data.dart';
import 'task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _searchQuery = '';
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = AppData.getTasks();
  }

  void _refresh() {
    setState(() {
      _tasksFuture = AppData.getTasks();
    });
  }

  Future<void> _addTask() async {
    final subjects = await AppData.getSubjects();

    if (subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add subject first')),
      );
      return;
    }

    final titleController = TextEditingController();
    String? selectedSubject;
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adding a task'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(hintText: 'Task name'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  hint: const Text('Choose subject'),
                  items: subjects
                      .map(
                        (s) => DropdownMenuItem(
                          value: s.name,
                          child: Text(s.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => selectedSubject = value,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    selectedDate == null
                        ? 'Choose date'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  ),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365)),
                      initialDate: DateTime.now(),
                    );
                    if (date != null) {
                      selectedDate = date;
                    }
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    selectedTime == null
                        ? 'Choose time'
                        : selectedTime!.format(context),
                  ),
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      selectedTime = time;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    selectedSubject == null ||
                    selectedDate == null ||
                    selectedTime == null) {
                  return;
                }

                final dueDate = DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );

                final task = Task(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: titleController.text,
                  subject: selectedSubject!,
                  dueDate: dueDate,
                );

                await AppData.addTask(task);

                

                _refresh();
                Navigator.pop(context);
              },
              child: const Text('Add'),
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
        title: const Text('Tasks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search task or subject...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}'));
                }

                final tasks = snapshot.data!
                  ..sort(
                      (a, b) => a.dueDate.compareTo(b.dueDate));

                final filteredTasks = tasks.where((task) {
                  final q = _searchQuery.toLowerCase();
                  return task.title.toLowerCase().contains(q) ||
                      task.subject.toLowerCase().contains(q);
                }).toList();

                if (filteredTasks.isEmpty) {
                  return const Center(
                      child: Text('No results found'));
                }

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];

                    return ListTile(
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (value) async {
                          await AppData.toggleTask(
                              task.id, value ?? false);
                          _refresh();
                        },
                      ),
                      title: Text(task.title),
                      subtitle: Text(
                        '${task.subject} • '
                        '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year} '
                        '${task.dueDate.hour}:${task.dueDate.minute.toString().padLeft(2, '0')}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}

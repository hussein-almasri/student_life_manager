import 'package:flutter/material.dart';
import '../../core/data/app_data.dart';
import '../../core/notifications/notification_service.dart';
import 'task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _searchQuery = '';

  void _addTask() async {
    if (AppData.subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add material first')),
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
          title: const Text('Adding a tasks'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(hintText: 'Tasks Name'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  hint: const Text('Choose the material'),
                  items: AppData.subjects
                      .map(
                        (s) => DropdownMenuItem(
                          value: s.name,
                          child: Text(s.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    selectedSubject = value;
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    selectedDate == null
                        ? 'Choosing the end time '
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
                      setState(() => selectedDate = date);
                    }
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    selectedTime == null
                        ? 'Choosing the time'
                        : selectedTime!.format(context),
                  ),
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() => selectedTime = time);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('delete '),
            ),
            ElevatedButton(
              onPressed: () {
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

                // ✅ إنشاء الواجب
                final task = Task(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: titleController.text,
                  subject: selectedSubject!,
                  dueDate: dueDate,
                );

                // 💾 حفظ الواجب
                AppData.addTask(task);

                // 🔔 جدولة التنبيه قبل ساعة
                final notificationTime =
                    dueDate.subtract(const Duration(hours: 1));

                if (notificationTime.isAfter(DateTime.now())) {
                  NotificationService.scheduleTaskNotification(
                    id: task.id,
                    title: '📚 ${task.title} - ${task.subject}',
                    scheduledTime: notificationTime,
                  );
                }

                setState(() {});
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
    final tasks = [...AppData.tasks]
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    final filteredTasks = tasks.where((task) {
      final q = _searchQuery.toLowerCase();
      return task.title.toLowerCase().contains(q) ||
          task.subject.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks '),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search for an tasks or subject...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(child: Text('No results found'))
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];

                      return ListTile(
                        leading: Checkbox(
                          value: task.isDone,
                          onChanged: (value) {
                            AppData.toggleTaskById(
                                task.id, value ?? false);
                            setState(() {});
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

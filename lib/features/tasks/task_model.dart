class Task {
  final int id;
  final String title;
  final String subject;
  final DateTime dueDate; // 🔥 جديد
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.isDone = false,
  });
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../features/subjects/subject_model.dart';
import '../../features/tasks/task_model.dart';
import '../settings/app_settings.dart';

/// 🔔 Notifier للتحكم بالـ Dark Mode
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);

class AppData {
  // ===== Hive Boxes =====
  static final Box subjectsBox = Hive.box('subjects');
  static final Box tasksBox = Hive.box('tasks');
  static final Box settingsBox = Hive.box('settings');
  static final Box notesBox = Hive.box('notes');

  // ===== Subjects =====
  static List<Subject> get subjects =>
      subjectsBox.values
          .map((e) => Subject(name: e as String))
          .toList();

  static void addSubject(String name) {
    subjectsBox.add(name);
  }

  // ===== Tasks =====
  static List<Task> get tasks =>
      tasksBox.values.map<Task>((e) {
        final map = Map<String, dynamic>.from(e as Map);

        return Task(
          id: map['id'] as int,
          title: map['title'] as String,
          subject: map['subject'] as String,
          dueDate: DateTime.parse(map['dueDate'] as String),
          isDone: map['isDone'] as bool,
        );
      }).toList();

  static void addTask(Task task) {
    tasksBox.add({
      'id': task.id,
      'title': task.title,
      'subject': task.subject,
      'dueDate': task.dueDate.toIso8601String(),
      'isDone': task.isDone,
    });
  }

  static void toggleTaskById(int id, bool value) {
    final index = tasksBox.values
        .toList()
        .indexWhere((e) => (e as Map)['id'] == id);

    if (index == -1) return;

    final task = Map<String, dynamic>.from(tasksBox.getAt(index));
    task['isDone'] = value;
    tasksBox.putAt(index, task);
  }

  static void deleteTaskById(int id) {
    final index = tasksBox.values
        .toList()
        .indexWhere((e) => (e as Map)['id'] == id);

    if (index == -1) return;

    tasksBox.deleteAt(index);
  }

  // ===== Settings =====
  static AppSettings get settings {
    final data = settingsBox.get('app_settings');

    if (data == null) {
      final deviceLang =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode;

      final defaults = AppSettings.defaultSettings(deviceLang);

      settingsBox.put('app_settings', defaults.toMap());
      darkModeNotifier.value = defaults.darkMode;
      return defaults;
    }

    final settings =
        AppSettings.fromMap(Map<String, dynamic>.from(data));

    darkModeNotifier.value = settings.darkMode;
    return settings;
  }

  static void saveSettings(AppSettings settings) {
    settingsBox.put('app_settings', settings.toMap());
    darkModeNotifier.value = settings.darkMode;
  }

  // ===== Notes =====

  static List<Map<String, dynamic>> notesBySubject(String subject) {
    return notesBox.values
        .cast<Map>()
        .where((n) => n['subject'] == subject)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  static void addNote({
    required String subject,
    required String title,
    required String content,
  }) {
    notesBox.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'subject': subject,
      'title': title,
      'content': content,
      'createdDate': DateTime.now().toIso8601String(),
    });
  }

  static void updateNote(int key, String title, String content) {
    final raw = notesBox.get(key);
    if (raw == null) return;

    final note = Map<String, dynamic>.from(raw);
    note['title'] = title;
    note['content'] = content;
    notesBox.put(key, note);
  }

  static void deleteNote(int key) {
    if (!notesBox.containsKey(key)) return;
    notesBox.delete(key);
  }

  static int notesBoxKey(Map note) {
    return notesBox.keys.firstWhere(
      (k) => notesBox.get(k)?['id'] == note['id'],
    );
  }
}

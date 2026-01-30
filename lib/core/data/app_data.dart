import 'package:flutter/material.dart';
import 'package:student_life_manager/core/data/database_helper.dart';
import 'package:student_life_manager/core/settings/app_settings.dart';
import 'package:student_life_manager/features/subjects/subject_model.dart';
import 'package:student_life_manager/features/tasks/task_model.dart';

final ValueNotifier<bool> darkModeNotifier = ValueNotifier(false);

class AppData {
  static final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // ===== Subjects =====
  static Future<List<Subject>> getSubjects() async {
    final db = await dbHelper.database;
    final result = await db.query('subjects');
    return result
        .map((e) => Subject(name: e['name'] as String))
        .toList();
  }

  static Future<void> addSubject(String name) async {
    final db = await dbHelper.database;
    await db.insert('subjects', {
      'name': name.trim(), // 🔧 تطبيع
    });
  }

  // ===== Tasks =====
  static Future<List<Task>> getTasks() async {
    final db = await dbHelper.database;
    final result = await db.query('tasks');
    return result.map((e) => Task(
      id: e['id'] as int,
      title: e['title'] as String,
      subject: e['subject'] as String,
      dueDate: DateTime.parse(e['dueDate'] as String),
      isDone: (e['isDone'] as int) == 1,
    )).toList();
  }

  static Future<void> addTask(Task task) async {
    final db = await dbHelper.database;
    await db.insert('tasks', {
      'id': task.id,
      'title': task.title,
      'subject': task.subject.trim().toLowerCase(), // 🔧 مهم
      'dueDate': task.dueDate.toIso8601String(),
      'isDone': task.isDone ? 1 : 0,
    });
  }

  static Future<void> toggleTask(int id, bool value) async {
    final db = await dbHelper.database;
    await db.update(
      'tasks',
      {'isDone': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ===== Notes =====
  static Future<List<Map<String, dynamic>>> getNotesBySubject(
      String subject) async {
    final db = await dbHelper.database;
    return db.query(
      'notes',
      where: 'subject = ?',
      whereArgs: [subject.trim().toLowerCase()], // ✅ الحل
      orderBy: 'createdDate DESC',
    );
  }

  static Future<void> addNote({
    required String subject,
    required String title,
    required String content,
  }) async {
    final db = await dbHelper.database;
    await db.insert('notes', {
      'subject': subject.trim().toLowerCase(), // ✅ الحل
      'title': title,
      'content': content,
      'createdDate': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> updateNote(
    int id,
    String title,
    String content,
  ) async {
    final db = await dbHelper.database;
    await db.update(
      'notes',
      {
        'title': title,
        'content': content,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteNote(int id) async {
    final db = await dbHelper.database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ===== Settings =====
  static Future<AppSettings> getSettings() async {
    final db = await dbHelper.database;
    final result = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['app_settings'],
    );

    if (result.isEmpty) {
      final lang =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      final defaults = AppSettings.defaultSettings(lang);

      await db.insert('settings', {
        'key': 'app_settings',
        'value': defaults.toJson(),
      });

      darkModeNotifier.value = defaults.darkMode;
      return defaults;
    }

    final settings =
        AppSettings.fromJson(result.first['value'] as String);
    darkModeNotifier.value = settings.darkMode;
    return settings;
  }

  static Future<void> saveSettings(AppSettings settings) async {
    final db = await dbHelper.database;
    await db.update(
      'settings',
      {'value': settings.toJson()},
      where: 'key = ?',
      whereArgs: ['app_settings'],
    );
    darkModeNotifier.value = settings.darkMode;
  }
}

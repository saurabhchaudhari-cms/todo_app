import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/models/task.dart';

// provider for SharedPreferences instance; override in main before using

class TaskNotifier extends Notifier<List<Task>> {
  static const _key = 'tasks';

  @override
  List<Task> build() {
    final raw = ref.read(prefsProvider).getStringList(_key) ?? [];
    if (raw.isEmpty) return [];
    return raw.map((e) => Task.fromJson(jsonDecode(e))).toList();
  }

  SharedPreferences get prefs => ref.read(prefsProvider);
  void addTask(String title) {
    state = [...state, Task(title: title)];
    _saveTasks();
  }

  void _saveTasks() {
    final saveData = state.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList(_key, saveData);
  }

  void searchList(String query) {
    final raw = ref.read(prefsProvider).getStringList(_key) ?? [];
    if (raw.isEmpty) return;
    final allTasks = raw.map((e) => Task.fromJson(jsonDecode(e))).toList();
    if (query.trim().isEmpty) {
      state = allTasks;
      return;
    }
    state = allTasks
        .where(
          (task) =>
              task.title.toLowerCase().contains(query.toLowerCase().trim()),
        )
        .toList();
  }

  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
    _saveTasks();
  }

  void toggleTask(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isDone: !task.isDone) else task,
    ];
    _saveTasks();
  }
}

final prefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences has not been initialized');
});

final taskProvider = NotifierProvider<TaskNotifier, List<Task>>(
  TaskNotifier.new,
);

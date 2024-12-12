import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks_api/tasks_api.dart';

/// {@template local_storage_tasks_api}
/// A Flutter implementation of the [TasksApi] that uses local storage.
/// {@endtemplate}
class LocalStorageTasksApi extends TasksApi {
  /// {@macro local_storage_tasks_api}
  LocalStorageTasksApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  late final _taskStreamController = BehaviorSubject<List<Task>>.seeded(
    const [],
  );

  /// The key used for storing the tasks locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kTasksCollectionKey = '__tasks_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final tasksJson = _getValue(kTasksCollectionKey);
    if (tasksJson != null) {
      final tasks = List<Map<dynamic, dynamic>>.from(
        json.decode(tasksJson) as List,
      )
          .map((jsonMap) => Task.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _taskStreamController.add(tasks);
    } else {
      _taskStreamController.add(const []);
    }
  }

  @override
  Stream<List<Task>> getTasks() => _taskStreamController.asBroadcastStream();

  @override
  Future<void> saveTask(Task task) {
    final tasks = [..._taskStreamController.value];
    final taskIndex = tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex >= 0) {
      tasks[taskIndex] = task;
    } else {
      tasks.add(task);
    }

    _taskStreamController.add(tasks);
    return _setValue(kTasksCollectionKey, json.encode(tasks));
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = [..._taskStreamController.value];
    final taskIndex = tasks.indexWhere((t) => t.id == id);
    if (taskIndex == -1) {
      throw TaskNotFoundException();
    } else {
      tasks.removeAt(taskIndex);
      _taskStreamController.add(tasks);
      return _setValue(kTasksCollectionKey, json.encode(tasks));
    }
  }

  @override
  Future<int> clearCompleted() async {
    final tasks = [..._taskStreamController.value];
    final completedTasksAmount = tasks.where((t) => t.isCompleted).length;
    tasks.removeWhere((t) => t.isCompleted);
    _taskStreamController.add(tasks);
    await _setValue(kTasksCollectionKey, json.encode(tasks));
    return completedTasksAmount;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    final tasks = [..._taskStreamController.value];
    final changedTasksAmount =
        tasks.where((t) => t.isCompleted != isCompleted).length;
    final newTasks = [
      for (final task in tasks) task.copyWith(isCompleted: isCompleted),
    ];
    _taskStreamController.add(newTasks);
    await _setValue(kTasksCollectionKey, json.encode(newTasks));
    return changedTasksAmount;
  }

  @override
  Future<void> close() {
    return _taskStreamController.close();
  }

  @override
  Future<int> setAllToday() async {
    final tasks = [..._taskStreamController.value];
    final uncompletedTasks = tasks.where((t) => !t.isCompleted);
    final newTasks = [
      for (final task in uncompletedTasks) task.copyWith(due: DateTime.now()),
    ];
    _taskStreamController.add(newTasks);
    await _setValue(kTasksCollectionKey, json.encode(newTasks));
    return uncompletedTasks.length;
  }
}

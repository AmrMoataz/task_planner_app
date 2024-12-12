import 'package:tasks_api/src/models/task.dart';

/// {@template tasks_api}
/// The interface for an API that provides access to a list of tasks.
/// {@endtemplate}
abstract class TasksApi {
  /// {@macro tasks_api}
  const TasksApi();

  /// Provides a [Stream] of all tasks.
  Stream<List<Task>> getTasks();

  /// Saves a [task].
  ///
  /// If a [task] with the same id already exists, it will be replaced.
  Future<void> saveTask(Task task);

  /// Deletes the `task` with the given id.
  ///
  /// If no `task` with the given id exists, a [TaskNotFoundException] error is
  /// thrown.
  Future<void> deleteTask(String id);

  /// Deletes all completed tasks.
  ///
  /// Returns the number of deleted tasks.
  Future<int> clearCompleted();

  /// Sets the `isCompleted` state of all tasks to the given value.
  ///
  /// Returns the number of updated tasks.
  Future<int> completeAll({required bool isCompleted});

  /// Sets all tasks due to current day
  ///
  /// Returns the number of updated tasks.
  Future<int> setAllToday();

  /// Closes the client and frees up any resources.
  Future<void> close();
}

/// Error thrown when a [Task] with a given id is not found.
class TaskNotFoundException implements Exception {}

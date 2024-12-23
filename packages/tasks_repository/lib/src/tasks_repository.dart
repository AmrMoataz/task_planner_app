import 'package:tasks_api/tasks_api.dart';

/// {@template tasks_repository}
/// A repository that handles `task` related requests.
/// {@endtemplate}
class TasksRepository {
  /// {@macro tasks_repository}
  const TasksRepository({
    required TasksApi tasksApi,
  }) : _tasksApi = tasksApi;

  final TasksApi _tasksApi;

  /// Provides a [Stream] of all tasks.
  Stream<List<Task>> getTasks() => _tasksApi.getTasks();

  /// Saves a [task].
  ///
  /// If a [task] with the same id already exists, it will be replaced.
  Future<void> saveTask(Task task) => _tasksApi.saveTask(task);

  /// Deletes the `task` with the given id.
  ///
  /// If no `task` with the given id exists, a [TaskNotFoundException] error is
  /// thrown.
  Future<void> deleteTask(String id) => _tasksApi.deleteTask(id);

  /// Deletes all completed tasks.
  ///
  /// Returns the number of deleted tasks.
  Future<int> clearCompleted() => _tasksApi.clearCompleted();

  /// Sets the `isCompleted` state of all tasks to the given value.
  ///
  /// Returns the number of updated tasks.
  Future<int> completeAll({required bool isCompleted}) =>
      _tasksApi.completeAll(isCompleted: isCompleted);

  /// Sets the `due` date of all uncompleted tasks to today.
  ///
  /// Returns the number of updated tasks.
  Future<int> setAllToday() => _tasksApi.setAllToday();
}

part of 'tasks_overview_bloc.dart';

enum TasksOverviewStatus { initial, loading, success, failure }

final class TasksOverviewState extends Equatable {
  const TasksOverviewState(
      {this.status = TasksOverviewStatus.initial,
      this.tasks = const [],
      this.filter = TasksViewFilter.all,
      this.lastDeletedTask,
      this.categories = const []});

  final TasksOverviewStatus status;
  final List<Task> tasks;
  final TasksViewFilter filter;
  final Task? lastDeletedTask;
  final List<Category> categories;

  @override
  List<Object?> get props => [status, tasks, filter, lastDeletedTask];

  Iterable<Task> get filteredTasks => filter.applyAll(tasks);

  TasksOverviewState copyWith({
    TasksOverviewStatus Function()? status,
    List<Task> Function()? tasks,
    TasksViewFilter Function()? filter,
    Task? Function()? lastDeletedTask,
    List<Category> Function()? categories,
  }) {
    return TasksOverviewState(
      status: status != null ? status() : this.status,
      tasks: tasks != null ? tasks() : this.tasks,
      filter: filter != null ? filter() : this.filter,
      categories: categories != null ? categories() : this.categories,
      lastDeletedTask:
          lastDeletedTask != null ? lastDeletedTask() : this.lastDeletedTask,
    );
  }
}

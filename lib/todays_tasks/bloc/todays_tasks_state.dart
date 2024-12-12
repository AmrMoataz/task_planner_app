part of 'todays_tasks_bloc.dart';

enum TodaysTasksStatus { initial, loading, success, failure }

  extension TodaysTasksStateCountByCategory on TodaysTasksState {
    int taskCountByCategory(Category category) =>  tasks
    .where((task) => task.category.name == category.name).length;
  }

final class TodaysTasksState extends Equatable {
  const TodaysTasksState({
    this.status = TodaysTasksStatus.initial,
    this.tasks = const [],
    this.filteredTasks = const [],
    this.lastDeletedTask,
    this.categoryFilter,
    this.categories = const [],
  });

  final TodaysTasksStatus status;
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final Task? lastDeletedTask;
  final Category? categoryFilter;
  final List<Category> categories;

  @override
  List<Object?> get props => [status, tasks, filteredTasks, lastDeletedTask, categoryFilter, categories];

  TodaysTasksState copyWith({
    TodaysTasksStatus Function()? status,
    List<Task> Function()? tasks,
    List<Task> Function()? filteredTasks,
    Task? Function()? lastDeletedTask,
    Category? Function()? categoryFilter,
    List<Category> Function()? categories,
  }) {
    return TodaysTasksState(
      status: status != null ? status() : this.status,
      tasks: tasks != null ? tasks() : this.tasks,
      filteredTasks: filteredTasks != null ? filteredTasks() : this.filteredTasks,
      lastDeletedTask: lastDeletedTask != null ? lastDeletedTask() : this.lastDeletedTask,
      categoryFilter: categoryFilter != null ? categoryFilter() : this.categoryFilter,
      categories: categories != null ? categories() : this.categories,
    );
  }
}

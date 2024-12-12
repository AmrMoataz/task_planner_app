part of 'tasks_overview_bloc.dart';

sealed class TasksOverviewEvent extends Equatable {
  const TasksOverviewEvent();

  @override
  List<Object> get props => [];
}

final class TasksOverviewSubscriptionRequested extends TasksOverviewEvent {
  const TasksOverviewSubscriptionRequested();
}

final class TasksOverviewTaskDeleted extends TasksOverviewEvent {
  const TasksOverviewTaskDeleted(this.task);

  final Task task;

  @override
  List<Object> get props => [task];
}

final class TasksOverviewTaskUndoDeletionRequested extends TasksOverviewEvent {
  const TasksOverviewTaskUndoDeletionRequested();
}

final class TaskOverviewFilterChanged extends TasksOverviewEvent {
  const TaskOverviewFilterChanged(this.filter);

  final TasksViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class TasksOverviewToggleAllRequested extends TasksOverviewEvent {
  const TasksOverviewToggleAllRequested();
}

class TasksOverviewClearCompletedRequested extends TasksOverviewEvent {
  const TasksOverviewClearCompletedRequested();
}

class TasksOverviewCategoriesRequested extends TasksOverviewEvent {
  const TasksOverviewCategoriesRequested();
}

class TasksOverviewTaskSetToTodayRequested extends TasksOverviewEvent {
  const TasksOverviewTaskSetToTodayRequested(this.task);

  final Task task;

  @override
  List<Object> get props => [task];
}

class TasksOverviewToggleAllTasksToTodayRequested extends TasksOverviewEvent {
  const TasksOverviewToggleAllTasksToTodayRequested();
}

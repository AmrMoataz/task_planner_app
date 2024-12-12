part of 'todays_tasks_bloc.dart';

sealed class TodaysTasksEvent extends Equatable {
  const TodaysTasksEvent();

  @override
  List<Object?> get props => [];
}

class TodaysTasksRequested extends TodaysTasksEvent {
  const TodaysTasksRequested();
}

final class TodaysTasksTaskCompletionToggled extends TodaysTasksEvent {
  const TodaysTasksTaskCompletionToggled(
      {required this.task, required this.isCompleted,});

  final Task task;
  final bool isCompleted;

  @override
  List<Object> get props => [task, isCompleted];
}

final class TodaysTasksTaskDeleted extends TodaysTasksEvent {
  const TodaysTasksTaskDeleted(this.task);

  final Task task;

  @override
  List<Object> get props => [task];
}

final class TodaysTasksTaskUndoDeletionRequested extends TodaysTasksEvent {
  const TodaysTasksTaskUndoDeletionRequested();
}

final class TodaysTasksCategoryFilterChanged extends TodaysTasksEvent {
  const TodaysTasksCategoryFilterChanged({this.categoryFilter});

  final Category? categoryFilter;

  @override
  List<Object?> get props => [categoryFilter];
}

final class TodaysTasksCategoriesRequested extends TodaysTasksEvent {
  const TodaysTasksCategoriesRequested();
}

final class TodaysTasksToggleAllRequested extends TodaysTasksEvent {
  const TodaysTasksToggleAllRequested();
}

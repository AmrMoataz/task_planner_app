import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:category_api/category_api.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:task_planner/tasks_overview/models/tasks_overview_filter.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'tasks_overview_event.dart';
part 'tasks_overview_state.dart';

class TasksOverviewBloc extends Bloc<TasksOverviewEvent, TasksOverviewState> {
  TasksOverviewBloc({required TasksRepository tasksRepository, required CategoryRepository categoryRepository})
      : _tasksRepository = tasksRepository,
        _categoryRepository = categoryRepository,
        super(const TasksOverviewState()) {
    on<TasksOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<TasksOverviewTaskDeleted>(_onTaskDeleted);
    on<TasksOverviewTaskUndoDeletionRequested>(_onTaskUndoDeletionRequested);
    on<TaskOverviewFilterChanged>(_onFilterChanged);
    on<TasksOverviewClearCompletedRequested>(onClearCompletionRequested);
    on<TasksOverviewCategoriesRequested>(_onCategoriesRequested);
    on<TasksOverviewTaskSetToTodayRequested>(_onTaskSetToTodayRequested);
    on<TasksOverviewToggleAllTasksToTodayRequested>(_onToggleAllTasksToTodayRequested);
  }

  final TasksRepository _tasksRepository;
  final CategoryRepository _categoryRepository;

  FutureOr<void> _onSubscriptionRequested(
      TasksOverviewSubscriptionRequested event,
      Emitter<TasksOverviewState> emit,) async {
    emit(state.copyWith(status: () => TasksOverviewStatus.loading));

    await emit.forEach(_tasksRepository.getTasks(),
        onData: (tasks) => state.copyWith(
            status: () => TasksOverviewStatus.success, tasks: () => tasks,),
        onError: (_, __) =>
            state.copyWith(status: () => TasksOverviewStatus.failure),);
  }

  FutureOr<void> _onTaskDeleted(
      TasksOverviewTaskDeleted event, Emitter<TasksOverviewState> emit,) async {
    emit(state.copyWith(lastDeletedTask: () => event.task));
    await _tasksRepository.deleteTask(event.task.id);
  }

  FutureOr<void> _onFilterChanged(
      TaskOverviewFilterChanged event, Emitter<TasksOverviewState> emit,) async {
    emit(state.copyWith(
      filter: () => event.filter,
    ),);
  }

  FutureOr<void> _onTaskUndoDeletionRequested(
      TasksOverviewTaskUndoDeletionRequested event,
      Emitter<TasksOverviewState> emit,) async {
    assert(state.lastDeletedTask != null, 'Last deleted task can not be null.');
    final task = state.lastDeletedTask!;
    emit(state.copyWith(
      lastDeletedTask: () => null,
    ),);
    await _tasksRepository.saveTask(task);
  }

  FutureOr<void> onClearCompletionRequested(
      TasksOverviewClearCompletedRequested event,
      Emitter<TasksOverviewState> emit,) async {
    await _tasksRepository.clearCompleted();
  }

  FutureOr<void> _onCategoriesRequested(
      TasksOverviewCategoriesRequested event,
      Emitter<TasksOverviewState> emit,) async {
    emit(state.copyWith(status: () => TasksOverviewStatus.loading));
    await emit.forEach(
      _categoryRepository.getCategories(),
      onData: (categories) => state.copyWith(status: () => TasksOverviewStatus.success, categories: () => categories),
      onError: (_, __) => state.copyWith(status: () => TasksOverviewStatus.failure),
    );
  }

  FutureOr<void> _onTaskSetToTodayRequested(
      TasksOverviewTaskSetToTodayRequested event,
      Emitter<TasksOverviewState> emit,) async {
    final task = event.task.copyWith(due: DateTime.now());
    await _tasksRepository.saveTask(task);

    emit(state.copyWith(status: () => TasksOverviewStatus.success));
  }

  FutureOr<void> _onToggleAllTasksToTodayRequested(
      TasksOverviewToggleAllTasksToTodayRequested event,
      Emitter<TasksOverviewState> emit,) async {
    await _tasksRepository.setAllToday();
    emit(state.copyWith(status: () => TasksOverviewStatus.success));
  }
}

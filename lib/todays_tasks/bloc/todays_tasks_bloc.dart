import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:category_api/category_api.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'todays_tasks_event.dart';
part 'todays_tasks_state.dart';

class TodaysTasksBloc extends Bloc<TodaysTasksEvent, TodaysTasksState> {
  TodaysTasksBloc(
      {required TasksRepository tasksRepository,
      required CategoryRepository categoryRepository,})
      : _tasksRepository = tasksRepository,
        _categoryRepository = categoryRepository,
        super(const TodaysTasksState()) {
    on<TodaysTasksRequested>(_onTodaysTasksRequested);
    on<TodaysTasksTaskCompletionToggled>(_onTodaysTasksTaskCompletionToggled);
    on<TodaysTasksTaskDeleted>(_onTodaysTasksTaskDeleted);
    on<TodaysTasksTaskUndoDeletionRequested>(
        _onTodaysTasksTaskUndoDeletionRequested,);
    on<TodaysTasksCategoryFilterChanged>(_onTodaysTasksCategoryFilterChanged);
    on<TodaysTasksCategoriesRequested>(_onTodaysTasksCategoriesRequested);
  }

  final TasksRepository _tasksRepository;
  final CategoryRepository _categoryRepository;

  Future<void> _onTodaysTasksRequested(
      TodaysTasksRequested event, Emitter<TodaysTasksState> emit,) async {
    emit(state.copyWith(status: () => TodaysTasksStatus.loading));
    await emit.forEach<List<Task>>(
      _tasksRepository.getTasks(),
      onData: (tasks) => state.copyWith(
        status: () => TodaysTasksStatus.success,
        categoryFilter: () => null,
        tasks: () => _getTodaysTasks(tasks),
        filteredTasks: () => _getTodaysTasks(tasks),
      ),
      onError: (_, __) =>
          state.copyWith(status: () => TodaysTasksStatus.failure),
    );
  }

  List<Task> _getTodaysTasks(List<Task> tasks) {
  final now = DateTime.now();
  return tasks.where((task) => task.due != null &&
      task.due!.year == now.year &&
      task.due!.month == now.month &&
      task.due!.day == now.day).toList();
}

  Future<void> _onTodaysTasksTaskCompletionToggled(
      TodaysTasksTaskCompletionToggled event,
      Emitter<TodaysTasksState> emit,) async {
    final task = event.task.copyWith(isCompleted: !event.task.isCompleted);
    await _tasksRepository.saveTask(task);
  }

  Future<void> _onTodaysTasksTaskDeleted(
      TodaysTasksTaskDeleted event, Emitter<TodaysTasksState> emit,) async {
    emit(state.copyWith(lastDeletedTask: () => event.task));
    await _tasksRepository.deleteTask(event.task.id);
  }

  Future<void> _onTodaysTasksTaskUndoDeletionRequested(
      TodaysTasksTaskUndoDeletionRequested event,
      Emitter<TodaysTasksState> emit,) async {
    assert(state.lastDeletedTask != null, 'Last deleted task can not be null.');
    final task = state.lastDeletedTask!;
    emit(
      state.copyWith(
        lastDeletedTask: () => null,
      ),
    );
    await _tasksRepository.saveTask(task);
  }

  Future<void> _onTodaysTasksCategoryFilterChanged(
      TodaysTasksCategoryFilterChanged event,
      Emitter<TodaysTasksState> emit,) async {
    
    if (event.categoryFilter == null) {
      return _onTodaysTasksRequested(const TodaysTasksRequested(), emit);
    }


    emit(state.copyWith(status: () => TodaysTasksStatus.loading));
    await emit.forEach<List<Task>>(
      _tasksRepository.getTasks(),
      onData: (tasks) => state.copyWith(
        status: () => TodaysTasksStatus.success,
        categoryFilter: () => event.categoryFilter,
        tasks: () => _getTodaysTasks(tasks),
        filteredTasks: () => _getTodaysTasks(tasks)
            .where((task) => task.category == event.categoryFilter).toList(),
      ),
      onError: (_, __) =>
          state.copyWith(status: () => TodaysTasksStatus.failure),
    );
  }

  Future<void> _onTodaysTasksCategoriesRequested(
      TodaysTasksCategoriesRequested event,
      Emitter<TodaysTasksState> emit,) async {
    emit(state.copyWith(status: () => TodaysTasksStatus.loading));
    await emit.forEach(
      _categoryRepository.getCategories(),
      onData: (categories) => state.copyWith(
          status: () => TodaysTasksStatus.success,
          categories: () => categories,),
      onError: (_, __) =>
          state.copyWith(status: () => TodaysTasksStatus.failure),
    );
  }

   FutureOr<void> _onToggleAllRequested(TodaysTasksToggleAllRequested event,
      Emitter<TodaysTasksState> emit,) async {
    final areAllCompleted = state.tasks.every((task) => task.isCompleted);
    await _tasksRepository.completeAll(isCompleted: !areAllCompleted);
  }
}

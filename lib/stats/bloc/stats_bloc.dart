import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({
    required TasksRepository tasksRepository,
  })  : _tasksRepository = tasksRepository,
        super(const StatsState()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final TasksRepository _tasksRepository;

  Future<void> _onSubscriptionRequested(
    StatsSubscriptionRequested event,
    Emitter<StatsState> emit,
  ) async {
    emit(state.copyWith(status: StatsStatus.loading));

    await emit.forEach<List<Task>>(
      _tasksRepository.getTasks(),
      onData: (todos) => state.copyWith(
        status: StatsStatus.success,
        completedTasks: todos.where((todo) => todo.isCompleted).length,
        activeTasks: todos.where((todo) => !todo.isCompleted).length,
      ),
      onError: (_, __) => state.copyWith(status: StatsStatus.failure),
    );
  }
}

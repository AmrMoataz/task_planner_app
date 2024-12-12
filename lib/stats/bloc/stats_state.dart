part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

final class StatsState extends Equatable {
  const StatsState({
    this.status = StatsStatus.initial,
    this.completedTasks = 0,
    this.activeTasks = 0,
  });

  final StatsStatus status;
  final int completedTasks;
  final int activeTasks;

  @override
  List<Object> get props => [status, completedTasks, activeTasks];

  StatsState copyWith({
    StatsStatus? status,
    int? completedTasks,
    int? activeTasks,
  }) {
    return StatsState(
      status: status ?? this.status,
      completedTasks: completedTasks ?? this.completedTasks,
      activeTasks: activeTasks ?? this.activeTasks,
    );
  }
}

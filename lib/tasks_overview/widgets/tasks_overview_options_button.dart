import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/l10n/l10n.dart';
import 'package:task_planner/tasks_overview/bloc/tasks_overview_bloc.dart';

@visibleForTesting
enum TasksOverviewOption { ToggleAllToday }

class TasksOverviewOptionsButton extends StatelessWidget {
  const TasksOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final tasks = context.select((TasksOverviewBloc bloc) => bloc.state.tasks);
    final hasTasks = tasks.isNotEmpty;

    return PopupMenuButton<TasksOverviewOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: l10n.tasksOverviewOptionsTooltip,
      onSelected: (options) {
        switch (options) {
          case TasksOverviewOption.ToggleAllToday:
            context
                .read<TasksOverviewBloc>()
                .add(const TasksOverviewToggleAllTasksToTodayRequested());
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TasksOverviewOption.ToggleAllToday,
            enabled: hasTasks,
            child: Text(
              l10n.tasksOverviewOptionsToggleAllToday,
            ),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}

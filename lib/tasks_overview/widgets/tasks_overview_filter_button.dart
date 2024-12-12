import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/l10n/l10n.dart';
import 'package:task_planner/tasks_overview/bloc/tasks_overview_bloc.dart';

import 'package:task_planner/tasks_overview/models/models.dart';

class TasksOverviewFilterButton extends StatelessWidget {
  const TasksOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final activeFilter =
        context.select((TasksOverviewBloc bloc) => bloc.state.filter);

    return PopupMenuButton<TasksViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: l10n.tasksOverviewFilterTooltip,
      onSelected: (filter) {
        context
            .read<TasksOverviewBloc>()
            .add(TaskOverviewFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TasksViewFilter.all,
            child: Text(l10n.tasksOverviewFilterAll),
          ),
          PopupMenuItem(
            value: TasksViewFilter.activeOnly,
            child: Text(l10n.tasksOverviewFilterActiveOnly),
          ),
          PopupMenuItem(
            value: TasksViewFilter.completedOnly,
            child: Text(l10n.tasksOverviewFilterCompletedOnly),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}

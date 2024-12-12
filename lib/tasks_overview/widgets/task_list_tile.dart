import 'package:flutter/material.dart';
import 'package:task_planner/tasks_overview/models/tasks_quadrant.dart';
import 'package:tasks_api/tasks_api.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    required this.task,
    super.key,
    this.onToggleCompleted,
    this.onDismissed,
    this.onTap,
    this.inToday = false,
  });

  final Task task;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;
  final bool inToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;

    return Dismissible(
      direction:
          inToday ? DismissDirection.endToStart : DismissDirection.horizontal,
      key: Key('taskListTile_dismissible_${task.id}'),
      confirmDismiss: (direction) {
        if (onDismissed == null) {
          return Future.value(false);
        }

        onDismissed?.call(direction);
        if (direction == DismissDirection.endToStart) {
          return Future.value(true);
        }
        return Future.value(false);
      },
      background: Container(
        margin: const EdgeInsets.all(8),
        alignment: inToday ? Alignment.centerRight : Alignment.centerLeft,
        color: inToday ? theme.colorScheme.error : theme.colorScheme.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          inToday ? Icons.delete : Icons.archive_rounded,
          color: const Color(0xAAFFFFFF),
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.all(8),
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: inToday
                ? Border(
                    left: BorderSide(
                        color: Color(int.parse(task.category.color.substring(1),
                                radix: 16) |
                            0xFF000000)))
                : null),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          onTap: onTap,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: !task.isCompleted
              ? null
              : TextStyle(
                  color: captionColor,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                task.quadrantIcon,
              ),
              const SizedBox(width: 8),
              TaskPriorityIndicator(priority: task.priority),
            ],
          ),
          subtitle: Text(
            task.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: inToday
              ? Checkbox(
                  shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  value: task.isCompleted,
                  onChanged: onToggleCompleted == null
                      ? null
                      : (value) => onToggleCompleted!(value!),
                )
              : task.due?.day == DateTime.now().day &&
                      task.due?.month == DateTime.now().month &&
                      task.due?.year == DateTime.now().year
                  ? Icon(Icons.today,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
          trailing: onTap == null ? null : const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

class TaskPriorityIndicator extends StatelessWidget {
  const TaskPriorityIndicator({
    required this.priority,
    super.key,
  });

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.priority_high_rounded,
      color: switch (priority) {
        TaskPriority.High => Theme.of(context).colorScheme.onError,
        TaskPriority.Medium => Theme.of(context).colorScheme.error,
        TaskPriority.Low => Theme.of(context).colorScheme.primary,
      },
    );
  }
}

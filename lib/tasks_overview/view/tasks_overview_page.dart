import 'package:category_repository/category_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/edit_task/view/view.dart';
import 'package:task_planner/l10n/l10n.dart';
import 'package:task_planner/tasks_overview/bloc/tasks_overview_bloc.dart';
import 'package:task_planner/tasks_overview/widgets/widgets.dart';
import 'package:tasks_repository/tasks_repository.dart';

class TasksOverviewPage extends StatelessWidget {
  const TasksOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksOverviewBloc(
        tasksRepository: context.read<TasksRepository>(),
        categoryRepository: context.read<CategoryRepository>(),
      )
        ..add(const TasksOverviewSubscriptionRequested())
        ..add(const TasksOverviewCategoriesRequested()),
      child: const TasksOverviewView(),
    );
  }
}

class TasksOverviewView extends StatelessWidget {
  const TasksOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tasksOverviewAppBarTitle),
        actions: const [
          TasksOverviewFilterButton(),
          TasksOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TasksOverviewBloc, TasksOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TasksOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.tasksOverviewErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
          BlocListener<TasksOverviewBloc, TasksOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTask != current.lastDeletedTask &&
                current.lastDeletedTask != null,
            listener: (context, state) {
              final deletedTask = state.lastDeletedTask!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(deletedTask.title),
                    action: SnackBarAction(
                      label: l10n.tasksOverviewUndoDeletionButtonText,
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context.read<TasksOverviewBloc>().add(
                              const TasksOverviewTaskUndoDeletionRequested(),
                            );
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TasksOverviewBloc, TasksOverviewState>(
          builder: (context, state) {
              if (state.status == TasksOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != TasksOverviewStatus.success) {
                return const SizedBox();
              } 

              return  SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    state.categories.length,
                    (categoryIndex) {
                      final category = state.categories[categoryIndex];
                      final tasksInCategory = state.filteredTasks
                          .where((task) => task.category == category)
                          .toList();
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(int.parse(category.color.substring(1), radix: 16) | 0xFF000000),
                                shape: BoxShape.circle,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  category.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${tasksInCategory.length})',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            children: [
                              if (tasksInCategory.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'This category is empty',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )
                              else
                                Column(
                                  children: tasksInCategory.map((task) {
                                    return TaskListTile(
                                      task: task,
                                      onDismissed: (direction) {
                                        if (direction == DismissDirection.endToStart) {
                                           context
                                            .read<TasksOverviewBloc>()
                                            .add(TasksOverviewTaskDeleted(task));
                                        } else if (direction == DismissDirection.startToEnd) {
                                           context
                                            .read<TasksOverviewBloc>()
                                            .add(TasksOverviewTaskSetToTodayRequested(task));
                                        }
                                      },
                                      onTap: () {
                                        Navigator.of(context).push(
                                          EditTaskPage.route(initialTask: task),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}

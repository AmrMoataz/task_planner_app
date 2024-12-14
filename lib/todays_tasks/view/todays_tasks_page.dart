import 'package:category_repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/edit_task/view/view.dart';
import 'package:task_planner/l10n/l10n.dart';
import 'package:task_planner/tasks_overview/widgets/task_list_tile.dart';
import 'package:task_planner/todays_tasks/bloc/todays_tasks_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';

class TodaysTasksOverviewPage extends StatelessWidget {
  const TodaysTasksOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodaysTasksBloc(
        tasksRepository: context.read<TasksRepository>(),
        categoryRepository: context.read<CategoryRepository>(),
      )
        ..add(const TodaysTasksRequested())
        ..add(const TodaysTasksCategoriesRequested()),
      child: const TodaysTasksView(),
    );
  }
}

class TodaysTasksView extends StatelessWidget {
  const TodaysTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todaysTasksAppBarTitle),
        actions: const [],
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: MultiBlocListener(
          listeners: [
            BlocListener<TodaysTasksBloc, TodaysTasksState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status &&
                  current.status == TodaysTasksStatus.failure,
              listener: (context, state) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.todaysTasksErrorSnackbarText),
                    ),
                  );
              },
            ),
            BlocListener<TodaysTasksBloc, TodaysTasksState>(
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
                        label: l10n.todaysTasksUndoDeletionButtonText,
                        onPressed: () {
                          messenger.hideCurrentSnackBar();
                          context.read<TodaysTasksBloc>().add(
                                const TodaysTasksTaskUndoDeletionRequested(),
                              );
                        },
                      ),
                    ),
                  );
              },
            ),
          ],
          child: BlocBuilder<TodaysTasksBloc, TodaysTasksState>(
            builder: (context, state) {
              return Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 50,
                    child: BlocBuilder<TodaysTasksBloc, TodaysTasksState>(
                      builder: (context, state) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            final categoryColor = Color(int.parse(
                                    category.color.substring(1),
                                    radix: 16,) |
                                0xFF000000,);
                            final isSelected = state.categoryFilter == category;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: FilterChip(
                                label: Text(
                                  '${category.name} (${state.taskCountByCategory(category)})',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                selected: isSelected,
                                onSelected: (_) {
                                  context.read<TodaysTasksBloc>().add(
                                        TodaysTasksCategoryFilterChanged(
                                          categoryFilter:
                                              isSelected ? null : category,
                                        ),
                                      );
                                },
                                backgroundColor: categoryColor,
                                selectedColor: categoryColor.withOpacity(0.7),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<TodaysTasksBloc, TodaysTasksState>(
                      builder: (context, state) {
                        if (state.filteredTasks.isEmpty) {
                          if (state.status == TodaysTasksStatus.loading) {
                            return const Center(
                                child: CircularProgressIndicator(),);
                          } else {
                            return Center(
                                child: Text(l10n.todaysTasksEmptyText),);
                          }
                        }
                        return ListView.builder(
                          itemCount: state.filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = state.filteredTasks[index];
                            return TaskListTile(
                              inToday: true,
                              task: task,
                              onToggleCompleted: (isCompleted) {
                                context.read<TodaysTasksBloc>().add(
                                      TodaysTasksTaskCompletionToggled(
                                          task: task, isCompleted: isCompleted,),
                                    );
                              },
                              onTap: () {
                                Navigator.of(context).push(
                                  EditTaskPage.route(initialTask: task),
                                );
                              },
                              onDismissed: (_) {
                                context.read<TodaysTasksBloc>().add(
                                      TodaysTasksTaskDeleted(task),
                                    );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),),
    );
  }
}

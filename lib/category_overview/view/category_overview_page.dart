import 'package:category_repository/category_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/category_overview/bloc/category_overview_bloc.dart';
import 'package:task_planner/category_overview/widgets/categories_overview_edit_button.dart';
import 'package:task_planner/l10n/l10n.dart';
import 'package:tasks_repository/tasks_repository.dart';

class CategoryOverviewPage extends StatelessWidget {
  const CategoryOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryOverviewBloc(
        categoryRepository: context.read<CategoryRepository>(),
        tasksRepository: context.read<TasksRepository>(),
      )..add(const CategoriesOverviewSubscriptionRequested()),
      child: const CategoryOverviewView(),
    );
  }
}

class CategoryOverviewView extends StatelessWidget {
  const CategoryOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.categoriesOverviewAppBarTitle),
        actions: const [
          CategoriesOverviewEditButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CategoryOverviewBloc, CategoryOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status &&
                current.status == CategoryOverviewStatus.failure,
            listener: (context, state) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(l10n.categoriesOverviewErrorSnackbarText),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<CategoryOverviewBloc, CategoryOverviewState>(
          builder: (context, state) {
            if (state.categories.isEmpty) {
              if (state.status == CategoryOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != CategoryOverviewStatus.success) {
                return const SizedBox();
              } else {
                return Column(children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: _SearchField(),
                  ),
                  Center(
                    child: Text(
                      l10n.categoriesOverviewEmptyText,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                ]);
              }
            }

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: _SearchField(),
                ),
                Expanded(
                  child: GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return Dismissible(
                        key: Key('categoryTile_dismissible_${category.id}'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          context.read<CategoryOverviewBloc>().add(
                                CategoriesOverviewCategoryDeleteRequested(
                                  category: category,
                                ),
                              );
                        },
                        background: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(
                            Icons.delete,
                            color: Color(0xAAFFFFFF),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border(
                              left: BorderSide(
                                color: Color(
                                  int.parse(
                                        category.color.substring(1),
                                        radix: 16,
                                      ) |
                                      0xFF000000,
                                ),
                                width: 8,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              Text(
                                '${category.tasks.length} task(s)',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.5),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextField(
      decoration: InputDecoration(
        hintText: l10n.categoriesOverviewSearchFieldLabel,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (value) {
        context
            .read<CategoryOverviewBloc>()
            .add(CategoriesOverviewSearchRequested(searchTerm: value));
      },
    );
  }
}

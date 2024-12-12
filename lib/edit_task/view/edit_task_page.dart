import 'package:category_repository/category_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_planner/edit_task/bloc/edit_task_bloc.dart';
import 'package:task_planner/l10n/l10n.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({super.key});

  static Route<void> route({Task? initialTask}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider<EditTaskBloc>(
        create: (context) => EditTaskBloc(
          tasksRepository: context.read<TasksRepository>(),
          categoryRepository: context.read<CategoryRepository>(),
          initialTask: initialTask,
        )..add(const EditTaskCategoriesRequested()),
        child: const EditTaskPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTaskBloc, EditTaskState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditTaskStatus.submit,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditTaskView(),
    );
  }
}

class EditTaskView extends StatelessWidget {
  const EditTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((EditTaskBloc bloc) => bloc.state.status);
    final isNewTask = context.select(
      (EditTaskBloc bloc) => bloc.state.isNewTask,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewTask
              ? l10n.editTaskAddAppBarTitle
              : l10n.editTaskEditAppBarTitle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editTaskSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        onPressed: status.isLoadingOrSubmit || status == EditTaskStatus.invalidInput
            ? null
            : () => context.read<EditTaskBloc>().add(const EditTaskSubmitted()),
        child: status.isLoadingOrSubmit
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _TitleField(),
                _DescriptionField(),
                SizedBox(height: 35),
                _CategoryField(),
                SizedBox(height: 35),
                _PriorityField(),
                SizedBox(height: 35),
                _QuadrantField(),
                SizedBox(height: 35),
                _DateField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTaskBloc>().state;
    final hintText = state.initialTask?.title ?? '';

    return TextFormField(
      key: const Key('editTaskView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSubmit,
        labelText: l10n.editTaskTitleLabel,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      onChanged: (value) {
        context.read<EditTaskBloc>().add(EditTaskTitleChanged(value));
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTaskBloc>().state;
    final hintText = state.initialTask?.description ?? '';

    return TextFormField(
      key: const Key('editTaskView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSubmit,
        labelText: l10n.editTaskDescriptionLabel,
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 3,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditTaskBloc>().add(EditTaskDescriptionChanged(value));
      },
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTaskBloc>().state;
    final currentDate = state.due ?? DateTime.now();

    return TextFormField(
      key: const Key('editTaskView_date_textFormField'),
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSubmit,
        labelText: l10n.editTaskDateLabel,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      controller: TextEditingController(
        text: currentDate.toLocal().toString().split(' ')[0],
      ),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (pickedDate != null) {
          context.read<EditTaskBloc>().add(EditTaskDateChanged(pickedDate));
        }
      },
    );
  }
}

class _CategoryField extends StatelessWidget {
  const _CategoryField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTaskBloc>().state;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.editTaskCategoryLabel,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              final isSelected = state.selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  color: WidgetStateProperty.all(Color(int.parse(category.color.substring(1), radix: 16) | 0xFF000000).withOpacity(0.7)),
                  label: Text(category.name, style: theme.textTheme.bodyMedium),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<EditTaskBloc>().add(EditTaskCategoryChanged(category));
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuadrantField extends StatelessWidget {
  const _QuadrantField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTaskBloc>().state;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.editTaskQuadrantLabel,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: TaskQuadrant.values.length,
            itemBuilder: (context, index) {
              final quadrant = TaskQuadrant.values[index];
              final isSelected = state.quadrant == quadrant;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(quadrant.toString().split('.').last),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<EditTaskBloc>().add(EditTaskQuadrantChanged(quadrant));
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PriorityField extends StatelessWidget {
  const _PriorityField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTaskBloc>().state;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.editTaskPriorityLabel,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: TaskPriority.values.length,
            itemBuilder: (context, index) {
              final priority = TaskPriority.values[index];
              final isSelected = state.priority == priority;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(priority.toString().split('.').last),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<EditTaskBloc>().add(EditTaskPriorityChanged(priority));
                    }
                  },
                  backgroundColor: _getPriorityColor(priority, theme),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(TaskPriority priority, ThemeData theme) {
    switch (priority) {
      case TaskPriority.High:
        return theme.colorScheme.onError;
      case TaskPriority.Medium:
        return theme.colorScheme.secondaryContainer;
      case TaskPriority.Low:
        return theme.colorScheme.tertiaryContainer;
    }
  }
}

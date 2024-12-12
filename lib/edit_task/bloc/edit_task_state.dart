part of 'edit_task_bloc.dart';

enum EditTaskStatus { initial, loading, success, failure, invalidInput, submit }

extension EditTaskStatusX on EditTaskStatus {
  bool get isLoadingOrSubmit => [
        EditTaskStatus.loading,
        EditTaskStatus.submit,
      ].contains(this);
}

final class EditTaskState extends Equatable {
  const EditTaskState({
    this.status = EditTaskStatus.initial,
    this.initialTask,
    this.title = '',
    this.description = '',
    this.quadrant = TaskQuadrant.Quandrant1,
    this.selectedCategory,
    this.due,
    this.categories = const [],
    this.priority = TaskPriority.Medium,
  });

  final EditTaskStatus status;
  final Task? initialTask;
  final String title;
  final String description;
  final TaskQuadrant? quadrant;
  final Category? selectedCategory;
  final DateTime? due;
  final List<Category> categories;
  final TaskPriority? priority;

  bool get isNewTask => initialTask == null;

  EditTaskState copyWith({
    EditTaskStatus? status,
    Task? initialTask,
    String? title,
    String? description,
    TaskQuadrant? quadrant,
    Category? selectedCategory,
    DateTime? due,
    List<Category>? categories,
    TaskPriority? priority,
  }) {
    return EditTaskState(
      status: status ?? this.status,
      initialTask: initialTask ?? this.initialTask,
      title: title ?? this.title,
      description: description ?? this.description,
      quadrant: quadrant ?? this.quadrant,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      due: due ?? this.due,
      categories: categories ?? this.categories,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialTask,
        title,
        description,
        quadrant,
        selectedCategory,
        due,
        categories,
        priority
      ];
}

part of 'edit_task_bloc.dart';

sealed class EditTaskEvent extends Equatable {
  const EditTaskEvent();

  @override
  List<Object> get props => [];
}

final class EditTaskTitleChanged extends EditTaskEvent {
  const EditTaskTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

final class EditTaskDescriptionChanged extends EditTaskEvent {
  const EditTaskDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

final class EditTaskCategoryChanged extends EditTaskEvent {
  const EditTaskCategoryChanged(this.category);

  final Category category;

  @override
  List<Object> get props => [category];
}

final class EditTaskDateChanged extends EditTaskEvent {
  const EditTaskDateChanged(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];
}

final class EditTaskQuadrantChanged extends EditTaskEvent {
  const EditTaskQuadrantChanged(this.quadrant);

  final TaskQuadrant quadrant;  

  @override
  List<Object> get props => [quadrant];
}

final class EditTaskPriorityChanged extends EditTaskEvent {
  const EditTaskPriorityChanged(this.priority);

  final TaskPriority priority;

  @override
  List<Object> get props => [priority];
}

final class EditTaskSubmitted extends EditTaskEvent {
  const EditTaskSubmitted();
}

final class EditTaskCategoriesRequested extends EditTaskEvent {
  const EditTaskCategoriesRequested();
}

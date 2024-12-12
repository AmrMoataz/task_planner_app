import 'package:bloc/bloc.dart';
import 'package:category_api/category_api.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'edit_task_event.dart';
part 'edit_task_state.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  EditTaskBloc({
    required TasksRepository tasksRepository,
    required CategoryRepository categoryRepository,
    required Task? initialTask,
  })  : _tasksRepository = tasksRepository,
        _categoryRepository = categoryRepository,
        super(
          EditTaskState(
            initialTask: initialTask,
            title: initialTask?.title ?? '',
            description: initialTask?.description ?? '',
            quadrant: initialTask?.quadrant,
            selectedCategory: initialTask?.category,
            due: initialTask?.due,
            priority: initialTask?.priority,
          ),
        ) {
    on<EditTaskTitleChanged>(_onTitleChanged);
    on<EditTaskDescriptionChanged>(_onDescriptionChanged);
    on<EditTaskQuadrantChanged>(_onQuadrantChanged);
    on<EditTaskCategoryChanged>(_onCategoryChanged);
    on<EditTaskDateChanged>(_onDateChanged);
    on<EditTaskSubmitted>(_onSubmitted);
    on<EditTaskCategoriesRequested>(_onCategoriesRequested);
    on<EditTaskPriorityChanged>(_onPriorityChanged);
  }

  final TasksRepository _tasksRepository;
  final CategoryRepository _categoryRepository;

  void _onTitleChanged(
    EditTaskTitleChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(title: event.title,
     initialTask: state.initialTask?.copyWith(title: event.title),),);
  }

  void _onDescriptionChanged(
    EditTaskDescriptionChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(description: event.description,
     initialTask: state.initialTask?.copyWith(description: event.description),),);
  }

  void _onQuadrantChanged(
    EditTaskQuadrantChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(quadrant: event.quadrant,
     initialTask: state.initialTask?.copyWith(quadrant: event.quadrant),),);
  }

  Future<void> _onCategoryChanged(
    EditTaskCategoryChanged event,
    Emitter<EditTaskState> emit,
  ) async {
    final categories = await _categoryRepository.getCategories().first;
    if (categories.isEmpty ||
        !categories.any((category) => category.name == event.category.name)) {
      emit(state.copyWith(status: EditTaskStatus.invalidInput));
      return;
    }

    emit(state.copyWith(selectedCategory: event.category,
     initialTask: state.initialTask?.copyWith(category: event.category),),);
  }

  void _onDateChanged(
    EditTaskDateChanged event,
    Emitter<EditTaskState> emit,
  ) {
    if (event.date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
      emit(state.copyWith(status: EditTaskStatus.invalidInput));
      return;
    }
    emit(state.copyWith(due: event.date,
     initialTask: state.initialTask?.copyWith(due: event.date),),);
  }

  void _onPriorityChanged(
    EditTaskPriorityChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(priority: event.priority,
     initialTask: state.initialTask?.copyWith(priority: event.priority),),);
  }

  Future<void> _onSubmitted(
    EditTaskSubmitted event,
    Emitter<EditTaskState> emit,
  ) async {
    emit(state.copyWith(status: EditTaskStatus.loading));

    if (state.title.isEmpty || state.selectedCategory == null) {
      emit(state.copyWith(status: EditTaskStatus.failure));
      return;
    }

    final task = state.initialTask ??
        Task(
          title: state.title,
          description: state.description,
          quadrant: state.quadrant ?? TaskQuadrant.Quandrant2,
          category: state.selectedCategory ?? Category(name: '', color: ''),
          due: state.due,
          priority: state.priority ?? TaskPriority.Medium,
        );

    try {
      await _tasksRepository.saveTask(task);
      emit(state.copyWith(status: EditTaskStatus.submit));
    } catch (e) {
      emit(state.copyWith(status: EditTaskStatus.failure));
    }
  }

  Future<void> _onCategoriesRequested(
    EditTaskCategoriesRequested event,
    Emitter<EditTaskState> emit,
  ) async {
    emit(state.copyWith(status: EditTaskStatus.loading));
    await emit.forEach(
      _categoryRepository.getCategories(),
      onData: (categories) => state.copyWith(status: EditTaskStatus.success, categories: categories),
      onError: (_, __) => state.copyWith(status: EditTaskStatus.failure),
    );
  }
}

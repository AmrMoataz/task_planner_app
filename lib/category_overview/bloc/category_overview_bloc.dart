import 'package:bloc/bloc.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:task_planner/category_overview/models/overview_category.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'category_overview_event.dart';
part 'category_overview_state.dart';

const _duration = Duration(milliseconds: 300);
EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class CategoryOverviewBloc
    extends Bloc<CategoryOverviewEvent, CategoryOverviewState> {
  CategoryOverviewBloc(
      {required CategoryRepository categoryRepository,
      required TasksRepository tasksRepository,})
      : _categoryRepository = categoryRepository,
        _tasksRepository = tasksRepository,
        super(const CategoryOverviewState()) {
    on<CategoriesOverviewSearchRequested>(_onCategoriesOverviewSearchRequested,
        transformer: debounce(_duration),);
    on<CategoriesOverviewSubscriptionRequested>(
        _onCategoriesOverviewSubscriptionRequested,);
    on<CategoriesOverviewCategoryDeleteRequested>(
        _onCategoriesOverviewCategoryDeleteRequested,);
  }

  final CategoryRepository _categoryRepository;
  final TasksRepository _tasksRepository;

  Future<void> _onCategoriesOverviewSearchRequested(
    CategoriesOverviewSearchRequested event,
    Emitter<CategoryOverviewState> emit,
  ) async {
    if (event.searchTerm.isEmpty) {
      return _onCategoriesOverviewSubscriptionRequested(
        const CategoriesOverviewSubscriptionRequested(),
        emit,
      );
    }

    emit(state.copyWith(status: () => CategoryOverviewStatus.loading));

    await emit.forEach<List<OverviewCategory>>(
      _getCategoriesOverview(),
      onData: (categories) => state.copyWith(
          status: () => CategoryOverviewStatus.success,
          categories: () => categories
              .where((category) => category.name
                  .toLowerCase()
                  .contains(event.searchTerm.toLowerCase()),)
              .toList(),),
      onError: (_, __) =>
          state.copyWith(status: () => CategoryOverviewStatus.failure),
    );
  }

  Future<void> _onCategoriesOverviewSubscriptionRequested(
      CategoriesOverviewSubscriptionRequested event,
      Emitter<CategoryOverviewState> emit,) async {
    emit(state.copyWith(status: () => CategoryOverviewStatus.loading));
    await emit.forEach<List<OverviewCategory>>(
      _getCategoriesOverview(),
      onData: (categories) => state.copyWith(
        status: () => CategoryOverviewStatus.success,
        categories: () => categories,
      ),
      onError: (_, __) =>
          state.copyWith(status: () => CategoryOverviewStatus.failure),
    );
  }

  Future<void> _onCategoriesOverviewCategoryDeleteRequested(
      CategoriesOverviewCategoryDeleteRequested event,
      Emitter<CategoryOverviewState> emit,) async {
    try {
      final categoryName = event.category.name;
      final tasks = await _tasksRepository.getTasks().first;
      final taskWithSameName = tasks.any((task) => task.title == categoryName);
      
      if (taskWithSameName) {
        emit(state.copyWith(status: () => CategoryOverviewStatus.failure));
      } else {
        await _categoryRepository.deleteCategory(event.category.id);
        emit(state.copyWith(status: () => CategoryOverviewStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(status: () => CategoryOverviewStatus.failure));
    }
  }

  Stream<List<OverviewCategory>> _getCategoriesOverview() {
    return _categoryRepository.getCategories().asyncMap((categories) async {
      final tasks = await _tasksRepository.getTasks().first;
      return categories.map((category) {
        final categoryTasks =
            tasks.where((task) => task.category.id == category.id).toList();
        return OverviewCategory(
          id: category.id,
          name: category.name,
          color: category.color,
          tasks: categoryTasks,
        );
      }).toList();
    });
  }
}

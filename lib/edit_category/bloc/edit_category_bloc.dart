import 'package:bloc/bloc.dart';
import 'package:category_api/category_api.dart';
import 'package:category_repository/category_repository.dart';
import 'package:equatable/equatable.dart';

part 'edit_category_event.dart';
part 'edit_category_state.dart';

class EditCategoryBloc extends Bloc<EditCategoryEvent, EditCategoryState> {
  EditCategoryBloc(
      {required this.categoryRepository, required Category? initialCategory,})
      : super(EditCategoryState(
            color: initialCategory?.color ?? '',
            name: initialCategory?.name ?? '',
            initialCategory: initialCategory,),) {
    on<EditCategoryNameChanged>(_onEditCategoryNameChanged);
    on<EditCategoryColorChanged>(_onEditCategoryColorChanged);
    on<EditCategorySubmitted>(_onEditCategorySubmitted);
  }

  final CategoryRepository categoryRepository;

  void _onEditCategoryNameChanged(
      EditCategoryNameChanged event, Emitter<EditCategoryState> emit,) {
    emit(state.copyWith(name: event.name));
  }

  void _onEditCategoryColorChanged(
      EditCategoryColorChanged event, Emitter<EditCategoryState> emit,) {
    emit(state.copyWith(color: event.color));
  }

  Future<void> _onEditCategorySubmitted(
      EditCategorySubmitted event, Emitter<EditCategoryState> emit,) async {
    emit(state.copyWith(status: EditCategoryStatus.loading));

    if (state.name.isEmpty || state.color.isEmpty) {
      emit(state.copyWith(status: EditCategoryStatus.failure));
      return;
    }
    
    final category = state.initialCategory ?? Category(name: state.name, color: state.color);
    try {
      await categoryRepository.saveCategory(category);
      emit(state.copyWith(status: EditCategoryStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditCategoryStatus.failure));
    }
  }
}

part of 'edit_category_bloc.dart';

sealed class EditCategoryEvent extends Equatable {
  const EditCategoryEvent();

  @override
  List<Object> get props => [];
}

class EditCategoryNameChanged extends EditCategoryEvent {
  const EditCategoryNameChanged({required this.name});
  final String name;

  @override
  List<Object> get props => [name];
}

class EditCategoryColorChanged extends EditCategoryEvent {
  const EditCategoryColorChanged({required this.color});
  final String color;

  @override
  List<Object> get props => [color];
}

class EditCategorySubmitted extends EditCategoryEvent {
  const EditCategorySubmitted();
}

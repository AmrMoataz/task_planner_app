part of 'edit_category_bloc.dart';

enum EditCategoryStatus {
  initial,
  loading,
  success,
  failure,
}

extension EditCategoryStatusX on EditCategoryStatus {
  bool get isLoadingOrSuccess => [
        EditCategoryStatus.loading,
        EditCategoryStatus.success,
      ].contains(this);
}

final class EditCategoryState extends Equatable {
  const EditCategoryState({
    this.status = EditCategoryStatus.initial,
    this.initialCategory,
    this.name = '',
    this.color = '',
  });
  
  final EditCategoryStatus status;
  final Category? initialCategory;
  final String name;
  final String color;
  
  @override
  List<Object?> get props => [status, initialCategory, name, color];

  EditCategoryState copyWith({
    EditCategoryStatus? status,
    Category? initialCategory,
    String? name,
    String? color,
  }) {
    return EditCategoryState(
      status: status ?? this.status,
      initialCategory: initialCategory ?? this.initialCategory,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }
}
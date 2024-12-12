
part of 'category_overview_bloc.dart';

enum CategoryOverviewStatus {
  initial,
  loading,
  success,
  failure,
}

final class CategoryOverviewState extends Equatable {
  const CategoryOverviewState({
    this.status = CategoryOverviewStatus.initial,
    this.categories = const [],
  });

  final CategoryOverviewStatus status;
  final List<OverviewCategory> categories;

  @override
  List<Object> get props => [status, categories];

  CategoryOverviewState copyWith({
    CategoryOverviewStatus Function()? status,
    List<OverviewCategory> Function()? categories,
  }) {
    return CategoryOverviewState(
      status: status != null ? status() : this.status,
      categories: categories != null ? categories() : this.categories,
    );
  }
}

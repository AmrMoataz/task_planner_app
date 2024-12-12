part of 'category_overview_bloc.dart';

sealed class CategoryOverviewEvent extends Equatable {
  const CategoryOverviewEvent();

  @override
  List<Object> get props => [];
}

class CategoriesOverviewSubscriptionRequested extends CategoryOverviewEvent {
  const CategoriesOverviewSubscriptionRequested();
}

class CategoriesOverviewCategoryDeleteRequested extends CategoryOverviewEvent {
  const CategoriesOverviewCategoryDeleteRequested({
    required this.category,
  });

  final OverviewCategory category;

  @override
  List<Object> get props => [category];
}

class CategoriesOverviewSearchRequested extends CategoryOverviewEvent {
  const CategoriesOverviewSearchRequested({
    required this.searchTerm,
  }); 

  final String searchTerm;

  @override
  List<Object> get props => [searchTerm];
} 


import 'package:category_api/category_api.dart';

/// {@template category_repository}
/// A repository that handles category related requests.
/// {@endtemplate}
class CategoryRepository {
  /// {@macro category_repository}
  const CategoryRepository({
    required CategoryApi categoryApi,
  }) : _categoryApi = categoryApi;

  final CategoryApi _categoryApi;

  /// Provides a [Stream] of all categories.
  Stream<List<Category>> getCategories() => _categoryApi.getCategories();

  /// Saves a [category].
  ///
  /// If a [category] with the same id already exists, it will be replaced.
  Future<void> saveCategory(Category category) =>
      _categoryApi.saveCategory(category);

  /// Deletes the category with the given id.
  ///
  /// If no category with the given id exists, a [CategoryNotFoundException]
  /// error is thrown.
  Future<void> deleteCategory(String id) => _categoryApi.deleteCategory(id);
}
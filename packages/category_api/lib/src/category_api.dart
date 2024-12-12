import 'package:category_api/category_api.dart';

/// {@template task_type_api}
/// The interface for an API that provides access to a list of categories.
/// {@endtemplate}
abstract class CategoryApi {
  /// {@macro category_api}
  const CategoryApi();

  /// Provides a [Stream] of all categories.
  Stream<List<Category>> getCategories();

  /// Saves a [Category].
  ///
  /// If a [Category] with the same id already exists, it will be replaced.
  Future<void> saveCategory(Category category);

  /// Deletes the category with the given id.
  ///
  /// If no category with the given id exists, a [CategoryNotFoundException]
  /// error is thrown.
  Future<void> deleteCategory(String id);
}

/// Error thrown when a [Category] with a given id is not found.
class CategoryNotFoundException implements Exception {}

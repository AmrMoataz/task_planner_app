import 'dart:convert';

import 'package:category_api/category_api.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_category_api}
/// A Flutter implementation of the CategoryApi that uses local storage.
/// {@endtemplate}
class LocalStorageCategoryApi extends CategoryApi {
  /// {@macro local_storage_category_api}
  LocalStorageCategoryApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _categoryStreamController = BehaviorSubject<List<Category>>.seeded(const []);

  /// The key used for storing the categories locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kCategoriesCollectionKey = '__categories_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final categoriesJson = _getValue(kCategoriesCollectionKey);
    if (categoriesJson != null) {
      final categories = List<Map<String, dynamic>>.from(
        json.decode(categoriesJson) as List,
      ).map(Category.fromJson).toList();
      _categoryStreamController.add(categories);
    } else {
      _categoryStreamController.add(const []);
    }
  }

  @override
  Stream<List<Category>> getCategories() =>
      _categoryStreamController.asBroadcastStream();

  @override
  Future<void> saveCategory(Category category) {
    final categories = [..._categoryStreamController.value];
    final categoryIndex = categories.indexWhere((t) => t.id == category.id);
    if (categoryIndex >= 0) {
      categories[categoryIndex] = category;
    } else {
      categories.add(category);
    }

    _categoryStreamController.add(categories);
    return _setValue(kCategoriesCollectionKey, json.encode(categories));
  }

  @override
  Future<void> deleteCategory(String id) async {
    final categories = [..._categoryStreamController.value];
    final categoryIndex = categories.indexWhere((t) => t.id == id);
    if (categoryIndex == -1) {
      throw CategoryNotFoundException();
    } else {
      categories.removeAt(categoryIndex);
      _categoryStreamController.add(categories);
      return _setValue(kCategoriesCollectionKey, json.encode(categories));
    }
  }
}

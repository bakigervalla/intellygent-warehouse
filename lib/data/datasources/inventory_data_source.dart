import '../../domain/entities/category.dart';
import '../../domain/entities/item.dart';

/// Storage seam for live inventory. Today implemented by Drift
/// ([DriftInventoryDataSource]); a future remote/API source implements the
/// same contract without touching domain or presentation.
abstract interface class InventoryDataSource {
  Stream<List<Category>> watchCategories();
  Stream<List<Item>> watchItems();
  Future<List<Category>> getCategories();
  Future<List<Item>> getItems();
  Future<Item?> getItemById(int id);
  Future<Item?> findItemByName(String name);
  Future<Category?> findCategoryByName(String name);
  Future<Category> saveCategory(Category category);
  Future<Item> saveItem(Item item);
}

import '../entities/category.dart';
import '../entities/item.dart';

/// Live inventory access. Implementations decide where the data lives
/// (local DB today, remote API later) — domain and presentation never know.
abstract interface class InventoryRepository {
  Stream<List<Category>> watchCategories();

  Stream<List<Item>> watchItems();

  Future<List<Category>> getCategories();

  Future<List<Item>> getItems();

  Future<Item?> getItemById(int id);

  /// Case-insensitive exact-name lookup, used to match scan results
  /// against existing stock.
  Future<Item?> findItemByName(String name);

  /// Case-insensitive exact-name lookup.
  Future<Category?> findCategoryByName(String name);

  /// Inserts when [Category.id] is null, updates otherwise.
  /// Returns the persisted entity (with id).
  Future<Category> saveCategory(Category category);

  /// Inserts when [Item.id] is null, updates otherwise.
  /// Returns the persisted entity (with id).
  Future<Item> saveItem(Item item);
}

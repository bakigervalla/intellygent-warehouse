import '../../core/errors/app_exception.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_data_source.dart';

/// Delegates to whichever [InventoryDataSource] is wired in (Drift today),
/// translating storage failures into domain [StorageException]s.
class InventoryRepositoryImpl implements InventoryRepository {
  const InventoryRepositoryImpl(this._dataSource);

  final InventoryDataSource _dataSource;

  @override
  Stream<List<Category>> watchCategories() => _dataSource.watchCategories();

  @override
  Stream<List<Item>> watchItems() => _dataSource.watchItems();

  @override
  Future<List<Category>> getCategories() =>
      _guard(() => _dataSource.getCategories(), 'getCategories');

  @override
  Future<List<Item>> getItems() =>
      _guard(() => _dataSource.getItems(), 'getItems');

  @override
  Future<Item?> getItemById(int id) =>
      _guard(() => _dataSource.getItemById(id), 'getItemById');

  @override
  Future<Item?> findItemByName(String name) =>
      _guard(() => _dataSource.findItemByName(name), 'findItemByName');

  @override
  Future<Category?> findCategoryByName(String name) =>
      _guard(() => _dataSource.findCategoryByName(name), 'findCategoryByName');

  @override
  Future<Category> saveCategory(Category category) =>
      _guard(() => _dataSource.saveCategory(category), 'saveCategory');

  @override
  Future<Item> saveItem(Item item) =>
      _guard(() => _dataSource.saveItem(item), 'saveItem');

  Future<T> _guard<T>(Future<T> Function() action, String operation) async {
    try {
      return await action();
    } on AppException {
      rethrow;
    } catch (e) {
      throw StorageException('$operation failed: $e');
    }
  }
}

import 'package:drift/drift.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/item.dart';
import '../datasources/inventory_data_source.dart';
import 'app_database.dart';
import 'entity_mappers.dart';

class DriftInventoryDataSource implements InventoryDataSource {
  const DriftInventoryDataSource(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Category>> watchCategories() {
    final query = _db.select(_db.categories)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch().map(
          (rows) => rows.map((r) => r.toEntity()).toList(),
        );
  }

  @override
  Stream<List<Item>> watchItems() {
    final query = _db.select(_db.items)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch().map(
          (rows) => rows.map((r) => r.toEntity()).toList(),
        );
  }

  @override
  Future<List<Category>> getCategories() async {
    final rows = await _db.select(_db.categories).get();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<List<Item>> getItems() async {
    final rows = await _db.select(_db.items).get();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<Item?> getItemById(int id) async {
    final row = await (_db.select(_db.items)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<Item?> findItemByName(String name) async {
    final row = await (_db.select(_db.items)
          ..where((t) => t.name.lower().equals(name.trim().toLowerCase())))
        .getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<Category?> findCategoryByName(String name) async {
    final row = await (_db.select(_db.categories)
          ..where((t) => t.name.lower().equals(name.trim().toLowerCase())))
        .getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<Category> saveCategory(Category category) async {
    final id = await _db
        .into(_db.categories)
        .insertOnConflictUpdate(category.toCompanion());
    return category.copyWith(id: category.id ?? id);
  }

  @override
  Future<Item> saveItem(Item item) async {
    final id =
        await _db.into(_db.items).insertOnConflictUpdate(item.toCompanion());
    return item.copyWith(id: item.id ?? id);
  }
}

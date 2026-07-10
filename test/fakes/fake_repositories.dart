import 'package:intellygent_warehouse/domain/entities/category.dart';
import 'package:intellygent_warehouse/domain/entities/draft.dart';
import 'package:intellygent_warehouse/domain/entities/draft_enums.dart';
import 'package:intellygent_warehouse/domain/entities/item.dart';
import 'package:intellygent_warehouse/domain/repositories/draft_repository.dart';
import 'package:intellygent_warehouse/domain/repositories/inventory_repository.dart';

/// In-memory fakes so use-case tests stay pure Dart, no database involved.

class FakeInventoryRepository implements InventoryRepository {
  final List<Category> categories = [];
  final List<Item> items = [];
  int _nextCategoryId = 1;
  int _nextItemId = 1;

  @override
  Stream<List<Category>> watchCategories() => Stream.value(categories);

  @override
  Stream<List<Item>> watchItems() => Stream.value(items);

  @override
  Future<List<Category>> getCategories() async => List.of(categories);

  @override
  Future<List<Item>> getItems() async => List.of(items);

  @override
  Future<Item?> getItemById(int id) async =>
      items.where((i) => i.id == id).firstOrNull;

  @override
  Future<Item?> findItemByName(String name) async => items
      .where((i) => i.name.toLowerCase() == name.trim().toLowerCase())
      .firstOrNull;

  @override
  Future<Category?> findCategoryByName(String name) async => categories
      .where((c) => c.name.toLowerCase() == name.trim().toLowerCase())
      .firstOrNull;

  @override
  Future<Category> saveCategory(Category category) async {
    if (category.id == null) {
      final saved = category.copyWith(id: _nextCategoryId++);
      categories.add(saved);
      return saved;
    }
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      categories[index] = category;
    } else {
      categories.add(category);
    }
    return category;
  }

  @override
  Future<Item> saveItem(Item item) async {
    if (item.id == null) {
      final saved = item.copyWith(id: _nextItemId++);
      items.add(saved);
      return saved;
    }
    final index = items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      items[index] = item;
    } else {
      items.add(item);
    }
    return item;
  }
}

class FakeDraftRepository implements DraftRepository {
  final List<Draft> drafts = [];
  int _nextId = 1;

  @override
  Stream<List<Draft>> watchPendingDrafts() => Stream.value(
        drafts.where((d) => d.status == DraftStatus.pending).toList(),
      );

  @override
  Future<List<Draft>> getPendingDrafts() async =>
      drafts.where((d) => d.status == DraftStatus.pending).toList();

  @override
  Future<Draft?> getDraftById(int id) async =>
      drafts.where((d) => d.id == id).firstOrNull;

  @override
  Future<List<Draft>> createDrafts(List<Draft> newDrafts) async {
    final created = <Draft>[];
    for (final draft in newDrafts) {
      final saved = draft.copyWith(id: _nextId++);
      drafts.add(saved);
      created.add(saved);
    }
    return created;
  }

  @override
  Future<Draft> updateDraft(Draft draft) async {
    final index = drafts.indexWhere((d) => d.id == draft.id);
    if (index >= 0) drafts[index] = draft;
    return draft;
  }

  @override
  Future<Draft?> findPendingCategoryDraftByName(String name) async => drafts
      .where(
        (d) =>
            d.type == DraftType.newCategory &&
            d.status == DraftStatus.pending &&
            (d.categoryName?.toLowerCase() ?? '') ==
                name.trim().toLowerCase(),
      )
      .firstOrNull;

  @override
  Future<List<Draft>> getPendingDraftsByType(DraftType type) async => drafts
      .where((d) => d.type == type && d.status == DraftStatus.pending)
      .toList();
}

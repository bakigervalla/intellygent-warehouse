import '../entities/draft.dart';
import '../entities/draft_enums.dart';
import '../entities/recognized_item.dart';
import '../repositories/draft_repository.dart';
import '../repositories/inventory_repository.dart';

/// Turns AI scan results into pending drafts:
/// - recognised name matches a live item  -> stockUpdate draft
/// - unknown item, known category         -> newItem draft on live category
/// - unknown item, unknown category       -> newCategory draft + newItem
///   draft linked to it (reusing an already-pending category draft when one
///   exists with the same name)
class CreateDraftsFromScan {
  const CreateDraftsFromScan(this._inventory, this._drafts);

  final InventoryRepository _inventory;
  final DraftRepository _drafts;

  Future<List<Draft>> call(List<RecognizedItem> recognized) async {
    final created = <Draft>[];
    final now = DateTime.now();

    // Category drafts created during THIS scan, keyed by lowercase name,
    // so one scan never proposes the same category twice.
    final batchCategoryDrafts = <String, Draft>{};

    for (final item in _mergeDuplicates(recognized)) {
      final existing = await _inventory.findItemByName(item.itemName);

      if (existing != null) {
        created.add(await _createStockUpdateDraft(existing.id!, item, now));
        continue;
      }

      created.addAll(
        await _createNewItemDrafts(item, now, batchCategoryDrafts),
      );
    }
    return created;
  }

  /// Same item name recognised twice across photos: sum counts, keep the
  /// highest confidence.
  List<RecognizedItem> _mergeDuplicates(List<RecognizedItem> input) {
    final byName = <String, RecognizedItem>{};
    for (final item in input) {
      final key = item.itemName.trim().toLowerCase();
      final seen = byName[key];
      byName[key] = seen == null
          ? item
          : seen.copyWith(
              estimatedCount: seen.estimatedCount + item.estimatedCount,
              confidence:
                  seen.confidence > item.confidence
                      ? seen.confidence
                      : item.confidence,
            );
    }
    return byName.values.toList();
  }

  Future<Draft> _createStockUpdateDraft(
    int itemId,
    RecognizedItem item,
    DateTime now,
  ) async {
    final existing = await _inventory.getItemById(itemId);
    final drafts = await _drafts.createDrafts([
      Draft(
        type: DraftType.stockUpdate,
        status: DraftStatus.pending,
        createdAt: now,
        itemId: itemId,
        itemName: item.itemName,
        categoryId: existing?.categoryId,
        proposedCount: item.estimatedCount,
        previousCount: existing?.quantity,
        confidence: item.confidence,
      ),
    ]);
    return drafts.first;
  }

  Future<List<Draft>> _createNewItemDrafts(
    RecognizedItem item,
    DateTime now,
    Map<String, Draft> batchCategoryDrafts,
  ) async {
    final created = <Draft>[];
    final categoryName = item.category.trim();
    final categoryKey = categoryName.toLowerCase();

    final liveCategory = await _inventory.findCategoryByName(categoryName);

    int? categoryId = liveCategory?.id;
    int? categoryDraftId;

    if (liveCategory == null) {
      var categoryDraft = batchCategoryDrafts[categoryKey] ??
          await _drafts.findPendingCategoryDraftByName(categoryName);

      if (categoryDraft == null) {
        final persisted = await _drafts.createDrafts([
          Draft(
            type: DraftType.newCategory,
            status: DraftStatus.pending,
            createdAt: now,
            categoryName: categoryName,
          ),
        ]);
        categoryDraft = persisted.first;
        created.add(categoryDraft);
      }
      batchCategoryDrafts[categoryKey] = categoryDraft;
      categoryDraftId = categoryDraft.id;
    }

    final itemDrafts = await _drafts.createDrafts([
      Draft(
        type: DraftType.newItem,
        status: DraftStatus.pending,
        createdAt: now,
        itemName: item.itemName,
        categoryId: categoryId,
        categoryName: categoryName,
        newCategoryDraftId: categoryDraftId,
        proposedCount: item.estimatedCount,
        confidence: item.confidence,
      ),
    ]);
    created.addAll(itemDrafts);
    return created;
  }
}

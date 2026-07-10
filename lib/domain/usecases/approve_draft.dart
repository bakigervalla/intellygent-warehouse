import '../../core/errors/app_exception.dart';
import '../entities/category.dart';
import '../entities/draft.dart';
import '../entities/draft_enums.dart';
import '../entities/item.dart';
import '../repositories/draft_repository.dart';
import '../repositories/inventory_repository.dart';

/// Applies a pending draft to the live inventory. This is the ONLY place
/// live data is mutated from a scan.
///
/// Rules:
/// - newCategory: creates the live category.
/// - newItem: creates the live item; if its category only exists as a
///   pending draft, that draft is approved first (cascade). If the category
///   draft was rejected, the item falls back to "Uncategorized".
/// - stockUpdate: sets the live item's quantity to the proposed count.
class ApproveDraft {
  const ApproveDraft(this._inventory, this._drafts);

  static const String fallbackCategoryName = 'Uncategorized';

  final InventoryRepository _inventory;
  final DraftRepository _drafts;

  Future<void> call(int draftId) async {
    final draft = await _requirePending(draftId);
    switch (draft.type) {
      case DraftType.newCategory:
        await _approveNewCategory(draft);
      case DraftType.newItem:
        await _approveNewItem(draft);
      case DraftType.stockUpdate:
        await _approveStockUpdate(draft);
    }
  }

  Future<Draft> _requirePending(int draftId) async {
    final draft = await _drafts.getDraftById(draftId);
    if (draft == null) {
      throw const DomainRuleException(
        'Draft not found',
        'This draft no longer exists.',
      );
    }
    if (draft.status != DraftStatus.pending) {
      throw DomainRuleException(
        'Draft ${draft.id} already ${draft.status.name}',
        'This draft was already resolved.',
      );
    }
    return draft;
  }

  Future<Category> _approveNewCategory(Draft draft) async {
    final name = draft.categoryName?.trim() ?? '';
    if (name.isEmpty) {
      throw const DomainRuleException(
        'newCategory draft without a name',
        'This category draft is invalid and cannot be approved.',
      );
    }
    // Idempotent against a category approved through another draft.
    final category = await _inventory.findCategoryByName(name) ??
        await _inventory
            .saveCategory(Category(name: name, createdAt: DateTime.now()));
    await _drafts.updateDraft(draft.copyWith(status: DraftStatus.approved));
    return category;
  }

  Future<void> _approveNewItem(Draft draft) async {
    final name = draft.itemName?.trim() ?? '';
    if (name.isEmpty) {
      throw const DomainRuleException(
        'newItem draft without a name',
        'This item draft is invalid and cannot be approved.',
      );
    }
    final categoryId = await _resolveCategoryId(draft);
    await _inventory.saveItem(
      Item(
        name: name,
        categoryId: categoryId,
        quantity: draft.proposedCount ?? 0,
        updatedAt: DateTime.now(),
      ),
    );
    await _drafts.updateDraft(draft.copyWith(status: DraftStatus.approved));
  }

  Future<void> _approveStockUpdate(Draft draft) async {
    final itemId = draft.itemId;
    final item = itemId == null ? null : await _inventory.getItemById(itemId);
    if (item == null) {
      throw const DomainRuleException(
        'stockUpdate draft points at a missing item',
        'The item this draft updates no longer exists.',
      );
    }
    await _inventory.saveItem(
      item.copyWith(
        quantity: draft.proposedCount ?? item.quantity,
        updatedAt: DateTime.now(),
      ),
    );
    await _drafts.updateDraft(draft.copyWith(status: DraftStatus.approved));
  }

  Future<int> _resolveCategoryId(Draft draft) async {
    if (draft.categoryId != null) return draft.categoryId!;

    final categoryDraftId = draft.newCategoryDraftId;
    if (categoryDraftId != null) {
      final categoryDraft = await _drafts.getDraftById(categoryDraftId);
      if (categoryDraft != null) {
        switch (categoryDraft.status) {
          case DraftStatus.pending:
            final category = await _approveNewCategory(categoryDraft);
            return category.id!;
          case DraftStatus.approved:
            final existing = await _inventory
                .findCategoryByName(categoryDraft.categoryName ?? '');
            if (existing != null) return existing.id!;
          case DraftStatus.rejected:
            break; // fall through to Uncategorized
        }
      }
    }

    final fallback = await _inventory.findCategoryByName(fallbackCategoryName);
    if (fallback != null) return fallback.id!;
    final createdFallback = await _inventory.saveCategory(
      Category(name: fallbackCategoryName, createdAt: DateTime.now()),
    );
    return createdFallback.id!;
  }
}

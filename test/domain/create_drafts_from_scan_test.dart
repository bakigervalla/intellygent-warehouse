import 'package:flutter_test/flutter_test.dart';
import 'package:intellygent_warehouse/domain/entities/category.dart';
import 'package:intellygent_warehouse/domain/entities/draft_enums.dart';
import 'package:intellygent_warehouse/domain/entities/item.dart';
import 'package:intellygent_warehouse/domain/entities/recognized_item.dart';
import 'package:intellygent_warehouse/domain/usecases/create_drafts_from_scan.dart';

import '../fakes/fake_repositories.dart';

void main() {
  late FakeInventoryRepository inventory;
  late FakeDraftRepository drafts;
  late CreateDraftsFromScan useCase;

  setUp(() {
    inventory = FakeInventoryRepository();
    drafts = FakeDraftRepository();
    useCase = CreateDraftsFromScan(inventory, drafts);
  });

  test('existing item produces a stockUpdate draft, live count untouched',
      () async {
    // Arrange
    final category = await inventory.saveCategory(
      Category(name: 'Tools', createdAt: DateTime(2026)),
    );
    final hammer = await inventory.saveItem(
      Item(
        name: 'Hammer',
        categoryId: category.id!,
        quantity: 5,
        updatedAt: DateTime(2026),
      ),
    );

    // Act
    final created = await useCase([
      const RecognizedItem(
        itemName: 'hammer',
        category: 'Tools',
        estimatedCount: 8,
        confidence: 0.9,
      ),
    ]);

    // Assert
    expect(created, hasLength(1));
    final draft = created.single;
    expect(draft.type, DraftType.stockUpdate);
    expect(draft.status, DraftStatus.pending);
    expect(draft.itemId, hammer.id);
    expect(draft.previousCount, 5);
    expect(draft.proposedCount, 8);
    expect((await inventory.getItemById(hammer.id!))!.quantity, 5);
  });

  test('unknown item in existing category produces only a newItem draft',
      () async {
    await inventory.saveCategory(
      Category(name: 'Beverages', createdAt: DateTime(2026)),
    );

    final created = await useCase([
      const RecognizedItem(
        itemName: 'Cola bottle',
        category: 'beverages',
        estimatedCount: 24,
        confidence: 0.8,
      ),
    ]);

    expect(created, hasLength(1));
    expect(created.single.type, DraftType.newItem);
    expect(created.single.categoryId, isNotNull);
    expect(created.single.newCategoryDraftId, isNull);
    expect(await inventory.getItems(), isEmpty);
  });

  test('unknown item + unknown category produces category and item drafts',
      () async {
    final created = await useCase([
      const RecognizedItem(
        itemName: 'Drill',
        category: 'Power tools',
        estimatedCount: 2,
        confidence: 0.7,
      ),
    ]);

    expect(created, hasLength(2));
    final categoryDraft =
        created.singleWhere((d) => d.type == DraftType.newCategory);
    final itemDraft = created.singleWhere((d) => d.type == DraftType.newItem);
    expect(categoryDraft.categoryName, 'Power tools');
    expect(itemDraft.newCategoryDraftId, categoryDraft.id);
    expect(await inventory.getCategories(), isEmpty);
  });

  test('two unknown items sharing an unknown category reuse one category draft',
      () async {
    final created = await useCase([
      const RecognizedItem(
        itemName: 'Drill',
        category: 'Power tools',
        estimatedCount: 2,
        confidence: 0.7,
      ),
      const RecognizedItem(
        itemName: 'Circular saw',
        category: 'power tools',
        estimatedCount: 1,
        confidence: 0.6,
      ),
    ]);

    final categoryDrafts =
        created.where((d) => d.type == DraftType.newCategory);
    expect(categoryDrafts, hasLength(1));
  });

  test('duplicate recognitions of one item merge counts', () async {
    final created = await useCase([
      const RecognizedItem(
        itemName: 'Box',
        category: 'Storage',
        estimatedCount: 3,
        confidence: 0.5,
      ),
      const RecognizedItem(
        itemName: 'box',
        category: 'Storage',
        estimatedCount: 4,
        confidence: 0.9,
      ),
    ]);

    final itemDraft = created.singleWhere((d) => d.type == DraftType.newItem);
    expect(itemDraft.proposedCount, 7);
    expect(itemDraft.confidence, 0.9);
  });
}

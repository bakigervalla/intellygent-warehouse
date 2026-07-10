import 'package:flutter_test/flutter_test.dart';
import 'package:intellygent_warehouse/core/errors/app_exception.dart';
import 'package:intellygent_warehouse/domain/entities/category.dart';
import 'package:intellygent_warehouse/domain/entities/draft.dart';
import 'package:intellygent_warehouse/domain/entities/draft_enums.dart';
import 'package:intellygent_warehouse/domain/entities/item.dart';
import 'package:intellygent_warehouse/domain/usecases/approve_draft.dart';
import 'package:intellygent_warehouse/domain/usecases/reject_draft.dart';

import '../fakes/fake_repositories.dart';

void main() {
  late FakeInventoryRepository inventory;
  late FakeDraftRepository drafts;
  late ApproveDraft approve;
  late RejectDraft reject;

  setUp(() {
    inventory = FakeInventoryRepository();
    drafts = FakeDraftRepository();
    approve = ApproveDraft(inventory, drafts);
    reject = RejectDraft(drafts);
  });

  Draft pending(DraftType type) => Draft(
        type: type,
        status: DraftStatus.pending,
        createdAt: DateTime(2026),
      );

  test('approving a stockUpdate draft changes the live quantity', () async {
    final category = await inventory.saveCategory(
      Category(name: 'Tools', createdAt: DateTime(2026)),
    );
    final item = await inventory.saveItem(
      Item(
        name: 'Hammer',
        categoryId: category.id!,
        quantity: 5,
        updatedAt: DateTime(2026),
      ),
    );
    final created = await drafts.createDrafts([
      pending(DraftType.stockUpdate)
          .copyWith(itemId: item.id, previousCount: 5, proposedCount: 9),
    ]);

    await approve(created.single.id!);

    expect((await inventory.getItemById(item.id!))!.quantity, 9);
    expect(
      (await drafts.getDraftById(created.single.id!))!.status,
      DraftStatus.approved,
    );
  });

  test('approving a newItem draft cascades its pending category draft',
      () async {
    final categoryDraft = (await drafts.createDrafts([
      pending(DraftType.newCategory).copyWith(categoryName: 'Power tools'),
    ]))
        .single;
    final itemDraft = (await drafts.createDrafts([
      pending(DraftType.newItem).copyWith(
        itemName: 'Drill',
        newCategoryDraftId: categoryDraft.id,
        proposedCount: 2,
      ),
    ]))
        .single;

    await approve(itemDraft.id!);

    final categories = await inventory.getCategories();
    expect(categories.map((c) => c.name), contains('Power tools'));
    final items = await inventory.getItems();
    expect(items.single.name, 'Drill');
    expect(items.single.quantity, 2);
    expect(
      (await drafts.getDraftById(categoryDraft.id!))!.status,
      DraftStatus.approved,
    );
  });

  test(
      'approving a newItem draft whose category draft was rejected falls '
      'back to Uncategorized', () async {
    final categoryDraft = (await drafts.createDrafts([
      pending(DraftType.newCategory).copyWith(categoryName: 'Mystery'),
    ]))
        .single;
    final itemDraft = (await drafts.createDrafts([
      pending(DraftType.newItem).copyWith(
        itemName: 'Widget',
        newCategoryDraftId: categoryDraft.id,
        proposedCount: 1,
      ),
    ]))
        .single;

    await reject(categoryDraft.id!);
    await approve(itemDraft.id!);

    final categories = await inventory.getCategories();
    expect(categories.map((c) => c.name), contains('Uncategorized'));
    expect(categories.map((c) => c.name), isNot(contains('Mystery')));
    expect((await inventory.getItems()).single.name, 'Widget');
  });

  test('rejected drafts never mutate live inventory', () async {
    final created = await drafts.createDrafts([
      pending(DraftType.newItem)
          .copyWith(itemName: 'Ghost item', proposedCount: 3),
    ]);

    await reject(created.single.id!);

    expect(await inventory.getItems(), isEmpty);
    expect(
      (await drafts.getDraftById(created.single.id!))!.status,
      DraftStatus.rejected,
    );
  });

  test('resolving an already-resolved draft throws', () async {
    final created = await drafts.createDrafts([
      pending(DraftType.newCategory).copyWith(categoryName: 'Tools'),
    ]);

    await approve(created.single.id!);

    expect(
      () => approve(created.single.id!),
      throwsA(isA<DomainRuleException>()),
    );
    expect(
      () => reject(created.single.id!),
      throwsA(isA<DomainRuleException>()),
    );
  });
}

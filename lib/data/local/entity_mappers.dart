import 'package:drift/drift.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/draft.dart';
import '../../domain/entities/item.dart';
import 'app_database.dart';

extension CategoryRowMapper on CategoryRow {
  Category toEntity() => Category(id: id, name: name, createdAt: createdAt);
}

extension ItemRowMapper on ItemRow {
  Item toEntity() => Item(
        id: id,
        name: name,
        categoryId: categoryId,
        quantity: quantity,
        updatedAt: updatedAt,
      );
}

extension DraftRowMapper on DraftRow {
  Draft toEntity() => Draft(
        id: id,
        type: type,
        status: status,
        createdAt: createdAt,
        itemId: itemId,
        itemName: itemName,
        categoryId: categoryId,
        categoryName: categoryName,
        newCategoryDraftId: newCategoryDraftId,
        proposedCount: proposedCount,
        previousCount: previousCount,
        confidence: confidence,
      );
}

extension CategoryEntityMapper on Category {
  CategoriesCompanion toCompanion() => CategoriesCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        name: Value(name),
        createdAt: Value(createdAt),
      );
}

extension ItemEntityMapper on Item {
  ItemsCompanion toCompanion() => ItemsCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        name: Value(name),
        categoryId: Value(categoryId),
        quantity: Value(quantity),
        updatedAt: Value(updatedAt),
      );
}

extension DraftEntityMapper on Draft {
  DraftsCompanion toCompanion() => DraftsCompanion(
        id: id == null ? const Value.absent() : Value(id!),
        type: Value(type),
        status: Value(status),
        createdAt: Value(createdAt),
        itemId: Value(itemId),
        itemName: Value(itemName),
        categoryId: Value(categoryId),
        categoryName: Value(categoryName),
        newCategoryDraftId: Value(newCategoryDraftId),
        proposedCount: Value(proposedCount),
        previousCount: Value(previousCount),
        confidence: Value(confidence),
      );
}

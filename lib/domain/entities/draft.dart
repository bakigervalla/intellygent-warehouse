import 'package:freezed_annotation/freezed_annotation.dart';

import 'draft_enums.dart';

part 'draft.freezed.dart';
part 'draft.g.dart';

/// A proposed change to the live inventory. Nothing in the live inventory
/// mutates until a draft is approved.
///
/// Field usage per [DraftType]:
/// - [DraftType.newCategory]: [categoryName] is the proposed name.
/// - [DraftType.newItem]: [itemName] + [proposedCount]. The category is either
///   an existing live one ([categoryId]) or a pending category draft
///   ([newCategoryDraftId]). If both are null the item lands in
///   "Uncategorized" on approval.
/// - [DraftType.stockUpdate]: [itemId] points at the live item,
///   [previousCount] is its count at scan time, [proposedCount] the new count.
@freezed
abstract class Draft with _$Draft {
  const factory Draft({
    /// Null until persisted.
    int? id,
    required DraftType type,
    required DraftStatus status,
    required DateTime createdAt,

    /// Live item this draft updates (stockUpdate only).
    int? itemId,

    /// Display / creation name of the item (newItem, stockUpdate).
    String? itemName,

    /// Existing live category the item belongs to.
    int? categoryId,

    /// Proposed or matched category name, for display and creation.
    String? categoryName,

    /// Pending newCategory draft this newItem draft depends on.
    int? newCategoryDraftId,

    /// Estimated count from the scan (newItem, stockUpdate).
    int? proposedCount,

    /// Live quantity at scan time (stockUpdate).
    int? previousCount,

    /// AI confidence 0..1.
    double? confidence,
  }) = _Draft;

  factory Draft.fromJson(Map<String, dynamic> json) => _$DraftFromJson(json);
}

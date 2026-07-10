import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

/// A live inventory item. Quantity only ever changes through an approved
/// draft — never directly from a scan.
@freezed
abstract class Item with _$Item {
  const factory Item({
    /// Null until persisted.
    int? id,
    required String name,
    required int categoryId,
    required int quantity,
    required DateTime updatedAt,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

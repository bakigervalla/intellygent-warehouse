import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// A live inventory category. Proposed (not yet approved) categories exist
/// only as [Draft]s of type `newCategory` — they never appear here until
/// approved.
@freezed
abstract class Category with _$Category {
  const factory Category({
    /// Null until persisted.
    int? id,
    required String name,
    required DateTime createdAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

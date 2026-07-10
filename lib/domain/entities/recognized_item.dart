import 'package:freezed_annotation/freezed_annotation.dart';

part 'recognized_item.freezed.dart';
part 'recognized_item.g.dart';

/// One item the AI recognised in the captured photos. This is the validated
/// boundary type — raw AI JSON is parsed and checked before becoming one of
/// these.
@freezed
abstract class RecognizedItem with _$RecognizedItem {
  const factory RecognizedItem({
    required String itemName,
    required String category,
    required int estimatedCount,

    /// 0..1.
    required double confidence,
  }) = _RecognizedItem;

  factory RecognizedItem.fromJson(Map<String, dynamic> json) =>
      _$RecognizedItemFromJson(json);
}

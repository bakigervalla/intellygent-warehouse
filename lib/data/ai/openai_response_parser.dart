import 'dart:convert';

import '../../core/errors/app_exception.dart';
import '../../domain/entities/recognized_item.dart';

/// Strict boundary validation of the model's JSON answer.
///
/// Expected shape:
/// ```json
/// {"items": [{"itemName": "...", "category": "...",
///             "estimatedCount": 3, "confidence": 0.9}]}
/// ```
/// Individual malformed entries are skipped; a malformed envelope, or a
/// non-empty list in which nothing validates, throws
/// [AiResponseFormatException].
class OpenAiResponseParser {
  const OpenAiResponseParser();

  static const String _fallbackCategory = 'Uncategorized';

  List<RecognizedItem> parse(String content) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(content);
    } on FormatException catch (e) {
      throw AiResponseFormatException('Response is not JSON: ${e.message}');
    }

    if (decoded is! Map<String, dynamic>) {
      throw AiResponseFormatException(
        'Expected a JSON object, got ${decoded.runtimeType}',
      );
    }
    final rawItems = decoded['items'];
    if (rawItems is! List) {
      throw const AiResponseFormatException(
        'Missing or non-list "items" field',
      );
    }

    final items = rawItems.whereType<Map<String, dynamic>>().map(_parseEntry)
        .whereType<RecognizedItem>()
        .toList();

    if (items.isEmpty && rawItems.isNotEmpty) {
      throw const AiResponseFormatException(
        'No entry in "items" passed validation',
      );
    }
    return items;
  }

  RecognizedItem? _parseEntry(Map<String, dynamic> entry) {
    final name = entry['itemName'];
    if (name is! String || name.trim().isEmpty) return null;

    final category = entry['category'];
    final categoryName = category is String && category.trim().isNotEmpty
        ? category.trim()
        : _fallbackCategory;

    final rawCount = entry['estimatedCount'];
    if (rawCount is! num) return null;
    final count = rawCount.toInt();
    if (count < 0) return null;

    final rawConfidence = entry['confidence'];
    final confidence =
        rawConfidence is num ? rawConfidence.toDouble().clamp(0.0, 1.0) : 0.0;

    return RecognizedItem(
      itemName: name.trim(),
      category: categoryName,
      estimatedCount: count,
      confidence: confidence,
    );
  }
}

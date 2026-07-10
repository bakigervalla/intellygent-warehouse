import 'package:flutter_test/flutter_test.dart';
import 'package:intellygent_warehouse/core/errors/app_exception.dart';
import 'package:intellygent_warehouse/data/ai/openai_response_parser.dart';

void main() {
  const parser = OpenAiResponseParser();

  test('parses a valid response', () {
    final items = parser.parse(
      '{"items": [{"itemName": "Hammer", "category": "Tools", '
      '"estimatedCount": 3, "confidence": 0.85}]}',
    );

    expect(items, hasLength(1));
    expect(items.single.itemName, 'Hammer');
    expect(items.single.category, 'Tools');
    expect(items.single.estimatedCount, 3);
    expect(items.single.confidence, 0.85);
  });

  test('throws on non-JSON content', () {
    expect(
      () => parser.parse('I see a hammer and two boxes.'),
      throwsA(isA<AiResponseFormatException>()),
    );
  });

  test('throws when items field is missing', () {
    expect(
      () => parser.parse('{"stuff": []}'),
      throwsA(isA<AiResponseFormatException>()),
    );
  });

  test('skips malformed entries but keeps valid ones', () {
    final items = parser.parse(
      '{"items": ['
      '{"itemName": "", "category": "Tools", "estimatedCount": 1}, '
      '{"itemName": "Saw", "category": "Tools", "estimatedCount": "many"}, '
      '{"itemName": "Drill", "category": "Tools", "estimatedCount": 2, '
      '"confidence": 0.5}'
      ']}',
    );

    expect(items, hasLength(1));
    expect(items.single.itemName, 'Drill');
  });

  test('throws when every entry is invalid', () {
    expect(
      () => parser.parse('{"items": [{"itemName": 42}]}'),
      throwsA(isA<AiResponseFormatException>()),
    );
  });

  test('clamps confidence into 0..1 and defaults missing category', () {
    final items = parser.parse(
      '{"items": [{"itemName": "Crate", "estimatedCount": 4, '
      '"confidence": 3.5}]}',
    );

    expect(items.single.confidence, 1.0);
    expect(items.single.category, 'Uncategorized');
  });

  test('empty items list is valid', () {
    expect(parser.parse('{"items": []}'), isEmpty);
  });
}

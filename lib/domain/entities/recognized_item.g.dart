// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recognized_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecognizedItem _$RecognizedItemFromJson(Map<String, dynamic> json) =>
    _RecognizedItem(
      itemName: json['itemName'] as String,
      category: json['category'] as String,
      estimatedCount: (json['estimatedCount'] as num).toInt(),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$RecognizedItemToJson(_RecognizedItem instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'category': instance.category,
      'estimatedCount': instance.estimatedCount,
      'confidence': instance.confidence,
    };

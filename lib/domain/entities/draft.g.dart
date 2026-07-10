// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Draft _$DraftFromJson(Map<String, dynamic> json) => _Draft(
  id: (json['id'] as num?)?.toInt(),
  type: $enumDecode(_$DraftTypeEnumMap, json['type']),
  status: $enumDecode(_$DraftStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  itemId: (json['itemId'] as num?)?.toInt(),
  itemName: json['itemName'] as String?,
  categoryId: (json['categoryId'] as num?)?.toInt(),
  categoryName: json['categoryName'] as String?,
  newCategoryDraftId: (json['newCategoryDraftId'] as num?)?.toInt(),
  proposedCount: (json['proposedCount'] as num?)?.toInt(),
  previousCount: (json['previousCount'] as num?)?.toInt(),
  confidence: (json['confidence'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DraftToJson(_Draft instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$DraftTypeEnumMap[instance.type]!,
  'status': _$DraftStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'itemId': instance.itemId,
  'itemName': instance.itemName,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'newCategoryDraftId': instance.newCategoryDraftId,
  'proposedCount': instance.proposedCount,
  'previousCount': instance.previousCount,
  'confidence': instance.confidence,
};

const _$DraftTypeEnumMap = {
  DraftType.newItem: 'newItem',
  DraftType.stockUpdate: 'stockUpdate',
  DraftType.newCategory: 'newCategory',
};

const _$DraftStatusEnumMap = {
  DraftStatus.pending: 'pending',
  DraftStatus.approved: 'approved',
  DraftStatus.rejected: 'rejected',
};

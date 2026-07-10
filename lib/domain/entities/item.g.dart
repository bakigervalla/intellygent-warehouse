// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Item _$ItemFromJson(Map<String, dynamic> json) => _Item(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  categoryId: (json['categoryId'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ItemToJson(_Item instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'categoryId': instance.categoryId,
  'quantity': instance.quantity,
  'updatedAt': instance.updatedAt.toIso8601String(),
};

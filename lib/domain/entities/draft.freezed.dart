// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Draft {

/// Null until persisted.
 int? get id; DraftType get type; DraftStatus get status; DateTime get createdAt;/// Live item this draft updates (stockUpdate only).
 int? get itemId;/// Display / creation name of the item (newItem, stockUpdate).
 String? get itemName;/// Existing live category the item belongs to.
 int? get categoryId;/// Proposed or matched category name, for display and creation.
 String? get categoryName;/// Pending newCategory draft this newItem draft depends on.
 int? get newCategoryDraftId;/// Estimated count from the scan (newItem, stockUpdate).
 int? get proposedCount;/// Live quantity at scan time (stockUpdate).
 int? get previousCount;/// AI confidence 0..1.
 double? get confidence;
/// Create a copy of Draft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftCopyWith<Draft> get copyWith => _$DraftCopyWithImpl<Draft>(this as Draft, _$identity);

  /// Serializes this Draft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Draft&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.newCategoryDraftId, newCategoryDraftId) || other.newCategoryDraftId == newCategoryDraftId)&&(identical(other.proposedCount, proposedCount) || other.proposedCount == proposedCount)&&(identical(other.previousCount, previousCount) || other.previousCount == previousCount)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,status,createdAt,itemId,itemName,categoryId,categoryName,newCategoryDraftId,proposedCount,previousCount,confidence);

@override
String toString() {
  return 'Draft(id: $id, type: $type, status: $status, createdAt: $createdAt, itemId: $itemId, itemName: $itemName, categoryId: $categoryId, categoryName: $categoryName, newCategoryDraftId: $newCategoryDraftId, proposedCount: $proposedCount, previousCount: $previousCount, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $DraftCopyWith<$Res>  {
  factory $DraftCopyWith(Draft value, $Res Function(Draft) _then) = _$DraftCopyWithImpl;
@useResult
$Res call({
 int? id, DraftType type, DraftStatus status, DateTime createdAt, int? itemId, String? itemName, int? categoryId, String? categoryName, int? newCategoryDraftId, int? proposedCount, int? previousCount, double? confidence
});




}
/// @nodoc
class _$DraftCopyWithImpl<$Res>
    implements $DraftCopyWith<$Res> {
  _$DraftCopyWithImpl(this._self, this._then);

  final Draft _self;
  final $Res Function(Draft) _then;

/// Create a copy of Draft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? type = null,Object? status = null,Object? createdAt = null,Object? itemId = freezed,Object? itemName = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? newCategoryDraftId = freezed,Object? proposedCount = freezed,Object? previousCount = freezed,Object? confidence = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DraftType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DraftStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int?,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,newCategoryDraftId: freezed == newCategoryDraftId ? _self.newCategoryDraftId : newCategoryDraftId // ignore: cast_nullable_to_non_nullable
as int?,proposedCount: freezed == proposedCount ? _self.proposedCount : proposedCount // ignore: cast_nullable_to_non_nullable
as int?,previousCount: freezed == previousCount ? _self.previousCount : previousCount // ignore: cast_nullable_to_non_nullable
as int?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Draft].
extension DraftPatterns on Draft {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Draft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Draft() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Draft value)  $default,){
final _that = this;
switch (_that) {
case _Draft():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Draft value)?  $default,){
final _that = this;
switch (_that) {
case _Draft() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  DraftType type,  DraftStatus status,  DateTime createdAt,  int? itemId,  String? itemName,  int? categoryId,  String? categoryName,  int? newCategoryDraftId,  int? proposedCount,  int? previousCount,  double? confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Draft() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.createdAt,_that.itemId,_that.itemName,_that.categoryId,_that.categoryName,_that.newCategoryDraftId,_that.proposedCount,_that.previousCount,_that.confidence);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  DraftType type,  DraftStatus status,  DateTime createdAt,  int? itemId,  String? itemName,  int? categoryId,  String? categoryName,  int? newCategoryDraftId,  int? proposedCount,  int? previousCount,  double? confidence)  $default,) {final _that = this;
switch (_that) {
case _Draft():
return $default(_that.id,_that.type,_that.status,_that.createdAt,_that.itemId,_that.itemName,_that.categoryId,_that.categoryName,_that.newCategoryDraftId,_that.proposedCount,_that.previousCount,_that.confidence);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  DraftType type,  DraftStatus status,  DateTime createdAt,  int? itemId,  String? itemName,  int? categoryId,  String? categoryName,  int? newCategoryDraftId,  int? proposedCount,  int? previousCount,  double? confidence)?  $default,) {final _that = this;
switch (_that) {
case _Draft() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.createdAt,_that.itemId,_that.itemName,_that.categoryId,_that.categoryName,_that.newCategoryDraftId,_that.proposedCount,_that.previousCount,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Draft implements Draft {
  const _Draft({this.id, required this.type, required this.status, required this.createdAt, this.itemId, this.itemName, this.categoryId, this.categoryName, this.newCategoryDraftId, this.proposedCount, this.previousCount, this.confidence});
  factory _Draft.fromJson(Map<String, dynamic> json) => _$DraftFromJson(json);

/// Null until persisted.
@override final  int? id;
@override final  DraftType type;
@override final  DraftStatus status;
@override final  DateTime createdAt;
/// Live item this draft updates (stockUpdate only).
@override final  int? itemId;
/// Display / creation name of the item (newItem, stockUpdate).
@override final  String? itemName;
/// Existing live category the item belongs to.
@override final  int? categoryId;
/// Proposed or matched category name, for display and creation.
@override final  String? categoryName;
/// Pending newCategory draft this newItem draft depends on.
@override final  int? newCategoryDraftId;
/// Estimated count from the scan (newItem, stockUpdate).
@override final  int? proposedCount;
/// Live quantity at scan time (stockUpdate).
@override final  int? previousCount;
/// AI confidence 0..1.
@override final  double? confidence;

/// Create a copy of Draft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftCopyWith<_Draft> get copyWith => __$DraftCopyWithImpl<_Draft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Draft&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.newCategoryDraftId, newCategoryDraftId) || other.newCategoryDraftId == newCategoryDraftId)&&(identical(other.proposedCount, proposedCount) || other.proposedCount == proposedCount)&&(identical(other.previousCount, previousCount) || other.previousCount == previousCount)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,status,createdAt,itemId,itemName,categoryId,categoryName,newCategoryDraftId,proposedCount,previousCount,confidence);

@override
String toString() {
  return 'Draft(id: $id, type: $type, status: $status, createdAt: $createdAt, itemId: $itemId, itemName: $itemName, categoryId: $categoryId, categoryName: $categoryName, newCategoryDraftId: $newCategoryDraftId, proposedCount: $proposedCount, previousCount: $previousCount, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$DraftCopyWith<$Res> implements $DraftCopyWith<$Res> {
  factory _$DraftCopyWith(_Draft value, $Res Function(_Draft) _then) = __$DraftCopyWithImpl;
@override @useResult
$Res call({
 int? id, DraftType type, DraftStatus status, DateTime createdAt, int? itemId, String? itemName, int? categoryId, String? categoryName, int? newCategoryDraftId, int? proposedCount, int? previousCount, double? confidence
});




}
/// @nodoc
class __$DraftCopyWithImpl<$Res>
    implements _$DraftCopyWith<$Res> {
  __$DraftCopyWithImpl(this._self, this._then);

  final _Draft _self;
  final $Res Function(_Draft) _then;

/// Create a copy of Draft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? type = null,Object? status = null,Object? createdAt = null,Object? itemId = freezed,Object? itemName = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? newCategoryDraftId = freezed,Object? proposedCount = freezed,Object? previousCount = freezed,Object? confidence = freezed,}) {
  return _then(_Draft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DraftType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DraftStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int?,itemName: freezed == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,newCategoryDraftId: freezed == newCategoryDraftId ? _self.newCategoryDraftId : newCategoryDraftId // ignore: cast_nullable_to_non_nullable
as int?,proposedCount: freezed == proposedCount ? _self.proposedCount : proposedCount // ignore: cast_nullable_to_non_nullable
as int?,previousCount: freezed == previousCount ? _self.previousCount : previousCount // ignore: cast_nullable_to_non_nullable
as int?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on

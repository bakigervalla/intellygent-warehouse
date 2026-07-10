// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recognized_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecognizedItem {

 String get itemName; String get category; int get estimatedCount;/// 0..1.
 double get confidence;
/// Create a copy of RecognizedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecognizedItemCopyWith<RecognizedItem> get copyWith => _$RecognizedItemCopyWithImpl<RecognizedItem>(this as RecognizedItem, _$identity);

  /// Serializes this RecognizedItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecognizedItem&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.category, category) || other.category == category)&&(identical(other.estimatedCount, estimatedCount) || other.estimatedCount == estimatedCount)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,category,estimatedCount,confidence);

@override
String toString() {
  return 'RecognizedItem(itemName: $itemName, category: $category, estimatedCount: $estimatedCount, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $RecognizedItemCopyWith<$Res>  {
  factory $RecognizedItemCopyWith(RecognizedItem value, $Res Function(RecognizedItem) _then) = _$RecognizedItemCopyWithImpl;
@useResult
$Res call({
 String itemName, String category, int estimatedCount, double confidence
});




}
/// @nodoc
class _$RecognizedItemCopyWithImpl<$Res>
    implements $RecognizedItemCopyWith<$Res> {
  _$RecognizedItemCopyWithImpl(this._self, this._then);

  final RecognizedItem _self;
  final $Res Function(RecognizedItem) _then;

/// Create a copy of RecognizedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemName = null,Object? category = null,Object? estimatedCount = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,estimatedCount: null == estimatedCount ? _self.estimatedCount : estimatedCount // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RecognizedItem].
extension RecognizedItemPatterns on RecognizedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecognizedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecognizedItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecognizedItem value)  $default,){
final _that = this;
switch (_that) {
case _RecognizedItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecognizedItem value)?  $default,){
final _that = this;
switch (_that) {
case _RecognizedItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemName,  String category,  int estimatedCount,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecognizedItem() when $default != null:
return $default(_that.itemName,_that.category,_that.estimatedCount,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemName,  String category,  int estimatedCount,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _RecognizedItem():
return $default(_that.itemName,_that.category,_that.estimatedCount,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemName,  String category,  int estimatedCount,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _RecognizedItem() when $default != null:
return $default(_that.itemName,_that.category,_that.estimatedCount,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecognizedItem implements RecognizedItem {
  const _RecognizedItem({required this.itemName, required this.category, required this.estimatedCount, required this.confidence});
  factory _RecognizedItem.fromJson(Map<String, dynamic> json) => _$RecognizedItemFromJson(json);

@override final  String itemName;
@override final  String category;
@override final  int estimatedCount;
/// 0..1.
@override final  double confidence;

/// Create a copy of RecognizedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecognizedItemCopyWith<_RecognizedItem> get copyWith => __$RecognizedItemCopyWithImpl<_RecognizedItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecognizedItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecognizedItem&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.category, category) || other.category == category)&&(identical(other.estimatedCount, estimatedCount) || other.estimatedCount == estimatedCount)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,category,estimatedCount,confidence);

@override
String toString() {
  return 'RecognizedItem(itemName: $itemName, category: $category, estimatedCount: $estimatedCount, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$RecognizedItemCopyWith<$Res> implements $RecognizedItemCopyWith<$Res> {
  factory _$RecognizedItemCopyWith(_RecognizedItem value, $Res Function(_RecognizedItem) _then) = __$RecognizedItemCopyWithImpl;
@override @useResult
$Res call({
 String itemName, String category, int estimatedCount, double confidence
});




}
/// @nodoc
class __$RecognizedItemCopyWithImpl<$Res>
    implements _$RecognizedItemCopyWith<$Res> {
  __$RecognizedItemCopyWithImpl(this._self, this._then);

  final _RecognizedItem _self;
  final $Res Function(_RecognizedItem) _then;

/// Create a copy of RecognizedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemName = null,Object? category = null,Object? estimatedCount = null,Object? confidence = null,}) {
  return _then(_RecognizedItem(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,estimatedCount: null == estimatedCount ? _self.estimatedCount : estimatedCount // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

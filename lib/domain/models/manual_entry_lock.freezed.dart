// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manual_entry_lock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ManualEntryLock {

 bool get locked; DateTime? get unlockAt;
/// Create a copy of ManualEntryLock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManualEntryLockCopyWith<ManualEntryLock> get copyWith => _$ManualEntryLockCopyWithImpl<ManualEntryLock>(this as ManualEntryLock, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ManualEntryLock;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManualEntryLock&&(identical(other.locked, _this.locked) || other.locked == _this.locked)&&(identical(other.unlockAt, _this.unlockAt) || other.unlockAt == _this.unlockAt));
}


@override
int get hashCode {
  final _this = this as ManualEntryLock;
  return Object.hash(runtimeType,_this.locked,_this.unlockAt);
}

@override
String toString() {
  final _this = this as ManualEntryLock;
  return 'ManualEntryLock(locked: ${_this.locked}, unlockAt: ${_this.unlockAt})';
}


}

/// @nodoc
abstract mixin class $ManualEntryLockCopyWith<$Res>  {
  factory $ManualEntryLockCopyWith(ManualEntryLock value, $Res Function(ManualEntryLock) _then) = _$ManualEntryLockCopyWithImpl;
@useResult
$Res call({
 bool locked, DateTime? unlockAt
});




}
/// @nodoc
class _$ManualEntryLockCopyWithImpl<$Res>
    implements $ManualEntryLockCopyWith<$Res> {
  _$ManualEntryLockCopyWithImpl(this._self, this._then);

  final ManualEntryLock _self;
  final $Res Function(ManualEntryLock) _then;

/// Create a copy of ManualEntryLock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locked = null,Object? unlockAt = freezed,}) {
  return _then(ManualEntryLock(
locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,unlockAt: freezed == unlockAt ? _self.unlockAt : unlockAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManualEntryLock].
extension ManualEntryLockPatterns on ManualEntryLock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManualEntryLock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManualEntryLock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManualEntryLock value)  $default,){
final _that = this;
switch (_that) {
case _ManualEntryLock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManualEntryLock value)?  $default,){
final _that = this;
switch (_that) {
case _ManualEntryLock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool locked,  DateTime? unlockAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManualEntryLock() when $default != null:
return $default(_that.locked,_that.unlockAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool locked,  DateTime? unlockAt)  $default,) {final _that = this;
switch (_that) {
case _ManualEntryLock():
return $default(_that.locked,_that.unlockAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool locked,  DateTime? unlockAt)?  $default,) {final _that = this;
switch (_that) {
case _ManualEntryLock() when $default != null:
return $default(_that.locked,_that.unlockAt);case _:
  return null;

}
}

}

/// @nodoc


class _ManualEntryLock extends ManualEntryLock {
  const _ManualEntryLock({this.locked = false, this.unlockAt}): super._();
  

@override@JsonKey() final  bool locked;
@override final  DateTime? unlockAt;

/// Create a copy of ManualEntryLock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManualEntryLockCopyWith<_ManualEntryLock> get copyWith => __$ManualEntryLockCopyWithImpl<_ManualEntryLock>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManualEntryLock&&(identical(other.locked, locked) || other.locked == locked)&&(identical(other.unlockAt, unlockAt) || other.unlockAt == unlockAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,locked,unlockAt);
}

@override
String toString() {
    return 'ManualEntryLock(locked: $locked, unlockAt: $unlockAt)';
}


}

/// @nodoc
abstract mixin class _$ManualEntryLockCopyWith<$Res> implements $ManualEntryLockCopyWith<$Res> {
  factory _$ManualEntryLockCopyWith(_ManualEntryLock value, $Res Function(_ManualEntryLock) _then) = __$ManualEntryLockCopyWithImpl;
@override @useResult
$Res call({
 bool locked, DateTime? unlockAt
});




}
/// @nodoc
class __$ManualEntryLockCopyWithImpl<$Res>
    implements _$ManualEntryLockCopyWith<$Res> {
  __$ManualEntryLockCopyWithImpl(this._self, this._then);

  final _ManualEntryLock _self;
  final $Res Function(_ManualEntryLock) _then;

/// Create a copy of ManualEntryLock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locked = null,Object? unlockAt = freezed,}) {
  return _then(_ManualEntryLock(
locked: null == locked ? _self.locked : locked // ignore: cast_nullable_to_non_nullable
as bool,unlockAt: freezed == unlockAt ? _self.unlockAt : unlockAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

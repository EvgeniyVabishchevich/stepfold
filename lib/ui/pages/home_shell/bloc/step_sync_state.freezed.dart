// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'step_sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StepSyncState {

 PermissionStatus? get permission; bool get checking; StepSourceFailure? get sourceFailure; StorageFailure? get storageFailure;
/// Create a copy of StepSyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepSyncStateCopyWith<StepSyncState> get copyWith => _$StepSyncStateCopyWithImpl<StepSyncState>(this as StepSyncState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StepSyncState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StepSyncState&&(identical(other.permission, _this.permission) || other.permission == _this.permission)&&(identical(other.checking, _this.checking) || other.checking == _this.checking)&&(identical(other.sourceFailure, _this.sourceFailure) || other.sourceFailure == _this.sourceFailure)&&(identical(other.storageFailure, _this.storageFailure) || other.storageFailure == _this.storageFailure));
}


@override
int get hashCode {
  final _this = this as StepSyncState;
  return Object.hash(runtimeType,_this.permission,_this.checking,_this.sourceFailure,_this.storageFailure);
}

@override
String toString() {
  final _this = this as StepSyncState;
  return 'StepSyncState(permission: ${_this.permission}, checking: ${_this.checking}, sourceFailure: ${_this.sourceFailure}, storageFailure: ${_this.storageFailure})';
}


}

/// @nodoc
abstract mixin class $StepSyncStateCopyWith<$Res>  {
  factory $StepSyncStateCopyWith(StepSyncState value, $Res Function(StepSyncState) _then) = _$StepSyncStateCopyWithImpl;
@useResult
$Res call({
 PermissionStatus? permission, bool checking, StepSourceFailure? sourceFailure, StorageFailure? storageFailure
});




}
/// @nodoc
class _$StepSyncStateCopyWithImpl<$Res>
    implements $StepSyncStateCopyWith<$Res> {
  _$StepSyncStateCopyWithImpl(this._self, this._then);

  final StepSyncState _self;
  final $Res Function(StepSyncState) _then;

/// Create a copy of StepSyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? permission = freezed,Object? checking = null,Object? sourceFailure = freezed,Object? storageFailure = freezed,}) {
  return _then(StepSyncState(
permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as PermissionStatus?,checking: null == checking ? _self.checking : checking // ignore: cast_nullable_to_non_nullable
as bool,sourceFailure: freezed == sourceFailure ? _self.sourceFailure : sourceFailure // ignore: cast_nullable_to_non_nullable
as StepSourceFailure?,storageFailure: freezed == storageFailure ? _self.storageFailure : storageFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [StepSyncState].
extension StepSyncStatePatterns on StepSyncState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StepSyncState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StepSyncState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StepSyncState value)  $default,){
final _that = this;
switch (_that) {
case _StepSyncState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StepSyncState value)?  $default,){
final _that = this;
switch (_that) {
case _StepSyncState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PermissionStatus? permission,  bool checking,  StepSourceFailure? sourceFailure,  StorageFailure? storageFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StepSyncState() when $default != null:
return $default(_that.permission,_that.checking,_that.sourceFailure,_that.storageFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PermissionStatus? permission,  bool checking,  StepSourceFailure? sourceFailure,  StorageFailure? storageFailure)  $default,) {final _that = this;
switch (_that) {
case _StepSyncState():
return $default(_that.permission,_that.checking,_that.sourceFailure,_that.storageFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PermissionStatus? permission,  bool checking,  StepSourceFailure? sourceFailure,  StorageFailure? storageFailure)?  $default,) {final _that = this;
switch (_that) {
case _StepSyncState() when $default != null:
return $default(_that.permission,_that.checking,_that.sourceFailure,_that.storageFailure);case _:
  return null;

}
}

}

/// @nodoc


class _StepSyncState implements StepSyncState {
  const _StepSyncState({this.permission, this.checking = true, this.sourceFailure, this.storageFailure});
  

@override final  PermissionStatus? permission;
@override@JsonKey() final  bool checking;
@override final  StepSourceFailure? sourceFailure;
@override final  StorageFailure? storageFailure;

/// Create a copy of StepSyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StepSyncStateCopyWith<_StepSyncState> get copyWith => __$StepSyncStateCopyWithImpl<_StepSyncState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StepSyncState&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.checking, checking) || other.checking == checking)&&(identical(other.sourceFailure, sourceFailure) || other.sourceFailure == sourceFailure)&&(identical(other.storageFailure, storageFailure) || other.storageFailure == storageFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,permission,checking,sourceFailure,storageFailure);
}

@override
String toString() {
    return 'StepSyncState(permission: $permission, checking: $checking, sourceFailure: $sourceFailure, storageFailure: $storageFailure)';
}


}

/// @nodoc
abstract mixin class _$StepSyncStateCopyWith<$Res> implements $StepSyncStateCopyWith<$Res> {
  factory _$StepSyncStateCopyWith(_StepSyncState value, $Res Function(_StepSyncState) _then) = __$StepSyncStateCopyWithImpl;
@override @useResult
$Res call({
 PermissionStatus? permission, bool checking, StepSourceFailure? sourceFailure, StorageFailure? storageFailure
});




}
/// @nodoc
class __$StepSyncStateCopyWithImpl<$Res>
    implements _$StepSyncStateCopyWith<$Res> {
  __$StepSyncStateCopyWithImpl(this._self, this._then);

  final _StepSyncState _self;
  final $Res Function(_StepSyncState) _then;

/// Create a copy of StepSyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? permission = freezed,Object? checking = null,Object? sourceFailure = freezed,Object? storageFailure = freezed,}) {
  return _then(_StepSyncState(
permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as PermissionStatus?,checking: null == checking ? _self.checking : checking // ignore: cast_nullable_to_non_nullable
as bool,sourceFailure: freezed == sourceFailure ? _self.sourceFailure : sourceFailure // ignore: cast_nullable_to_non_nullable
as StepSourceFailure?,storageFailure: freezed == storageFailure ? _self.storageFailure : storageFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,
  ));
}


}

// dart format on

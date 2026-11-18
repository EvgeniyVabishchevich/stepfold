// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dev_menu_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DevMenuState {

 DevMenuAction? get lastAction;
/// Create a copy of DevMenuState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DevMenuStateCopyWith<DevMenuState> get copyWith => _$DevMenuStateCopyWithImpl<DevMenuState>(this as DevMenuState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DevMenuState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DevMenuState&&(identical(other.lastAction, _this.lastAction) || other.lastAction == _this.lastAction));
}


@override
int get hashCode {
  final _this = this as DevMenuState;
  return Object.hash(runtimeType,_this.lastAction);
}

@override
String toString() {
  final _this = this as DevMenuState;
  return 'DevMenuState(lastAction: ${_this.lastAction})';
}


}

/// @nodoc
abstract mixin class $DevMenuStateCopyWith<$Res>  {
  factory $DevMenuStateCopyWith(DevMenuState value, $Res Function(DevMenuState) _then) = _$DevMenuStateCopyWithImpl;
@useResult
$Res call({
 DevMenuAction? lastAction
});




}
/// @nodoc
class _$DevMenuStateCopyWithImpl<$Res>
    implements $DevMenuStateCopyWith<$Res> {
  _$DevMenuStateCopyWithImpl(this._self, this._then);

  final DevMenuState _self;
  final $Res Function(DevMenuState) _then;

/// Create a copy of DevMenuState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastAction = freezed,}) {
  return _then(DevMenuState(
lastAction: freezed == lastAction ? _self.lastAction : lastAction // ignore: cast_nullable_to_non_nullable
as DevMenuAction?,
  ));
}

}


/// Adds pattern-matching-related methods to [DevMenuState].
extension DevMenuStatePatterns on DevMenuState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DevMenuState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DevMenuState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DevMenuState value)  $default,){
final _that = this;
switch (_that) {
case _DevMenuState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DevMenuState value)?  $default,){
final _that = this;
switch (_that) {
case _DevMenuState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DevMenuAction? lastAction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DevMenuState() when $default != null:
return $default(_that.lastAction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DevMenuAction? lastAction)  $default,) {final _that = this;
switch (_that) {
case _DevMenuState():
return $default(_that.lastAction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DevMenuAction? lastAction)?  $default,) {final _that = this;
switch (_that) {
case _DevMenuState() when $default != null:
return $default(_that.lastAction);case _:
  return null;

}
}

}

/// @nodoc


class _DevMenuState implements DevMenuState {
  const _DevMenuState({this.lastAction});
  

@override final  DevMenuAction? lastAction;

/// Create a copy of DevMenuState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DevMenuStateCopyWith<_DevMenuState> get copyWith => __$DevMenuStateCopyWithImpl<_DevMenuState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DevMenuState&&(identical(other.lastAction, lastAction) || other.lastAction == lastAction));
}


@override
int get hashCode {
    return Object.hash(runtimeType,lastAction);
}

@override
String toString() {
    return 'DevMenuState(lastAction: $lastAction)';
}


}

/// @nodoc
abstract mixin class _$DevMenuStateCopyWith<$Res> implements $DevMenuStateCopyWith<$Res> {
  factory _$DevMenuStateCopyWith(_DevMenuState value, $Res Function(_DevMenuState) _then) = __$DevMenuStateCopyWithImpl;
@override @useResult
$Res call({
 DevMenuAction? lastAction
});




}
/// @nodoc
class __$DevMenuStateCopyWithImpl<$Res>
    implements _$DevMenuStateCopyWith<$Res> {
  __$DevMenuStateCopyWithImpl(this._self, this._then);

  final _DevMenuState _self;
  final $Res Function(_DevMenuState) _then;

/// Create a copy of DevMenuState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastAction = freezed,}) {
  return _then(_DevMenuState(
lastAction: freezed == lastAction ? _self.lastAction : lastAction // ignore: cast_nullable_to_non_nullable
as DevMenuAction?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_steps.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DaySteps {

 Day get day; int? get auto; int? get manual;
/// Create a copy of DaySteps
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayStepsCopyWith<DaySteps> get copyWith => _$DayStepsCopyWithImpl<DaySteps>(this as DaySteps, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DaySteps;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DaySteps&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.auto, _this.auto) || other.auto == _this.auto)&&(identical(other.manual, _this.manual) || other.manual == _this.manual));
}


@override
int get hashCode {
  final _this = this as DaySteps;
  return Object.hash(runtimeType,_this.day,_this.auto,_this.manual);
}

@override
String toString() {
  final _this = this as DaySteps;
  return 'DaySteps(day: ${_this.day}, auto: ${_this.auto}, manual: ${_this.manual})';
}


}

/// @nodoc
abstract mixin class $DayStepsCopyWith<$Res>  {
  factory $DayStepsCopyWith(DaySteps value, $Res Function(DaySteps) _then) = _$DayStepsCopyWithImpl;
@useResult
$Res call({
 Day day, int? auto, int? manual
});




}
/// @nodoc
class _$DayStepsCopyWithImpl<$Res>
    implements $DayStepsCopyWith<$Res> {
  _$DayStepsCopyWithImpl(this._self, this._then);

  final DaySteps _self;
  final $Res Function(DaySteps) _then;

/// Create a copy of DaySteps
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? auto = freezed,Object? manual = freezed,}) {
  return _then(DaySteps(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as Day,auto: freezed == auto ? _self.auto : auto // ignore: cast_nullable_to_non_nullable
as int?,manual: freezed == manual ? _self.manual : manual // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DaySteps].
extension DayStepsPatterns on DaySteps {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DaySteps value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DaySteps() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DaySteps value)  $default,){
final _that = this;
switch (_that) {
case _DaySteps():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DaySteps value)?  $default,){
final _that = this;
switch (_that) {
case _DaySteps() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Day day,  int? auto,  int? manual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DaySteps() when $default != null:
return $default(_that.day,_that.auto,_that.manual);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Day day,  int? auto,  int? manual)  $default,) {final _that = this;
switch (_that) {
case _DaySteps():
return $default(_that.day,_that.auto,_that.manual);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Day day,  int? auto,  int? manual)?  $default,) {final _that = this;
switch (_that) {
case _DaySteps() when $default != null:
return $default(_that.day,_that.auto,_that.manual);case _:
  return null;

}
}

}

/// @nodoc


class _DaySteps extends DaySteps {
  const _DaySteps({required this.day, this.auto, this.manual}): super._();
  

@override final  Day day;
@override final  int? auto;
@override final  int? manual;

/// Create a copy of DaySteps
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayStepsCopyWith<_DaySteps> get copyWith => __$DayStepsCopyWithImpl<_DaySteps>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DaySteps&&(identical(other.day, day) || other.day == day)&&(identical(other.auto, auto) || other.auto == auto)&&(identical(other.manual, manual) || other.manual == manual));
}


@override
int get hashCode {
    return Object.hash(runtimeType,day,auto,manual);
}

@override
String toString() {
    return 'DaySteps(day: $day, auto: $auto, manual: $manual)';
}


}

/// @nodoc
abstract mixin class _$DayStepsCopyWith<$Res> implements $DayStepsCopyWith<$Res> {
  factory _$DayStepsCopyWith(_DaySteps value, $Res Function(_DaySteps) _then) = __$DayStepsCopyWithImpl;
@override @useResult
$Res call({
 Day day, int? auto, int? manual
});




}
/// @nodoc
class __$DayStepsCopyWithImpl<$Res>
    implements _$DayStepsCopyWith<$Res> {
  __$DayStepsCopyWithImpl(this._self, this._then);

  final _DaySteps _self;
  final $Res Function(_DaySteps) _then;

/// Create a copy of DaySteps
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? auto = freezed,Object? manual = freezed,}) {
  return _then(_DaySteps(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as Day,auto: freezed == auto ? _self.auto : auto // ignore: cast_nullable_to_non_nullable
as int?,manual: freezed == manual ? _self.manual : manual // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DayCount {

 Day get day; int get steps;
/// Create a copy of DayCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayCountCopyWith<DayCount> get copyWith => _$DayCountCopyWithImpl<DayCount>(this as DayCount, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DayCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayCount&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.steps, _this.steps) || other.steps == _this.steps));
}


@override
int get hashCode {
  final _this = this as DayCount;
  return Object.hash(runtimeType,_this.day,_this.steps);
}

@override
String toString() {
  final _this = this as DayCount;
  return 'DayCount(day: ${_this.day}, steps: ${_this.steps})';
}


}

/// @nodoc
abstract mixin class $DayCountCopyWith<$Res>  {
  factory $DayCountCopyWith(DayCount value, $Res Function(DayCount) _then) = _$DayCountCopyWithImpl;
@useResult
$Res call({
 Day day, int steps
});




}
/// @nodoc
class _$DayCountCopyWithImpl<$Res>
    implements $DayCountCopyWith<$Res> {
  _$DayCountCopyWithImpl(this._self, this._then);

  final DayCount _self;
  final $Res Function(DayCount) _then;

/// Create a copy of DayCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? steps = null,}) {
  return _then(DayCount(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as Day,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DayCount].
extension DayCountPatterns on DayCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayCount value)  $default,){
final _that = this;
switch (_that) {
case _DayCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayCount value)?  $default,){
final _that = this;
switch (_that) {
case _DayCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Day day,  int steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayCount() when $default != null:
return $default(_that.day,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Day day,  int steps)  $default,) {final _that = this;
switch (_that) {
case _DayCount():
return $default(_that.day,_that.steps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Day day,  int steps)?  $default,) {final _that = this;
switch (_that) {
case _DayCount() when $default != null:
return $default(_that.day,_that.steps);case _:
  return null;

}
}

}

/// @nodoc


class _DayCount implements DayCount {
  const _DayCount({required this.day, required this.steps});
  

@override final  Day day;
@override final  int steps;

/// Create a copy of DayCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayCountCopyWith<_DayCount> get copyWith => __$DayCountCopyWithImpl<_DayCount>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayCount&&(identical(other.day, day) || other.day == day)&&(identical(other.steps, steps) || other.steps == steps));
}


@override
int get hashCode {
    return Object.hash(runtimeType,day,steps);
}

@override
String toString() {
    return 'DayCount(day: $day, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$DayCountCopyWith<$Res> implements $DayCountCopyWith<$Res> {
  factory _$DayCountCopyWith(_DayCount value, $Res Function(_DayCount) _then) = __$DayCountCopyWithImpl;
@override @useResult
$Res call({
 Day day, int steps
});




}
/// @nodoc
class __$DayCountCopyWithImpl<$Res>
    implements _$DayCountCopyWith<$Res> {
  __$DayCountCopyWithImpl(this._self, this._then);

  final _DayCount _self;
  final $Res Function(_DayCount) _then;

/// Create a copy of DayCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? steps = null,}) {
  return _then(_DayCount(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as Day,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

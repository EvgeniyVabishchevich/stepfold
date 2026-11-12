// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Progress {

 Day get installDay; Map<Day, DaySteps> get days; List<Spending> get spendings; Goal? get goal;
/// Create a copy of Progress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressCopyWith<Progress> get copyWith => _$ProgressCopyWithImpl<Progress>(this as Progress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Progress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Progress&&(identical(other.installDay, _this.installDay) || other.installDay == _this.installDay)&&const DeepCollectionEquality().equals(other.days, _this.days)&&const DeepCollectionEquality().equals(other.spendings, _this.spendings)&&(identical(other.goal, _this.goal) || other.goal == _this.goal));
}


@override
int get hashCode {
  final _this = this as Progress;
  return Object.hash(runtimeType,_this.installDay,const DeepCollectionEquality().hash(_this.days),const DeepCollectionEquality().hash(_this.spendings),_this.goal);
}

@override
String toString() {
  final _this = this as Progress;
  return 'Progress(installDay: ${_this.installDay}, days: ${_this.days}, spendings: ${_this.spendings}, goal: ${_this.goal})';
}


}

/// @nodoc
abstract mixin class $ProgressCopyWith<$Res>  {
  factory $ProgressCopyWith(Progress value, $Res Function(Progress) _then) = _$ProgressCopyWithImpl;
@useResult
$Res call({
 Day installDay, Map<Day, DaySteps> days, List<Spending> spendings, Goal? goal
});


$GoalCopyWith<$Res>? get goal;

}
/// @nodoc
class _$ProgressCopyWithImpl<$Res>
    implements $ProgressCopyWith<$Res> {
  _$ProgressCopyWithImpl(this._self, this._then);

  final Progress _self;
  final $Res Function(Progress) _then;

/// Create a copy of Progress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? installDay = null,Object? days = null,Object? spendings = null,Object? goal = freezed,}) {
  return _then(Progress(
installDay: null == installDay ? _self.installDay : installDay // ignore: cast_nullable_to_non_nullable
as Day,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as Map<Day, DaySteps>,spendings: null == spendings ? _self.spendings : spendings // ignore: cast_nullable_to_non_nullable
as List<Spending>,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as Goal?,
  ));
}
/// Create a copy of Progress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalCopyWith<$Res>? get goal {
    if (_self.goal == null) {
    return null;
  }

  return $GoalCopyWith<$Res>(_self.goal!, (value) {
    return _then(_self.copyWith(goal: value));
  });
}
}


/// Adds pattern-matching-related methods to [Progress].
extension ProgressPatterns on Progress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Progress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Progress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Progress value)  $default,){
final _that = this;
switch (_that) {
case _Progress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Progress value)?  $default,){
final _that = this;
switch (_that) {
case _Progress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Day installDay,  Map<Day, DaySteps> days,  List<Spending> spendings,  Goal? goal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Progress() when $default != null:
return $default(_that.installDay,_that.days,_that.spendings,_that.goal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Day installDay,  Map<Day, DaySteps> days,  List<Spending> spendings,  Goal? goal)  $default,) {final _that = this;
switch (_that) {
case _Progress():
return $default(_that.installDay,_that.days,_that.spendings,_that.goal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Day installDay,  Map<Day, DaySteps> days,  List<Spending> spendings,  Goal? goal)?  $default,) {final _that = this;
switch (_that) {
case _Progress() when $default != null:
return $default(_that.installDay,_that.days,_that.spendings,_that.goal);case _:
  return null;

}
}

}

/// @nodoc


class _Progress extends Progress {
  const _Progress({required this.installDay,  Map<Day, DaySteps> days = const <Day, DaySteps>{},  List<Spending> spendings = const <Spending>[], this.goal}): _days = days,_spendings = spendings,super._();
  

@override final  Day installDay;
 final  Map<Day, DaySteps> _days;
@override@JsonKey() Map<Day, DaySteps> get days {
  if (_days is EqualUnmodifiableMapView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_days);
}

 final  List<Spending> _spendings;
@override@JsonKey() List<Spending> get spendings {
  if (_spendings is EqualUnmodifiableListView) return _spendings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_spendings);
}

@override final  Goal? goal;

/// Create a copy of Progress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressCopyWith<_Progress> get copyWith => __$ProgressCopyWithImpl<_Progress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Progress&&(identical(other.installDay, installDay) || other.installDay == installDay)&&const DeepCollectionEquality().equals(other.days, _days)&&const DeepCollectionEquality().equals(other.spendings, _spendings)&&(identical(other.goal, goal) || other.goal == goal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,installDay,const DeepCollectionEquality().hash(_days),const DeepCollectionEquality().hash(_spendings),goal);
}

@override
String toString() {
    return 'Progress(installDay: $installDay, days: $days, spendings: $spendings, goal: $goal)';
}


}

/// @nodoc
abstract mixin class _$ProgressCopyWith<$Res> implements $ProgressCopyWith<$Res> {
  factory _$ProgressCopyWith(_Progress value, $Res Function(_Progress) _then) = __$ProgressCopyWithImpl;
@override @useResult
$Res call({
 Day installDay, Map<Day, DaySteps> days, List<Spending> spendings, Goal? goal
});


@override $GoalCopyWith<$Res>? get goal;

}
/// @nodoc
class __$ProgressCopyWithImpl<$Res>
    implements _$ProgressCopyWith<$Res> {
  __$ProgressCopyWithImpl(this._self, this._then);

  final _Progress _self;
  final $Res Function(_Progress) _then;

/// Create a copy of Progress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? installDay = null,Object? days = null,Object? spendings = null,Object? goal = freezed,}) {
  return _then(_Progress(
installDay: null == installDay ? _self.installDay : installDay // ignore: cast_nullable_to_non_nullable
as Day,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as Map<Day, DaySteps>,spendings: null == spendings ? _self._spendings : spendings // ignore: cast_nullable_to_non_nullable
as List<Spending>,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as Goal?,
  ));
}

/// Create a copy of Progress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalCopyWith<$Res>? get goal {
    if (_self.goal == null) {
    return null;
  }

  return $GoalCopyWith<$Res>(_self.goal!, (value) {
    return _then(_self.copyWith(goal: value));
  });
}
}

// dart format on

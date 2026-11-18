// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TodayState {

 Day get day; Progress? get progress; StorageFailure? get progressFailure; TodayGoal? get target; bool get catalogLoading; CatalogFailure? get catalogFailure; Goal? get spendingGoal; ProgressFailure? get spendingFailure; StorageFailure? get spendingStorageFailure; ChapterGoal? get openedChapter;
/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayStateCopyWith<TodayState> get copyWith => _$TodayStateCopyWithImpl<TodayState>(this as TodayState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TodayState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayState&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.progressFailure, _this.progressFailure) || other.progressFailure == _this.progressFailure)&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.catalogLoading, _this.catalogLoading) || other.catalogLoading == _this.catalogLoading)&&(identical(other.catalogFailure, _this.catalogFailure) || other.catalogFailure == _this.catalogFailure)&&(identical(other.spendingGoal, _this.spendingGoal) || other.spendingGoal == _this.spendingGoal)&&(identical(other.spendingFailure, _this.spendingFailure) || other.spendingFailure == _this.spendingFailure)&&(identical(other.spendingStorageFailure, _this.spendingStorageFailure) || other.spendingStorageFailure == _this.spendingStorageFailure)&&const DeepCollectionEquality().equals(other.openedChapter, _this.openedChapter));
}


@override
int get hashCode {
  final _this = this as TodayState;
  return Object.hash(runtimeType,_this.day,_this.progress,_this.progressFailure,_this.target,_this.catalogLoading,_this.catalogFailure,_this.spendingGoal,_this.spendingFailure,_this.spendingStorageFailure,const DeepCollectionEquality().hash(_this.openedChapter));
}

@override
String toString() {
  final _this = this as TodayState;
  return 'TodayState(day: ${_this.day}, progress: ${_this.progress}, progressFailure: ${_this.progressFailure}, target: ${_this.target}, catalogLoading: ${_this.catalogLoading}, catalogFailure: ${_this.catalogFailure}, spendingGoal: ${_this.spendingGoal}, spendingFailure: ${_this.spendingFailure}, spendingStorageFailure: ${_this.spendingStorageFailure}, openedChapter: ${_this.openedChapter})';
}


}

/// @nodoc
abstract mixin class $TodayStateCopyWith<$Res>  {
  factory $TodayStateCopyWith(TodayState value, $Res Function(TodayState) _then) = _$TodayStateCopyWithImpl;
@useResult
$Res call({
 Day day, Progress? progress, StorageFailure? progressFailure, TodayGoal? target, bool catalogLoading, CatalogFailure? catalogFailure, Goal? spendingGoal, ProgressFailure? spendingFailure, StorageFailure? spendingStorageFailure, ChapterGoal? openedChapter
});


$ProgressCopyWith<$Res>? get progress;$GoalCopyWith<$Res>? get spendingGoal;

}
/// @nodoc
class _$TodayStateCopyWithImpl<$Res>
    implements $TodayStateCopyWith<$Res> {
  _$TodayStateCopyWithImpl(this._self, this._then);

  final TodayState _self;
  final $Res Function(TodayState) _then;

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? progress = freezed,Object? progressFailure = freezed,Object? target = freezed,Object? catalogLoading = null,Object? catalogFailure = freezed,Object? spendingGoal = freezed,Object? spendingFailure = freezed,Object? spendingStorageFailure = freezed,Object? openedChapter = freezed,}) {
  return _then(TodayState(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as Day,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,progressFailure: freezed == progressFailure ? _self.progressFailure : progressFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as TodayGoal?,catalogLoading: null == catalogLoading ? _self.catalogLoading : catalogLoading // ignore: cast_nullable_to_non_nullable
as bool,catalogFailure: freezed == catalogFailure ? _self.catalogFailure : catalogFailure // ignore: cast_nullable_to_non_nullable
as CatalogFailure?,spendingGoal: freezed == spendingGoal ? _self.spendingGoal : spendingGoal // ignore: cast_nullable_to_non_nullable
as Goal?,spendingFailure: freezed == spendingFailure ? _self.spendingFailure : spendingFailure // ignore: cast_nullable_to_non_nullable
as ProgressFailure?,spendingStorageFailure: freezed == spendingStorageFailure ? _self.spendingStorageFailure : spendingStorageFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,openedChapter: freezed == openedChapter ? _self.openedChapter : openedChapter // ignore: cast_nullable_to_non_nullable
as ChapterGoal?,
  ));
}
/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $ProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalCopyWith<$Res>? get spendingGoal {
    if (_self.spendingGoal == null) {
    return null;
  }

  return $GoalCopyWith<$Res>(_self.spendingGoal!, (value) {
    return _then(_self.copyWith(spendingGoal: value));
  });
}
}


/// Adds pattern-matching-related methods to [TodayState].
extension TodayStatePatterns on TodayState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayState value)  $default,){
final _that = this;
switch (_that) {
case _TodayState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayState value)?  $default,){
final _that = this;
switch (_that) {
case _TodayState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Day day,  Progress? progress,  StorageFailure? progressFailure,  TodayGoal? target,  bool catalogLoading,  CatalogFailure? catalogFailure,  Goal? spendingGoal,  ProgressFailure? spendingFailure,  StorageFailure? spendingStorageFailure,  ChapterGoal? openedChapter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayState() when $default != null:
return $default(_that.day,_that.progress,_that.progressFailure,_that.target,_that.catalogLoading,_that.catalogFailure,_that.spendingGoal,_that.spendingFailure,_that.spendingStorageFailure,_that.openedChapter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Day day,  Progress? progress,  StorageFailure? progressFailure,  TodayGoal? target,  bool catalogLoading,  CatalogFailure? catalogFailure,  Goal? spendingGoal,  ProgressFailure? spendingFailure,  StorageFailure? spendingStorageFailure,  ChapterGoal? openedChapter)  $default,) {final _that = this;
switch (_that) {
case _TodayState():
return $default(_that.day,_that.progress,_that.progressFailure,_that.target,_that.catalogLoading,_that.catalogFailure,_that.spendingGoal,_that.spendingFailure,_that.spendingStorageFailure,_that.openedChapter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Day day,  Progress? progress,  StorageFailure? progressFailure,  TodayGoal? target,  bool catalogLoading,  CatalogFailure? catalogFailure,  Goal? spendingGoal,  ProgressFailure? spendingFailure,  StorageFailure? spendingStorageFailure,  ChapterGoal? openedChapter)?  $default,) {final _that = this;
switch (_that) {
case _TodayState() when $default != null:
return $default(_that.day,_that.progress,_that.progressFailure,_that.target,_that.catalogLoading,_that.catalogFailure,_that.spendingGoal,_that.spendingFailure,_that.spendingStorageFailure,_that.openedChapter);case _:
  return null;

}
}

}

/// @nodoc


class _TodayState implements TodayState {
  const _TodayState({required this.day, this.progress, this.progressFailure, this.target, this.catalogLoading = true, this.catalogFailure, this.spendingGoal, this.spendingFailure, this.spendingStorageFailure, this.openedChapter});
  

@override final  Day day;
@override final  Progress? progress;
@override final  StorageFailure? progressFailure;
@override final  TodayGoal? target;
@override@JsonKey() final  bool catalogLoading;
@override final  CatalogFailure? catalogFailure;
@override final  Goal? spendingGoal;
@override final  ProgressFailure? spendingFailure;
@override final  StorageFailure? spendingStorageFailure;
@override final  ChapterGoal? openedChapter;

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayStateCopyWith<_TodayState> get copyWith => __$TodayStateCopyWithImpl<_TodayState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayState&&(identical(other.day, day) || other.day == day)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.progressFailure, progressFailure) || other.progressFailure == progressFailure)&&(identical(other.target, target) || other.target == target)&&(identical(other.catalogLoading, catalogLoading) || other.catalogLoading == catalogLoading)&&(identical(other.catalogFailure, catalogFailure) || other.catalogFailure == catalogFailure)&&(identical(other.spendingGoal, spendingGoal) || other.spendingGoal == spendingGoal)&&(identical(other.spendingFailure, spendingFailure) || other.spendingFailure == spendingFailure)&&(identical(other.spendingStorageFailure, spendingStorageFailure) || other.spendingStorageFailure == spendingStorageFailure)&&const DeepCollectionEquality().equals(other.openedChapter, openedChapter));
}


@override
int get hashCode {
    return Object.hash(runtimeType,day,progress,progressFailure,target,catalogLoading,catalogFailure,spendingGoal,spendingFailure,spendingStorageFailure,const DeepCollectionEquality().hash(openedChapter));
}

@override
String toString() {
    return 'TodayState(day: $day, progress: $progress, progressFailure: $progressFailure, target: $target, catalogLoading: $catalogLoading, catalogFailure: $catalogFailure, spendingGoal: $spendingGoal, spendingFailure: $spendingFailure, spendingStorageFailure: $spendingStorageFailure, openedChapter: $openedChapter)';
}


}

/// @nodoc
abstract mixin class _$TodayStateCopyWith<$Res> implements $TodayStateCopyWith<$Res> {
  factory _$TodayStateCopyWith(_TodayState value, $Res Function(_TodayState) _then) = __$TodayStateCopyWithImpl;
@override @useResult
$Res call({
 Day day, Progress? progress, StorageFailure? progressFailure, TodayGoal? target, bool catalogLoading, CatalogFailure? catalogFailure, Goal? spendingGoal, ProgressFailure? spendingFailure, StorageFailure? spendingStorageFailure, ChapterGoal? openedChapter
});


@override $ProgressCopyWith<$Res>? get progress;@override $GoalCopyWith<$Res>? get spendingGoal;

}
/// @nodoc
class __$TodayStateCopyWithImpl<$Res>
    implements _$TodayStateCopyWith<$Res> {
  __$TodayStateCopyWithImpl(this._self, this._then);

  final _TodayState _self;
  final $Res Function(_TodayState) _then;

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? progress = freezed,Object? progressFailure = freezed,Object? target = freezed,Object? catalogLoading = null,Object? catalogFailure = freezed,Object? spendingGoal = freezed,Object? spendingFailure = freezed,Object? spendingStorageFailure = freezed,Object? openedChapter = freezed,}) {
  return _then(_TodayState(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as Day,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,progressFailure: freezed == progressFailure ? _self.progressFailure : progressFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,target: freezed == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as TodayGoal?,catalogLoading: null == catalogLoading ? _self.catalogLoading : catalogLoading // ignore: cast_nullable_to_non_nullable
as bool,catalogFailure: freezed == catalogFailure ? _self.catalogFailure : catalogFailure // ignore: cast_nullable_to_non_nullable
as CatalogFailure?,spendingGoal: freezed == spendingGoal ? _self.spendingGoal : spendingGoal // ignore: cast_nullable_to_non_nullable
as Goal?,spendingFailure: freezed == spendingFailure ? _self.spendingFailure : spendingFailure // ignore: cast_nullable_to_non_nullable
as ProgressFailure?,spendingStorageFailure: freezed == spendingStorageFailure ? _self.spendingStorageFailure : spendingStorageFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,openedChapter: freezed == openedChapter ? _self.openedChapter : openedChapter // ignore: cast_nullable_to_non_nullable
as ChapterGoal?,
  ));
}

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $ProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalCopyWith<$Res>? get spendingGoal {
    if (_self.spendingGoal == null) {
    return null;
  }

  return $GoalCopyWith<$Res>(_self.spendingGoal!, (value) {
    return _then(_self.copyWith(spendingGoal: value));
  });
}
}

// dart format on

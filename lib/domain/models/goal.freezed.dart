// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Goal {

 String get progressionId;
/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalCopyWith<Goal> get copyWith => _$GoalCopyWithImpl<Goal>(this as Goal, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Goal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Goal&&(identical(other.progressionId, _this.progressionId) || other.progressionId == _this.progressionId));
}


@override
int get hashCode {
  final _this = this as Goal;
  return Object.hash(runtimeType,_this.progressionId);
}

@override
String toString() {
  final _this = this as Goal;
  return 'Goal(progressionId: ${_this.progressionId})';
}


}

/// @nodoc
abstract mixin class $GoalCopyWith<$Res>  {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) _then) = _$GoalCopyWithImpl;
@useResult
$Res call({
 String progressionId
});




}
/// @nodoc
class _$GoalCopyWithImpl<$Res>
    implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._self, this._then);

  final Goal _self;
  final $Res Function(Goal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? progressionId = null,}) {
  return _then(_self.copyWith(
progressionId: null == progressionId ? _self.progressionId : progressionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Goal].
extension GoalPatterns on Goal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChapterGoal value)?  chapter,TResult Function( MedalGoal value)?  medal,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChapterGoal() when chapter != null:
return chapter(_that);case MedalGoal() when medal != null:
return medal(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChapterGoal value)  chapter,required TResult Function( MedalGoal value)  medal,}){
final _that = this;
switch (_that) {
case ChapterGoal():
return chapter(_that);case MedalGoal():
return medal(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChapterGoal value)?  chapter,TResult? Function( MedalGoal value)?  medal,}){
final _that = this;
switch (_that) {
case ChapterGoal() when chapter != null:
return chapter(_that);case MedalGoal() when medal != null:
return medal(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String progressionId,  String chapterId)?  chapter,TResult Function( String progressionId,  Medal medal)?  medal,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChapterGoal() when chapter != null:
return chapter(_that.progressionId,_that.chapterId);case MedalGoal() when medal != null:
return medal(_that.progressionId,_that.medal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String progressionId,  String chapterId)  chapter,required TResult Function( String progressionId,  Medal medal)  medal,}) {final _that = this;
switch (_that) {
case ChapterGoal():
return chapter(_that.progressionId,_that.chapterId);case MedalGoal():
return medal(_that.progressionId,_that.medal);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String progressionId,  String chapterId)?  chapter,TResult? Function( String progressionId,  Medal medal)?  medal,}) {final _that = this;
switch (_that) {
case ChapterGoal() when chapter != null:
return chapter(_that.progressionId,_that.chapterId);case MedalGoal() when medal != null:
return medal(_that.progressionId,_that.medal);case _:
  return null;

}
}

}

/// @nodoc


class ChapterGoal implements Goal {
  const ChapterGoal({required this.progressionId, required this.chapterId});
  

@override final  String progressionId;
 final  String chapterId;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterGoalCopyWith<ChapterGoal> get copyWith => _$ChapterGoalCopyWithImpl<ChapterGoal>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterGoal&&(identical(other.progressionId, progressionId) || other.progressionId == progressionId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,progressionId,chapterId);
}

@override
String toString() {
    return 'Goal.chapter(progressionId: $progressionId, chapterId: $chapterId)';
}


}

/// @nodoc
abstract mixin class $ChapterGoalCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory $ChapterGoalCopyWith(ChapterGoal value, $Res Function(ChapterGoal) _then) = _$ChapterGoalCopyWithImpl;
@override @useResult
$Res call({
 String progressionId, String chapterId
});




}
/// @nodoc
class _$ChapterGoalCopyWithImpl<$Res>
    implements $ChapterGoalCopyWith<$Res> {
  _$ChapterGoalCopyWithImpl(this._self, this._then);

  final ChapterGoal _self;
  final $Res Function(ChapterGoal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? progressionId = null,Object? chapterId = null,}) {
  return _then(ChapterGoal(
progressionId: null == progressionId ? _self.progressionId : progressionId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MedalGoal implements Goal {
  const MedalGoal({required this.progressionId, required this.medal});
  

@override final  String progressionId;
 final  Medal medal;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedalGoalCopyWith<MedalGoal> get copyWith => _$MedalGoalCopyWithImpl<MedalGoal>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MedalGoal&&(identical(other.progressionId, progressionId) || other.progressionId == progressionId)&&(identical(other.medal, medal) || other.medal == medal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,progressionId,medal);
}

@override
String toString() {
    return 'Goal.medal(progressionId: $progressionId, medal: $medal)';
}


}

/// @nodoc
abstract mixin class $MedalGoalCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory $MedalGoalCopyWith(MedalGoal value, $Res Function(MedalGoal) _then) = _$MedalGoalCopyWithImpl;
@override @useResult
$Res call({
 String progressionId, Medal medal
});




}
/// @nodoc
class _$MedalGoalCopyWithImpl<$Res>
    implements $MedalGoalCopyWith<$Res> {
  _$MedalGoalCopyWithImpl(this._self, this._then);

  final MedalGoal _self;
  final $Res Function(MedalGoal) _then;

/// Create a copy of Goal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? progressionId = null,Object? medal = null,}) {
  return _then(MedalGoal(
progressionId: null == progressionId ? _self.progressionId : progressionId // ignore: cast_nullable_to_non_nullable
as String,medal: null == medal ? _self.medal : medal // ignore: cast_nullable_to_non_nullable
as Medal,
  ));
}


}

// dart format on

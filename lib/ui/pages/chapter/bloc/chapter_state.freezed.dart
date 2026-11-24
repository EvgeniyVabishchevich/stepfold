// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChapterState {

 bool get loading; bool get unavailable; bool get retryable; bool get storageFull; String? get progressionTitle; String? get chapterTitle; ChapterContent? get content; ChapterJourney? get journey; bool get journeyTilesUnavailable;
/// Create a copy of ChapterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterStateCopyWith<ChapterState> get copyWith => _$ChapterStateCopyWithImpl<ChapterState>(this as ChapterState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChapterState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.unavailable, _this.unavailable) || other.unavailable == _this.unavailable)&&(identical(other.retryable, _this.retryable) || other.retryable == _this.retryable)&&(identical(other.storageFull, _this.storageFull) || other.storageFull == _this.storageFull)&&(identical(other.progressionTitle, _this.progressionTitle) || other.progressionTitle == _this.progressionTitle)&&(identical(other.chapterTitle, _this.chapterTitle) || other.chapterTitle == _this.chapterTitle)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.journey, _this.journey) || other.journey == _this.journey)&&(identical(other.journeyTilesUnavailable, _this.journeyTilesUnavailable) || other.journeyTilesUnavailable == _this.journeyTilesUnavailable));
}


@override
int get hashCode {
  final _this = this as ChapterState;
  return Object.hash(runtimeType,_this.loading,_this.unavailable,_this.retryable,_this.storageFull,_this.progressionTitle,_this.chapterTitle,_this.content,_this.journey,_this.journeyTilesUnavailable);
}

@override
String toString() {
  final _this = this as ChapterState;
  return 'ChapterState(loading: ${_this.loading}, unavailable: ${_this.unavailable}, retryable: ${_this.retryable}, storageFull: ${_this.storageFull}, progressionTitle: ${_this.progressionTitle}, chapterTitle: ${_this.chapterTitle}, content: ${_this.content}, journey: ${_this.journey}, journeyTilesUnavailable: ${_this.journeyTilesUnavailable})';
}


}

/// @nodoc
abstract mixin class $ChapterStateCopyWith<$Res>  {
  factory $ChapterStateCopyWith(ChapterState value, $Res Function(ChapterState) _then) = _$ChapterStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool unavailable, bool retryable, bool storageFull, String? progressionTitle, String? chapterTitle, ChapterContent? content, ChapterJourney? journey, bool journeyTilesUnavailable
});


$ChapterContentCopyWith<$Res>? get content;

}
/// @nodoc
class _$ChapterStateCopyWithImpl<$Res>
    implements $ChapterStateCopyWith<$Res> {
  _$ChapterStateCopyWithImpl(this._self, this._then);

  final ChapterState _self;
  final $Res Function(ChapterState) _then;

/// Create a copy of ChapterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? unavailable = null,Object? retryable = null,Object? storageFull = null,Object? progressionTitle = freezed,Object? chapterTitle = freezed,Object? content = freezed,Object? journey = freezed,Object? journeyTilesUnavailable = null,}) {
  return _then(ChapterState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,unavailable: null == unavailable ? _self.unavailable : unavailable // ignore: cast_nullable_to_non_nullable
as bool,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,storageFull: null == storageFull ? _self.storageFull : storageFull // ignore: cast_nullable_to_non_nullable
as bool,progressionTitle: freezed == progressionTitle ? _self.progressionTitle : progressionTitle // ignore: cast_nullable_to_non_nullable
as String?,chapterTitle: freezed == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ChapterContent?,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as ChapterJourney?,journeyTilesUnavailable: null == journeyTilesUnavailable ? _self.journeyTilesUnavailable : journeyTilesUnavailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ChapterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChapterContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $ChapterContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChapterState].
extension ChapterStatePatterns on ChapterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterState value)  $default,){
final _that = this;
switch (_that) {
case _ChapterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterState value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool unavailable,  bool retryable,  bool storageFull,  String? progressionTitle,  String? chapterTitle,  ChapterContent? content,  ChapterJourney? journey,  bool journeyTilesUnavailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterState() when $default != null:
return $default(_that.loading,_that.unavailable,_that.retryable,_that.storageFull,_that.progressionTitle,_that.chapterTitle,_that.content,_that.journey,_that.journeyTilesUnavailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool unavailable,  bool retryable,  bool storageFull,  String? progressionTitle,  String? chapterTitle,  ChapterContent? content,  ChapterJourney? journey,  bool journeyTilesUnavailable)  $default,) {final _that = this;
switch (_that) {
case _ChapterState():
return $default(_that.loading,_that.unavailable,_that.retryable,_that.storageFull,_that.progressionTitle,_that.chapterTitle,_that.content,_that.journey,_that.journeyTilesUnavailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool unavailable,  bool retryable,  bool storageFull,  String? progressionTitle,  String? chapterTitle,  ChapterContent? content,  ChapterJourney? journey,  bool journeyTilesUnavailable)?  $default,) {final _that = this;
switch (_that) {
case _ChapterState() when $default != null:
return $default(_that.loading,_that.unavailable,_that.retryable,_that.storageFull,_that.progressionTitle,_that.chapterTitle,_that.content,_that.journey,_that.journeyTilesUnavailable);case _:
  return null;

}
}

}

/// @nodoc


class _ChapterState implements ChapterState {
  const _ChapterState({this.loading = true, this.unavailable = false, this.retryable = false, this.storageFull = false, this.progressionTitle, this.chapterTitle, this.content, this.journey, this.journeyTilesUnavailable = false});
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool unavailable;
@override@JsonKey() final  bool retryable;
@override@JsonKey() final  bool storageFull;
@override final  String? progressionTitle;
@override final  String? chapterTitle;
@override final  ChapterContent? content;
@override final  ChapterJourney? journey;
@override@JsonKey() final  bool journeyTilesUnavailable;

/// Create a copy of ChapterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterStateCopyWith<_ChapterState> get copyWith => __$ChapterStateCopyWithImpl<_ChapterState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.unavailable, unavailable) || other.unavailable == unavailable)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.storageFull, storageFull) || other.storageFull == storageFull)&&(identical(other.progressionTitle, progressionTitle) || other.progressionTitle == progressionTitle)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.content, content) || other.content == content)&&(identical(other.journey, journey) || other.journey == journey)&&(identical(other.journeyTilesUnavailable, journeyTilesUnavailable) || other.journeyTilesUnavailable == journeyTilesUnavailable));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,unavailable,retryable,storageFull,progressionTitle,chapterTitle,content,journey,journeyTilesUnavailable);
}

@override
String toString() {
    return 'ChapterState(loading: $loading, unavailable: $unavailable, retryable: $retryable, storageFull: $storageFull, progressionTitle: $progressionTitle, chapterTitle: $chapterTitle, content: $content, journey: $journey, journeyTilesUnavailable: $journeyTilesUnavailable)';
}


}

/// @nodoc
abstract mixin class _$ChapterStateCopyWith<$Res> implements $ChapterStateCopyWith<$Res> {
  factory _$ChapterStateCopyWith(_ChapterState value, $Res Function(_ChapterState) _then) = __$ChapterStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool unavailable, bool retryable, bool storageFull, String? progressionTitle, String? chapterTitle, ChapterContent? content, ChapterJourney? journey, bool journeyTilesUnavailable
});


@override $ChapterContentCopyWith<$Res>? get content;

}
/// @nodoc
class __$ChapterStateCopyWithImpl<$Res>
    implements _$ChapterStateCopyWith<$Res> {
  __$ChapterStateCopyWithImpl(this._self, this._then);

  final _ChapterState _self;
  final $Res Function(_ChapterState) _then;

/// Create a copy of ChapterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? unavailable = null,Object? retryable = null,Object? storageFull = null,Object? progressionTitle = freezed,Object? chapterTitle = freezed,Object? content = freezed,Object? journey = freezed,Object? journeyTilesUnavailable = null,}) {
  return _then(_ChapterState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,unavailable: null == unavailable ? _self.unavailable : unavailable // ignore: cast_nullable_to_non_nullable
as bool,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,storageFull: null == storageFull ? _self.storageFull : storageFull // ignore: cast_nullable_to_non_nullable
as bool,progressionTitle: freezed == progressionTitle ? _self.progressionTitle : progressionTitle // ignore: cast_nullable_to_non_nullable
as String?,chapterTitle: freezed == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ChapterContent?,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as ChapterJourney?,journeyTilesUnavailable: null == journeyTilesUnavailable ? _self.journeyTilesUnavailable : journeyTilesUnavailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ChapterState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChapterContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $ChapterContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on

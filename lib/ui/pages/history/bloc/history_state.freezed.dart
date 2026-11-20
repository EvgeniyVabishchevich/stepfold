// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryState {

 DateTime get now; Progress? get progress; CatalogIndex? get catalog; StorageFailure? get readFailure; Exception? get writeFailure; HistoryEdit? get confirmation; bool get busy;
/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryStateCopyWith<HistoryState> get copyWith => _$HistoryStateCopyWithImpl<HistoryState>(this as HistoryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HistoryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryState&&(identical(other.now, _this.now) || other.now == _this.now)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.catalog, _this.catalog) || other.catalog == _this.catalog)&&(identical(other.readFailure, _this.readFailure) || other.readFailure == _this.readFailure)&&(identical(other.writeFailure, _this.writeFailure) || other.writeFailure == _this.writeFailure)&&(identical(other.confirmation, _this.confirmation) || other.confirmation == _this.confirmation)&&(identical(other.busy, _this.busy) || other.busy == _this.busy));
}


@override
int get hashCode {
  final _this = this as HistoryState;
  return Object.hash(runtimeType,_this.now,_this.progress,_this.catalog,_this.readFailure,_this.writeFailure,_this.confirmation,_this.busy);
}

@override
String toString() {
  final _this = this as HistoryState;
  return 'HistoryState(now: ${_this.now}, progress: ${_this.progress}, catalog: ${_this.catalog}, readFailure: ${_this.readFailure}, writeFailure: ${_this.writeFailure}, confirmation: ${_this.confirmation}, busy: ${_this.busy})';
}


}

/// @nodoc
abstract mixin class $HistoryStateCopyWith<$Res>  {
  factory $HistoryStateCopyWith(HistoryState value, $Res Function(HistoryState) _then) = _$HistoryStateCopyWithImpl;
@useResult
$Res call({
 DateTime now, Progress? progress, CatalogIndex? catalog, StorageFailure? readFailure, Exception? writeFailure, HistoryEdit? confirmation, bool busy
});


$ProgressCopyWith<$Res>? get progress;$CatalogIndexCopyWith<$Res>? get catalog;

}
/// @nodoc
class _$HistoryStateCopyWithImpl<$Res>
    implements $HistoryStateCopyWith<$Res> {
  _$HistoryStateCopyWithImpl(this._self, this._then);

  final HistoryState _self;
  final $Res Function(HistoryState) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? now = null,Object? progress = freezed,Object? catalog = freezed,Object? readFailure = freezed,Object? writeFailure = freezed,Object? confirmation = freezed,Object? busy = null,}) {
  return _then(HistoryState(
now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as CatalogIndex?,readFailure: freezed == readFailure ? _self.readFailure : readFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,writeFailure: freezed == writeFailure ? _self.writeFailure : writeFailure // ignore: cast_nullable_to_non_nullable
as Exception?,confirmation: freezed == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as HistoryEdit?,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HistoryState
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
}/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CatalogIndexCopyWith<$Res>? get catalog {
    if (_self.catalog == null) {
    return null;
  }

  return $CatalogIndexCopyWith<$Res>(_self.catalog!, (value) {
    return _then(_self.copyWith(catalog: value));
  });
}
}


/// Adds pattern-matching-related methods to [HistoryState].
extension HistoryStatePatterns on HistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryState value)  $default,){
final _that = this;
switch (_that) {
case _HistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime now,  Progress? progress,  CatalogIndex? catalog,  StorageFailure? readFailure,  Exception? writeFailure,  HistoryEdit? confirmation,  bool busy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryState() when $default != null:
return $default(_that.now,_that.progress,_that.catalog,_that.readFailure,_that.writeFailure,_that.confirmation,_that.busy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime now,  Progress? progress,  CatalogIndex? catalog,  StorageFailure? readFailure,  Exception? writeFailure,  HistoryEdit? confirmation,  bool busy)  $default,) {final _that = this;
switch (_that) {
case _HistoryState():
return $default(_that.now,_that.progress,_that.catalog,_that.readFailure,_that.writeFailure,_that.confirmation,_that.busy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime now,  Progress? progress,  CatalogIndex? catalog,  StorageFailure? readFailure,  Exception? writeFailure,  HistoryEdit? confirmation,  bool busy)?  $default,) {final _that = this;
switch (_that) {
case _HistoryState() when $default != null:
return $default(_that.now,_that.progress,_that.catalog,_that.readFailure,_that.writeFailure,_that.confirmation,_that.busy);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryState extends HistoryState {
  const _HistoryState({required this.now, this.progress, this.catalog, this.readFailure, this.writeFailure, this.confirmation, this.busy = false}): super._();


@override final  DateTime now;
@override final  Progress? progress;
@override final  CatalogIndex? catalog;
@override final  StorageFailure? readFailure;
@override final  Exception? writeFailure;
@override final  HistoryEdit? confirmation;
@override@JsonKey() final  bool busy;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryStateCopyWith<_HistoryState> get copyWith => __$HistoryStateCopyWithImpl<_HistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryState&&(identical(other.now, now) || other.now == now)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.catalog, catalog) || other.catalog == catalog)&&(identical(other.readFailure, readFailure) || other.readFailure == readFailure)&&(identical(other.writeFailure, writeFailure) || other.writeFailure == writeFailure)&&(identical(other.confirmation, confirmation) || other.confirmation == confirmation)&&(identical(other.busy, busy) || other.busy == busy));
}


@override
int get hashCode {
    return Object.hash(runtimeType,now,progress,catalog,readFailure,writeFailure,confirmation,busy);
}

@override
String toString() {
    return 'HistoryState(now: $now, progress: $progress, catalog: $catalog, readFailure: $readFailure, writeFailure: $writeFailure, confirmation: $confirmation, busy: $busy)';
}


}

/// @nodoc
abstract mixin class _$HistoryStateCopyWith<$Res> implements $HistoryStateCopyWith<$Res> {
  factory _$HistoryStateCopyWith(_HistoryState value, $Res Function(_HistoryState) _then) = __$HistoryStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime now, Progress? progress, CatalogIndex? catalog, StorageFailure? readFailure, Exception? writeFailure, HistoryEdit? confirmation, bool busy
});


@override $ProgressCopyWith<$Res>? get progress;@override $CatalogIndexCopyWith<$Res>? get catalog;

}
/// @nodoc
class __$HistoryStateCopyWithImpl<$Res>
    implements _$HistoryStateCopyWith<$Res> {
  __$HistoryStateCopyWithImpl(this._self, this._then);

  final _HistoryState _self;
  final $Res Function(_HistoryState) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? now = null,Object? progress = freezed,Object? catalog = freezed,Object? readFailure = freezed,Object? writeFailure = freezed,Object? confirmation = freezed,Object? busy = null,}) {
  return _then(_HistoryState(
now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as CatalogIndex?,readFailure: freezed == readFailure ? _self.readFailure : readFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,writeFailure: freezed == writeFailure ? _self.writeFailure : writeFailure // ignore: cast_nullable_to_non_nullable
as Exception?,confirmation: freezed == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as HistoryEdit?,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HistoryState
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
}/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CatalogIndexCopyWith<$Res>? get catalog {
    if (_self.catalog == null) {
    return null;
  }

  return $CatalogIndexCopyWith<$Res>(_self.catalog!, (value) {
    return _then(_self.copyWith(catalog: value));
  });
}
}

// dart format on

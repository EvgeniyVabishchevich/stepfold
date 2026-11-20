// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatalogState {

 CatalogIndex? get index; Progress? get progress; String? get lengthId; CatalogFailure? get catalogFailure; StorageFailure? get readFailure; StorageFailure? get saveFailure; bool get chapterUnavailable; bool get saving;
/// Create a copy of CatalogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogStateCopyWith<CatalogState> get copyWith => _$CatalogStateCopyWithImpl<CatalogState>(this as CatalogState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CatalogState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogState&&(identical(other.index, _this.index) || other.index == _this.index)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.lengthId, _this.lengthId) || other.lengthId == _this.lengthId)&&(identical(other.catalogFailure, _this.catalogFailure) || other.catalogFailure == _this.catalogFailure)&&(identical(other.readFailure, _this.readFailure) || other.readFailure == _this.readFailure)&&(identical(other.saveFailure, _this.saveFailure) || other.saveFailure == _this.saveFailure)&&(identical(other.chapterUnavailable, _this.chapterUnavailable) || other.chapterUnavailable == _this.chapterUnavailable)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as CatalogState;
  return Object.hash(runtimeType,_this.index,_this.progress,_this.lengthId,_this.catalogFailure,_this.readFailure,_this.saveFailure,_this.chapterUnavailable,_this.saving);
}

@override
String toString() {
  final _this = this as CatalogState;
  return 'CatalogState(index: ${_this.index}, progress: ${_this.progress}, lengthId: ${_this.lengthId}, catalogFailure: ${_this.catalogFailure}, readFailure: ${_this.readFailure}, saveFailure: ${_this.saveFailure}, chapterUnavailable: ${_this.chapterUnavailable}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $CatalogStateCopyWith<$Res>  {
  factory $CatalogStateCopyWith(CatalogState value, $Res Function(CatalogState) _then) = _$CatalogStateCopyWithImpl;
@useResult
$Res call({
 CatalogIndex? index, Progress? progress, String? lengthId, CatalogFailure? catalogFailure, StorageFailure? readFailure, StorageFailure? saveFailure, bool chapterUnavailable, bool saving
});


$CatalogIndexCopyWith<$Res>? get index;$ProgressCopyWith<$Res>? get progress;

}
/// @nodoc
class _$CatalogStateCopyWithImpl<$Res>
    implements $CatalogStateCopyWith<$Res> {
  _$CatalogStateCopyWithImpl(this._self, this._then);

  final CatalogState _self;
  final $Res Function(CatalogState) _then;

/// Create a copy of CatalogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = freezed,Object? progress = freezed,Object? lengthId = freezed,Object? catalogFailure = freezed,Object? readFailure = freezed,Object? saveFailure = freezed,Object? chapterUnavailable = null,Object? saving = null,}) {
  return _then(CatalogState(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as CatalogIndex?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,lengthId: freezed == lengthId ? _self.lengthId : lengthId // ignore: cast_nullable_to_non_nullable
as String?,catalogFailure: freezed == catalogFailure ? _self.catalogFailure : catalogFailure // ignore: cast_nullable_to_non_nullable
as CatalogFailure?,readFailure: freezed == readFailure ? _self.readFailure : readFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,chapterUnavailable: null == chapterUnavailable ? _self.chapterUnavailable : chapterUnavailable // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CatalogState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CatalogIndexCopyWith<$Res>? get index {
    if (_self.index == null) {
    return null;
  }

  return $CatalogIndexCopyWith<$Res>(_self.index!, (value) {
    return _then(_self.copyWith(index: value));
  });
}/// Create a copy of CatalogState
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
}
}


/// Adds pattern-matching-related methods to [CatalogState].
extension CatalogStatePatterns on CatalogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogState value)  $default,){
final _that = this;
switch (_that) {
case _CatalogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogState value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CatalogIndex? index,  Progress? progress,  String? lengthId,  CatalogFailure? catalogFailure,  StorageFailure? readFailure,  StorageFailure? saveFailure,  bool chapterUnavailable,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogState() when $default != null:
return $default(_that.index,_that.progress,_that.lengthId,_that.catalogFailure,_that.readFailure,_that.saveFailure,_that.chapterUnavailable,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CatalogIndex? index,  Progress? progress,  String? lengthId,  CatalogFailure? catalogFailure,  StorageFailure? readFailure,  StorageFailure? saveFailure,  bool chapterUnavailable,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _CatalogState():
return $default(_that.index,_that.progress,_that.lengthId,_that.catalogFailure,_that.readFailure,_that.saveFailure,_that.chapterUnavailable,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CatalogIndex? index,  Progress? progress,  String? lengthId,  CatalogFailure? catalogFailure,  StorageFailure? readFailure,  StorageFailure? saveFailure,  bool chapterUnavailable,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _CatalogState() when $default != null:
return $default(_that.index,_that.progress,_that.lengthId,_that.catalogFailure,_that.readFailure,_that.saveFailure,_that.chapterUnavailable,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogState extends CatalogState {
  const _CatalogState({this.index, this.progress, this.lengthId, this.catalogFailure, this.readFailure, this.saveFailure, this.chapterUnavailable = false, this.saving = false}): super._();


@override final  CatalogIndex? index;
@override final  Progress? progress;
@override final  String? lengthId;
@override final  CatalogFailure? catalogFailure;
@override final  StorageFailure? readFailure;
@override final  StorageFailure? saveFailure;
@override@JsonKey() final  bool chapterUnavailable;
@override@JsonKey() final  bool saving;

/// Create a copy of CatalogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogStateCopyWith<_CatalogState> get copyWith => __$CatalogStateCopyWithImpl<_CatalogState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogState&&(identical(other.index, index) || other.index == index)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.lengthId, lengthId) || other.lengthId == lengthId)&&(identical(other.catalogFailure, catalogFailure) || other.catalogFailure == catalogFailure)&&(identical(other.readFailure, readFailure) || other.readFailure == readFailure)&&(identical(other.saveFailure, saveFailure) || other.saveFailure == saveFailure)&&(identical(other.chapterUnavailable, chapterUnavailable) || other.chapterUnavailable == chapterUnavailable)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,index,progress,lengthId,catalogFailure,readFailure,saveFailure,chapterUnavailable,saving);
}

@override
String toString() {
    return 'CatalogState(index: $index, progress: $progress, lengthId: $lengthId, catalogFailure: $catalogFailure, readFailure: $readFailure, saveFailure: $saveFailure, chapterUnavailable: $chapterUnavailable, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$CatalogStateCopyWith<$Res> implements $CatalogStateCopyWith<$Res> {
  factory _$CatalogStateCopyWith(_CatalogState value, $Res Function(_CatalogState) _then) = __$CatalogStateCopyWithImpl;
@override @useResult
$Res call({
 CatalogIndex? index, Progress? progress, String? lengthId, CatalogFailure? catalogFailure, StorageFailure? readFailure, StorageFailure? saveFailure, bool chapterUnavailable, bool saving
});


@override $CatalogIndexCopyWith<$Res>? get index;@override $ProgressCopyWith<$Res>? get progress;

}
/// @nodoc
class __$CatalogStateCopyWithImpl<$Res>
    implements _$CatalogStateCopyWith<$Res> {
  __$CatalogStateCopyWithImpl(this._self, this._then);

  final _CatalogState _self;
  final $Res Function(_CatalogState) _then;

/// Create a copy of CatalogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = freezed,Object? progress = freezed,Object? lengthId = freezed,Object? catalogFailure = freezed,Object? readFailure = freezed,Object? saveFailure = freezed,Object? chapterUnavailable = null,Object? saving = null,}) {
  return _then(_CatalogState(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as CatalogIndex?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as Progress?,lengthId: freezed == lengthId ? _self.lengthId : lengthId // ignore: cast_nullable_to_non_nullable
as String?,catalogFailure: freezed == catalogFailure ? _self.catalogFailure : catalogFailure // ignore: cast_nullable_to_non_nullable
as CatalogFailure?,readFailure: freezed == readFailure ? _self.readFailure : readFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as StorageFailure?,chapterUnavailable: null == chapterUnavailable ? _self.chapterUnavailable : chapterUnavailable // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CatalogState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CatalogIndexCopyWith<$Res>? get index {
    if (_self.index == null) {
    return null;
  }

  return $CatalogIndexCopyWith<$Res>(_self.index!, (value) {
    return _then(_self.copyWith(index: value));
  });
}/// Create a copy of CatalogState
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
}
}

// dart format on

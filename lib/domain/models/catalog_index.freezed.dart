// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_index.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgressionKind {

 String get id; String get title;
/// Create a copy of ProgressionKind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressionKindCopyWith<ProgressionKind> get copyWith => _$ProgressionKindCopyWithImpl<ProgressionKind>(this as ProgressionKind, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProgressionKind;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressionKind&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title));
}


@override
int get hashCode {
  final _this = this as ProgressionKind;
  return Object.hash(runtimeType,_this.id,_this.title);
}

@override
String toString() {
  final _this = this as ProgressionKind;
  return 'ProgressionKind(id: ${_this.id}, title: ${_this.title})';
}


}

/// @nodoc
abstract mixin class $ProgressionKindCopyWith<$Res>  {
  factory $ProgressionKindCopyWith(ProgressionKind value, $Res Function(ProgressionKind) _then) = _$ProgressionKindCopyWithImpl;
@useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class _$ProgressionKindCopyWithImpl<$Res>
    implements $ProgressionKindCopyWith<$Res> {
  _$ProgressionKindCopyWithImpl(this._self, this._then);

  final ProgressionKind _self;
  final $Res Function(ProgressionKind) _then;

/// Create a copy of ProgressionKind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,}) {
  return _then(ProgressionKind(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressionKind].
extension ProgressionKindPatterns on ProgressionKind {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressionKind value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressionKind() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressionKind value)  $default,){
final _that = this;
switch (_that) {
case _ProgressionKind():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressionKind value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressionKind() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressionKind() when $default != null:
return $default(_that.id,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title)  $default,) {final _that = this;
switch (_that) {
case _ProgressionKind():
return $default(_that.id,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title)?  $default,) {final _that = this;
switch (_that) {
case _ProgressionKind() when $default != null:
return $default(_that.id,_that.title);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressionKind implements ProgressionKind {
  const _ProgressionKind({required this.id, required this.title});
  

@override final  String id;
@override final  String title;

/// Create a copy of ProgressionKind
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressionKindCopyWith<_ProgressionKind> get copyWith => __$ProgressionKindCopyWithImpl<_ProgressionKind>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressionKind&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title);
}

@override
String toString() {
    return 'ProgressionKind(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class _$ProgressionKindCopyWith<$Res> implements $ProgressionKindCopyWith<$Res> {
  factory _$ProgressionKindCopyWith(_ProgressionKind value, $Res Function(_ProgressionKind) _then) = __$ProgressionKindCopyWithImpl;
@override @useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class __$ProgressionKindCopyWithImpl<$Res>
    implements _$ProgressionKindCopyWith<$Res> {
  __$ProgressionKindCopyWithImpl(this._self, this._then);

  final _ProgressionKind _self;
  final $Res Function(_ProgressionKind) _then;

/// Create a copy of ProgressionKind
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,}) {
  return _then(_ProgressionKind(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$LengthGroup {

 String get id; String get title; int? get maxSteps;
/// Create a copy of LengthGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LengthGroupCopyWith<LengthGroup> get copyWith => _$LengthGroupCopyWithImpl<LengthGroup>(this as LengthGroup, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LengthGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LengthGroup&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.maxSteps, _this.maxSteps) || other.maxSteps == _this.maxSteps));
}


@override
int get hashCode {
  final _this = this as LengthGroup;
  return Object.hash(runtimeType,_this.id,_this.title,_this.maxSteps);
}

@override
String toString() {
  final _this = this as LengthGroup;
  return 'LengthGroup(id: ${_this.id}, title: ${_this.title}, maxSteps: ${_this.maxSteps})';
}


}

/// @nodoc
abstract mixin class $LengthGroupCopyWith<$Res>  {
  factory $LengthGroupCopyWith(LengthGroup value, $Res Function(LengthGroup) _then) = _$LengthGroupCopyWithImpl;
@useResult
$Res call({
 String id, String title, int? maxSteps
});




}
/// @nodoc
class _$LengthGroupCopyWithImpl<$Res>
    implements $LengthGroupCopyWith<$Res> {
  _$LengthGroupCopyWithImpl(this._self, this._then);

  final LengthGroup _self;
  final $Res Function(LengthGroup) _then;

/// Create a copy of LengthGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? maxSteps = freezed,}) {
  return _then(LengthGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,maxSteps: freezed == maxSteps ? _self.maxSteps : maxSteps // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LengthGroup].
extension LengthGroupPatterns on LengthGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LengthGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LengthGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LengthGroup value)  $default,){
final _that = this;
switch (_that) {
case _LengthGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LengthGroup value)?  $default,){
final _that = this;
switch (_that) {
case _LengthGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  int? maxSteps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LengthGroup() when $default != null:
return $default(_that.id,_that.title,_that.maxSteps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  int? maxSteps)  $default,) {final _that = this;
switch (_that) {
case _LengthGroup():
return $default(_that.id,_that.title,_that.maxSteps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  int? maxSteps)?  $default,) {final _that = this;
switch (_that) {
case _LengthGroup() when $default != null:
return $default(_that.id,_that.title,_that.maxSteps);case _:
  return null;

}
}

}

/// @nodoc


class _LengthGroup implements LengthGroup {
  const _LengthGroup({required this.id, required this.title, this.maxSteps});
  

@override final  String id;
@override final  String title;
@override final  int? maxSteps;

/// Create a copy of LengthGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LengthGroupCopyWith<_LengthGroup> get copyWith => __$LengthGroupCopyWithImpl<_LengthGroup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LengthGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.maxSteps, maxSteps) || other.maxSteps == maxSteps));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,maxSteps);
}

@override
String toString() {
    return 'LengthGroup(id: $id, title: $title, maxSteps: $maxSteps)';
}


}

/// @nodoc
abstract mixin class _$LengthGroupCopyWith<$Res> implements $LengthGroupCopyWith<$Res> {
  factory _$LengthGroupCopyWith(_LengthGroup value, $Res Function(_LengthGroup) _then) = __$LengthGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int? maxSteps
});




}
/// @nodoc
class __$LengthGroupCopyWithImpl<$Res>
    implements _$LengthGroupCopyWith<$Res> {
  __$LengthGroupCopyWithImpl(this._self, this._then);

  final _LengthGroup _self;
  final $Res Function(_LengthGroup) _then;

/// Create a copy of LengthGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? maxSteps = freezed,}) {
  return _then(_LengthGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,maxSteps: freezed == maxSteps ? _self.maxSteps : maxSteps // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$CatalogIndex {

 List<ProgressionKind> get kinds; List<LengthGroup> get lengthGroups; List<Progression> get progressions;
/// Create a copy of CatalogIndex
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogIndexCopyWith<CatalogIndex> get copyWith => _$CatalogIndexCopyWithImpl<CatalogIndex>(this as CatalogIndex, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CatalogIndex;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogIndex&&const DeepCollectionEquality().equals(other.kinds, _this.kinds)&&const DeepCollectionEquality().equals(other.lengthGroups, _this.lengthGroups)&&const DeepCollectionEquality().equals(other.progressions, _this.progressions));
}


@override
int get hashCode {
  final _this = this as CatalogIndex;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.kinds),const DeepCollectionEquality().hash(_this.lengthGroups),const DeepCollectionEquality().hash(_this.progressions));
}

@override
String toString() {
  final _this = this as CatalogIndex;
  return 'CatalogIndex(kinds: ${_this.kinds}, lengthGroups: ${_this.lengthGroups}, progressions: ${_this.progressions})';
}


}

/// @nodoc
abstract mixin class $CatalogIndexCopyWith<$Res>  {
  factory $CatalogIndexCopyWith(CatalogIndex value, $Res Function(CatalogIndex) _then) = _$CatalogIndexCopyWithImpl;
@useResult
$Res call({
 List<ProgressionKind> kinds, List<LengthGroup> lengthGroups, List<Progression> progressions
});




}
/// @nodoc
class _$CatalogIndexCopyWithImpl<$Res>
    implements $CatalogIndexCopyWith<$Res> {
  _$CatalogIndexCopyWithImpl(this._self, this._then);

  final CatalogIndex _self;
  final $Res Function(CatalogIndex) _then;

/// Create a copy of CatalogIndex
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kinds = null,Object? lengthGroups = null,Object? progressions = null,}) {
  return _then(CatalogIndex(
kinds: null == kinds ? _self.kinds : kinds // ignore: cast_nullable_to_non_nullable
as List<ProgressionKind>,lengthGroups: null == lengthGroups ? _self.lengthGroups : lengthGroups // ignore: cast_nullable_to_non_nullable
as List<LengthGroup>,progressions: null == progressions ? _self.progressions : progressions // ignore: cast_nullable_to_non_nullable
as List<Progression>,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogIndex].
extension CatalogIndexPatterns on CatalogIndex {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogIndex value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogIndex() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogIndex value)  $default,){
final _that = this;
switch (_that) {
case _CatalogIndex():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogIndex value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogIndex() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProgressionKind> kinds,  List<LengthGroup> lengthGroups,  List<Progression> progressions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogIndex() when $default != null:
return $default(_that.kinds,_that.lengthGroups,_that.progressions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProgressionKind> kinds,  List<LengthGroup> lengthGroups,  List<Progression> progressions)  $default,) {final _that = this;
switch (_that) {
case _CatalogIndex():
return $default(_that.kinds,_that.lengthGroups,_that.progressions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProgressionKind> kinds,  List<LengthGroup> lengthGroups,  List<Progression> progressions)?  $default,) {final _that = this;
switch (_that) {
case _CatalogIndex() when $default != null:
return $default(_that.kinds,_that.lengthGroups,_that.progressions);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogIndex extends CatalogIndex {
  const _CatalogIndex({required  List<ProgressionKind> kinds, required  List<LengthGroup> lengthGroups, required  List<Progression> progressions}): _kinds = kinds,_lengthGroups = lengthGroups,_progressions = progressions,super._();
  

 final  List<ProgressionKind> _kinds;
@override List<ProgressionKind> get kinds {
  if (_kinds is EqualUnmodifiableListView) return _kinds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_kinds);
}

 final  List<LengthGroup> _lengthGroups;
@override List<LengthGroup> get lengthGroups {
  if (_lengthGroups is EqualUnmodifiableListView) return _lengthGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lengthGroups);
}

 final  List<Progression> _progressions;
@override List<Progression> get progressions {
  if (_progressions is EqualUnmodifiableListView) return _progressions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_progressions);
}


/// Create a copy of CatalogIndex
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogIndexCopyWith<_CatalogIndex> get copyWith => __$CatalogIndexCopyWithImpl<_CatalogIndex>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogIndex&&const DeepCollectionEquality().equals(other.kinds, _kinds)&&const DeepCollectionEquality().equals(other.lengthGroups, _lengthGroups)&&const DeepCollectionEquality().equals(other.progressions, _progressions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_kinds),const DeepCollectionEquality().hash(_lengthGroups),const DeepCollectionEquality().hash(_progressions));
}

@override
String toString() {
    return 'CatalogIndex(kinds: $kinds, lengthGroups: $lengthGroups, progressions: $progressions)';
}


}

/// @nodoc
abstract mixin class _$CatalogIndexCopyWith<$Res> implements $CatalogIndexCopyWith<$Res> {
  factory _$CatalogIndexCopyWith(_CatalogIndex value, $Res Function(_CatalogIndex) _then) = __$CatalogIndexCopyWithImpl;
@override @useResult
$Res call({
 List<ProgressionKind> kinds, List<LengthGroup> lengthGroups, List<Progression> progressions
});




}
/// @nodoc
class __$CatalogIndexCopyWithImpl<$Res>
    implements _$CatalogIndexCopyWith<$Res> {
  __$CatalogIndexCopyWithImpl(this._self, this._then);

  final _CatalogIndex _self;
  final $Res Function(_CatalogIndex) _then;

/// Create a copy of CatalogIndex
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kinds = null,Object? lengthGroups = null,Object? progressions = null,}) {
  return _then(_CatalogIndex(
kinds: null == kinds ? _self._kinds : kinds // ignore: cast_nullable_to_non_nullable
as List<ProgressionKind>,lengthGroups: null == lengthGroups ? _self._lengthGroups : lengthGroups // ignore: cast_nullable_to_non_nullable
as List<LengthGroup>,progressions: null == progressions ? _self._progressions : progressions // ignore: cast_nullable_to_non_nullable
as List<Progression>,
  ));
}


}

// dart format on

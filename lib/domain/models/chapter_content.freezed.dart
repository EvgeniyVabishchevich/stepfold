// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContentBlock {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentBlock);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ContentBlock()';
}


}

/// @nodoc
class $ContentBlockCopyWith<$Res>  {
$ContentBlockCopyWith(ContentBlock _, $Res Function(ContentBlock) __);
}


/// Adds pattern-matching-related methods to [ContentBlock].
extension ContentBlockPatterns on ContentBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Paragraph value)?  paragraph,TResult Function( ImageBlock value)?  image,TResult Function( MapPoint value)?  mapPoint,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Paragraph() when paragraph != null:
return paragraph(_that);case ImageBlock() when image != null:
return image(_that);case MapPoint() when mapPoint != null:
return mapPoint(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Paragraph value)  paragraph,required TResult Function( ImageBlock value)  image,required TResult Function( MapPoint value)  mapPoint,}){
final _that = this;
switch (_that) {
case Paragraph():
return paragraph(_that);case ImageBlock():
return image(_that);case MapPoint():
return mapPoint(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Paragraph value)?  paragraph,TResult? Function( ImageBlock value)?  image,TResult? Function( MapPoint value)?  mapPoint,}){
final _that = this;
switch (_that) {
case Paragraph() when paragraph != null:
return paragraph(_that);case ImageBlock() when image != null:
return image(_that);case MapPoint() when mapPoint != null:
return mapPoint(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String text)?  paragraph,TResult Function( Uri source,  String caption)?  image,TResult Function( double latitude,  double longitude,  String label)?  mapPoint,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Paragraph() when paragraph != null:
return paragraph(_that.text);case ImageBlock() when image != null:
return image(_that.source,_that.caption);case MapPoint() when mapPoint != null:
return mapPoint(_that.latitude,_that.longitude,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String text)  paragraph,required TResult Function( Uri source,  String caption)  image,required TResult Function( double latitude,  double longitude,  String label)  mapPoint,}) {final _that = this;
switch (_that) {
case Paragraph():
return paragraph(_that.text);case ImageBlock():
return image(_that.source,_that.caption);case MapPoint():
return mapPoint(_that.latitude,_that.longitude,_that.label);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String text)?  paragraph,TResult? Function( Uri source,  String caption)?  image,TResult? Function( double latitude,  double longitude,  String label)?  mapPoint,}) {final _that = this;
switch (_that) {
case Paragraph() when paragraph != null:
return paragraph(_that.text);case ImageBlock() when image != null:
return image(_that.source,_that.caption);case MapPoint() when mapPoint != null:
return mapPoint(_that.latitude,_that.longitude,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class Paragraph implements ContentBlock {
  const Paragraph({required this.text});
  

 final  String text;

/// Create a copy of ContentBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParagraphCopyWith<Paragraph> get copyWith => _$ParagraphCopyWithImpl<Paragraph>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Paragraph&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'ContentBlock.paragraph(text: $text)';
}


}

/// @nodoc
abstract mixin class $ParagraphCopyWith<$Res> implements $ContentBlockCopyWith<$Res> {
  factory $ParagraphCopyWith(Paragraph value, $Res Function(Paragraph) _then) = _$ParagraphCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$ParagraphCopyWithImpl<$Res>
    implements $ParagraphCopyWith<$Res> {
  _$ParagraphCopyWithImpl(this._self, this._then);

  final Paragraph _self;
  final $Res Function(Paragraph) _then;

/// Create a copy of ContentBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(Paragraph(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ImageBlock implements ContentBlock {
  const ImageBlock({required this.source, this.caption = ''});
  

 final  Uri source;
@JsonKey() final  String caption;

/// Create a copy of ContentBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageBlockCopyWith<ImageBlock> get copyWith => _$ImageBlockCopyWithImpl<ImageBlock>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageBlock&&(identical(other.source, source) || other.source == source)&&(identical(other.caption, caption) || other.caption == caption));
}


@override
int get hashCode {
    return Object.hash(runtimeType,source,caption);
}

@override
String toString() {
    return 'ContentBlock.image(source: $source, caption: $caption)';
}


}

/// @nodoc
abstract mixin class $ImageBlockCopyWith<$Res> implements $ContentBlockCopyWith<$Res> {
  factory $ImageBlockCopyWith(ImageBlock value, $Res Function(ImageBlock) _then) = _$ImageBlockCopyWithImpl;
@useResult
$Res call({
 Uri source, String caption
});




}
/// @nodoc
class _$ImageBlockCopyWithImpl<$Res>
    implements $ImageBlockCopyWith<$Res> {
  _$ImageBlockCopyWithImpl(this._self, this._then);

  final ImageBlock _self;
  final $Res Function(ImageBlock) _then;

/// Create a copy of ContentBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? source = null,Object? caption = null,}) {
  return _then(ImageBlock(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as Uri,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MapPoint implements ContentBlock {
  const MapPoint({required this.latitude, required this.longitude, this.label = ''});
  

 final  double latitude;
 final  double longitude;
@JsonKey() final  String label;

/// Create a copy of ContentBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapPointCopyWith<MapPoint> get copyWith => _$MapPointCopyWithImpl<MapPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapPoint&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode {
    return Object.hash(runtimeType,latitude,longitude,label);
}

@override
String toString() {
    return 'ContentBlock.mapPoint(latitude: $latitude, longitude: $longitude, label: $label)';
}


}

/// @nodoc
abstract mixin class $MapPointCopyWith<$Res> implements $ContentBlockCopyWith<$Res> {
  factory $MapPointCopyWith(MapPoint value, $Res Function(MapPoint) _then) = _$MapPointCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, String label
});




}
/// @nodoc
class _$MapPointCopyWithImpl<$Res>
    implements $MapPointCopyWith<$Res> {
  _$MapPointCopyWithImpl(this._self, this._then);

  final MapPoint _self;
  final $Res Function(MapPoint) _then;

/// Create a copy of ContentBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? label = null,}) {
  return _then(MapPoint(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChapterContent {

 String get progressionId; String get chapterId; List<ContentBlock> get blocks;
/// Create a copy of ChapterContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterContentCopyWith<ChapterContent> get copyWith => _$ChapterContentCopyWithImpl<ChapterContent>(this as ChapterContent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChapterContent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterContent&&(identical(other.progressionId, _this.progressionId) || other.progressionId == _this.progressionId)&&(identical(other.chapterId, _this.chapterId) || other.chapterId == _this.chapterId)&&const DeepCollectionEquality().equals(other.blocks, _this.blocks));
}


@override
int get hashCode {
  final _this = this as ChapterContent;
  return Object.hash(runtimeType,_this.progressionId,_this.chapterId,const DeepCollectionEquality().hash(_this.blocks));
}

@override
String toString() {
  final _this = this as ChapterContent;
  return 'ChapterContent(progressionId: ${_this.progressionId}, chapterId: ${_this.chapterId}, blocks: ${_this.blocks})';
}


}

/// @nodoc
abstract mixin class $ChapterContentCopyWith<$Res>  {
  factory $ChapterContentCopyWith(ChapterContent value, $Res Function(ChapterContent) _then) = _$ChapterContentCopyWithImpl;
@useResult
$Res call({
 String progressionId, String chapterId, List<ContentBlock> blocks
});




}
/// @nodoc
class _$ChapterContentCopyWithImpl<$Res>
    implements $ChapterContentCopyWith<$Res> {
  _$ChapterContentCopyWithImpl(this._self, this._then);

  final ChapterContent _self;
  final $Res Function(ChapterContent) _then;

/// Create a copy of ChapterContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? progressionId = null,Object? chapterId = null,Object? blocks = null,}) {
  return _then(ChapterContent(
progressionId: null == progressionId ? _self.progressionId : progressionId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,blocks: null == blocks ? _self.blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<ContentBlock>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterContent].
extension ChapterContentPatterns on ChapterContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterContent value)  $default,){
final _that = this;
switch (_that) {
case _ChapterContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterContent value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String progressionId,  String chapterId,  List<ContentBlock> blocks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterContent() when $default != null:
return $default(_that.progressionId,_that.chapterId,_that.blocks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String progressionId,  String chapterId,  List<ContentBlock> blocks)  $default,) {final _that = this;
switch (_that) {
case _ChapterContent():
return $default(_that.progressionId,_that.chapterId,_that.blocks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String progressionId,  String chapterId,  List<ContentBlock> blocks)?  $default,) {final _that = this;
switch (_that) {
case _ChapterContent() when $default != null:
return $default(_that.progressionId,_that.chapterId,_that.blocks);case _:
  return null;

}
}

}

/// @nodoc


class _ChapterContent implements ChapterContent {
  const _ChapterContent({required this.progressionId, required this.chapterId, required  List<ContentBlock> blocks}): _blocks = blocks;
  

@override final  String progressionId;
@override final  String chapterId;
 final  List<ContentBlock> _blocks;
@override List<ContentBlock> get blocks {
  if (_blocks is EqualUnmodifiableListView) return _blocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blocks);
}


/// Create a copy of ChapterContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterContentCopyWith<_ChapterContent> get copyWith => __$ChapterContentCopyWithImpl<_ChapterContent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterContent&&(identical(other.progressionId, progressionId) || other.progressionId == progressionId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&const DeepCollectionEquality().equals(other.blocks, _blocks));
}


@override
int get hashCode {
    return Object.hash(runtimeType,progressionId,chapterId,const DeepCollectionEquality().hash(_blocks));
}

@override
String toString() {
    return 'ChapterContent(progressionId: $progressionId, chapterId: $chapterId, blocks: $blocks)';
}


}

/// @nodoc
abstract mixin class _$ChapterContentCopyWith<$Res> implements $ChapterContentCopyWith<$Res> {
  factory _$ChapterContentCopyWith(_ChapterContent value, $Res Function(_ChapterContent) _then) = __$ChapterContentCopyWithImpl;
@override @useResult
$Res call({
 String progressionId, String chapterId, List<ContentBlock> blocks
});




}
/// @nodoc
class __$ChapterContentCopyWithImpl<$Res>
    implements _$ChapterContentCopyWith<$Res> {
  __$ChapterContentCopyWithImpl(this._self, this._then);

  final _ChapterContent _self;
  final $Res Function(_ChapterContent) _then;

/// Create a copy of ChapterContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? progressionId = null,Object? chapterId = null,Object? blocks = null,}) {
  return _then(_ChapterContent(
progressionId: null == progressionId ? _self.progressionId : progressionId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,blocks: null == blocks ? _self._blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<ContentBlock>,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spending.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Spending {

 String get progressionId; int get price; DateTime get at;
/// Create a copy of Spending
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpendingCopyWith<Spending> get copyWith => _$SpendingCopyWithImpl<Spending>(this as Spending, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Spending;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Spending&&(identical(other.progressionId, _this.progressionId) || other.progressionId == _this.progressionId)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.at, _this.at) || other.at == _this.at));
}


@override
int get hashCode {
  final _this = this as Spending;
  return Object.hash(runtimeType,_this.progressionId,_this.price,_this.at);
}

@override
String toString() {
  final _this = this as Spending;
  return 'Spending(progressionId: ${_this.progressionId}, price: ${_this.price}, at: ${_this.at})';
}


}

/// @nodoc
abstract mixin class $SpendingCopyWith<$Res>  {
  factory $SpendingCopyWith(Spending value, $Res Function(Spending) _then) = _$SpendingCopyWithImpl;
@useResult
$Res call({
 String progressionId, int price, DateTime at
});




}
/// @nodoc
class _$SpendingCopyWithImpl<$Res>
    implements $SpendingCopyWith<$Res> {
  _$SpendingCopyWithImpl(this._self, this._then);

  final Spending _self;
  final $Res Function(Spending) _then;

/// Create a copy of Spending
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? progressionId = null,Object? price = null,Object? at = null,}) {
  return _then(_self.copyWith(
progressionId: null == progressionId ? _self.progressionId : progressionId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Spending].
extension SpendingPatterns on Spending {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChapterOpened value)?  chapter,TResult Function( MedalBought value)?  medal,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChapterOpened() when chapter != null:
return chapter(_that);case MedalBought() when medal != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChapterOpened value)  chapter,required TResult Function( MedalBought value)  medal,}){
final _that = this;
switch (_that) {
case ChapterOpened():
return chapter(_that);case MedalBought():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChapterOpened value)?  chapter,TResult? Function( MedalBought value)?  medal,}){
final _that = this;
switch (_that) {
case ChapterOpened() when chapter != null:
return chapter(_that);case MedalBought() when medal != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String progressionId,  String chapterId,  int price,  DateTime at)?  chapter,TResult Function( String progressionId,  Medal medal,  int price,  DateTime at)?  medal,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChapterOpened() when chapter != null:
return chapter(_that.progressionId,_that.chapterId,_that.price,_that.at);case MedalBought() when medal != null:
return medal(_that.progressionId,_that.medal,_that.price,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String progressionId,  String chapterId,  int price,  DateTime at)  chapter,required TResult Function( String progressionId,  Medal medal,  int price,  DateTime at)  medal,}) {final _that = this;
switch (_that) {
case ChapterOpened():
return chapter(_that.progressionId,_that.chapterId,_that.price,_that.at);case MedalBought():
return medal(_that.progressionId,_that.medal,_that.price,_that.at);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String progressionId,  String chapterId,  int price,  DateTime at)?  chapter,TResult? Function( String progressionId,  Medal medal,  int price,  DateTime at)?  medal,}) {final _that = this;
switch (_that) {
case ChapterOpened() when chapter != null:
return chapter(_that.progressionId,_that.chapterId,_that.price,_that.at);case MedalBought() when medal != null:
return medal(_that.progressionId,_that.medal,_that.price,_that.at);case _:
  return null;

}
}

}

/// @nodoc


class ChapterOpened implements Spending {
  const ChapterOpened({required this.progressionId, required this.chapterId, required this.price, required this.at});
  

@override final  String progressionId;
 final  String chapterId;
@override final  int price;
@override final  DateTime at;

/// Create a copy of Spending
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterOpenedCopyWith<ChapterOpened> get copyWith => _$ChapterOpenedCopyWithImpl<ChapterOpened>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterOpened&&(identical(other.progressionId, progressionId) || other.progressionId == progressionId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.price, price) || other.price == price)&&(identical(other.at, at) || other.at == at));
}


@override
int get hashCode {
    return Object.hash(runtimeType,progressionId,chapterId,price,at);
}

@override
String toString() {
    return 'Spending.chapter(progressionId: $progressionId, chapterId: $chapterId, price: $price, at: $at)';
}


}

/// @nodoc
abstract mixin class $ChapterOpenedCopyWith<$Res> implements $SpendingCopyWith<$Res> {
  factory $ChapterOpenedCopyWith(ChapterOpened value, $Res Function(ChapterOpened) _then) = _$ChapterOpenedCopyWithImpl;
@override @useResult
$Res call({
 String progressionId, String chapterId, int price, DateTime at
});




}
/// @nodoc
class _$ChapterOpenedCopyWithImpl<$Res>
    implements $ChapterOpenedCopyWith<$Res> {
  _$ChapterOpenedCopyWithImpl(this._self, this._then);

  final ChapterOpened _self;
  final $Res Function(ChapterOpened) _then;

/// Create a copy of Spending
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? progressionId = null,Object? chapterId = null,Object? price = null,Object? at = null,}) {
  return _then(ChapterOpened(
progressionId: null == progressionId ? _self.progressionId : progressionId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class MedalBought implements Spending {
  const MedalBought({required this.progressionId, required this.medal, required this.price, required this.at});
  

@override final  String progressionId;
 final  Medal medal;
@override final  int price;
@override final  DateTime at;

/// Create a copy of Spending
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedalBoughtCopyWith<MedalBought> get copyWith => _$MedalBoughtCopyWithImpl<MedalBought>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MedalBought&&(identical(other.progressionId, progressionId) || other.progressionId == progressionId)&&(identical(other.medal, medal) || other.medal == medal)&&(identical(other.price, price) || other.price == price)&&(identical(other.at, at) || other.at == at));
}


@override
int get hashCode {
    return Object.hash(runtimeType,progressionId,medal,price,at);
}

@override
String toString() {
    return 'Spending.medal(progressionId: $progressionId, medal: $medal, price: $price, at: $at)';
}


}

/// @nodoc
abstract mixin class $MedalBoughtCopyWith<$Res> implements $SpendingCopyWith<$Res> {
  factory $MedalBoughtCopyWith(MedalBought value, $Res Function(MedalBought) _then) = _$MedalBoughtCopyWithImpl;
@override @useResult
$Res call({
 String progressionId, Medal medal, int price, DateTime at
});




}
/// @nodoc
class _$MedalBoughtCopyWithImpl<$Res>
    implements $MedalBoughtCopyWith<$Res> {
  _$MedalBoughtCopyWithImpl(this._self, this._then);

  final MedalBought _self;
  final $Res Function(MedalBought) _then;

/// Create a copy of Spending
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? progressionId = null,Object? medal = null,Object? price = null,Object? at = null,}) {
  return _then(MedalBought(
progressionId: null == progressionId ? _self.progressionId : progressionId // ignore: cast_nullable_to_non_nullable
as String,medal: null == medal ? _self.medal : medal // ignore: cast_nullable_to_non_nullable
as Medal,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

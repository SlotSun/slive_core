// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_super_chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LiveSuperChatMessage {

 String get userName; String get face; String get message; int get price; int get startTime; int get endTime; String get backgroundColor; String get backgroundBottomColor;
/// Create a copy of LiveSuperChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveSuperChatMessageCopyWith<LiveSuperChatMessage> get copyWith => _$LiveSuperChatMessageCopyWithImpl<LiveSuperChatMessage>(this as LiveSuperChatMessage, _$identity);

  /// Serializes this LiveSuperChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveSuperChatMessage&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.face, face) || other.face == face)&&(identical(other.message, message) || other.message == message)&&(identical(other.price, price) || other.price == price)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.backgroundBottomColor, backgroundBottomColor) || other.backgroundBottomColor == backgroundBottomColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,face,message,price,startTime,endTime,backgroundColor,backgroundBottomColor);

@override
String toString() {
  return 'LiveSuperChatMessage(userName: $userName, face: $face, message: $message, price: $price, startTime: $startTime, endTime: $endTime, backgroundColor: $backgroundColor, backgroundBottomColor: $backgroundBottomColor)';
}


}

/// @nodoc
abstract mixin class $LiveSuperChatMessageCopyWith<$Res>  {
  factory $LiveSuperChatMessageCopyWith(LiveSuperChatMessage value, $Res Function(LiveSuperChatMessage) _then) = _$LiveSuperChatMessageCopyWithImpl;
@useResult
$Res call({
 String userName, String face, String message, int price, int startTime, int endTime, String backgroundColor, String backgroundBottomColor
});




}
/// @nodoc
class _$LiveSuperChatMessageCopyWithImpl<$Res>
    implements $LiveSuperChatMessageCopyWith<$Res> {
  _$LiveSuperChatMessageCopyWithImpl(this._self, this._then);

  final LiveSuperChatMessage _self;
  final $Res Function(LiveSuperChatMessage) _then;

/// Create a copy of LiveSuperChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userName = null,Object? face = null,Object? message = null,Object? price = null,Object? startTime = null,Object? endTime = null,Object? backgroundColor = null,Object? backgroundBottomColor = null,}) {
  return _then(_self.copyWith(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,face: null == face ? _self.face : face // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as int,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as int,backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String,backgroundBottomColor: null == backgroundBottomColor ? _self.backgroundBottomColor : backgroundBottomColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveSuperChatMessage].
extension LiveSuperChatMessagePatterns on LiveSuperChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveSuperChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveSuperChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveSuperChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _LiveSuperChatMessage():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveSuperChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _LiveSuperChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userName,  String face,  String message,  int price,  int startTime,  int endTime,  String backgroundColor,  String backgroundBottomColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveSuperChatMessage() when $default != null:
return $default(_that.userName,_that.face,_that.message,_that.price,_that.startTime,_that.endTime,_that.backgroundColor,_that.backgroundBottomColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userName,  String face,  String message,  int price,  int startTime,  int endTime,  String backgroundColor,  String backgroundBottomColor)  $default,) {final _that = this;
switch (_that) {
case _LiveSuperChatMessage():
return $default(_that.userName,_that.face,_that.message,_that.price,_that.startTime,_that.endTime,_that.backgroundColor,_that.backgroundBottomColor);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userName,  String face,  String message,  int price,  int startTime,  int endTime,  String backgroundColor,  String backgroundBottomColor)?  $default,) {final _that = this;
switch (_that) {
case _LiveSuperChatMessage() when $default != null:
return $default(_that.userName,_that.face,_that.message,_that.price,_that.startTime,_that.endTime,_that.backgroundColor,_that.backgroundBottomColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LiveSuperChatMessage implements LiveSuperChatMessage {
  const _LiveSuperChatMessage({required this.userName, required this.face, required this.message, required this.price, required this.startTime, required this.endTime, required this.backgroundColor, required this.backgroundBottomColor});
  factory _LiveSuperChatMessage.fromJson(Map<String, dynamic> json) => _$LiveSuperChatMessageFromJson(json);

@override final  String userName;
@override final  String face;
@override final  String message;
@override final  int price;
@override final  int startTime;
@override final  int endTime;
@override final  String backgroundColor;
@override final  String backgroundBottomColor;

/// Create a copy of LiveSuperChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveSuperChatMessageCopyWith<_LiveSuperChatMessage> get copyWith => __$LiveSuperChatMessageCopyWithImpl<_LiveSuperChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LiveSuperChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveSuperChatMessage&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.face, face) || other.face == face)&&(identical(other.message, message) || other.message == message)&&(identical(other.price, price) || other.price == price)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.backgroundBottomColor, backgroundBottomColor) || other.backgroundBottomColor == backgroundBottomColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,face,message,price,startTime,endTime,backgroundColor,backgroundBottomColor);

@override
String toString() {
  return 'LiveSuperChatMessage(userName: $userName, face: $face, message: $message, price: $price, startTime: $startTime, endTime: $endTime, backgroundColor: $backgroundColor, backgroundBottomColor: $backgroundBottomColor)';
}


}

/// @nodoc
abstract mixin class _$LiveSuperChatMessageCopyWith<$Res> implements $LiveSuperChatMessageCopyWith<$Res> {
  factory _$LiveSuperChatMessageCopyWith(_LiveSuperChatMessage value, $Res Function(_LiveSuperChatMessage) _then) = __$LiveSuperChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String userName, String face, String message, int price, int startTime, int endTime, String backgroundColor, String backgroundBottomColor
});




}
/// @nodoc
class __$LiveSuperChatMessageCopyWithImpl<$Res>
    implements _$LiveSuperChatMessageCopyWith<$Res> {
  __$LiveSuperChatMessageCopyWithImpl(this._self, this._then);

  final _LiveSuperChatMessage _self;
  final $Res Function(_LiveSuperChatMessage) _then;

/// Create a copy of LiveSuperChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userName = null,Object? face = null,Object? message = null,Object? price = null,Object? startTime = null,Object? endTime = null,Object? backgroundColor = null,Object? backgroundBottomColor = null,}) {
  return _then(_LiveSuperChatMessage(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,face: null == face ? _self.face : face // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as int,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as int,backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as String,backgroundBottomColor: null == backgroundBottomColor ? _self.backgroundBottomColor : backgroundBottomColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

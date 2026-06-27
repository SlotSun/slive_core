// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_danmu_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LiveDanmuItem {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveDanmuItem&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'LiveDanmuItem(field0: $field0)';
}


}

/// @nodoc
class $LiveDanmuItemCopyWith<$Res>  {
$LiveDanmuItemCopyWith(LiveDanmuItem _, $Res Function(LiveDanmuItem) __);
}


/// Adds pattern-matching-related methods to [LiveDanmuItem].
extension LiveDanmuItemPatterns on LiveDanmuItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LiveDanmuItem_Message value)?  message,TResult Function( LiveDanmuItem_Control value)?  control,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LiveDanmuItem_Message() when message != null:
return message(_that);case LiveDanmuItem_Control() when control != null:
return control(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LiveDanmuItem_Message value)  message,required TResult Function( LiveDanmuItem_Control value)  control,}){
final _that = this;
switch (_that) {
case LiveDanmuItem_Message():
return message(_that);case LiveDanmuItem_Control():
return control(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LiveDanmuItem_Message value)?  message,TResult? Function( LiveDanmuItem_Control value)?  control,}){
final _that = this;
switch (_that) {
case LiveDanmuItem_Message() when message != null:
return message(_that);case LiveDanmuItem_Control() when control != null:
return control(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( LiveMessage field0)?  message,TResult Function( LiveDanmuControlEvent field0)?  control,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LiveDanmuItem_Message() when message != null:
return message(_that.field0);case LiveDanmuItem_Control() when control != null:
return control(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( LiveMessage field0)  message,required TResult Function( LiveDanmuControlEvent field0)  control,}) {final _that = this;
switch (_that) {
case LiveDanmuItem_Message():
return message(_that.field0);case LiveDanmuItem_Control():
return control(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( LiveMessage field0)?  message,TResult? Function( LiveDanmuControlEvent field0)?  control,}) {final _that = this;
switch (_that) {
case LiveDanmuItem_Message() when message != null:
return message(_that.field0);case LiveDanmuItem_Control() when control != null:
return control(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class LiveDanmuItem_Message extends LiveDanmuItem {
  const LiveDanmuItem_Message(this.field0): super._();
  

@override final  LiveMessage field0;

/// Create a copy of LiveDanmuItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveDanmuItem_MessageCopyWith<LiveDanmuItem_Message> get copyWith => _$LiveDanmuItem_MessageCopyWithImpl<LiveDanmuItem_Message>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveDanmuItem_Message&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'LiveDanmuItem.message(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $LiveDanmuItem_MessageCopyWith<$Res> implements $LiveDanmuItemCopyWith<$Res> {
  factory $LiveDanmuItem_MessageCopyWith(LiveDanmuItem_Message value, $Res Function(LiveDanmuItem_Message) _then) = _$LiveDanmuItem_MessageCopyWithImpl;
@useResult
$Res call({
 LiveMessage field0
});




}
/// @nodoc
class _$LiveDanmuItem_MessageCopyWithImpl<$Res>
    implements $LiveDanmuItem_MessageCopyWith<$Res> {
  _$LiveDanmuItem_MessageCopyWithImpl(this._self, this._then);

  final LiveDanmuItem_Message _self;
  final $Res Function(LiveDanmuItem_Message) _then;

/// Create a copy of LiveDanmuItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(LiveDanmuItem_Message(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as LiveMessage,
  ));
}


}

/// @nodoc


class LiveDanmuItem_Control extends LiveDanmuItem {
  const LiveDanmuItem_Control(this.field0): super._();
  

@override final  LiveDanmuControlEvent field0;

/// Create a copy of LiveDanmuItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveDanmuItem_ControlCopyWith<LiveDanmuItem_Control> get copyWith => _$LiveDanmuItem_ControlCopyWithImpl<LiveDanmuItem_Control>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveDanmuItem_Control&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'LiveDanmuItem.control(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $LiveDanmuItem_ControlCopyWith<$Res> implements $LiveDanmuItemCopyWith<$Res> {
  factory $LiveDanmuItem_ControlCopyWith(LiveDanmuItem_Control value, $Res Function(LiveDanmuItem_Control) _then) = _$LiveDanmuItem_ControlCopyWithImpl;
@useResult
$Res call({
 LiveDanmuControlEvent field0
});




}
/// @nodoc
class _$LiveDanmuItem_ControlCopyWithImpl<$Res>
    implements $LiveDanmuItem_ControlCopyWith<$Res> {
  _$LiveDanmuItem_ControlCopyWithImpl(this._self, this._then);

  final LiveDanmuItem_Control _self;
  final $Res Function(LiveDanmuItem_Control) _then;

/// Create a copy of LiveDanmuItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(LiveDanmuItem_Control(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as LiveDanmuControlEvent,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SliveDanmuItem {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SliveDanmuItem&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'SliveDanmuItem(field0: $field0)';
}


}

/// @nodoc
class $SliveDanmuItemCopyWith<$Res>  {
$SliveDanmuItemCopyWith(SliveDanmuItem _, $Res Function(SliveDanmuItem) __);
}


/// Adds pattern-matching-related methods to [SliveDanmuItem].
extension SliveDanmuItemPatterns on SliveDanmuItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SliveDanmuItem_Message value)?  message,TResult Function( SliveDanmuItem_SuperChat value)?  superChat,TResult Function( SliveDanmuItem_Control value)?  control,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SliveDanmuItem_Message() when message != null:
return message(_that);case SliveDanmuItem_SuperChat() when superChat != null:
return superChat(_that);case SliveDanmuItem_Control() when control != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SliveDanmuItem_Message value)  message,required TResult Function( SliveDanmuItem_SuperChat value)  superChat,required TResult Function( SliveDanmuItem_Control value)  control,}){
final _that = this;
switch (_that) {
case SliveDanmuItem_Message():
return message(_that);case SliveDanmuItem_SuperChat():
return superChat(_that);case SliveDanmuItem_Control():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SliveDanmuItem_Message value)?  message,TResult? Function( SliveDanmuItem_SuperChat value)?  superChat,TResult? Function( SliveDanmuItem_Control value)?  control,}){
final _that = this;
switch (_that) {
case SliveDanmuItem_Message() when message != null:
return message(_that);case SliveDanmuItem_SuperChat() when superChat != null:
return superChat(_that);case SliveDanmuItem_Control() when control != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( SliveMessage field0)?  message,TResult Function( SliveSuperChatMessage field0)?  superChat,TResult Function( SliveDanmuControlEvent field0)?  control,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SliveDanmuItem_Message() when message != null:
return message(_that.field0);case SliveDanmuItem_SuperChat() when superChat != null:
return superChat(_that.field0);case SliveDanmuItem_Control() when control != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( SliveMessage field0)  message,required TResult Function( SliveSuperChatMessage field0)  superChat,required TResult Function( SliveDanmuControlEvent field0)  control,}) {final _that = this;
switch (_that) {
case SliveDanmuItem_Message():
return message(_that.field0);case SliveDanmuItem_SuperChat():
return superChat(_that.field0);case SliveDanmuItem_Control():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( SliveMessage field0)?  message,TResult? Function( SliveSuperChatMessage field0)?  superChat,TResult? Function( SliveDanmuControlEvent field0)?  control,}) {final _that = this;
switch (_that) {
case SliveDanmuItem_Message() when message != null:
return message(_that.field0);case SliveDanmuItem_SuperChat() when superChat != null:
return superChat(_that.field0);case SliveDanmuItem_Control() when control != null:
return control(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class SliveDanmuItem_Message extends SliveDanmuItem {
  const SliveDanmuItem_Message(this.field0): super._();
  

@override final  SliveMessage field0;

/// Create a copy of SliveDanmuItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SliveDanmuItem_MessageCopyWith<SliveDanmuItem_Message> get copyWith => _$SliveDanmuItem_MessageCopyWithImpl<SliveDanmuItem_Message>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SliveDanmuItem_Message&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'SliveDanmuItem.message(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $SliveDanmuItem_MessageCopyWith<$Res> implements $SliveDanmuItemCopyWith<$Res> {
  factory $SliveDanmuItem_MessageCopyWith(SliveDanmuItem_Message value, $Res Function(SliveDanmuItem_Message) _then) = _$SliveDanmuItem_MessageCopyWithImpl;
@useResult
$Res call({
 SliveMessage field0
});




}
/// @nodoc
class _$SliveDanmuItem_MessageCopyWithImpl<$Res>
    implements $SliveDanmuItem_MessageCopyWith<$Res> {
  _$SliveDanmuItem_MessageCopyWithImpl(this._self, this._then);

  final SliveDanmuItem_Message _self;
  final $Res Function(SliveDanmuItem_Message) _then;

/// Create a copy of SliveDanmuItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(SliveDanmuItem_Message(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as SliveMessage,
  ));
}


}

/// @nodoc


class SliveDanmuItem_SuperChat extends SliveDanmuItem {
  const SliveDanmuItem_SuperChat(this.field0): super._();
  

@override final  SliveSuperChatMessage field0;

/// Create a copy of SliveDanmuItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SliveDanmuItem_SuperChatCopyWith<SliveDanmuItem_SuperChat> get copyWith => _$SliveDanmuItem_SuperChatCopyWithImpl<SliveDanmuItem_SuperChat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SliveDanmuItem_SuperChat&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'SliveDanmuItem.superChat(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $SliveDanmuItem_SuperChatCopyWith<$Res> implements $SliveDanmuItemCopyWith<$Res> {
  factory $SliveDanmuItem_SuperChatCopyWith(SliveDanmuItem_SuperChat value, $Res Function(SliveDanmuItem_SuperChat) _then) = _$SliveDanmuItem_SuperChatCopyWithImpl;
@useResult
$Res call({
 SliveSuperChatMessage field0
});




}
/// @nodoc
class _$SliveDanmuItem_SuperChatCopyWithImpl<$Res>
    implements $SliveDanmuItem_SuperChatCopyWith<$Res> {
  _$SliveDanmuItem_SuperChatCopyWithImpl(this._self, this._then);

  final SliveDanmuItem_SuperChat _self;
  final $Res Function(SliveDanmuItem_SuperChat) _then;

/// Create a copy of SliveDanmuItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(SliveDanmuItem_SuperChat(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as SliveSuperChatMessage,
  ));
}


}

/// @nodoc


class SliveDanmuItem_Control extends SliveDanmuItem {
  const SliveDanmuItem_Control(this.field0): super._();
  

@override final  SliveDanmuControlEvent field0;

/// Create a copy of SliveDanmuItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SliveDanmuItem_ControlCopyWith<SliveDanmuItem_Control> get copyWith => _$SliveDanmuItem_ControlCopyWithImpl<SliveDanmuItem_Control>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SliveDanmuItem_Control&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'SliveDanmuItem.control(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $SliveDanmuItem_ControlCopyWith<$Res> implements $SliveDanmuItemCopyWith<$Res> {
  factory $SliveDanmuItem_ControlCopyWith(SliveDanmuItem_Control value, $Res Function(SliveDanmuItem_Control) _then) = _$SliveDanmuItem_ControlCopyWithImpl;
@useResult
$Res call({
 SliveDanmuControlEvent field0
});




}
/// @nodoc
class _$SliveDanmuItem_ControlCopyWithImpl<$Res>
    implements $SliveDanmuItem_ControlCopyWith<$Res> {
  _$SliveDanmuItem_ControlCopyWithImpl(this._self, this._then);

  final SliveDanmuItem_Control _self;
  final $Res Function(SliveDanmuItem_Control) _then;

/// Create a copy of SliveDanmuItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(SliveDanmuItem_Control(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as SliveDanmuControlEvent,
  ));
}


}

// dart format on

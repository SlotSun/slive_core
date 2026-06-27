// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_super_chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LiveSuperChatMessage _$LiveSuperChatMessageFromJson(
  Map<String, dynamic> json,
) => _LiveSuperChatMessage(
  userName: json['userName'] as String,
  face: json['face'] as String,
  message: json['message'] as String,
  price: (json['price'] as num).toInt(),
  startTime: (json['startTime'] as num).toInt(),
  endTime: (json['endTime'] as num).toInt(),
  backgroundColor: json['backgroundColor'] as String,
  backgroundBottomColor: json['backgroundBottomColor'] as String,
);

Map<String, dynamic> _$LiveSuperChatMessageToJson(
  _LiveSuperChatMessage instance,
) => <String, dynamic>{
  'userName': instance.userName,
  'face': instance.face,
  'message': instance.message,
  'price': instance.price,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'backgroundColor': instance.backgroundColor,
  'backgroundBottomColor': instance.backgroundBottomColor,
};
